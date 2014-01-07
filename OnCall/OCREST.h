//
//  OCREST.h
//  OnCall
//
//  Created by Robert Heuts on 9/8/13.
//  Copyright (c) 2013 Robert Heuts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

typedef void(^RESTResultCallback)(RKMappingResult *result, NSError *error);
typedef void(^RESTCallback)(NSError *error);

@interface OCREST : NSObject
{
    RKObjectManager *objectManager;
    NSDictionary *configuration;
}

- (OCREST*) init;
- (void) getObjects:(NSDictionary *) parameters responseDescriptor:(RKResponseDescriptor *) descriptor callback:(RESTResultCallback) callback;
- (void) getObjects:(NSDictionary *) parameters responseDescriptors:(NSMutableArray *) descriptors callback:(RESTResultCallback) callback;
- (void) postObject:(NSDictionary *) parameters callback:(RESTCallback) callback;

@end
