//
//  PPAddressBook.h
//  PaperlessProblems
//
//  Created by Salvatore Randazzo on 8/19/14.
//  Copyright (c) 2014 Paperless Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPAddressBook : NSObject <UITableViewDataSource>

// Since we will use the PPAddressBook object as a table view data source,
// we don't need to actually return anything in the completion block.
- (void)loadContacts:(void(^)(void))completionBlock error:(void(^)(NSError *error))errorBlock;
- (NSArray *)search:(NSString *)keyword;

@end
