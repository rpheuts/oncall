//
//  OCServiceDetailViewController.h
//  OnCall
//
//  Created by Robert Heuts on 9/8/13.
//  Copyright (c) 2013 Robert Heuts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCService.h"

@interface OCServiceDetailViewController : UIViewController
{
    IBOutlet UILabel *lblStatusValue;
    IBOutlet UILabel *lblSampleTodayValue;
    IBOutlet UILabel *lblUptimeTodayValue;
    IBOutlet UILabel *lblUptimeMonthValue;
    IBOutlet UILabel *lblRTTodayValue;
    IBOutlet UILabel *lblRTMonthValue;
    IBOutlet UIImageView *imgHealth;
    IBOutlet UISwitch *serviceToggle;
    
    UIAlertView *alertView;
}

- (IBAction)toggleService:(id)sender;
- (IBAction)updateService:(id)sender;

@property (nonatomic, retain) OCService *service;

@end
