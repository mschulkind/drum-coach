//
//  DrumPadView.m
//  Drum Coach
//
//  Created by Matthew Schulkind on 11/15/12.
//  Copyright (c) 2012 Matthew Schulkind. All rights reserved.
//

#import "DrumPadView.h"

const int kNumPads = 4;
const CGFloat kPadSpacing = 15.0;
const CGFloat kPadCornerRadius = 15.0;
const CGFloat kPadBorderWidth = 9;
const int kPadActiveMS = 100;

UIColor* lightenColor(UIColor* color, float factor) {
  assert(factor >= 0);

  CGFloat hue, saturation, brightness, alpha;
  [color getHue:&hue 
     saturation:&saturation 
     brightness:&brightness 
          alpha:&alpha];

  brightness *= factor;
  if (brightness >= 1) brightness = 1;

  return [UIColor colorWithHue:hue
                    saturation:saturation 
                    brightness:brightness 
                         alpha:alpha];
}

@implementation DrumPadView

- (CGSize)padSize {
  return CGSizeMake(self.bounds.size.height, self.bounds.size.height);
}

- (CGRect)padRect:(int)n {
  CGFloat padWidth = self.bounds.size.height;
  CGFloat totalPadsWidth = kNumPads*padWidth + (kNumPads-1)*kPadSpacing;
  CGFloat padding = self.bounds.size.width - totalPadsWidth;

  CGSize size = [self padSize];

  return CGRectMake(
      padding/2 + n*(padWidth + kPadSpacing), 0, size.width, size.height);
}

- (UIColor*)padColor:(int)n {
  switch(n) {
    case 0:
      return [UIColor redColor];
    case 1:
      return [UIColor blueColor];
    case 2:
      return [UIColor greenColor];
    case 3:
      return [UIColor yellowColor];
    default:
      assert(false);
  }
}

- (id)initWithCoder:(NSCoder*)decoder {
  self = [super initWithCoder:decoder];
  if (self) {
    assert((self.bounds.size.width - (kNumPads - 1)*kPadSpacing) 
           / self.bounds.size.height >= kNumPads);

    padActive_ = [NSMutableArray arrayWithCapacity:kNumPads];
    for (int i = 0; i < kNumPads; ++i) {
      [padActive_ addObject:[NSNumber numberWithBool:NO]];
    }

    self.multipleTouchEnabled = YES;
  }
  return self;
}

- (void)setPad:(int)n asActive:(BOOL)active {
    [padActive_ setObject:[NSNumber numberWithBool:active] 
       atIndexedSubscript:n];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
  for (int i = 0; i < kNumPads; ++i) {
    __block BOOL padHit = NO;
    CGRect padRect = [self padRect:i];

    [touches enumerateObjectsUsingBlock:^(UITouch* touch, BOOL* stop) {
      if (CGRectContainsPoint(padRect, [touch locationInView:self])) {
        padHit = YES;
      }
    }];

    // Only redraw the pad if the active state changed.
    if (padHit) {
      [self setPad:i asActive:YES];
      [self setNeedsDisplayInRect:padRect];
      dispatch_after(
          dispatch_time(DISPATCH_TIME_NOW, kPadActiveMS*1e6),
          dispatch_get_main_queue(),
          ^{
            [self setPad:i asActive:NO];
            [self setNeedsDisplayInRect:padRect];
          });
    }
  }
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {}
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {}
- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {}

- (void)drawRect:(CGRect)rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();

  CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
  CGContextFillRect(context, self.bounds);

  for (int i = 0; i < kNumPads; ++i) {
    UIBezierPath* outsideRectPath =
        [UIBezierPath bezierPathWithRoundedRect:[self padRect:i]
                                   cornerRadius:kPadCornerRadius];
    CGRect insideRect =
        CGRectInset([self padRect:i], kPadBorderWidth, kPadBorderWidth);
    UIBezierPath* insideRectPath =
        [UIBezierPath 
            bezierPathWithRoundedRect:insideRect 
                         cornerRadius:kPadCornerRadius - kPadBorderWidth];

    UIColor* padColor = [self padColor:i];

    CGContextSetFillColorWithColor(
        context, lightenColor(padColor, 0.5).CGColor);
    [outsideRectPath fill];

    if (![[padActive_ objectAtIndex:i] boolValue]) {
      CGContextSetFillColorWithColor(context, padColor.CGColor);
      [insideRectPath fill];
    }
  }
}

@end
