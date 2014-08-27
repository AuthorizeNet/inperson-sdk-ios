//
//  GetUnsettledTransactionListRequest.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/24/11.
//  Copyright 2011 none. All rights reserved.
//

#import "GetUnsettledTransactionListRequest.h"


@implementation GetUnsettledTransactionListRequest

+ (GetUnsettledTransactionListRequest *) getUnsettledTransactionListRequest {
    GetUnsettledTransactionListRequest *g = [[GetUnsettledTransactionListRequest alloc] init];
    return g;
}

- (id) init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSString *) description {
    NSString *output = [NSString stringWithFormat:@""
                        @"GetUnsettledTransactionListRequest.anetApiRequest = %@",
                        super.anetApiRequest];
    return output;
}

- (NSString *) stringOfXMLRequest {
    
    NSString *s = [NSString stringWithFormat:@""
                   "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<getUnsettledTransactionListRequest xmlns=\"AnetApi/xml/v1/schema/AnetApiSchema.xsd\">"
                        @"%@"
                   "</getUnsettledTransactionListRequest>",
				   [super.anetApiRequest stringOfXMLRequest]];
	return s;
}
@end
