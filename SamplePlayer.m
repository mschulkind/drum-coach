//
//  SamplePlayer.m
//  Drum Coach
//
//  Created by Matthew Schulkind on 11/16/12.
//  Copyright (c) 2012 Matthew Schulkind. All rights reserved.
//

#import "SamplePlayer.h"

@implementation SamplePlayer

- (id)init
{
  if ((self = [super init])) {
    nextSampleID_ = 0;
  }
  return self;
}

- (int)addSample:(NSString*)fileName {
  return nextSampleID_++;
}

- (void)triggerSample:(int)sampleID {
  NSLog(@"trigger %d", sampleID);
}

@end
