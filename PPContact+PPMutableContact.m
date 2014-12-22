//
//  PPContact+PPMutableContact.m
//  PaperlessProblems
//
//  Created by Austin Lange on 12/19/14.
//  Copyright (c) 2014 Paperless Inc. All rights reserved.
//

#import "PPContact+PPMutableContact.h"

@implementation PPContact (PPMutableContact)

- (instancetype)initWithName:(NSString *)name andEmail:(NSString *)emailAddress;
{
    self = [self init];
    if (!self) return nil;
    
    self.name = name;
    self.emailAddress = emailAddress;
    
    return self;
}

@end
