//
//  PPAddressBookContact.m
//  PaperlessProblems
//
//  Created by Austin Lange on 12/19/14.
//  Copyright (c) 2014 Paperless Inc. All rights reserved.
//

#import "PPAddressBookContact.h"
#import "PPContact+PPMutableContact.h"

@implementation PPAddressBookContact

- (NSString *)description;
{
    NSString *contactTypeString;
    
    switch (self.contactType) {
        case PPAddressBookContactTypeIPhone:
            contactTypeString = @"iPhone"; break;
        case PPAddressBookContactTypeGoogle:
            contactTypeString = @"Google Contacts"; break;
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@ (%@)", self.emailAddress, contactTypeString];
}

@end
