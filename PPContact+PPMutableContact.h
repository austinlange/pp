//
//  PPContact+PPMutableContact.h
//  PaperlessProblems
//
//  Created by Austin Lange on 12/19/14.
//  Copyright (c) 2014 Paperless Inc. All rights reserved.
//

#import "PPContact.h"

@interface PPContact (PPMutableContact)

- (instancetype)initWithName:(NSString *)name andEmail:(NSString *)emailAddress;

@end
