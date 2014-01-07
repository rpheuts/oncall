//
//  OCFirstViewController.h
//  OnCall
//
//  Created by Robert Heuts on 9/7/13.
//  Copyright (c) 2013 Robert Heuts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCFirstViewController : UITableViewController <UITableViewDataSource>
{
    IBOutlet UITableView *tableView;
    
    NSMutableArray *_servicesError;
    NSMutableArray *_servicesWarning;
    NSMutableArray *_servicesOk;
    NSMutableArray *_servicesOff;
    UIAlertView *alertView;
}

- (IBAction)refreshData:(id)sender;

@end
