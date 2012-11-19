//
//  Sample.m
//  Drum Coach
//
//  Created by Matthew Schulkind on 11/16/12.
//  Copyright (c) 2012 Matthew Schulkind. All rights reserved.
//

#import "Sample.h"

@implementation Sample

@synthesize frameCount = frameCount_;

- (id)initWithFileName:(NSString*)fileName {
  if ((self = [super init])) {
    OSStatus status;

    NSString* fullFileName = 
        [NSString stringWithFormat:@"Samples/%@", fileName];

    NSURL* url =
        [[NSBundle mainBundle] URLForResource:fullFileName withExtension:nil];

    // Open the file.
    ExtAudioFileRef file;
    status = ExtAudioFileOpenURL((__bridge CFURLRef)url, &file);
    assert(!status);

    // Read the frame count.
    UInt32 frameCountSize = sizeof(frameCount_);
    status = ExtAudioFileGetProperty(
        file, kExtAudioFileProperty_FileLengthFrames,
        &frameCountSize, &frameCount_);
    assert(!status);

    // Define the sample format for reading.
    AudioStreamBasicDescription streamFormat = [Sample streamFormat];
    status = ExtAudioFileSetProperty(
        file, kExtAudioFileProperty_ClientDataFormat,
        sizeof(streamFormat), &streamFormat);

    AudioBufferList *bufferList;
    bufferList = 
        (AudioBufferList*)malloc(sizeof(AudioBufferList) + sizeof(AudioBuffer));
    assert(bufferList);

    UInt32 channelDataSize = frameCount_*sizeof(AudioUnitSampleType);

    bufferList->mNumberBuffers = 2;
    for (int i = 0; i < 2; ++i) {
      samplesByChannel_[i] = (AudioUnitSampleType*)malloc(channelDataSize);
      assert(samplesByChannel_[i]);

      bufferList->mBuffers[i].mNumberChannels = 1;
      bufferList->mBuffers[i].mDataByteSize = channelDataSize;
      bufferList->mBuffers[i].mData = samplesByChannel_[i];
    }

    UInt32 numberOfPacketsToRead = frameCount_;
    status = ExtAudioFileRead(file, &numberOfPacketsToRead, bufferList);
    assert(!status);

    free(bufferList);
    ExtAudioFileDispose(file);
  }
  return self;
}

+ (Sample*)sampleWithFileName:(NSString*)fileName {
  return [[Sample alloc] initWithFileName:fileName];
}

+ (AudioStreamBasicDescription)streamFormat {
  // Get the current hardware sample rate.
  Float64 sampleRate;
  UInt32 sampleRateSize = sizeof(sampleRate);
  AudioSessionGetProperty(
      kAudioSessionProperty_CurrentHardwareSampleRate,
      &sampleRateSize, &sampleRate);

  AudioStreamBasicDescription streamFormat;
  size_t bytesPerSample = sizeof(AudioUnitSampleType);
  streamFormat.mFormatID = kAudioFormatLinearPCM;
  streamFormat.mFormatFlags = kAudioFormatFlagsAudioUnitCanonical;
  streamFormat.mBytesPerPacket = bytesPerSample;
  streamFormat.mFramesPerPacket = 1;
  streamFormat.mBytesPerFrame = bytesPerSample;
  streamFormat.mChannelsPerFrame = 2;
  streamFormat.mBitsPerChannel = 8*bytesPerSample;
  streamFormat.mSampleRate = sampleRate;
  return streamFormat;
}

- (void)dealloc {
  free(samplesByChannel_[0]);
  free(samplesByChannel_[1]);
}

- (AudioUnitSampleType*)sampleBuffer:(int)channel {
  return samplesByChannel_[channel];
}

@end
