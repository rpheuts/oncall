//
//  OCPSREST.m
//  OnCall
//
//  Created by Robert Heuts on 9/18/13.
//  Copyright (c) 2013 Robert Heuts. All rights reserved.
//

#import "OCPSREST.h"
#import <CommonCrypto/CommonDigest.h>
#import "Base64.h"
#import "RKXMLReaderSerialization.h"

@implementation OCPSREST

- (OCPSREST*) init
{
    if ( self = [super init] )
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
        configuration = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        
        // Initialize HTTPClient
        NSURL *baseURL = [NSURL URLWithString:[configuration valueForKey:@"PSRESTUrl"]];
        AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
        RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
        
        if ([[configuration valueForKey:@"RESTType"] isEqualToString:@"XML"])
        {
            [client setDefaultHeader:@"Accept" value:RKMIMETypeTextXML];
            [RKMIMETypeSerialization registerClass:[RKXMLReaderSerialization class] forMIMEType:@"text/xml"];
        }
        else if ([[configuration valueForKey:@"RESTType"] isEqualToString:@"JSON"])
        {
            [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
        }
        
        // Initialize RestKit
        objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    }

    return self;
}

- (void) getClients:(NSDictionary *) parameters responseDescriptor:(RKResponseDescriptor *) descriptor callback:(RESTResultCallback) callback
{
    NSMutableDictionary *params = [parameters mutableCopy];
    [params setValue:[self getSignature] forKey:@"signature"];
    
    [objectManager addResponseDescriptor:descriptor];
    [objectManager getObjectsAtPath:@"clients" parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         callback(mappingResult, NULL);
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         callback(NULL, error);
     }];
}

- (NSString*) getSignature
{
    double epoch = [[NSDate date] timeIntervalSince1970];
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    NSString *accountAPIKey = [configuration valueForKey:@"accountAPIKey"];
    
    NSString *sig = [NSString stringWithFormat:@"%@%1.0f", accountAPIKey, epoch];
    NSData *stringBytes = [sig dataUsingEncoding: NSUTF8StringEncoding];
    
    if (CC_SHA1([stringBytes bytes], [stringBytes length], digest))
    {
        return [[NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH] base64EncodedString];
    }
    
    return @"";
}

@end
