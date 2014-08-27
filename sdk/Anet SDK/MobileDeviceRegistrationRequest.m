//
//  MobileDeviceRegistrationRequest.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import "MobileDeviceRegistrationRequest.h"

@implementation MobileDeviceRegistrationRequest

@synthesize mobileDevice;


+ (MobileDeviceRegistrationRequest *) mobileDeviceRegistrationRequest {
	MobileDeviceRegistrationRequest *m = [[MobileDeviceRegistrationRequest alloc] init];
	return m;
}

- (id) init {
    self = [super init];
	if (self) {
		self.mobileDevice = [MobileDeviceType mobileDevice];
	}
	return self;
}

- (NSString *) description {
	
	NSString *output = [NSString stringWithFormat:@""
						"MobileDeviceRegistrationRequest.anetApiRequest = %@\n"
						"MobileDeviceRegistrationRequest.mobileDevice = %@\n",
						super.anetApiRequest,
						self.mobileDevice];
	return output;
}


- (NSString *) stringOfXMLRequest {
	NSString *s = [NSString stringWithFormat:@""
				   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>" 
				   @"<mobileDeviceRegistrationRequest xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns=\"AnetApi/xml/v1/schema/AnetApiSchema.xsd\">"
						@"%@"
						@"%@"  //mobileDevice
				   @"</mobileDeviceRegistrationRequest>",
				   [super.anetApiRequest stringOfXMLRequest],
				   [self.mobileDevice stringOfXMLRequest]];
	return s;
}

@end
