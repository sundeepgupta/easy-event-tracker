//
//  ParticipantsVC.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@class Event;

@interface ParticipantsVC : UITableViewController <ABPeoplePickerNavigationControllerDelegate>


@property BOOL isAddConfirmedMode;
@property (weak, nonatomic) Event *event;


- (IBAction)addButtonPress:(UIBarButtonItem *)sender;

@end
