//
//  EventsCell.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-07-18.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "EventsCell.h"

@implementation EventsCell

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

+ (CGFloat)height {
    UIView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    CGFloat height = view.frame.size.height;
    view = nil;
    return height;
}


@end
