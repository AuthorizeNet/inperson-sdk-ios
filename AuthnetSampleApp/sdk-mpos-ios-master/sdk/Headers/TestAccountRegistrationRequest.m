//
//  TestAccountRegistrationRequest.m
//  Anet SDK
//
//  Created by Shankar Gosain on 12/01/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import "TestAccountRegistrationRequest.h"
#import "NSString+stringWithXMLTag.h"

@implementation TestAccountRegistrationRequest

@synthesize mobileDevice;
@synthesize fullName,emailAddress,zipCode,loginName,password,captchaImageView,captchaUserInput;

+ (TestAccountRegistrationRequest *) testAccountRegistrationRequest {
	TestAccountRegistrationRequest *m = [[TestAccountRegistrationRequest alloc] init];
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
                   "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:mob=\"http://visa.com/mobileApi\" xmlns:mob1=\"http://mobileApi.schema\"> <soapenv:Header>  <mob:Version>1.2</mob:Version> <mob:RequestID>cad84c5e-e663-48e1-be35-3ade12d5be70</mob:RequestID> <mob:TransactionID>cad84c5e-e663-48e1-be35-3ade12d5be70</mob:TransactionID> </soapenv:Header> <soapenv:Body> <mob:CreateMerchantRequest> <mob:Request> <mob1:Merchant>"
                   @"%@" //full name
                   @"<mob1:AccountCredential>"
                   @"%@" //user name
                   @"%@" // password
                   @"</mob1:AccountCredential><mob1:Phone>4255866062</mob1:Phone>"
                   @"%@" //email address
                   @"%@" //zip code
                   @"<mob1:SecretAnswer>spot</mob1:SecretAnswer>"
                   @"<mob1:DeviceList> <mob1:DeviceInfo> <mob1:DeviceID>%@</mob1:DeviceID> <mob1:PhoneNumber>4255888888</mob1:PhoneNumber> <mob1:Description>sadfdsgdfs</mob1:Description> <mob1:DevicePlatform>sadfdsgdfs</mob1:DevicePlatform> </mob1:DeviceInfo> </mob1:DeviceList> </mob1:Merchant> <mob1:Captcha> <mob1:Source>ios</mob1:Source><mob1:Type>validate</mob1:Type><mob1:Validate>"
                   @"%@" //captcha imageview
                   @"%@" // captcha user input
                   @"</mob1:Validate> </mob1:Captcha> </mob:Request> </mob:CreateMerchantRequest> </soapenv:Body> </soapenv:Envelope>",
				   [NSString stringWithXMLTag:@"mob1:Name" andValue:self.fullName],
				   [NSString stringWithXMLTag:@"mob1:Login" andValue:self.loginName],
                   [NSString stringWithXMLTag:@"mob1:Password" andValue:self.password],
                   [NSString stringWithXMLTag:@"mob1:Email" andValue:self.emailAddress],
                   [NSString stringWithXMLTag:@"mob1:ZipCode" andValue:self.zipCode],
                   self.mobileDevice.mobileDeviceId,
                   [NSString stringWithXMLTag:@"mob1:View" andValue:self.captchaImageView],
                   [NSString stringWithXMLTag:@"mob1:UserInput" andValue:self.captchaUserInput]];
    NSLog(@"@@@@@ TEST REGISTRATION REQUEST : %@",s);
    
    //back up
    
    /*<mob1:DeviceList> <mob1:DeviceInfo> <mob1:DeviceID>%@</mob1:DeviceID> <mob1:PhoneNumber>4255888888</mob1:PhoneNumber> <mob1:Description>sadfdsgdfs</mob1:Description> <mob1:DevicePlatform>sadfdsgdfs</mob1:DevicePlatform> </mob1:DeviceInfo> </mob1:DeviceList> </mob1:Merchant> <mob1:Captcha> <mob1:Source>ios</mob1:Source><mob1:Type>validate</mob1:Type><mob1:Validate>"*/
	return s;
}

@end
