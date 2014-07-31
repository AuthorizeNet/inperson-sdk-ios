//
//  MobileDeviceRegistrationResponse.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import "MobileDeviceRegistrationResponse.h"
#import "GDataXMLNode.h"
#import "NSString+dataFromFilename.h"

@implementation MobileDeviceRegistrationResponse

+ (MobileDeviceRegistrationResponse *) mobileDeviceRegistrationResponse {
	MobileDeviceRegistrationResponse *m = [[MobileDeviceRegistrationResponse alloc] init];
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
						"MobileDeviceRegistrationResponse.anetApiResponse = %@\n",
						self.anetApiResponse];
	return output;
}


+ (MobileDeviceRegistrationResponse *)parseMobileDeviceRegistrationResponse:(NSData *)xmlData {
	NSError *error;
	
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
														   options:0 
															 error:&error];
	
	NSLog(@"Error = %@", error);
	
    if (doc == nil) { return nil; }
	
	MobileDeviceRegistrationResponse *m = [MobileDeviceRegistrationResponse mobileDeviceRegistrationResponse];
	
	m.anetApiResponse = [ANetApiResponse buildANetApiResponse:doc.rootElement];
    
	
	NSLog(@"MobileDeviceRegistrationResponse: %@", m);
	
    return m;
}


// For unit testing.
+ (MobileDeviceRegistrationResponse *)loadMobileDeviceRegistrationResponseFromFilename:(NSString *)filename {
    NSString *filePath = [NSString dataFromFilename:filename];
	
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    MobileDeviceRegistrationResponse *m = [self parseMobileDeviceRegistrationResponse:xmlData];
	
	return m;
}

@end
