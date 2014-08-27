//
//  ANetApiRequest.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import "ANetApiRequest.h"
#import "NSString+stringWithXMLTag.h"


@implementation ANetApiRequest

@synthesize merchantAuthentication;
@synthesize refId;

+ (ANetApiRequest *) anetApiRequest {
	ANetApiRequest *a = [[ANetApiRequest alloc] init];
	return a;
}

- (id) init {
    self = [super init];
	if (self) {
		self.merchantAuthentication = [MerchantAuthenticationType merchantAuthentication];
		self.refId = nil;
	}
	return self;
}

- (NSString *) description {
	
	NSString *output = [NSString stringWithFormat:@""
						"ANetApiRequest.merchantAuthentication = %@\n"
						"ANetApiRequest.refId = %@",
						self.merchantAuthentication,
						self.refId];
	return output;
}

- (NSString *) stringOfXMLRequest {
	NSString *s = [NSString stringWithFormat:@""
				   @"%@"
				   @"%@",		//refId (optional)
				   [self.merchantAuthentication stringOfXMLRequest],
				   (self.refId ? [NSString stringWithXMLTag:@"refId" andValue:self.refId] : @"")];
	
	return s;
}
@end
