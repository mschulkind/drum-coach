//
//  DrumCoachViewController.h
//  Drum Coach
//
//  Created by Matthew Schulkind on 11/15/12.
//  Copyright (c) 2012 Matthew Schulkind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrumPadView.h"
#import "SamplePlayer.h"

@interface DrumCoachViewController : UIViewController <DrumPadDelegate> {
  IBOutlet UILabel* tempoValueLabel_;
  IBOutlet UISlider* tempoSlider_;
  IBOutlet DrumPadView* drumPadView_;
  int tempo_;
  SamplePlayer* samplePlayer_;
  int drumSampleIDs_[4];
}

@end
