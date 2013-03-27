//
//  ViewController.h
//  TWSatatusExample
//
//  Created by Thanakrit Weekhamchai on 3/27/13.
//  Copyright (c) 2013 Thanakrit Weekhamchai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textfield;
- (IBAction)statusButtonPressed:(UIButton *)sender;
- (IBAction)loadingStatusButtonPressed:(UIButton *)sender;
- (IBAction)dismissButtonPressed:(UIButton *)sender;


@end
