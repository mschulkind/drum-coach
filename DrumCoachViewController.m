//
//  DrumCoachViewController.m
//  Drum Coach
//
//  Created by Matthew Schulkind on 11/15/12.
//  Copyright (c) 2012 Matthew Schulkind. All rights reserved.
//

#import "DrumCoachViewController.h"

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

@end
