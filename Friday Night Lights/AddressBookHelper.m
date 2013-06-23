//
//  AddressBookHelper.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-17.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "AddressBookHelper.h"

@implementation AddressBookHelper

+ (ABAddressBookRef)addressBook {
    ABAddressBookRef addressBook;
    if (&ABAddressBookCreateWithOptions != NULL) {
        addressBook = ABAddressBookCreateWithOptions(nil, nil);
    } else { //below iOS 6
        addressBook = ABAddressBookCreate();
    }
    return addressBook;
}

+ (NSNumber *)abRecordIdFromAbRecordRef:(ABRecordRef)abRecordRef {
    return  [NSNumber numberWithInt:ABRecordGetRecordID(abRecordRef)];
}

+ (NSString *)abCompositeNameFromAbRecordId:(NSNumber *)abRecordId {
    ABRecordRef abRecordRef = [self abRecordRefFromAbRecordId:abRecordId];
    return (__bridge NSString *)ABRecordCopyCompositeName(abRecordRef); 
}
+ (ABRecordRef)abRecordRefFromAbRecordId:(NSNumber *)abRecordId {
    ABAddressBookRef addressBook = [self addressBook];
    NSInteger abRecordIdInteger = abRecordId.intValue;
    return  ABAddressBookGetPersonWithRecordID(addressBook, abRecordIdInteger);
}

+ (NSString *)mobileNumberFromAbRecordId:(NSNumber *)abRecordId {
    ABRecordRef abRecordRef = [self abRecordRefFromAbRecordId:abRecordId];

    ABMultiValueRef phoneNumbers = ABRecordCopyValue(abRecordRef, kABPersonPhoneProperty);
    
    return [self mobileNumberFromPhoneNumbers:phoneNumbers];
}

+ (NSString *)mobileNumberFromPhoneNumbers:(ABMultiValueRef)phoneNumbers {
    NSString *mobileNumber = @"";
    for(CFIndex j = 0; j < ABMultiValueGetCount(phoneNumbers); j++)
    {
        CFStringRef localizedLabel = ABMultiValueCopyLabelAtIndex(phoneNumbers, j);
        NSString *phoneLabel =(__bridge NSString *)ABAddressBookCopyLocalizedLabel(localizedLabel);
        
        if ([phoneLabel isEqualToString:@"mobile"]) {
            CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phoneNumbers, j);
            mobileNumber = (__bridge NSString *)phoneNumberRef;
        }
    }
    return mobileNumber;
}

@end
