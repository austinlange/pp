//
//  PPAddressBookContact.h
//  PaperlessProblems
//
//  Created by Austin Lange on 12/19/14.
//  Copyright (c) 2014 Paperless Inc. All rights reserved.
//

#import "PPContact+PPMutableContact.h"

// Define an enum representing our possible contact types.
// Since this is a zero-based enum, it will map directly to the
// table view section numbers.
typedef NS_ENUM(NSUInteger, PPAddressBookContactType) {
    PPAddressBookContactTypeIPhone,
    PPAddressBookContactTypeGoogle,
    
    // bit of hackery here, but since we're using consecutive values it should be ok
    PPAddressBookNumberOfTypes
};

@interface PPAddressBookContact : PPContact

@property (nonatomic) PPAddressBookContactType contactType;

@end
