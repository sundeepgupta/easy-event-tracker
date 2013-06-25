//
//  MessageHelper.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-25.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageHelper : NSObject

+ (void)showCantSendTextAlert;

+ (NSArray *)mobileNumbersFromPartipants:(NSArray *)participants;

@end
