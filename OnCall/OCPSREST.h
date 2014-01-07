//
//  OCPSREST.h
//  OnCall
//
//  Created by Robert Heuts on 9/18/13.
//  Copyright (c) 2013 Robert Heuts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

typedef void(^RESTResultCallback)(RKMappingResult *result, NSError *error);
typedef void(^RESTCallback)(NSError *error);

@interface OCPSREST : NSObject
{
    RKObjectManager *objectManager;
    NSDictionary *configuration;
}

- (void) getClients:(NSDictionary *) parameters responseDescriptor:(RKResponseDescriptor *) descriptor callback:(RESTResultCallback) callback;

@end
