//
//  OCSecondViewController.m
//  OnCall
//
//  Created by Robert Heuts on 9/7/13.
//  Copyright (c) 2013 Robert Heuts. All rights reserved.
//

#import "OCSecondViewController.h"
#import "OCGroupViewController.h"
#import "OCContactGroup.h"
#import "OCWMRest.h"

@interface OCSecondViewController ()

@end

@implementation OCSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Contact Groups"];
	
    [[OCWMRest instance] getContactGroups:^(NSArray *result, NSError *error)
     {
         _groups = result;
         [(UITableView *)self.view setDataSource:self];
         [(UITableView *)self.view reloadData];
     }];
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [_groups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"GroupCell";
    UITableViewCell *cell = [(UITableView *)self.view dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    OCContactGroup* group = [_groups objectAtIndex:indexPath.row];
    [cell.textLabel setText:[[group groupName] substringFromIndex:[[group groupName] rangeOfString:@"}"].location + 2]];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"GroupSelect"])
    {
        OCGroupViewController *vc = [segue destinationViewController];
        vc.group = [_groups objectAtIndex:[(UITableView *)self.view indexPathForSelectedRow].row];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
