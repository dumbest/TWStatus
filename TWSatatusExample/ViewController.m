//
//  ViewController.m
//  TWSatatusExample
//
//  Created by Thanakrit Weekhamchai on 3/27/13.
//  Copyright (c) 2013 Thanakrit Weekhamchai. All rights reserved.
//

#import "ViewController.h"
#import "TWStatus.h"

@interface ViewController ()

@end

@implementation ViewController

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

- (void)viewDidUnload {
    [self setTextfield:nil];
    [super viewDidUnload];
}

- (IBAction)statusButtonPressed:(UIButton *)sender {
    [TWStatus showStatus:self.textfield.text];
}

- (IBAction)loadingStatusButtonPressed:(UIButton *)sender {
    [TWStatus showLoadingWithStatus:self.textfield.text];
}

- (IBAction)dismissButtonPressed:(UIButton *)sender {
    [TWStatus dismiss];
}
@end
