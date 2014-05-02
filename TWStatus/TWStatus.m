//
//  TWStatus.m
//  Office24TH
//
//  Created by Thanakrit Weekhamchai on 3/21/13.
//  Copyright (c) 2013 Clbs Ltd. All rights reserved.
//

#import "TWStatus.h"

const static CGFloat kTWStatusHeight = 20;

@interface TWStatus (){
    UIWindow *_statusWindow;
    UIView *_backgroundView;
    UILabel *_statusLabel;
    
    UIActivityIndicatorView *_activityIndicator;
}

@end

@implementation TWStatus

- (id)init{
    self = [super init];
    if (self) {
        [self setupDefaultApperance];
        
        // Orientation support
        // No harm if this gets called multiple times
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)setupDefaultApperance{
    CGFloat screenWidth = [UIScreen mainScreen].applicationFrame.size.width;
    _statusWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, screenWidth, kTWStatusHeight)];
    _statusWindow.windowLevel = UIWindowLevelStatusBar;
    _statusWindow.backgroundColor = [UIColor blackColor];
    _statusWindow.alpha = 0.0;
    
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, kTWStatusHeight)];
    _backgroundView.backgroundColor = [UIColor clearColor];
    _backgroundView.alpha = 0.0;
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, kTWStatusHeight)];
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.textColor = [UIColor colorWithRed:191.0/255.0 green:191.0/255.0 blue:191.0/255.0 alpha:1.0];
    _statusLabel.font = [UIFont boldSystemFontOfSize:13];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.numberOfLines = 1;
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
    _activityIndicator.transform = CGAffineTransformMakeScale(0.6, 0.6);
    _activityIndicator.frame = CGRectMake(0, 0, 20, 20);
    _activityIndicator.hidesWhenStopped = YES;
    
    [_backgroundView addSubview:_statusLabel];
    [_backgroundView addSubview:_activityIndicator];
    
    [_statusWindow addSubview:_backgroundView];
    
    [self layoutForOrientation];
}

+ (id)sharedTWStatus{
    
    static TWStatus *_sharedTWStatus = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedTWStatus = [[TWStatus alloc] init];
    });
    
    return _sharedTWStatus;
}

+ (void)showLoadingWithStatus:(NSString *)status{
    [[TWStatus sharedTWStatus] showLoadingWithStatus:status];
}

+ (void)showStatus:(NSString *)status{
    [[TWStatus sharedTWStatus] showStatus:status];
}

+ (void)dismiss{
    [[TWStatus sharedTWStatus] dismiss];
}

+ (void)dismissAfter:(NSTimeInterval)interval{
    [[TWStatus sharedTWStatus] dismissAfter:interval];
}

#pragma mark - orientation

- (void)handleOrientationChange:(NSNotification *)notif {
    // NOTE- In iOS7.1, statusBarOrientation property returns final value after the orientation is completed
    // Hence do the layout with delay
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.09) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(([UIApplication sharedApplication].statusBarOrientationAnimationDuration + .1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self layoutForOrientation];
            [self layout];
        });
    }
    else {
        [self layoutForOrientation];
        [self layout];
    }
}

#pragma mark - private

- (void)layoutForOrientation {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGAffineTransform t;
    CGRect frame;
    CGSize sizeAppFrame = [UIScreen mainScreen].applicationFrame.size;
    switch (orientation) {
        default:
            NSLog(@"Warning - Unrecognised interface orientation (%d)",orientation);
        case UIInterfaceOrientationPortrait:
            t = CGAffineTransformIdentity;
            frame = CGRectMake(0, 0, sizeAppFrame.width, kTWStatusHeight);
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            t = CGAffineTransformMakeRotation(-M_PI_2);
            frame = CGRectMake(0, 0, kTWStatusHeight, sizeAppFrame.height);
            break;;
            
        case UIInterfaceOrientationLandscapeRight:
            t = CGAffineTransformMakeRotation(M_PI_2);
            if ([UIApplication sharedApplication].statusBarHidden) {
                frame = CGRectMake(sizeAppFrame.width-kTWStatusHeight, 0, kTWStatusHeight, sizeAppFrame.height);
            }
            else {
                frame = CGRectMake(sizeAppFrame.width, 0, kTWStatusHeight, sizeAppFrame.height);
            }
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            t = CGAffineTransformMakeRotation(M_PI);
            if ([UIApplication sharedApplication].statusBarHidden) {
                frame = CGRectMake(0, sizeAppFrame.height - kTWStatusHeight, sizeAppFrame.width, kTWStatusHeight);
            }
            else {
                frame = CGRectMake(0, sizeAppFrame.height, sizeAppFrame.width, kTWStatusHeight);
            }
            break;
    }
    // Apply transform
    _statusWindow.transform = t;
    
    // Update frame
    _statusWindow.frame = frame;
}

- (void)showLoadingWithStatus:(NSString *)status{
    
    if (_statusWindow.hidden) {
        
        [self setStatus:status];
        _statusWindow.hidden = NO;

        [_activityIndicator startAnimating];
        
        [UIView animateWithDuration:0.2 animations:^{
            _statusWindow.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05 animations:^{
                _backgroundView.alpha = 1.0;
            }];
        }];
        
    }else{
        
        [UIView animateWithDuration:0.1 animations:^{
            _backgroundView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self setStatus:status];
            [_activityIndicator startAnimating];

            [UIView animateWithDuration:0.1 animations:^{
                _backgroundView.alpha = 1.0;
                
            }];
        }];
    }
}

- (void)showStatus:(NSString *)status{
    
    [_activityIndicator stopAnimating];

    if (_statusWindow.hidden) {
        
        [self setStatus:status];
        _statusWindow.hidden = NO;

        [UIView animateWithDuration:0.2 animations:^{
            
            _statusWindow.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.05 animations:^{
                
                _backgroundView.alpha = 1.0;
                
            }];
            
        }];
        
    }else{
        
        [UIView animateWithDuration:0.1 animations:^{
            
            _backgroundView.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            _activityIndicator.alpha = 1.0;
            [self setStatus:status];
            
            [UIView animateWithDuration:0.1 animations:^{
                
                _backgroundView.alpha = 1.0;
            
            }];
        }];
    }
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.05 animations:^{
        
        _backgroundView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            _statusWindow.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            _statusWindow.hidden = YES;
            [[[[UIApplication sharedApplication] delegate] window] makeKeyWindow];
        }];
    }];
}

- (void)dismissAfter:(NSTimeInterval)interval{

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self dismiss];
    });
}

#pragma mark - properties
- (void)setStatus:(NSString *)status{
    _status = status;
    _statusLabel.text = status;
    
    [self layout];
}

- (void)layout{
    CGFloat screenWidth = [UIScreen mainScreen].applicationFrame.size.width;
    CGSize size = [_status sizeWithFont:_statusLabel.font forWidth:screenWidth lineBreakMode:_statusLabel.lineBreakMode];
 
    CGRect statusLabelFrame = _statusLabel.frame;
    statusLabelFrame.size.width = size.width;

    if (_activityIndicator.isAnimating) {
        statusLabelFrame.origin.x += 10;
    }
    _statusLabel.frame = statusLabelFrame;
    _statusLabel.center = _backgroundView.center;
    
    CGRect activityFrame = _activityIndicator.frame;
    activityFrame.origin.x = CGRectGetMinX(_statusLabel.frame) - 20;
    _activityIndicator.frame = activityFrame;
    
}

@end
