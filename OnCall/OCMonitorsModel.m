//
//  OCMonitorsModel.m
//  OnCall
//
//  Created by Robert Heuts on 9/16/13.
//  Copyright (c) 2013 Robert Heuts. All rights reserved.
//

#import "OCMonitorsModel.h"
#import "OCService.h"
#import "OCWMRest.h"

static OCMonitorsModel *_instance;

@implementation OCMonitorsModel

+ (OCMonitorsModel *)instance
{
    if (_instance == NULL)
        _instance = [[OCMonitorsModel alloc] init];
    
    return _instance;
}

- (void)setMonitors:(NSMutableArray *)monitors
{
    _monitors = monitors;
}

- (NSMutableArray *)getMonitors
{
    return _monitors;
}

- (void)updateMonitors:(WMUpdateCallback)callback
{
    [[OCWMRest instance] getServices:^(NSMutableArray *result, NSError *error)
     {
         if (error == NULL)
         {
             _monitors = result;
         }
         
         callback(error);
     }];
}

@end
