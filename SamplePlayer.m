//
//  SamplePlayer.m
//  Drum Coach
//
//  Created by Matthew Schulkind on 11/16/12.
//  Copyright (c) 2012 Matthew Schulkind. All rights reserved.
//

#import "SamplePlayer.h"
#import "Sample.h"

@implementation SamplePlayer

@synthesize samples = samples_;
@synthesize samplePositions = samplePositions_;

OSStatus renderSamples(
   void* inRefCon, AudioUnitRenderActionFlags* ioActionFlags,
   const AudioTimeStamp* inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames,
   AudioBufferList* ioData) {
  SamplePlayer* player = (__bridge SamplePlayer*)inRefCon;

  // Zero out the output buffers.
  for (int i = 0; i < 2; ++i) {
    bzero(
        ioData->mBuffers[i].mData, inNumberFrames*sizeof(AudioUnitSampleType));
  }

  for (int sampleIndex = 0
       ; sampleIndex < [player.samples count]
       ; ++sampleIndex) {
    int samplePosition = 
        [[player.samplePositions objectAtIndex:sampleIndex] intValue];
    Sample* sample = [player.samples objectAtIndex:sampleIndex];

    if (samplePosition != -1) {
      int endSamplePosition = samplePosition + inNumberFrames;
      int nextRenderSamplePosition = endSamplePosition + 1;

      // Check if the sample will end this render.
      if (endSamplePosition >= sample.frameCount) {
        endSamplePosition = sample.frameCount - 1;
        nextRenderSamplePosition = -1;
      }

      int sampleFrameCount = endSamplePosition - samplePosition + 1;

      for (int channelIndex = 0; channelIndex < 2; ++channelIndex) {
        AudioUnitSampleType* sampleBuffer = [sample sampleBuffer:channelIndex];
        AudioUnitSampleType* outputBuffer =
            ioData->mBuffers[channelIndex].mData;
        for (int frameIndex = 0; frameIndex < sampleFrameCount; ++frameIndex) {
          outputBuffer[frameIndex] += sampleBuffer[samplePosition + frameIndex];
        }
      }

      [player.samplePositions 
          setObject:[[NSNumber alloc] initWithInt:nextRenderSamplePosition]
          atIndexedSubscript:sampleIndex];
    }
  }

  return 0;
}

- (id)init
{
  if ((self = [super init])) {
    samples_ = [NSMutableArray array];
    samplePositions_ = [NSMutableArray array];

    OSStatus status;

    AudioComponentDescription ioUnitDescription;
    ioUnitDescription.componentType = kAudioUnitType_Output;
    ioUnitDescription.componentSubType = kAudioUnitSubType_RemoteIO;
    ioUnitDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
    ioUnitDescription.componentFlags = 0;
    ioUnitDescription.componentFlagsMask = 0;

    // Declare and instantiate an audio processing graph
    NewAUGraph(&graph_);

    // Add an audio unit node to the graph, then instantiate the audio unit
    AUNode ioNode;
    AUGraphAddNode(graph_, &ioUnitDescription, &ioNode);
    AUGraphOpen(graph_);

    AURenderCallbackStruct renderCallbackStruct;
    renderCallbackStruct.inputProc = &renderSamples;
    renderCallbackStruct.inputProcRefCon = (__bridge void*)self;
    status = 
        AUGraphSetNodeInputCallback(graph_, ioNode, 0, &renderCallbackStruct);
    assert(!status);

    // Obtain a reference to the newly-instantiated I/O unit
    AudioUnit ioUnit;
    AUGraphNodeInfo(graph_, ioNode, NULL, &ioUnit);

    // Set the stream format.
    AudioStreamBasicDescription streamFormat = [Sample streamFormat];
    status = AudioUnitSetProperty(
        ioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input,
        0, &streamFormat, sizeof(streamFormat));
    assert(!status);

    status = AUGraphInitialize(graph_);
    assert(!status);

    AUGraphStart(graph_);
  }
  return self;
}

- (int)addSample:(NSString*)fileName {
  [samples_ addObject:[Sample sampleWithFileName:fileName]];
  [samplePositions_ addObject:[NSNumber numberWithInt:-1]];
  return [samples_ count] - 1;
}

- (void)triggerSample:(int)sampleID {
  [samplePositions_ setObject:[NSNumber numberWithInt:0]
           atIndexedSubscript:sampleID];
}

@end
