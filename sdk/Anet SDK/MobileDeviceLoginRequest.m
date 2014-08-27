//
//  MobileDeviceLoginRequest.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import "MobileDeviceLoginRequest.h"


@implementation MobileDeviceLoginRequest

+ (MobileDeviceLoginRequest *) mobileDeviceLoginRequest {
	MobileDeviceLoginRequest *m = [[MobileDeviceLoginRequest alloc] init];
	return m;
}

- (id) init {
	if (self = [super init]) {
	}
	return self;
}


- (NSString *) description {
	
	NSString *output = [NSString stringWithFormat:@""
						"MobileDeviceLoginRequest.anetApiRequest = %@\n",
						super.anetApiRequest];
	return output;
}

- (NSString *) stringOfXMLRequest {
	NSString *s = [NSString stringWithFormat:@""
				   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>" 
				   @"<mobileDeviceLoginRequest xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns=\"AnetApi/xml/v1/schema/AnetApiSchema.xsd\">"
						@"%@"
				   @"</mobileDeviceLoginRequest>",
				   [super.anetApiRequest stringOfXMLRequest]];
	return s;
}
@end
