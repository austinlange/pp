//
//  PPAddressBook.m
//  PaperlessProblems
//
//  Created by Salvatore Randazzo on 8/19/14.
//  Copyright (c) 2014 Paperless Inc. All rights reserved.
//

#import "PPAddressBook.h"
#import "PPAddressBookContact.h"

#define CELL_IDENTIFIER @"Cell"

@interface PPAddressBook ()

@property (nonatomic, strong) NSArray *allContacts;
@property (nonatomic, strong) NSMutableDictionary *searchResults;
@property (nonatomic, strong) NSArray *emailContacts;

@end

@implementation PPAddressBook

- (void)loadContacts:(void(^)(void))completionBlock error:(void(^)(NSError *error))errorBlock;
{
    // declare an error object to handle whatever errors might be thrown by the contact
    // loading process
    __block NSError *error;

    // an array to hold our loaded contacts
    __block NSMutableArray *contacts = [NSMutableArray array];

    // if we want to use a single array with our asynchronous load tasks,
    // we need to be aware of thread safety.
    
    // since we're running multiple blocks, we have to guard against
    // multiple blocks attempting to modify the array at the same time.
    
    // solution: use a semaphore to force a block to wait until it's safe
    // to access the array.
    __block dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);

    // since we're running asynchronous tasks, we can
    // run them concurrently in the background and
    // utilize a dispatch group to let us know when everything's done
    dispatch_group_t group = dispatch_group_create();
    
    // load iPhone contacts
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // this is just a stub for some data. replace with requesting permission
        // to access the contacts, loading them, and handling errors
        
        // however, a similar for loop would probably be a common feature. presumably
        // we'd end up with an array of contacts from our data source, which we
        // would loop through and process.
        for (int i = 1; i <= 50; i++) {
            PPAddressBookContact *newContact = [[PPAddressBookContact alloc] initWithName:[NSString stringWithFormat:@"iPhone Contact %d", i] andEmail:[NSString stringWithFormat:@"iPhone.%d@icloud.com", i]];
            newContact.contactType = PPAddressBookContactTypeIPhone;
            
            // wait until it's safe, then insert the new contact into the array
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            [contacts addObject:newContact];
            dispatch_semaphore_signal(semaphore);
        }
        
    });

    // load Google contacts
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (int i = 1; i <= 50; i++) {
            PPAddressBookContact *newContact = [[PPAddressBookContact alloc] initWithName:[NSString stringWithFormat:@"Google Contact %d", i] andEmail:[NSString stringWithFormat:@"Google.%d@gmail.com", i]];
            newContact.contactType = PPAddressBookContactTypeGoogle;

            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            [contacts addObject:newContact];
            dispatch_semaphore_signal(semaphore);
        }
        
    });
    
    
    // continue to add more asynchronous tasks by appending them to the group
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // load some contacts!
        // don't forget to wait on the semaphore and signal when we're done
    });
    
    
    // schedule a notification for when the group finishes, and dispatch
    // our completion blocks to the main thread
    
    // once again, avoid a retain cycle by not capturing self strongly
    __weak typeof (self) weakSelf = self;
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        // clear our search and filter caches
        weakSelf.searchResults = nil;
        weakSelf.emailContacts = nil;
        
        // store our contacts internally for operations like searching and filtering
        weakSelf.allContacts = [NSArray arrayWithArray:contacts];
        
        if (!error) {
            completionBlock();
        } else {
            errorBlock(error);
        }
    });
}

// Filtering and searching

- (void)setAllContacts:(NSArray *)allContacts;
{
    _allContacts = allContacts;
    
    // when the local data store changes, update our stored email filter
    self.emailContacts = [self.allContacts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"emailAddress <> '' AND emailAddress <> nil"]];
}

// Since we always only want to display contacts with an email, we first filter
// by email and then by the specified type.
- (NSArray *)filterContactsByType:(PPAddressBookContactType)type;
{
    NSArray *filteredContacts = [self.emailContacts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"contactType = %@", @(type)]];
    return filteredContacts;
}

- (NSArray *)search:(NSString *)keyword;
{
    if (!self.searchResults) {
        self.searchResults = [NSMutableDictionary dictionary];
    }
    
    NSArray *cachedResults = [self.searchResults objectForKey:keyword];
    
    if (!cachedResults) {
        cachedResults = [self.allContacts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name LIKE *%@* OR emailAddress LIKE *%@*", keyword, keyword]];
        
        [self.searchResults setObject:cachedResults forKey:keyword];
    }

    return cachedResults;
}

#pragma mark UITableViewDataSource implementation
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    // dequeue a cell if we have one to re-use, create it if not.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_IDENTIFIER];
    }
    
    // get a reference to our contact and update the cell
    NSArray *filteredContacts = [self filterContactsByType:indexPath.section];
    PPAddressBookContact *contact = [filteredContacts objectAtIndex:indexPath.row];
    
    cell.textLabel.text = contact.name;
    cell.detailTextLabel.text = contact.description;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    NSArray *filteredContacts = [self filterContactsByType:section];
    return [filteredContacts count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    // We're sectioning by type, and we've defined an enum for our different
    // contact types. Since the enum is both zero-based and consecutive, we can
    // define a "count" symbol as the last value that will respond to any new
    // additions to the enum, like more contact types... as long as they're added
    // before the count symbol, of course.
    return PPAddressBookNumberOfTypes;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    switch (section) {
        case PPAddressBookContactTypeIPhone:
            return @"iPhone"; break;
        case PPAddressBookContactTypeGoogle:
            return @"Google"; break;
        default:
            return @""; break;
    }
}

@end
