//
//  TextMessageManager.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-10-03.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "TextMessageManager.h"
#import "UIAlertView+Helpers.h"

@interface TextMessageManager ()
@property (strong, nonatomic) MFMessageComposeViewController *messageComposeVc;
@end

@implementation TextMessageManager

- (id)initWithRecipients:(NSArray *)recipients body:(NSString *)body delegate:(id)delegate {
    self = [super init];
    if (self) {
        self.recipients = recipients;
        self.body = body;
        self.delegate = delegate;
    }
    return self;
}


- (void)sendTextMessage {
    if (self.recipients.count > 0) {
        [self setupMessageComposeVc];
        [self.delegate presentMessageComposeVc:self.messageComposeVc];
    } else {
        [UIAlertView showAlertWithTitle:@"No Recipients" withMessage:@"No mobile numbers were found."];
    }
}
- (void)setupMessageComposeVc {
    self.messageComposeVc = [[MFMessageComposeViewController alloc] init];
    self.messageComposeVc.recipients = self.recipients;
    self.messageComposeVc.body = self.body;
    self.messageComposeVc.messageComposeDelegate = self;
}



#pragma mark - MessageComposerViewController Delegate Methods
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultCancelled: {
            break;
        }
        case MessageComposeResultSent: {
            break;
        }
        case MessageComposeResultFailed: {
            [UIAlertView showAlertWithTitle:@"Send Error" withMessage:@"There was an error sending the text messages"];
            break;
        }
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}


@end
