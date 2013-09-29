//
//  Participant.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-09-29.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Transaction;

@interface Participant : NSManagedObject

@property (nonatomic, retain) NSNumber * abRecordId;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * playsForFree;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * salutation;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * externalId;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *expenses;
@property (nonatomic, retain) NSSet *transactions;
@end

@interface Participant (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

- (void)addExpensesObject:(NSManagedObject *)value;
- (void)removeExpensesObject:(NSManagedObject *)value;
- (void)addExpenses:(NSSet *)values;
- (void)removeExpenses:(NSSet *)values;

- (void)addTransactionsObject:(Transaction *)value;
- (void)removeTransactionsObject:(Transaction *)value;
- (void)addTransactions:(NSSet *)values;
- (void)removeTransactions:(NSSet *)values;

@end
