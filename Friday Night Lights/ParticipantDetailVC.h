//
//  ParticipantDetailVC.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextMessageManager.h"

@class Participant;

@interface ParticipantDetailVC : UITableViewController <TextMessageManagerDelegate>

@property (strong, nonatomic) Participant *participant;


@end
