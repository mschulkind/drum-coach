//
//  Sample.h
//  Drum Coach
//
//  Created by Matthew Schulkind on 11/16/12.
//  Copyright (c) 2012 Matthew Schulkind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sample : NSObject {
  SInt64 frameCount_;
  AudioUnitSampleType* samplesByChannel_[2];
}

@property (nonatomic, readonly) SInt64 frameCount;

- (id)initWithFileName:(NSString*)fileName;
+ (Sample*)sampleWithFileName:(NSString*)fileName;

+ (AudioStreamBasicDescription)streamFormat;

- (AudioUnitSampleType*)sampleBuffer:(int)channel;

@end
