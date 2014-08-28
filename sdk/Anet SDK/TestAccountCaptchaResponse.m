//
//  TestAccountCaptchaResponse.m
//  Anet SDK
//
//  Created by Tejus Chavan on 09/01/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import "TestAccountCaptchaResponse.h"
#import "NSString+dataFromFilename.h"
#import "NSString+stringValueOfXMLElement.h"

@interface TestAccountCaptchaResponse (private)

@end

@implementation TestAccountCaptchaResponse

@synthesize captchaImage;

+ (TestAccountCaptchaResponse *) testAccountCaptchaResponse {
	TestAccountCaptchaResponse *m = [[TestAccountCaptchaResponse alloc] init];
	return m;
}

- (id) init {
    self = [super init];
	if (self) {
		self.captchaImage = nil;
    }
	return self;
}

- (NSString *) description {
	
	NSString *output = [NSString stringWithFormat:@""
						"TestAccountCaptchaResponse.anetApiResponse = %@\n",
						self.anetApiResponse];
	return output;
}

+ (TestAccountCaptchaResponse *)parseTestAccountCaptchaResponse:(NSData *)xmlData {
	NSError *error;
	
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
														   options:0
															 error:&error];
	
	NSLog(@"Error = %@", error);
	
    if (doc == nil) { return nil; }
	
	TestAccountCaptchaResponse *m = [TestAccountCaptchaResponse testAccountCaptchaResponse];
	
	m.anetApiResponse = [ANetApiResponse buildANetApiResponse:doc.rootElement];
    m.captchaImage = [NSString stringValueOfXMLElement:doc.rootElement withName:@"a:Image"];
	
    NSLog(@"CaptchaImage STRING: %@", m.captchaImage);
    
	NSLog(@"MobileDeviceRegistrationResponse: %@", m);
	
    return m;
}

+ (TestAccountCaptchaResponse *)loadMobileDeviceLoginResponseFromFilename:(NSString *)filename {
    NSString *filePath = [NSString dataFromFilename:filename];
	
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    TestAccountCaptchaResponse *m = [self parseTestAccountCaptchaResponse:xmlData];
	
	return m;
}



@end
