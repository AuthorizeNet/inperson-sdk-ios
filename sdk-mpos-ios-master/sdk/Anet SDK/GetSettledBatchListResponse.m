//
//  GetSettledBatchListResponse.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/24/11.
//  Copyright 2011 none. All rights reserved.
//

#import "GetSettledBatchListResponse.h"
#import "BatchDetailsType.h"
#import "NSString+dataFromFilename.h"

@implementation GetSettledBatchListResponse

@synthesize batchList;

+ (GetSettledBatchListResponse *) getSettledBatchListResponse {
    GetSettledBatchListResponse *g = [[GetSettledBatchListResponse alloc] init];
    return g;
}

- (id) init {
    self = [super init];
    if (self) {
        self.batchList = [NSMutableArray array];
    }
    return self;
}

- (NSString *) description {
    NSString *output = [NSString stringWithFormat:@""
                        @"GetSettledBatchListResponse.anetApiRequest = %@"
                        @"GetSettledBatchListResponse.includeStatistics = %@",
                        self.anetApiResponse,
                        self.batchList];
    return output;
}

+ (GetSettledBatchListResponse *)parseGetSettledBatchListResponse:(NSData *)xmlData {
    NSError *error;
	
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
														   options:0 error:&error];
	
	NSLog(@"Error = %@", error);
	
    if (doc == nil) { return nil; }
	
	GetSettledBatchListResponse *t = [GetSettledBatchListResponse getSettledBatchListResponse];
	
	t.anetApiResponse = [ANetApiResponse buildANetApiResponse:doc.rootElement];
    
    
    NSArray *currArray = [doc.rootElement elementsForName:@"batchList"];
	GDataXMLElement *currNode = (GDataXMLElement *) [currArray objectAtIndex:0];
	
	
	currArray = [currNode elementsForName:@"batch"];
	for (GDataXMLElement *node in currArray) {
		BatchDetailsType *b = [BatchDetailsType buildBatchDetails:node];
		[t.batchList addObject:b];
	}
	
    return t;
	
}


+ (GetSettledBatchListResponse *)loadGetSettledBatchListResponseFromFilename:(NSString *)filename {
    NSString *filePath = [NSString dataFromFilename:filename];
	// TODO: Change this to process from HTTP response data
	// after initial testing.
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
	GetSettledBatchListResponse *t = [self parseGetSettledBatchListResponse:xmlData];
    return t;
	
}



@end
