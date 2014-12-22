//
//  PPAddressBookViewController.m
//  PaperlessProblems
//
//  Created by Austin Lange on 12/19/14.
//  Copyright (c) 2014 Paperless Inc. All rights reserved.
//

#import "PPAddressBookViewController.h"
#import "PPAddressBook.h"

@interface PPAddressBookViewController ()

@property (nonatomic, strong) PPAddressBook *addressBook;

@end

@implementation PPAddressBookViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    // create our address book and set it as the tableView's data source
    self.addressBook = [PPAddressBook new];
    self.tableView.dataSource = self.addressBook;
    
    // avoid a retain cycle while loading contacts
    __weak typeof (self) weakSelf = self;
    [self.addressBook loadContacts:^{
        
        [weakSelf.tableView reloadData];
        
    } error:^(NSError *error) {
        NSLog(@"Error: %@", error);
        
        // presumably we would also notify the user of the error, probably via
        // an alert view
    }];
}

@end
