//
//  ParticipantDetailVC.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class Participant;

@interface ParticipantDetailVC : UITableViewController <MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) Participant *participant;


@end
