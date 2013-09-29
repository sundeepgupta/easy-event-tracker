//
//  Transaction.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-09-29.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Participant;

@interface Transaction : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * method;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * externalId;
@property (nonatomic, retain) Participant *participant;

@end
