//
//  OCServiceDetailViewController.m
//  OnCall
//
//  Created by Robert Heuts on 9/8/13.
//  Copyright (c) 2013 Robert Heuts. All rights reserved.
//

#import "OCServiceDetailViewController.h"
#import "OCService.h"
#import "OCInstaCheckViewController.h"
#import "OCWMRest.h"
#import "OCMonitorsModel.h"
#import "OCPSREST.h"
#import "OCClient.h"

@interface OCServiceDetailViewController ()

@end

@implementation OCServiceDetailViewController

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
	
    [self setUIWithService:service];
    
    ////////////////
    
    RKObjectMapping *clientMapping = [RKObjectMapping mappingForClass:[OCClient class]];
    [clientMapping addAttributeMappingsFromDictionary:@{
                                                         @"id.text":   @"serviceName",
                                                         @"name.text":     @"serviceGroup",
                                                         @"name.text":        @"serviceUptimeToday"
                                                         }];
    RKResponseDescriptor *descriptor = [RKResponseDescriptor responseDescriptorWithMapping:clientMapping method:RKRequestMethodAny pathPattern:@"" keyPath:@"response.client" statusCodes:NULL];
    
    [[[OCPSREST alloc] init] getClients:@{} responseDescriptor:descriptor callback:^(RKMappingResult *result, NSError *error) {
        NSLog(@"Result");
    }];
}

- (void)setUIWithService:(OCService *)argService
{
    [self setTitle:[argService serviceName]];
    [lblStatusValue setText:[argService serviceStatus]];
    [lblUptimeTodayValue setText:[argService serviceUptimeToday]];
    [lblUptimeMonthValue setText:[argService serviceUptimeMonthly]];
    [lblSampleTodayValue setText:[argService serviceLastSampleTime]];
    [lblRTTodayValue setText:[argService serviceLoadTimeToday]];
    [lblRTMonthValue setText:[argService serviceLoadTimeMonthly]];
    [serviceToggle setOn:true];
    
    if ([[argService serviceStatus] isEqualToString:@"OK"])
    {
        [imgHealth setImage:[UIImage imageNamed: @"sun-100.png"]];
    }
    else if ([[argService serviceStatus] isEqualToString:@"MAINTENANCE"])
    {
        [imgHealth setImage:[UIImage imageNamed: @"hammer-100.png"]];
    }
    else if ([[argService serviceStatus] isEqualToString:@"OFF"])
    {
        [imgHealth setImage:[UIImage imageNamed: @"stop-100.png"]];
        [serviceToggle setOn:false];
    }
    else if ([[argService serviceStatus] isEqualToString:@"WARNING"])
    {
        [imgHealth setImage:[UIImage imageNamed: @"cloudy-100.png"]];
    }
    else if ([[argService serviceStatus] isEqualToString:@"ERROR"])
    {
        [imgHealth setImage:[UIImage imageNamed: @"storm-100.png"]];
    }
    else
    {
        [imgHealth setHidden:true];
        [serviceToggle setOn:false];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"InstaCheckSegue"])
    {
        OCInstaCheckViewController *vc = [segue destinationViewController];
        vc.service = service;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateService:(id)sender
{
    alertView = [[UIAlertView alloc] initWithTitle:@"Refreshing Data..." message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [alertView show];
    
    [[OCWMRest instance] getService:[service uuid] callback:^(OCService *result, NSError *error)
     {
         if (error == NULL)
         {
             service = result;
             [self setUIWithService:service];
             
             for (OCService *serv in [[OCMonitorsModel instance] getMonitors])
             {
                 if ([[serv uuid] isEqualToString:[service uuid]])
                 {
                     [[[OCMonitorsModel instance] getMonitors] removeObject:serv];
                     break;
                 }
             }
             
             [[[OCMonitorsModel instance] getMonitors] addObject:service];
             [alertView dismissWithClickedButtonIndex:0 animated:true];
         }
         else
         {
             alertView = [[UIAlertView alloc] initWithTitle:@"Unable to refresh" message:[error description] delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
             [alertView show];
         }
         
     }];
}

- (IBAction)toggleService:(id)sender
{
    if ([(UISwitch *)sender isOn])
    {
        if ([service.serviceStatus isEqualToString:@"OFF"])
        {
            [[OCWMRest instance] setServiceEnabled:[service uuid] enabled:YES callback:^(NSError *error)
            {
                if (error != NULL)
                    [(UISwitch *)sender setOn:false animated:true];
                else
                    [lblStatusValue setText:@"Unknown"];
            }];
        }
    }
    else
    {
        if (![service.serviceStatus isEqualToString:@"OFF"])
        {
            [[OCWMRest instance] setServiceEnabled:[service uuid] enabled:NO callback:^(NSError *error)
             {
                 if (error != NULL)
                     [(UISwitch *)sender setOn:true animated:true];
                 else
                     [lblStatusValue setText:@"OFF"];
             }];
        }
    }
}

@synthesize service;

@end
