//
//  EventDetailVC.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-22.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextMessageManager.h"

@class Event;

@interface EventDetailVC : UITableViewController <TextMessageManagerDelegate>
@property (strong, nonatomic) Event *event;

@end
