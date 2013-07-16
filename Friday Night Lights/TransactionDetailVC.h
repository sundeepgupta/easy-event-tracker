//
//  TransactionDetailVC.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-07-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Participant, Transaction;

@interface TransactionDetailVC : UITableViewController

@property (strong, nonatomic) Transaction *transaction;
@property (strong, nonatomic) Participant *participant;

@end
