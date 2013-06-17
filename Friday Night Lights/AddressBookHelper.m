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

@end
