//
//  Helper.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-07-14.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+ (void)addTapRecognizerToVc:(UIViewController *)vc {
    //Needed to dismiss keyboard on text field
    //http://stackoverflow.com/questions/5306240/iphone-dismiss-keyboard-when-touching-outside-of-textfield
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:vc action:@selector(dismissKeyboard:)];
    tap.cancelsTouchesInView = FALSE;
    [vc.view addGestureRecognizer:tap];
}



@end
