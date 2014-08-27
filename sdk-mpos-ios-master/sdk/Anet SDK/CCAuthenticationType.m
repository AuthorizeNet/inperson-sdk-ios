//
//  CCAuthenticationType.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/23/11.
//  Copyright 2011 none. All rights reserved.
//

#import "CCAuthenticationType.h"


@implementation CCAuthenticationType

@synthesize authenticationIndicator;
@synthesize cardholderAuthenticationValue;

+ (CCAuthenticationType *) ccAuthenticationType {
    CCAuthenticationType *c = [[CCAuthenticationType alloc] init];
    return c;
}

- (id) init {
    self = [super init];
    if (self) {
        self.authenticationIndicator = nil;
        self.cardholderAuthenticationValue = nil;
    }
    return self;
}


- (NSString *) description {
    NSString *output = [NSString stringWithFormat:@""
                        @"CCAuthenticationType.authenticataionIndication = %@"
                        @"CCAuthenticationType.cardholderAuthenticataionValue = %@",
                        self.authenticationIndicator,
                        self.cardholderAuthenticationValue];
    return output;
}

@end
