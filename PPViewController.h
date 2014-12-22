//
//  PPViewController.h
//  PaperlessProblems
//
//  Created by Salvatore Randazzo on 2/3/14.
//  Copyright (c) 2014 Paperless Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPViewController : UITableViewController

@end














#pragma mark -
#pragma mark - Ignore

@interface PPContactLoader : NSObject

- (NSArray *)allContacts;

+ (NSArray *)contactsSortedByEmailAddress:(NSArray *)contacts error:(NSError **)error;

@end
