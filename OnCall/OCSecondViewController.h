//
//  OCSecondViewController.h
//  OnCall
//
//  Created by Robert Heuts on 9/7/13.
//  Copyright (c) 2013 Robert Heuts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCWMRest.h"

@interface OCSecondViewController : UIViewController <UITableViewDataSource>
{
    NSArray *_groups;
    OCWMRest *_restClient;
}

@end
