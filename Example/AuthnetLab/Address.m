//
//  Address.m
//  AuthnetLab
//
//  Created by Senthil Kumar Periyasamy on 10/9/14.
//  Copyright (c) 2014 Paragyte. All rights reserved.
//

#import "Address.h"

@implementation Address

@synthesize firstName, lastName, street1, street2, city, state, zip, country, email, phone;

- (id) init {
    self = [super init];
    if (self) {
        self.firstName = nil;
        self.lastName = nil;
        self.street1 = nil;
        self.street2 = nil;
        self.city = nil;
        self.state = nil;
        self.zip = nil;
        self.country = nil;
        self.email = nil;
        self.phone = nil;
    }
    return self;
}
@end

