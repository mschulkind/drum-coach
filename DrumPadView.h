//
//  DrumPadView.h
//  Drum Coach
//
//  Created by Matthew Schulkind on 11/15/12.
//  Copyright (c) 2012 Matthew Schulkind. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DrumPadDelegate
- (void)drumPadTriggered:(int)index;
@end

@interface DrumPadView : UIView {
  NSMutableArray* padActive_;
  id<DrumPadDelegate> delegate_;
}

@property (nonatomic) id<DrumPadDelegate> delegate;

@end
