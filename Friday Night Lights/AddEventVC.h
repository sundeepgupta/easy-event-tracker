//
//  AddEventVC.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-22.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@class Event;

@interface AddEventVC : UITableViewController <MFMessageComposeViewControllerDelegate>
@property (strong, nonatomic) Event *event;

@end
