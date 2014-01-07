//
//  OCWMRest.m
//  OnCall
//
//  Created by Robert Heuts on 9/14/13.
//  Copyright (c) 2013 Robert Heuts. All rights reserved.
//

#import "OCWMRest.h"
#import <RestKit/RestKit.h>
#import "OCREST.h"

static OCWMRest *_instance = NULL;

@implementation OCWMRest

+ (OCWMRest *)instance
{
    if (_instance == NULL)
        _instance = [[OCWMRest alloc] init];
    
    return _instance;
}

- (Boolean)operationAllowed
{
    return [self allowRequest];
}

- (void)getServices:(WMResultArrayCallback)callback
{
    if ([self allowRequest])
    {
        OCREST *rest = [[OCREST alloc] init];
        [rest getObjects:@{@"method" : @"snapshot.getdata"} responseDescriptors:[self getResponseDescriptors]
                callback:^(RKMappingResult *result, NSError *error)
         {
             NSMutableArray *results = (error == NULL) ? [[result dictionary] valueForKey:@"rsp.service"] : NULL;
             callback(results, error);
         }];
    }
    else
        callback(NULL, [[NSError alloc] initWithDomain:@"World" code:-1 userInfo:@{@"details" : @"Refresh allowed only once every 10 seconds."}]);
}

- (void)getService:(NSString *)monitorUUID callback:(WMResultServiceCallback)callback
{
    if ([self allowRequest])
    {
        OCREST *rest = [[OCREST alloc] init];
        [rest getObjects:@{@"method" : @"snapshot.getdata", @"serviceid" : monitorUUID } responseDescriptors:[self getResponseDescriptors]
                callback:^(RKMappingResult *result, NSError *error)
         {
             OCService *service = (error == NULL) ? [[result dictionary] valueForKey:@"rsp.service"] : NULL;
             callback(service, error);
         }];
    }
    else
        callback(NULL, [[NSError alloc] initWithDomain:@"World" code:-1 userInfo:@{@"details" : @"Refresh allowed only once every 10 seconds."}]);
}

- (void)getContactGroups:(WMResultArrayCallback)callback
{
    OCREST *rest = [[OCREST alloc] init];
    [rest getObjects:@{@"method" : @"maintenance.getAlertingGroups"} responseDescriptors:[self getResponseDescriptors]
            callback:^(RKMappingResult *result, NSError *error)
     {
         NSMutableArray *results = (error == NULL) ? [[result dictionary] valueForKey:@"rsp.group"] : NULL;
         callback(results, error);
     }];
}

- (void)setServiceEnabled:(NSString *)serviceUUID enabled:(Boolean)enabled callback:(WMVoidCallback)callback
{
    OCREST *rest = [[OCREST alloc] init];
    
    if (enabled)
        [rest postObject:@{@"method" : @"maintenance.turnServiceOn", @"serviceid" : serviceUUID} callback:callback];
    else
        [rest postObject:@{@"method" : @"maintenance.turnServiceOff", @"serviceid" : serviceUUID} callback:callback];
}

- (void)getContactsForGroup:(NSString *)groupName callback:(WMResultArrayCallback)callback
{
    OCREST *rest = [[OCREST alloc] init];
    [rest getObjects:@{@"method" : @"maintenance.getAlertingGroupContacts", @"group" : [groupName substringFromIndex:[groupName rangeOfString:@"}"].location + 2]} responseDescriptors:[self getResponseDescriptors] callback:^(RKMappingResult *result, NSError *error)
     {
         if (error != NULL)
            return callback(NULL, error);
         
         NSMutableArray *retVal = NULL;
         if ([[[result dictionary] valueForKey:@"rsp.contact"] class] != [OCContact class])
             retVal = [[[result dictionary] valueForKey:@"rsp.contact"] mutableCopy];
         else
             retVal = [[NSMutableArray alloc] initWithObjects:[[result dictionary] valueForKey:@"rsp.contact"], nil];
         
         callback(retVal, NULL);
     }];
}

- (void)removeContactFromGroup:(NSString *)groupName contact:(NSString *)contactName callback:(WMVoidCallback)callback
{
    OCREST *rest = [[OCREST alloc] init];
    [rest postObject:@{@"method" : @"maintenance.removeContactsFromAlertingGroup",
                       @"group" : [groupName substringFromIndex:[groupName rangeOfString:@"}"].location + 2],
                       @"contact" : contactName
                       } callback:^(NSError *error)
     {
         callback(error);
     }];
}

- (void)addContactToGroup:(NSString *)groupName contact:(NSString *)contactName callback:(WMVoidCallback)callback
{
    OCREST *rest = [[OCREST alloc] init];
    [rest postObject:@{@"method" : @"maintenance.addContactsToAlertingGroup",
                       @"group" : [groupName substringFromIndex:[groupName rangeOfString:@"}"].location + 2],
                       @"contact" : contactName
                       } callback:^(NSError *error)
     {
         callback(error);
     }];
}

- (Boolean)allowRequest
{
    NSDate *currentDate = [[NSDate alloc] init];
    Boolean retVal = true;
    
    if (_lastRequest != NULL)
        retVal = [currentDate timeIntervalSinceDate:_lastRequest] > 10;
    
    _lastRequest = currentDate;
    
    return retVal;
}

- (NSMutableArray *)getResponseDescriptors
{
    NSMutableArray *descriptors = [[NSMutableArray alloc] init];
    
    RKObjectMapping *serviceMapping = [RKObjectMapping mappingForClass:[OCService class]];
    [serviceMapping addAttributeMappingsFromDictionary:@{
          @"name.text":   @"serviceName",
          @"group.text":     @"serviceGroup",
          @"id.text":        @"uuid",
          @"status.text":        @"serviceStatus",
          @"interval.text":        @"serviceInterval",
          @"lastsampletime.text":        @"serviceLastSampleTime",
          @"avglttoday.text":        @"serviceLoadTimeToday",
          @"avgltmonthly.text":        @"serviceLoadTimeMonthly",
          @"uptimemonthly.text":        @"serviceUptimeMonthly",
          @"uptimeweekly.text":        @"serviceUptimeWeekly",
          @"uptimetoday.text":        @"serviceUptimeToday"
          }];
    
    [descriptors addObject:[RKResponseDescriptor responseDescriptorWithMapping:serviceMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"rsp.service" statusCodes:nil]];
    
    RKObjectMapping *contactGroupMapping = [RKObjectMapping mappingForClass:[OCContactGroup class]];
    [contactGroupMapping addAttributeMappingsFromDictionary:@{ @"text":   @"groupName"}];
    [descriptors addObject:[RKResponseDescriptor responseDescriptorWithMapping:contactGroupMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"rsp.group" statusCodes:nil]];
    
    RKObjectMapping *contactMapping = [RKObjectMapping mappingForClass:[OCContact class]];
    [contactMapping addAttributeMappingsFromDictionary:@{@"text":   @"contactName"}];
    [descriptors addObject:[RKResponseDescriptor responseDescriptorWithMapping:contactMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"rsp.contact" statusCodes:nil]];
    
    return descriptors;
}

@end
