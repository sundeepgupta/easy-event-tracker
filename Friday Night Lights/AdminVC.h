//
//  AdminVC.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-07-18.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextMessageManager.h"

@interface AdminVC : UITableViewController <TextMessageManagerDelegate, MFMailComposeViewControllerDelegate>

@end
