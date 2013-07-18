//
//  DesignHelper.m
//  SalesCase
//
//  Created by Sundeep Gupta on 13-06-18.
//  Copyright (c) 2013 EnhanceTrade. All rights reserved.
//

#import "DesignHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation DesignHelper
 
#pragma mark - Colors
+ (UIColor *)lightTextColor {
    return [UIColor whiteColor];
}
+ (UIColor *)darkTextColor {
    return [UIColor colorWithRed:0.0 green:68.0/255 blue:118.0/255 alpha:1.0];
}
+ (UIColor *)lightTextShadowColor {
    return [UIColor colorWithRed:25.0/255 green:96.0/255 blue:148.0/255 alpha:1.0];
}
+ (UIColor *)darkTextShadowColor {
    return  [UIColor whiteColor];
}
+ (UIColor *)customBlueColor {
    return [UIColor colorWithRed:21/255 green:126/255 blue:196/255 alpha:1.0];
    //#157ec4
}

+ (void)customizeIphoneTheme {
    [self customizeStatusBar];
    [self customizeNavigationBar];
}
+ (void)customizeStatusBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
}

+ (void)customizeNavigationBar {
    UIImage *navBarImage = [[UIImage imageNamed:@"menubar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 15, 5, 15)];
    
    [[UINavigationBar appearance] setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
    
    [self customizeNavigationBarButton];
    [self customizeNavigationBackButton];
}
+ (void)customizeNavigationBarButton {
    UIImage *barButton = [[UIImage imageNamed:@"menubar-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    
    [[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
}
+ (void)customizeNavigationBackButton {
    UIImage *backButton = [[UIImage imageNamed:@"back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 4)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
}


#pragma mark - Table View
+ (void)customizeTableView:(UITableView *)tableView {
    [self addTopShadowToView:tableView];
    [self addBackgroundToView:tableView];
}
+ (void)addTopShadowToView:(UIView *)view {
    CGRect shadowFrame = [self shadowFrameFromView:view];
    CALayer *shadow = [self shadowFromFrame:shadowFrame];
    [view.layer addSublayer:shadow];
}
+ (CGRect)shadowFrameFromView:(UIView *)view {
    CGFloat frameWidth;
    
    if (view.frame.size.height == 1024) { //LoginVC is using the wrong orientation
        frameWidth = view.frame.size.height;
    } else {
        frameWidth = view.frame.size.width;
    }
    CGFloat frameHeight = 5;
    return CGRectMake(0, 0, frameWidth, frameHeight);
}
+ (CALayer *)shadowFromFrame:(CGRect)frame
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = frame;
    
    UIColor* lightColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    UIColor* darkColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    gradient.colors = [NSArray arrayWithObjects:(id)darkColor.CGColor, (id)lightColor.CGColor, nil];
    
    return gradient;
}
+ (void)addBackgroundToView:(UIView *)view {
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-BG-pattern.png"]];
    view.backgroundColor = bgColor;
    
    if ([view isKindOfClass:[UITableView class]]) {
        [self removeBackgroundViewFromTableView:(UITableView *)view];
    }
}
+ (void)removeBackgroundViewFromTableView:(UITableView *)tableView {
    tableView.backgroundView = nil;
}


#pragma mark - Table Cells
+ (void)customizeCells:(NSArray *)cells {
    for (UITableViewCell *cell in cells) {
        [self customizeCell:cell];
    }
}

+ (void)customizeCell:(UITableViewCell *)cell {
    [self customizeBackgroundForSelectedCell:cell];
    [self customizeBackgroundForUnSelectedCell:cell];

    [self customizeCellText:cell];
}
    + (void)customizeBackgroundForSelectedCell:(UITableViewCell *)cell {
        UIImage *image = [UIImage imageNamed:@"ipad-list-item-selected.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        cell.selectedBackgroundView = imageView;
    }
+ (void)customizeBackgroundForUnSelectedCell:(UITableViewCell *)cell {
    UIImage *image = [UIImage imageNamed:@"ipad-list-element.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    cell.backgroundView = imageView;
    cell.backgroundView.opaque = YES;
}

+ (void)customizeCellText:(UIView *)view {
    
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UILabel class]] || [subView isKindOfClass:[UITextField class]]) {
            [self customizeSelectedCellText:subView];
            [self customizeUnSelectedCellText:subView];
        } else {
            [self customizeCellText:subView];
        }
    }
}
+ (void)customizeSelectedCellText:(UIView *)view {
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *castedView = (UILabel *)view;
        castedView.textColor = [self lightTextColor];
        castedView.shadowColor = [self lightTextShadowColor];
        castedView.shadowOffset = CGSizeMake(0, -1);
    } else if ([view isKindOfClass:[UITextField class]]) {
        UITextField *castedView = (UITextField *)view;
        castedView.textColor = [self lightTextColor];
    }
}
+ (void)customizeUnSelectedCellText:(UIView *)view {
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *castedView = (UILabel *)view;
        castedView.textColor = [self darkTextColor];
        castedView.shadowColor = [self darkTextShadowColor];
        castedView.shadowOffset = CGSizeMake(0, 1);
    } else if ([view isKindOfClass:[UITextField class]]) {
        UITextField *castedView = (UITextField *)view;
        castedView.textColor = [self darkTextColor];
    }
}

+ (void)removeBorderForGroupedCells:(NSArray *)cells {
    for (UITableViewCell *cell in cells) {
        CGRect frame = cell.backgroundView.frame;
        UIView *view = [[UIView alloc] initWithFrame:frame];
        cell.backgroundView = view;
    }
}







@end
