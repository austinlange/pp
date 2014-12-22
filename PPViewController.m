//
//  PPViewController.m
//  PaperlessProblems
//
//  Created by Salvatore Randazzo on 2/3/14.
//  Copyright (c) 2014 Paperless Inc. All rights reserved.
//

#import "PPViewController.h"
#import "PPContact.h"
#import "PPContact+PPMutableContact.h"

@implementation PPContactLoader
- (NSArray *)allContacts { return nil; }
+ (NSArray *)contactsSortedByEmailAddress:(NSArray *)contacts error:(NSError **)error { return nil; }
@end

@interface PPViewController ()
@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, copy) NSString *myString;

@end

@implementation PPViewController


#pragma mark -
#pragma mark ##001##
// "Code review" the following two methods, fixing any potential issues you may see. Add comments where you have resolved issues indicating what the issue was
//Assume that all objects referenced are already initialized and valid
- (void)loadContacts
{
    // We probably want the indicator to disappear when we stop animating
    self.indicator.hidesWhenStopped = YES;
    [self.indicator startAnimating];
    
    // Avoid a retain cycle from capturing self strongly in this block
    // by creating a weak reference
    __weak typeof (self) weakSelf = self;
    [self loadContactsWithCompletionBlock:^(NSArray *objects) {
        
        weakSelf.contacts = objects;
        [weakSelf.tableView reloadData];
        [weakSelf.indicator stopAnimating];
        
    } error:^(NSError *error) {
        NSLog(@"error: %@", error);

    }];
}

- (void)loadContactsWithCompletionBlock:(void(^)(NSArray *objects))successBlock error:(void(^)(NSError *error))errorBlock
{
    //Dispatch to a BACKGROUND THREAD to load and sort contacts
    
    // If we actually want to dispatch this to a background background thread,
    // we should use a different priority.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        PPContactLoader *contactLoader = [PPContactLoader new];
        
        // Get allContacts
        NSArray *contacts = [contactLoader allContacts];
        
        // Sort the contacts by email address, assume this is a long running operation
        NSError *error;
        NSArray *sortedContacts = [PPContactLoader contactsSortedByEmailAddress:contacts error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                //Fire the completion block
                successBlock(sortedContacts);
            } else {
                //Fire the error block
                errorBlock(error);
            }
        });
        
    });
}













#pragma mark -
#pragma mark ##002##
// Implement the UITableView to display the contacts names
// Use a standard UITableViewCell, assume we are on iOS 7 only

#define CELL_IDENTIFIER @"Cell"

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *contacts = [NSMutableArray array];
    
    // this for loop will be a problem; since the condition is
    // i > 100 and i is initialized to 0, it will never actually run.
    // solution: change the condition to i < 100
    for (int i = 0; i < 100; i++) {
        PPContact *contact = [PPContact new];
        contact.name = [NSString stringWithFormat:@"Ms. %i", i];
        contact.emailAddress = [NSString stringWithFormat:@"A.%i@gmail.com", i];
        [contacts addObject:contact];
    }
    
    self.contacts = [NSArray arrayWithArray:contacts];
     
    // reload the table to see the contacts!
    //[self.tableView reloadData];
}

//Implement delegate + Data source methods below

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#pragma mark Implementation
    // We're displaying a flat view of contacts, so we've only got one section in the table
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#pragma mark Implementation
    // we'll need a row for each contact in our array
    return [self.contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#pragma mark Implementation
    // dequeue a cell; if no more dequeueable cells exist, create a new one
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_IDENTIFIER];
    }
    
    // fetch the contact at the index we're interested in
    PPContact *contact = [self.contacts objectAtIndex:indexPath.row];
    
    // customize the display of the table row
    cell.textLabel.text = contact.name;
    cell.detailTextLabel.text = contact.emailAddress;
    
    return cell;
}












#pragma mark -
#pragma mark ##003##
//Assuming the PPContact class is not a class we are able to modify, extend the classes functionality such that you can initialize it with a name and email address. You are free to create or modify any classes in this project except PPContact.

//Once you have done so, initialize an instance here

// Since all the key functionality is already part of the PPContact class, we don't need to do much fancy footwork.
// Simply creating a category on PPContact that exposes a new initialization method with name and email arguments
// will suffice.
- (void)makeANewContactHere
{
    PPContact *newContact = [[PPContact alloc] initWithName:@"New Contact" andEmail:@"new.contact@gmail.com"];
    NSLog(@"New contact: %@ (%@)", newContact.name, newContact.emailAddress);
}









#pragma mark -
#pragma mark ##004##

// This question is an opportunity for you to demonstrate how you architect a feature from the ground up. We are looking to see how you separate concerns, break down functions, and implement code that fits the needs of the feature. While it's good to run your code, do not be concerned about how the UI looks. We will be looking primarily at your code, not the resulting UI you create.

// * A new feature spec calls for a viewcontroller that allows you to select a contact from multiple resources. Create a new viewcontroller as well as any other files you need to implement the spec.

//   [x] Create a class the acts as an address book and/or data source for the viewcontroller displaying the contacts:

// The address book should contain contacts from two different sources:
    // -   [x] Contacts that are loaded from the iPhone address book
    // -   [x] Contacts that are loaded from a remote third-party resource, in this case Google Contacts. These would be loaded asynchronously.
        // You do NOT have to actually load from these resources, stub the result of loading the contacts. ie. If your method is async you can simply dispatches to a bg thread , create a number of contacts, and then return them. Do not make any network requests or dig into accessing the iPhone address book API. Stub all data.
        // You may use PPContact or create your own model for contacts

// [x] The spec calls for displaying the contacts in a tableview. They will be "sectioned" by where they came from (iPhone vs Google Contacts). The headers can be default headers that contain the name of the section.

// [x] Not all contacts have an email address. When displaying contacts, we will only ever want to show those with an email. Provide a way to get only the contacts that have an email address.

// [x] Overload the contact's description method.
    // [x] The description should include the email address and the source of the contact (iPhone or Google Contacts). Display this on the tableview cells

// The spec also includes the functionality to "search" through all contacts by email-address AND name. You do not need implement a UI for search in the viewcontroller.
    // [x] Add a search functionality to the code. Since we may be searching through thousands of contacts, make the method asynchronous.

@end
