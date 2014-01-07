//
//  OCContact.m
//  OnCall
//
//  Created by Robert Heuts on 9/8/13.
//  Copyright (c) 2013 Robert Heuts. All rights reserved.
//

#import "OCContact.h"

@implementation OCContact

- (OCContact *) initWithName:(NSString *) name
{
    self = [super init];
    if (self)
    {
        self.contactName = name;
    }
    return self;
}

@synthesize contactName;

@end
