//
//  LogoutRequest.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/7/11.
//  Copyright 2011 none. All rights reserved.
//

#import "LogoutRequest.h"


@implementation LogoutRequest

+ (LogoutRequest *) logoutRequest {
	LogoutRequest *m = [[LogoutRequest alloc] init];
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
						"LogoutRequest.anetApiRequest = %@\n",
						super.anetApiRequest];
	return output;
}

- (NSString *) stringOfXMLRequest {
	NSString *s = [NSString stringWithFormat:@""
				   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>" 
				   @"<logoutRequest xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns=\"AnetApi/xml/v1/schema/AnetApiSchema.xsd\">"
						@"%@"
				   @"</logoutRequest>",
				   [super.anetApiRequest stringOfXMLRequest]];
	return s;
}

@end
