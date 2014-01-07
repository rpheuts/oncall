//
//  OCContact.h
//  OnCall
//
//  Created by Robert Heuts on 9/8/13.
//  Copyright (c) 2013 Robert Heuts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCContact : NSObject

- (OCContact *) initWithName:(NSString *) name;

@property (nonatomic, copy) NSString *contactName;

@end
