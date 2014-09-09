//
//  MerchantAuthentication.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import "MerchantAuthenticationType.h"
#import "NSString+stringWithXMLTag.h"


@implementation MerchantAuthenticationType

@synthesize name;
@synthesize transactionKey;
@synthesize sessionToken;
@synthesize password;
@synthesize mobileDeviceId;
@synthesize fingerPrint;

+ (MerchantAuthenticationType *) merchantAuthentication {
	MerchantAuthenticationType *m = [[MerchantAuthenticationType alloc] init];
	return m;
}

- (id) init {
    self = [super init];
	if (self) {
		self.name = nil;
		self.transactionKey = nil;
		self.sessionToken = nil;
		self.password = nil;
		self.mobileDeviceId = nil;
	}
	return self;
}

- (NSString *) description {
	
	NSString *output = [NSString stringWithFormat:@""
						"MerchantAuthentication.name = %@\n"
						"MerchantAuthentication.transactionKey = %@\n"
						"MerchantAuthentication.sessionToken = %@\n"
						"MerchantAuthentication.password = %@\n"
						"MerchantAuthentication.mobileDeviceId = %@\n",
                        "MerchantAuthentication.fingerPrintType = %@\n", //SHANKAR 26th June
						self.name,
						self.transactionKey,
						self.sessionToken,
						self.password,
						self.mobileDeviceId,
                        self.fingerPrint];
	return output;
}

- (NSString *) stringOfXMLRequest {
    
    NSString *s = [NSString stringWithFormat:@""
				   @"<merchantAuthentication>"
                   @"%@"		//name (optional)
                   @"%@"		//fingerPrint type Object (optional) //SHANKAR 26th June
                   @"%@"		//transactionKey or
                   @"%@"		//sessionToken or
                   @"%@"		//password
                   @"%@"		//mobileDeviceId (optional)
				   @"</merchantAuthentication>",
				   (self.name ? [NSString stringWithXMLTag:@"name" andValue:self.name] : @""),
                   (self.fingerPrint ? [self.fingerPrint stringOfXMLRequest] : @""),
				   (self.transactionKey ? [NSString stringWithXMLTag:@"transactionKey" andValue:self.transactionKey] : @""),
				   (self.sessionToken ? [NSString stringWithXMLTag:@"sessionToken" andValue:self.sessionToken] : @""),
				   (self.password ? [NSString stringWithXMLTag:@"password" andValue:self.password] : @""),
				   (self.mobileDeviceId ? [NSString stringWithXMLTag:@"mobileDeviceId" andValue:self.mobileDeviceId] : @"")];
	
	return s;
}

@end
