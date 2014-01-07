//
//  OCREST.m
//  OnCall
//
//  Created by Robert Heuts on 9/8/13.
//  Copyright (c) 2013 Robert Heuts. All rights reserved.
//

#import "OCREST.h"
#import <CommonCrypto/CommonDigest.h>
#import "Base64.h"
#import "RKXMLReaderSerialization.h"
#import "OCResponse.h"

@implementation OCREST

- (OCREST*) init
{
    if ( self = [super init] )
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
        configuration = [[NSDictionary alloc] initWithContentsOfFile:path];
    
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
        // Initialize HTTPClient
        NSURL *baseURL = [NSURL URLWithString:[configuration valueForKey:@"RESTUrl"]];
        AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
        //RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    
        if ([[configuration valueForKey:@"RESTType"] isEqualToString:@"XML"])
        {
            [client setDefaultHeader:@"Accept" value:RKMIMETypeTextXML];
            [RKMIMETypeSerialization registerClass:[RKXMLReaderSerialization class] forMIMEType:@"application/xml"];
        }
        else if ([[configuration valueForKey:@"RESTType"] isEqualToString:@"JSON"])
        {
            [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
        }
    
        // Initialize RestKit
        objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
        
        RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[OCResponse class]];
        [mapping addAttributeMappingsFromDictionary:@{@"stat":   @"responseCode"}];
        
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodAny pathPattern:nil keyPath:@"rsp" statusCodes:nil];
        
        [objectManager addResponseDescriptor:responseDescriptor];
    }
    
    return self;
}

- (void) getObjects:(NSDictionary *) parameters responseDescriptor:(RKResponseDescriptor *) descriptor callback:(RESTResultCallback) callback
{
    NSMutableDictionary *params = [parameters mutableCopy];
    [params setValue:[configuration valueForKey:@"accountName"] forKey:@"username"];
    [params setValue:[self getSignature] forKey:@"sig"];
    [params setValue:@"xml" forKey:@"format"];
    
    [objectManager addResponseDescriptor:descriptor];
    [objectManager getObjectsAtPath:@"WMAPIs2.cgi" parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
    {
        callback(mappingResult, NULL);
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error)
    {
        callback(NULL, error);
    }];
}

- (void) getObjects:(NSDictionary *) parameters responseDescriptors:(NSMutableArray *) descriptors callback:(RESTResultCallback) callback
{
    NSMutableDictionary *params = [parameters mutableCopy];
    [params setValue:[configuration valueForKey:@"accountName"] forKey:@"username"];
    [params setValue:[self getSignature] forKey:@"sig"];
    [params setValue:@"xml" forKey:@"format"];
    
    [objectManager addResponseDescriptorsFromArray:descriptors];
    [objectManager getObjectsAtPath:@"WMAPIs2.cgi" parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         callback(mappingResult, NULL);
     }
                            failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         callback(NULL, error);
     }];
}

- (void) postObject:(NSDictionary *) parameters callback:(RESTCallback) callback
{
    NSMutableDictionary *params = [parameters mutableCopy];
    [params setValue:[configuration valueForKey:@"accountName"] forKey:@"username"];
    [params setValue:[self getSignature] forKey:@"sig"];
    [params setValue:@"xml" forKey:@"format"];
    
    [objectManager getObjectsAtPath:@"WMAPIs2.cgi" parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         OCResponse *response = [[mappingResult dictionary] valueForKey:@"rsp"];
         if ([response.responseCode isEqualToString:@"ok"])
         {
             callback(NULL);
         }
         else
         {
             callback([NSError errorWithDomain:@"RestKit" code:-1 userInfo:@{ NSLocalizedDescriptionKey : @"Received fail from endpoint."}]);
         }
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         callback(error);
     }];
}

- (NSString*) getSignature
{
    double epoch = [[NSDate date] timeIntervalSince1970];
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    NSString *accountName = [configuration valueForKey:@"accountName"];
    NSString *accountAPIKey = [configuration valueForKey:@"accountAPIKey"];
    
    NSString *sig = [NSString stringWithFormat:@"%@%@%1.0f", accountName, accountAPIKey, epoch];
    NSData *stringBytes = [sig dataUsingEncoding: NSUTF8StringEncoding];
    
    if (CC_SHA1([stringBytes bytes], [stringBytes length], digest))
    {
        return [[NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH] base64EncodedString];
    }
    
    return @"";
}

@end
