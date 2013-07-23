//
//  FileHelper.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-07-23.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "FileHelper.h"

@implementation FileHelper

+ (NSData *)dataForFilename:(NSString *)filename {
    NSString *path = [self pathForFileName:filename];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}
+ (NSString *)pathForFileName:(NSString *)filename {
    NSString *documentsDirectory = [self documentsDirectory];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
    return path;
}
+ (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}


@end
