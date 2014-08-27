//
//  AuthNetRequest.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 12/30/10.
//  Copyright 2010 none. All rights reserved.
//

#import "AuthNetRequest.h"


@implementation AuthNetRequest
@synthesize anetApiRequest;

- (id) init {
    self = [super init];
	if (self) {
        self.anetApiRequest = [ANetApiRequest anetApiRequest];
	}
	return self;
}

// This method does nothing.  The subclasses of AuthNetRequest 
// has implementation that generates the XML request bodies.
- (NSString *) stringOfXMLRequest {
    NSLog(@"ERROR: Base AuthNetRequest stringOfXMLRequest:  Should not be called");
	return nil;
}

@end
