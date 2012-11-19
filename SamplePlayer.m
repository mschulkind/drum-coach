//
//  SamplePlayer.m
//  Drum Coach
//
//  Created by Matthew Schulkind on 11/16/12.
//  Copyright (c) 2012 Matthew Schulkind. All rights reserved.
//

#import "SamplePlayer.h"
#import "Sample.h"

OSStatus renderSamples(
   void* inRefCon, AudioUnitRenderActionFlags* ioActionFlags,
   const AudioTimeStamp* inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames,
   AudioBufferList* ioData) {

  return 0;
}

@implementation SamplePlayer

- (id)init
{
  if ((self = [super init])) {
    samples_ = [NSMutableArray array];

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

    // Obtain a reference to the newly-instantiated I/O unit
    AudioUnit ioUnit;
    AUGraphNodeInfo(graph_, ioNode, NULL, &ioUnit);

    AURenderCallbackStruct renderCallbackStruct;
    renderCallbackStruct.inputProc = &renderSamples;
    renderCallbackStruct.inputProcRefCon = (__bridge void*)self;
    status = 
        AUGraphSetNodeInputCallback(graph_, ioNode, 0, &renderCallbackStruct);
    assert(!status);

    status = AUGraphInitialize(graph_);
    assert(!status);

    AUGraphStart(graph_);
  }
  return self;
}

- (int)addSample:(NSString*)fileName {
  [samples_ addObject:[Sample sampleWithFileName:fileName]];
  return [samples_ count] - 1;
}

- (void)triggerSample:(int)sampleID {
  NSLog(@"trigger %d", sampleID);
}

@end
