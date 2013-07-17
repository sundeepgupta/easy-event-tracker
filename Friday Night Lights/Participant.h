//
//  Participant.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-07-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Transaction;

@interface Participant : NSManagedObject

@property (nonatomic, retain) NSNumber * abRecordId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *transactions;
@end

@interface Participant (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

- (void)addTransactionsObject:(Transaction *)value;
- (void)removeTransactionsObject:(Transaction *)value;
- (void)addTransactions:(NSSet *)values;
- (void)removeTransactions:(NSSet *)values;

@end
