//
//  EventDetailVC.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-21.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Event;

@interface EventDetailVC : UITableViewController

@property (strong, nonatomic) Event *event;

@end
