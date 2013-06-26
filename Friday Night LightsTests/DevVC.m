//
//  DevVC.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "DevVC.h"
#import "Model.h"

@interface DevVC ()

@property (strong, nonatomic) Model *model;

@property (strong, nonatomic) IBOutlet UITextView *textView;
@end

@implementation DevVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)deleteStoreButtonPress:(UIButton *)sender {
    [Model resetStore];
    self.textView.text = @"Data deleted.";
}





- (void)viewDidUnload {
    [self setTextView:nil];
    [super viewDidUnload];
}
@end
