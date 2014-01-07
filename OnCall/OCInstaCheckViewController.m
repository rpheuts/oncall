//
//  OCInstaCheckViewController.m
//  OnCall
//
//  Created by Robert Heuts on 9/10/13.
//  Copyright (c) 2013 Robert Heuts. All rights reserved.
//

#import "OCInstaCheckViewController.h"

@interface OCInstaCheckViewController ()

@end

@implementation OCInstaCheckViewController

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
	
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    NSDictionary *configuration = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSString *checkUrl = [NSString stringWithFormat:@"https://www2.webmetrics.com/e/diagnose/diagnoseframe.cgi?diagnosetype=instacheck&account=%@&view=%@&server6=https%%3A%%2F%%2F69.71.111.141%%3A6212%%2Fcgi-bin%%2Frev2.8&Submit=Insta-check", service.uuid, [configuration valueForKey:@"accountName"]];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:checkUrl]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) dismissModal:(id)sender
{
    [self dismissViewControllerAnimated:true completion:NULL];
}

@synthesize service;

@end
