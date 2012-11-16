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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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

@end
