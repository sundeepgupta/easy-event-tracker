//
//  DesignHelper.h
//  SalesCase
//
//  Created by Sundeep Gupta on 13-06-18.
//  Copyright (c) 2013 EnhanceTrade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesignHelper : NSObject

+ (void)customizeIphoneTheme;
+ (void)customizeNavigationBar;

+ (void)customizeTableView:(UITableView *)tableView;

+ (void)addBackgroundToView:(UIView *)view;

+ (void)customizeCell:(UITableViewCell *)cell;
+ (void)customizeCellText:(UIView *)view ;

@end
