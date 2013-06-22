//
//  EventAttributeCell.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-21.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventAttributeCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *fieldLabel;
@property (strong, nonatomic) IBOutlet UITextField *fieldValue;
@end
