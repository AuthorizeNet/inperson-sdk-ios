//
//  GetBatchStatisticsRequest.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/25/11.
//  Copyright 2011 none. All rights reserved.
//

#import "GetBatchStatisticsRequest.h"
#import "NSString+stringWithXMLTag.h"


@implementation GetBatchStatisticsRequest

@synthesize batchId;

+ (GetBatchStatisticsRequest *) getBatchStatisticsRequest {
    GetBatchStatisticsRequest *g = [[GetBatchStatisticsRequest alloc] init];
    return g;
}

- (id) init {
    self = [super init];
    if (self) {
        self.batchId = nil;
    }
    return self;
}



- (NSString *) stringOfXMLRequest {
    
    NSString *s = [NSString stringWithFormat:@""
                   "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<getBatchStatisticsRequest xmlns=\"AnetApi/xml/v1/schema/AnetApiSchema.xsd\">"
                        @"%@"
                        @"%@"
                   "</getBatchStatisticsRequest>",
				   [super.anetApiRequest stringOfXMLRequest],
                   [NSString stringWithXMLTag:@"batchId" andValue:self.batchId]];
	return s;
}

- (NSString *) description {
    NSString *output = [NSString stringWithFormat:@""
                        @"GetBatchStatisticsRequest.anetApiRequest = %@"
                        @"GetBatchStatisticsRequest.batchId = %@",
                        super.anetApiRequest,
                        self.batchId];
    return output;
}


@end
