//
//  Model.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Participant, Event;

@interface Model : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


- (Participant *)newParticipant;
- (Event *)newEvent;

- (NSArray *)participants;
- (NSArray *)events;













- (void)saveContext;


- (void)deleteObject:(NSManagedObject *)object;
- (void)resetStore;

@end
