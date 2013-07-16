//
//  EventHelper.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-22.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Event, TDDatePickerController;

@interface EventHelper : NSObject

+ (BOOL)validReplacementString:(NSString *)replacementString forCostFieldString:(NSString *)costFieldString;

+ (void)saveCostString:(NSString *)costString toEvent:(Event *)event;

+ (void)presentDatePickerInVc:(UIViewController *)vc;

+ (void)setupCostValueForTextField:(UITextField *)textField forEvent:(Event *)event;


@end
