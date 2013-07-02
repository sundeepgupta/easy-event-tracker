//
//  ParticipantsVC.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ParticipantsVC : UITableViewController <ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic) BOOL eventMode;

- (IBAction)addButtonPress:(UIBarButtonItem *)sender;

@end
