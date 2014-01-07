//
//  OCOnCallViewController.m
//  OnCall
//
//  Created by Robert Heuts on 9/11/13.
//  Copyright (c) 2013 Robert Heuts. All rights reserved.
//

#import "OCOnCallViewController.h"
#import "OCREST.h"

@interface OCOnCallViewController ()

@end

@implementation OCOnCallViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"personalEmail"] length] > 0)
    {
        [personalEmail setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"personalEmail"]];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"personalGroup"] length] > 0)
    {
        [personalGroup setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"personalGroup"]];
    }
    
    [onCall setOn:[[[NSUserDefaults standardUserDefaults] valueForKey:@"personalOnCall"] isEqualToString:@"YES"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleOnCall:(id)sender
{
    if ([(UISwitch *)sender isOn])
    {
        OCREST *rest = [[OCREST alloc] init];
        [rest postObject:@{
                           @"method" : @"maintenance.addContactsToAlertingGroup",
                           @"group" : [[NSUserDefaults standardUserDefaults] valueForKey:@"personalGroup"],
                           @"contact" : [[NSUserDefaults standardUserDefaults] valueForKey:@"personalEmail"]
                           } callback:^(NSError *error)
         {
             if (error != NULL)
             {
                 [(UISwitch *)sender setOn:true animated:true];
             }
         }];
    }
    else
    {
        OCREST *rest = [[OCREST alloc] init];
        [rest postObject:@{
                           @"method" : @"maintenance.removeContactsFromAlertingGroup",
                           @"group" : [[NSUserDefaults standardUserDefaults] valueForKey:@"personalGroup"],
                           @"contact" : [[NSUserDefaults standardUserDefaults] valueForKey:@"personalEmail"]
                           } callback:^(NSError *error)
         {
             if (error != NULL)
             {
                 [(UISwitch *)sender setOn:false animated:true];
             }
         }];
    }
}

- (IBAction)saveEmail:(id)sender
{
    if ([[personalEmail text] length] > 0)
    {
        [[NSUserDefaults standardUserDefaults] setValue:[personalEmail text] forKey:@"personalEmail"];
        [personalEmail setTextColor:[UIColor blueColor]];
        [personalEmail resignFirstResponder];
    }
}

- (IBAction)saveGroup:(id)sender
{
    if ([[personalGroup text] length] > 0)
    {
        [[NSUserDefaults standardUserDefaults] setValue:[personalGroup text] forKey:@"personalGroup"];
        [personalGroup setTextColor:[UIColor blueColor]];
        [personalGroup resignFirstResponder];
    }
}

@end
