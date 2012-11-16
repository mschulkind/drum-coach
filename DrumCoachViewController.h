//
//  DrumCoachViewController.h
//  Drum Coach
//
//  Created by Matthew Schulkind on 11/15/12.
//  Copyright (c) 2012 Matthew Schulkind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrumCoachViewController : UIViewController {
  IBOutlet UILabel* tempoValueLabel_;
  IBOutlet UISlider* tempoSlider_;
  int tempo_;
}

@end
