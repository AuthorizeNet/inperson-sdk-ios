//
//  LogoutResponse.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/7/11.
//  Copyright 2011 none. All rights reserved.
//

#import "LogoutResponse.h"
#import "NSString+dataFromFilename.h"
#import "NSString+dataFromFilename.h"
#import "NSString+stringValueOfXMLElement.h"

@implementation LogoutResponse

@synthesize captchaImage;

+ (LogoutResponse *) logoutResponse {
	LogoutResponse *m = [[LogoutResponse alloc] init];
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
						"LogoutResponse.anetApiResponse = %@\n",
						self.anetApiResponse];
	return output;
}

+ (LogoutResponse *)parseLogoutResponse:(NSData *)xmlData {
	NSError *error;
	
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData 
														   options:0 
															 error:&error];
	
	NSLog(@"Error = %@", error);
	
    if (doc == nil) {
        NSLog(@"NILLL ### = %@", error);
        return nil; }
	
	LogoutResponse *m = [LogoutResponse logoutResponse];
	
	m.anetApiResponse = [ANetApiResponse buildANetApiResponse:doc.rootElement];
	
	NSLog(@"LogoutResponse  %@", m);
	
    return m;
}


+ (LogoutResponse *)parseTestAccountCaptchaResponse:(NSData *)xmlData {
	NSError *error;
	
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
														   options:0
															 error:&error];
	
	NSLog(@"Error = %@", error);
	
    if (doc == nil) {
        NSLog(@"NILLL ### = %@", error);
        return nil; }

	
	LogoutResponse *m = [LogoutResponse logoutResponse];
	
	m.anetApiResponse = [ANetApiResponse buildANetApiResponse:doc.rootElement];
    m.captchaImage = [NSString stringValueOfXMLElement:doc.rootElement withName:@"a:Image"];
	
    NSLog(@"CaptchaImage STRING #### : %@", m.captchaImage);
    
	NSLog(@"MobileDeviceRegistrationResponse: %@", m);
	
    return m;
}

// For unit testing.
+ (LogoutResponse *)loadLogoutResponseFromFilename:(NSString *)filename {
    NSString *filePath = [NSString dataFromFilename:filename];
	
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    LogoutResponse *m = [self parseLogoutResponse:xmlData];
	
	return m;
}
@end
