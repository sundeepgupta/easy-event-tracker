//
//  EventsCell.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-07-18.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *dateValue;
@property (strong, nonatomic) IBOutlet UILabel *confirmedParticipantsValue;

+ (void)setupReuseIdForTableView:(UITableView *)tableView;

@end
