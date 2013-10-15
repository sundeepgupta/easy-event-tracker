//
//  DeletedParticipantsSummaryCell.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-10-14.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeletedParticipantsSummaryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *countValue;

+ (void)setupReuseIdForTableView:(UITableView *)tableView;

@end
