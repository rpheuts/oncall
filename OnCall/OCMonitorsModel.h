//
//  OCMonitorsModel.h
//  OnCall
//
//  Created by Robert Heuts on 9/16/13.
//  Copyright (c) 2013 Robert Heuts. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WMUpdateCallback)(NSError *error);

@interface OCMonitorsModel : NSObject
{
    NSMutableArray *_monitors;
}

+ (OCMonitorsModel *)instance;

- (void)setMonitors:(NSMutableArray *)monitors;
- (NSMutableArray *)getMonitors;
- (void)updateMonitors:(WMUpdateCallback)callback;

@end
