//
//  FileHelper.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-07-23.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHelper : NSObject

+ (NSData *)dataForFilename:(NSString *)filename;
+ (NSString *)pathForFileName:(NSString *)name;
+ (NSString *)documentsDirectory;
@end
