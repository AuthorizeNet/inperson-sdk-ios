//
//  TestAccountCaptchaRequest.m
//  Anet SDK
//
//  Created by Qian Wang on 12/28/13.
//  Copyright (c) 2013 MMA. All rights reserved.
//
#import "TestAccountCaptchaRequest.h"


@implementation TestAccountCaptchaRequest
+ (TestAccountCaptchaRequest *) testAccountCaptchaRequest {
	TestAccountCaptchaRequest *m = [[TestAccountCaptchaRequest alloc] init];
	return m;
}

- (id) init {
    self = [super init];
	if (self) {
	}
	return self;
}


- (NSString *) description {
	
	NSString *output = [NSString stringWithFormat:@""
						"TestAccountCaptchaRequest.anetApiRequest = %@\n",
						super.anetApiRequest];
	return output;
}

- (NSString *) stringOfXMLRequest {
	NSString *s = @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:mob=\"http://visa.com/mobileApi\" xmlns:mob1=\"http://mobileApi.schema\">    <soapenv:Header>    <mob:Version>1.2</mob:Version>    <mob:TransactionID>cad84c5e-e663-48e1-be35-3ade12d5be70</mob:TransactionID>    <mob:RequestID>cad84c5e-e663-48e1-be35-3ade12d5be70</mob:RequestID>    </soapenv:Header>    <soapenv:Body>    <mob:CaptchaRequest>    <mob:Request>    <mob1:Captcha>    <mob1:Source>ios</mob1:Source>    <mob1:Type>create</mob1:Type>    <mob1:Create>    <mob1:NumOfChars>5</mob1:NumOfChars>    <mob1:Style>45</mob1:Style>    <mob1:Width>300</mob1:Width>    <mob1:Height>50</mob1:Height>    </mob1:Create>    </mob1:Captcha>    </mob:Request>    </mob:CaptchaRequest>    </soapenv:Body>    </soapenv:Envelope>";
    
     NSLog(@"@@@@@ CAPTCHA REQUEST : %@",s);
	return s;
}

/*
 https://apitest.authorize.net/MobileService/GatewayAccount.svc/soap/v1‏
 
 Content-Type: text/xml
 SOAPAction: http://visa.com/mobileApi/IGatewayAccount/ProcessCaptcha
 
 <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:mob="http://visa.com/mobileApi" xmlns:mob1="http://mobileApi.schema">
 <soapenv:Header>
 <mob:Version>1.2</mob:Version>
 <mob:TransactionID>cad84c5e-e663-48e1-be35-3ade12d5be70</mob:TransactionID>
 <mob:RequestID>cad84c5e-e663-48e1-be35-3ade12d5be70</mob:RequestID>
 </soapenv:Header>
 <soapenv:Body>
 <mob:CaptchaRequest>
 <!--Optional:-->
 <mob:Request>
 <mob1:Captcha>
 <mob1:Source>ios</mob1:Source>
 <mob1:Type>create</mob1:Type>
 <mob1:Create>
 <mob1:NumOfChars>4</mob1:NumOfChars>
 <mob1:Style>12</mob1:Style>
 <mob1:Width>122</mob1:Width>
 <mob1:Height>100</mob1:Height>
 </mob1:Create>
 </mob1:Captcha>
 </mob:Request>
 </mob:CaptchaRequest>
 </soapenv:Body>
 </soapenv:Envelope>
 */
@end
