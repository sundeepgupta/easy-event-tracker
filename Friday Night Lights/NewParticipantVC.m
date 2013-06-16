//
//  NewParticipantVC.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "NewParticipantVC.h"
#import "Participant.h"
#import "Model.h"

@interface NewParticipantVC ()

@property (strong, nonatomic) Model *model;

@property (strong, nonatomic) IBOutlet UITextField *nameField;

@end

@implementation NewParticipantVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    Global *global = [Global sharedGlobal];
    self.model = global.model;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)doneButtonPress:(UIBarButtonItem *)sender {
    [self saveParticipant];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveParticipant {
    self.participant.name = self.nameField.text;
    [self.model saveContext];
}

- (void)viewDidUnload {
    [self setNameField:nil];
    [super viewDidUnload];
}
@end
