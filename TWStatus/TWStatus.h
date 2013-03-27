//
//  TWStatus.h
//  Office24TH
//
//  Created by Thanakrit Weekhamchai on 3/21/13.
//  Copyright (c) 2013 Clbs Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWStatus : NSObject

@property (strong, nonatomic) NSString *status;

+ (void)showLoadingWithStatus:(NSString *)status;
+ (void)showStatus:(NSString *)status;
+ (void)dismiss;
+ (void)dismissAfter:(NSTimeInterval)interval;

@end
