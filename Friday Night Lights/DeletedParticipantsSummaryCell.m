//
//  DeletedParticipantsSummaryCell.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-10-14.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "DeletedParticipantsSummaryCell.h"

@implementation DeletedParticipantsSummaryCell

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

+ (void)setupReuseIdForTableView:(UITableView *)tableView {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([self class])];
}

@end
