//
//  GetTransactionListRequest.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/24/11.
//  Copyright 2011 none. All rights reserved.
//

#import "GetTransactionListRequest.h"
#import "NSString+stringWithXMLTag.h"

@implementation GetTransactionListRequest

@synthesize batchId;

+ (GetTransactionListRequest *) getTransactionListRequest {
    GetTransactionListRequest *g = [[GetTransactionListRequest alloc] init];
    return g;
}

- (id) init {
    self = [super init];
    if (self) {
        self.batchId = nil;
    }
    return self;
}

- (NSString *) description {
    NSString *output = [NSString stringWithFormat:@""
                        @"GetTransactionListRequest.anetApiRequest = %@"
                        @"GetTransactionListRequest.batchId = %@",
                        super.anetApiRequest,
                        self.batchId];
    return output;
}

- (NSString *) stringOfXMLRequest {
    
    NSString *s = [NSString stringWithFormat:@""
                   "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<getTransactionListRequest xmlns=\"AnetApi/xml/v1/schema/AnetApiSchema.xsd\">"
                        @"%@"
                        @"%@"
                   "</getTransactionListRequest>",
				   [super.anetApiRequest stringOfXMLRequest],
                   [NSString stringWithXMLTag:@"batchId" andValue:self.batchId]];
	return s;
}
@end
