//
//  GetTransactionDetailsRequest.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 12/3/10.
//  Copyright 2010 none. All rights reserved.
//

#import "GetTransactionDetailsRequest.h"
#import "NSString+stringWithXMLTag.h"


@implementation GetTransactionDetailsRequest

@synthesize transId;


+ (GetTransactionDetailsRequest *) getTransactionDetailsRequest {
	GetTransactionDetailsRequest *request = [[GetTransactionDetailsRequest alloc] init];
	return request;
}

- (id) init {
	if ((self = [super init])) {
	}
	return self;
}

- (NSString *) stringOfXMLRequest {
    
    NSString *s = [NSString stringWithFormat:@""
                   "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<getTransactionDetailsRequest xmlns=\"AnetApi/xml/v1/schema/AnetApiSchema.xsd\">"
                        @"%@"
                        @"%@"
                   "</getTransactionDetailsRequest>",
				   [self.anetApiRequest stringOfXMLRequest],
                   [NSString stringWithXMLTag:@"transId" andValue:self.transId] ];
	return s;
}

@end
