//
//  OCService.h
//  OnCall
//
//  Created by Robert Heuts on 9/7/13.
//  Copyright (c) 2013 Robert Heuts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCService : NSObject

@property (nonatomic, copy) NSString *serviceName;
@property (nonatomic, copy) NSString *serviceGroup;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *serviceStatus;
@property (nonatomic, copy) NSString *serviceInterval;
@property (nonatomic, copy) NSString *serviceLastSampleTime;
@property (nonatomic, copy) NSString *serviceLoadTimeToday;
@property (nonatomic, copy) NSString *serviceLoadTimeMonthly;
@property (nonatomic, copy) NSString *serviceUptimeMonthly;
@property (nonatomic, copy) NSString *serviceUptimeWeekly;
@property (nonatomic, copy) NSString *serviceUptimeToday;

@end
