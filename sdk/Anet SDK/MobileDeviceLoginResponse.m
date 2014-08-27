//
//  MobileDeviceLoginResponse.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import "MobileDeviceLoginResponse.h"
#import "NSString+dataFromFilename.h"
#import "NSString+stringValueOfXMLElement.h"



@interface MobileDeviceLoginResponse (private)
+ (NSMutableArray *)buildUserPermissions:(GDataXMLElement *)element;
@end


@implementation MobileDeviceLoginResponse

@synthesize sessionToken;
@synthesize merchantContact;
@synthesize userPermissions;
@synthesize merchantAccount;

+ (MobileDeviceLoginResponse *) mobileDeviceLoginResponse {
	MobileDeviceLoginResponse *m = [[MobileDeviceLoginResponse alloc] init];
	return m;
}

- (id) init {
    self = [super init];
	if (self) {
		self.sessionToken = nil;
		self.merchantContact = nil;
		self.userPermissions = [NSMutableArray array];
        self.merchantAccount = nil;
	}
	return self;
}

- (void) addPermission:(PermissionType *)p {
	[self.userPermissions addObject:p];
}

- (NSString *) description {
	
	NSString *output = [NSString stringWithFormat:@""
						"MobileDeviceLoginResponse.anetApiResponse = %@\n"
						"MobileDeviceLoginResponse.sessionToken = %@\n"
						"MobileDeviceLoginResponse.merchantContact = %@\n"
						"MobileDeviceLoginResponse.userPermissions = %@\n"
                        "MobileDeviceLoginResponse.merchantAccount = %@\n",
						self.anetApiResponse,
						self.sessionToken,
						self.merchantContact,
						self.userPermissions,
                        self.merchantAccount];
	return output;
}



+ (MobileDeviceLoginResponse *)parseMobileDeviceLoginResponse:(NSData *)xmlData {
	NSError *error;
	
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData 
														   options:0 
															 error:&error];
	
	NSLog(@"Error = %@", error);
	
    if (doc == nil) { return nil; }
	
	MobileDeviceLoginResponse *m = [MobileDeviceLoginResponse mobileDeviceLoginResponse];
	
	m.anetApiResponse = [ANetApiResponse buildANetApiResponse:doc.rootElement];
	
	m.sessionToken = [NSString stringValueOfXMLElement:doc.rootElement withName:@"sessionToken"];
	
	m.merchantContact = [MerchantContactType buildMerchantContact:doc.rootElement];
	
	m.userPermissions = [self buildUserPermissions:doc.rootElement];
    
    m.merchantAccount = [MerchantAccountType buildMerchantAccount:doc.rootElement];
	
	NSLog(@"MobileDeviceLoginResponse: %@", m);
	
    return m;
}


+ (NSMutableArray *)buildUserPermissions:(GDataXMLElement *)element {
	GDataXMLElement *currNode;
	
	NSMutableArray *up = [NSMutableArray array];
	
	NSArray *currArray = [element elementsForName:@"userPermissions"];
	currNode = (GDataXMLElement *) [currArray objectAtIndex:0];
	
	currArray = [currNode elementsForName:@"permission"];
	
	for (GDataXMLElement *node in currArray) {
		PermissionType *p = [PermissionType buildPermission:node];
		[up addObject:p];
	}
	return up;
}

+ (MobileDeviceLoginResponse *)loadMobileDeviceLoginResponseFromFilename:(NSString *)filename {
    NSString *filePath = [NSString dataFromFilename:filename];
	
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    MobileDeviceLoginResponse *m = [self parseMobileDeviceLoginResponse:xmlData];
	
	return m;
}

@end
