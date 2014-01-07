//
//  OCOnCallViewController.h
//  OnCall
//
//  Created by Robert Heuts on 9/11/13.
//  Copyright (c) 2013 Robert Heuts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCOnCallViewController : UIViewController
{
    IBOutlet UITextField *personalEmail;
    IBOutlet UITextField *personalGroup;
    IBOutlet UISwitch *onCall;
}

- (IBAction)toggleOnCall:(id)sender;
- (IBAction)saveEmail:(id)sender;
- (IBAction)saveGroup:(id)sender;

@end
