//
//  NSDate+Helpers.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-22.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "NSDate+Helpers.h"

@implementation NSDate (Helpers)

- (NSString *)dateAndTimeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"eeee MMMM dd"];
    [dateFormatter setDateFormat:@"eee MMM dd 'at' h:mm a"];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eeee MMMM dd"];
    return [dateFormatter stringFromDate:self];
}

@end
