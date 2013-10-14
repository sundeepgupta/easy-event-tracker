//
//  TextMessageManager.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-10-03.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>


@protocol TextMessageManagerDelegate
@required

@end


@interface TextMessageManager : NSObject <MFMessageComposeViewControllerDelegate>

@property (weak, nonatomic) id<TextMessageManagerDelegate> delegate;

@end





