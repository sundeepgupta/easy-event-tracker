//
//  Global.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Model;

@interface Global : NSObject

@property (strong, nonatomic) Model *model;

+ (id)sharedGlobal;

+ (void)showAlertWithTitle:(NSString *)title withMessage:(NSString *)message; 

@end
