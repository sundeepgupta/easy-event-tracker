//
//  keyValueCell.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-09-25.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "KeyValueLabelCell.h"

@implementation KeyValueLabelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
