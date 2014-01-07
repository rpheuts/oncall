//
//  OCWMRest.h
//  OnCall
//
//  Created by Robert Heuts on 9/14/13.
//  Copyright (c) 2013 Robert Heuts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCContactGroup.h"
#import "OCService.h"
#import "OCContact.h"

typedef void(^WMResultArrayCallback)(NSMutableArray *result, NSError *error);
typedef void(^WMResultServiceCallback)(OCService *result, NSError *error);
typedef void(^WMVoidCallback)(NSError *error);

@interface OCWMRest : NSObject
{
    NSString *_endPoint;
    NSDate *_lastRequest;
}

+ (OCWMRest *)instance;

- (Boolean)operationAllowed;

- (void)getServices:(WMResultArrayCallback)callback;
- (void)getService:(NSString *)monitorUUID callback:(WMResultServiceCallback)callback;
- (void)setServiceEnabled:(NSString *)serviceUUID enabled:(Boolean)enabled callback:(WMVoidCallback)callback;

- (void)getContactGroups:(WMResultArrayCallback)callback;
- (void)getContactsForGroup:(NSString *)groupName callback:(WMResultArrayCallback)callback;
- (void)removeContactFromGroup:(NSString *)groupName contact:(NSString *)contact callback:(WMVoidCallback)callback;
- (void)addContactToGroup:(NSString *)groupName contact:(NSString *)contact callback:(WMVoidCallback)callback;


@end
