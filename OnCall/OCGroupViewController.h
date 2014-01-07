//
//  OCGroupViewController.h
//  OnCall
//
//  Created by Robert Heuts on 9/8/13.
//  Copyright (c) 2013 Robert Heuts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCContactGroup.h"

@interface OCGroupViewController : UITableViewController <UITableViewDataSource, UIAlertViewDelegate>
{
    NSMutableArray *_contacts;
}

- (void) addContact;

@property (nonatomic, assign) OCContactGroup *group;

@end
