//
//  Sample.m
//  Drum Coach
//
//  Created by Matthew Schulkind on 11/16/12.
//  Copyright (c) 2012 Matthew Schulkind. All rights reserved.
//

#import "Sample.h"

@implementation Sample

- (id)initWithFileName:(NSString*)fileName {
  if ((self = [super init])) {
    OSStatus status;

    NSString* fullFileName = 
        [NSString stringWithFormat:@"Samples/%@", fileName];

    NSURL* url =
        [[NSBundle mainBundle] URLForResource:fullFileName withExtension:nil];

    ExtAudioFileRef file;
    status = ExtAudioFileOpenURL((__bridge CFURLRef)url, &file);
    assert(!status);

    UInt32 frameCountSize = sizeof(frameCount_);
    status = ExtAudioFileGetProperty(
        file, kExtAudioFileProperty_FileLengthFrames,
        &frameCountSize, &frameCount_);
    assert(!status);

    ExtAudioFileDispose(file);
  }
  return self;
}

+ (Sample*)sampleWithFileName:(NSString*)fileName {
  return [[Sample alloc] initWithFileName:fileName];
}

@end
