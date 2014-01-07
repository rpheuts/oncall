//
//  OCGroupViewController.m
//  OnCall
//
//  Created by Robert Heuts on 9/8/13.
//  Copyright (c) 2013 Robert Heuts. All rights reserved.
//

#import "OCGroupViewController.h"
#import "OCContact.h"
#import "OCWMRest.h"

@interface OCGroupViewController ()

@end

@implementation OCGroupViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItems = @[self.editButtonItem, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContact)]];

    [[OCWMRest instance] getContactsForGroup:[group groupName] callback:^(NSMutableArray *result, NSError *error) {
        if (error == NULL)
        {
            _contacts = result;
            [(UITableView *)self.view setDataSource:self];
            [(UITableView *)self.view reloadData];
        }
    }];
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [_contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"GroupCell";
    UITableViewCell *cell = [(UITableView *)self.view dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    OCContact* contact = [_contacts objectAtIndex:indexPath.row];
    [cell.textLabel setText:[contact contactName]];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        OCContact* contact = [_contacts objectAtIndex:indexPath.row];
        NSString *contactName = contact.contactName;
        
        if ([contact.contactName characterAtIndex:0] == '<')
            contactName = [[contactName stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""];
        
        [[OCWMRest instance] removeContactFromGroup:[group groupName] contact:contactName callback:^(NSError *error)
        {
            if (error == NULL)
            {
                [_contacts removeObject:contact];
                [(UITableView *)self.view reloadData];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addContact
{
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Add Contact" message:@"Email address:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];

    [view setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [view show];
}

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[OCWMRest instance] addContactToGroup:[group groupName] contact:[[alertView textFieldAtIndex:0] text] callback:^(NSError *error)
        {
             if (error == NULL)
             {
                 [_contacts addObject:[[OCContact alloc] initWithName:[[alertView textFieldAtIndex:0] text]]];
                 [(UITableView *)self.view reloadData];
             }
         }];
    }
}

@synthesize group;

@end
