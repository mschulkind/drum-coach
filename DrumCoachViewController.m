//
//  DrumCoachViewController.m
//  Drum Coach
//
//  Created by Matthew Schulkind on 11/15/12.
//  Copyright (c) 2012 Matthew Schulkind. All rights reserved.
//

#import "DrumCoachViewController.h"
#import "SamplePlayer.h"

@interface DrumCoachViewController ()

@end

@implementation DrumCoachViewController

- (void)updateTempoValues {
  tempo_ = (int)floor([tempoSlider_ value]);
  tempoValueLabel_.text = [NSString stringWithFormat:@"%d", tempo_];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self updateTempoValues];

  samplePlayer_ = [[SamplePlayer alloc] init];
  drumSampleIDs_[0] = [samplePlayer_ addSample:@"hihat_foot.wav"];
  drumSampleIDs_[1] = [samplePlayer_ addSample:@"kick.wav"];
  drumSampleIDs_[2] = [samplePlayer_ addSample:@"snare.wav"];
  drumSampleIDs_[3] = [samplePlayer_ addSample:@"ride.wav"];

  drumPadView_.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)toInterfaceOrientation {
  return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (NSUInteger)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskLandscape;
}

- (IBAction)onTempoChange:(UISlider*)sender {
  [self updateTempoValues];
}

- (void)drumPadTriggered:(int)index {
  [samplePlayer_ triggerSample:drumSampleIDs_[index]];
}

@end
