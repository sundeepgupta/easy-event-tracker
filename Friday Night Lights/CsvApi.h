//
//  CsvApi.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-07-23.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHCSVWriter;

@interface CsvApi : NSObject
@property (strong, nonatomic) CHCSVWriter *writer;

- (id)initWithPath:(NSString *)path;

- (void)writeEvent:(Event *)event;






- (void)writeField:(NSString *)field;
- (void)finishLine;
- (void)writeLineOfFields:(id<NSFastEnumeration>)fields;
- (void)closeStream;


@end
