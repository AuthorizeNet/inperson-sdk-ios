//
//  MobileDevice.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/4/11.
//  Copyright 2011 none. All rights reserved.
//

#import "MobileDeviceType.h"
#import "NSString+stringWithXMLTag.h"

@implementation MobileDeviceType

@synthesize mobileDeviceId;
@synthesize mobileDescription;
@synthesize phoneNumber;
@synthesize devicePlatform;

+ (MobileDeviceType *) mobileDevice {
	MobileDeviceType *m = [[MobileDeviceType alloc] init];
	return m;
}

- (id) init {
    self = [super init];
	if (self) {
		self.mobileDeviceId = nil;
		self.mobileDescription = nil;
		self.phoneNumber = nil;
        self.devicePlatform = nil;
	}
	return self;
}

- (NSString *) description {
	
	NSString *output = [NSString stringWithFormat:@""
						"MobileDevice.mobileDeviceId = %@\n"
						"MobileDevice.mobileDescription = %@\n"
						"MobileDevice.phoneNumber = %@\n"
                        "MobileDevice.devicePlatform = %@",
						self.mobileDeviceId,
						self.mobileDescription,
						self.phoneNumber,
                        self.devicePlatform];
	return output;
}


- (NSString *) stringOfXMLRequest 
{
	NSString *s = [NSString stringWithFormat:@""
				   @"<mobileDevice>"
						@"%@"       //mobileDeviceId
						@"%@"		//description (optional)
						@"%@"		//phoneNumber (optional)
                        @"%@"        //devicePlatform (optional)
				   @"</mobileDevice>",
				   [NSString stringWithXMLTag:@"mobileDeviceId" andValue:self.mobileDeviceId],
				   (self.mobileDescription ? [NSString stringWithXMLTag:@"description" andValue:self.mobileDescription] : @""),
				   (self.phoneNumber ? [NSString stringWithXMLTag:@"phoneNumber" andValue:self.phoneNumber] : @""),
                   (self.devicePlatform ? [NSString stringWithXMLTag:@"devicePlatform" andValue:self.devicePlatform] : @"")];
	
	return s;
}
@end
