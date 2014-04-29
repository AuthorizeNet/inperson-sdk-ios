//
//  ANetApiResponse.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import "ANetApiResponse.h"
#import "NSString+stringValueOfXMLElement.h"


@implementation ANetApiResponse

@synthesize refId;
@synthesize messages;

+ (ANetApiResponse *) anetApiResponse {
	ANetApiResponse *a = [[ANetApiResponse alloc] init];
	return a;
}

- (id) init {
    self = [super init];
	if (self) {
		self.refId = nil;
		self.messages = [Messages messages];
	}
	return self;
}

- (NSString *) description {
	
	NSString *output = [NSString stringWithFormat:@""
						"ANetApiResponse.refId = %@\n"
						"ANetApiResponse.messages = %@\n",
						self.refId,
						self.messages];
	return output;
}



+ (ANetApiResponse *) buildANetApiResponse:(GDataXMLElement *)element {
	ANetApiResponse *a = [ANetApiResponse anetApiResponse];
	
	a.refId = [NSString stringValueOfXMLElement:element withName:@"refId"];
	a.messages = [Messages buildMessages:element];
	
	return a;
}


+ (ANetApiResponse *) buildANetApiResponseForCaptcha:(GDataXMLElement *)element {
	ANetApiResponse *a = [ANetApiResponse anetApiResponse];
	
	a.refId = [NSString stringValueOfXMLElement:element withName:@"refId"];
	a.messages = [Messages buildMessagesForCaptchaResponse:element];
	
	return a;
}


+ (ANetApiResponse *) buildANetApiResponseTestAccountregistration:(GDataXMLElement *)element {
	ANetApiResponse *a = [ANetApiResponse anetApiResponse];
	
	a.refId = [NSString stringValueOfXMLElement:element withName:@"refId"];
	a.messages = [Messages buildMessagesForTestAccountRegistrationResponse:element];
	
	return a;
}

@end
