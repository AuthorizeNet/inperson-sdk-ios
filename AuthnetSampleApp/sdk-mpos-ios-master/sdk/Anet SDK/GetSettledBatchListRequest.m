//
//  GetSettledBatchListRequest.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/24/11.
//  Copyright 2011 none. All rights reserved.
//

#import "GetSettledBatchListRequest.h"
#import "NSString+stringWithXMLTag.h"


@implementation GetSettledBatchListRequest

@synthesize includeStatistics;
@synthesize firstSettlementDate;
@synthesize lastSettlementDate;

+ (GetSettledBatchListRequest *) getSettlementBatchListRequest {
    GetSettledBatchListRequest *g = [[GetSettledBatchListRequest alloc] init];
    return g;
}

- (id) init {
    self = [super init];
    if (self) {
        self.includeStatistics = nil;
        self.firstSettlementDate = nil;
        self.lastSettlementDate = nil;
    }
    return self;
}

- (NSString *) description {
    NSString *output = [NSString stringWithFormat:@""
                        @"GetSettledBatchListRequest.anetApiRequest = %@"
                        @"GetSettledBatchListRequest.includeStatistics = %@"
                        @"GetSettledBatchListRequest.firstSettlementDate = %@"
                        @"GetSettledBatchListRequest.lastSettlementDate = %@",
                        super.anetApiRequest,
                        self.includeStatistics,
                        self.firstSettlementDate,
                        self.lastSettlementDate];
    return output;
}


- (NSString *) stringOfXMLRequest {
    
    NSString *s = [NSString stringWithFormat:@""
                   "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<getSettledBatchListRequest xmlns=\"AnetApi/xml/v1/schema/AnetApiSchema.xsd\">"
                        @"%@"
                        @"%@"
                        @"%@"
                        @"%@"
                   "</getSettledBatchListRequest>",
				   [super.anetApiRequest stringOfXMLRequest],
                   [NSString stringWithXMLTag:@"includeStatistics" andValue:self.includeStatistics],
                   [NSString stringWithXMLTag:@"firstSettlementDate" andValue:self.includeStatistics],
                   [NSString stringWithXMLTag:@"lastSettlementDate" andValue:self.includeStatistics]];
	return s;
}
@end
