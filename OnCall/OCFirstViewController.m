//
//  OCFirstViewController.m
//  OnCall
//
//  Created by Robert Heuts on 9/7/13.
//  Copyright (c) 2013 Robert Heuts. All rights reserved.
//

#import "OCFirstViewController.h"
#import "OCServiceDetailViewController.h"
#import "OCService.h"
#import "OCServiceCell.h"
#import "OCMonitorsModel.h"

@interface OCFirstViewController ()

@end

@implementation OCFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _servicesOk = [[NSMutableArray alloc] init];
    _servicesError = [[NSMutableArray alloc] init];
    _servicesOff = [[NSMutableArray alloc] init];
    _servicesWarning = [[NSMutableArray alloc] init];
    
    [self.navigationItem setTitle:@"Monitors"];
    
    [self refreshData:NULL];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateData];
    [tableView setDataSource:self];
    [tableView reloadData];
}

- (void)updateData
{
    [_servicesOff removeAllObjects];
    [_servicesOk removeAllObjects];
    [_servicesError removeAllObjects];
    [_servicesWarning removeAllObjects];
    
    for (OCService *service in [[OCMonitorsModel instance] getMonitors])
    {
        if ([[service serviceStatus] isEqualToString:@"OK"])
            [_servicesOk addObject:service];
        
        if ([[service serviceStatus] isEqualToString:@"ERROR"])
            [_servicesError addObject:service];
        
        if ([[service serviceStatus] isEqualToString:@"WARNING"])
            [_servicesWarning addObject:service];
        
        if ([[service serviceStatus] isEqualToString:@"MAINTENANCE"])
            [_servicesOff addObject:service];
        
        if ([[service serviceStatus] isEqualToString:@"OFF"])
            [_servicesOff addObject:service];
    }
}

- (IBAction)refreshData:(id)sender
{
    alertView = [[UIAlertView alloc] initWithTitle:@"Loading Monitors..." message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [alertView show];
    
    [[OCMonitorsModel instance] updateMonitors:^(NSError *error)
    {
        if (error == NULL)
        {
            [self updateData];
            [tableView setDataSource:self];
            [tableView reloadData];
            [alertView dismissWithClickedButtonIndex:0 animated:true];
        }
        else
        {
            NSLog(@"Failed to load services.");
            [alertView dismissWithClickedButtonIndex:0 animated:true];
            [[[UIAlertView alloc] initWithTitle:@"Failed to refresh" message:[error description] delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil] show];
        }
    }];
}

#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Error";
    
    if (section == 1)
        return @"Warning";

    if (section == 2)
        return @"Ok";
    
    if (section == 3)
        return @"OFF / Maintenance";
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return [_servicesError count];

    if (section == 1)
        return [_servicesWarning count];
    
    if (section == 2)
        return [_servicesOk count];
    
    if (section == 3)
        return [_servicesOff count];
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableViewArg cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"Service Cell";
    OCServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (nil == cell) {
        cell = [[OCServiceCell alloc] init];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    OCService* service = NULL;
    if (indexPath.section == 0)
        service = [_servicesError objectAtIndex:indexPath.row];

    if (indexPath.section == 1)
        service = [_servicesWarning objectAtIndex:indexPath.row];
    
    if (indexPath.section == 2)
        service = [_servicesOk objectAtIndex:indexPath.row];
    
    if (indexPath.section == 3)
        service = [_servicesOff objectAtIndex:indexPath.row];
    
    [cell setTitle:[service serviceName]];
    [cell setHealth:[service serviceStatus]];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ServiceSelect"])
    {
        OCServiceDetailViewController *vc = [segue destinationViewController];
    
        OCService* service = NULL;
        if ([tableView indexPathForSelectedRow].section == 0)
            service = [_servicesError objectAtIndex:[tableView indexPathForSelectedRow].row];
        
        if ([tableView indexPathForSelectedRow].section == 1)
            service = [_servicesWarning objectAtIndex:[tableView indexPathForSelectedRow].row];
        
        if ([tableView indexPathForSelectedRow].section == 2)
            service = [_servicesOk objectAtIndex:[tableView indexPathForSelectedRow].row];
        
        if ([tableView indexPathForSelectedRow].section == 3)
            service = [_servicesOff objectAtIndex:[tableView indexPathForSelectedRow].row];
        
        vc.service = service;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@synthesize tableView;

@end
