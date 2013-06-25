//
//  UITableView+Helpers.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-25.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "UITableView+Helpers.h"

@implementation UITableView (Helpers)

- (void)deselectSelectedRow {
    NSIndexPath *indexPath = [self indexPathForSelectedRow];
    [self deselectRowAtIndexPath:indexPath animated:YES];
}

@end
