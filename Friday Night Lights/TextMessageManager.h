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
- (void)presentMessageComposeVc:(MFMessageComposeViewController *)messageComposeVc;
@end




@interface TextMessageManager : NSObject <MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) NSArray *recipients;
@property (strong, nonatomic) NSString *body;
@property (weak, nonatomic) id<TextMessageManagerDelegate> delegate;

- (id)initWithRecipients:(NSArray *)recipients body:(NSString *)body delegate:(id)delegate;
- (void)sendTextMessage;

@end





