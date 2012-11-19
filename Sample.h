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
}

- (id)initWithFileName:(NSString*)fileName;
+ (Sample*)sampleWithFileName:(NSString*)fileName;

@end
