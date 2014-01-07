//
//  OCInstaCheckViewController.h
//  OnCall
//
//  Created by Robert Heuts on 9/10/13.
//  Copyright (c) 2013 Robert Heuts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCService.h"

@interface OCInstaCheckViewController : UIViewController
{
    IBOutlet UIWebView *webView;
}

- (IBAction) dismissModal:(id)sender;

@property (nonatomic, assign) OCService *service;

@end
