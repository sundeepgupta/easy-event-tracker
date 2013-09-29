//
//  TransactionsCell.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-07-17.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *dateValue;
@property (strong, nonatomic) IBOutlet UILabel *amountValue;

+ (void)setupReuseIdForTableView:(UITableView *)tableView;


@end
