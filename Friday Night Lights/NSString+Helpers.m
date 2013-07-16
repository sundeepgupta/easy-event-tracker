//
//  NSString+Helpers.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-22.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "NSString+Helpers.h"

@implementation NSString (Helpers)

- (BOOL)hasNumbersOnly {
    BOOL hasNumbersOnly = NO;
    
    NSCharacterSet *validCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"-.0123456789"];
    NSCharacterSet *invalidCharacterSet = validCharacterSet.invertedSet;
    NSArray *separatedString = [self componentsSeparatedByCharactersInSet:invalidCharacterSet];
    NSString *validatedString = [separatedString componentsJoinedByString:@""];
    if ([self isEqualToString:validatedString]) {
        hasNumbersOnly = YES;
    }
    
    return hasNumbersOnly;
}

- (BOOL)containsString:(NSString *)substring {
    NSRange range = [self rangeOfString:substring];
    BOOL found = (range.location != NSNotFound);
    return found;
}

@end
