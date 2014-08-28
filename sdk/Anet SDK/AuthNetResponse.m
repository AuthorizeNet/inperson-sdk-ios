//
//  AuthNetResponse.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 12/30/10.
//  Copyright 2010 none. All rights reserved.
//

#import "AuthNetResponse.h"


@implementation AuthNetResponse

@synthesize errorType;
@synthesize responseReasonText;
@synthesize anetApiResponse;


+ (AuthNetResponse *) authNetResponse {
    AuthNetResponse *r = [[AuthNetResponse alloc] init];
    return r;
}

- (id) init {
    self = [super init];
	if (self) {
        self.anetApiResponse = nil;
		self.errorType = NO_ERROR;
		self.responseReasonText = nil;
	}
	return self;
}


@end
