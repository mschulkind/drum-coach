//
//  SamplePlayer.h
//  Drum Coach
//
//  Created by Matthew Schulkind on 11/16/12.
//  Copyright (c) 2012 Matthew Schulkind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SamplePlayer : NSObject {
  NSMutableArray* samples_;
  AUGraph graph_;
}

- (int)addSample:(NSString*)fileName;
- (void)triggerSample:(int)sampleID;

@end
