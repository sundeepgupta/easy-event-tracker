//
//  UIAlertView+Helpers.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-17.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "UIAlertView+Helpers.h"

@implementation UIAlertView (Helpers)

+ (void)showAlertWithTitle:(NSString *)title withMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

@end
