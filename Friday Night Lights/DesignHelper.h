//
//  DesignHelper.h
//  SalesCase
//
//  Created by Sundeep Gupta on 13-06-18.
//  Copyright (c) 2013 EnhanceTrade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesignHelper : NSObject

+ (UIColor *)customBlueColor;


+ (void)customizeIphoneTheme;
+ (void)customizeNavigationBar;

+ (void)customizeTableView:(UITableView *)tableView;

+ (void)addBackgroundToView:(UIView *)view;

+ (void)customizeCells:(NSArray *)cells;
+ (void)customizeCell:(UITableViewCell *)cell;
+ (void)customizeInactiveCell:(UITableViewCell *)cell;
+ (void)customizeTextForCell:(UIView *)view ;
+ (void)customizeTextForInactiveCell:(UIView *)view;

+ (void)removeBorderForGroupedCells:(NSArray *)cells;
@end
