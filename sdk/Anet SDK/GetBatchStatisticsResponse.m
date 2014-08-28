//
//  GetBatchStatisticsResponse.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/25/11.
//  Copyright 2011 none. All rights reserved.
//

#import "GetBatchStatisticsResponse.h"
#import "NSString+dataFromFilename.h"

@implementation GetBatchStatisticsResponse

@synthesize batch;

+ (GetBatchStatisticsResponse *) getBatchStatisticsResponse {
    GetBatchStatisticsResponse *g = [[GetBatchStatisticsResponse alloc] init];
    return g;
}

- (id) init {
    self = [super init];
    if (self) {
        self.batch = [BatchDetailsType batchDetails];
    }
    return self;
}

- (NSString *) description {
    NSString *output = [NSString stringWithFormat:@""
                        @"GetBatchStatisticsResponse.anetApiResponse = %@"
                        @"GetBatchStatisticsResponse.batch = %@",
                        self.anetApiResponse,
                        self.batch];
    return  output;
}

+ (GetBatchStatisticsResponse *)parseGetBatchStatisticsResponse:(NSData *)xmlData {
    NSError *error;
	
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData 
														   options:0 error:&error];
	
	NSLog(@"Error = %@", error);
	
    if (doc == nil) { return nil; }
	
	GetBatchStatisticsResponse *t = [GetBatchStatisticsResponse getBatchStatisticsResponse];
	
	t.anetApiResponse = [ANetApiResponse buildANetApiResponse:doc.rootElement];
    
    NSArray *currArray = [doc.rootElement elementsForName:@"batch"];
  	GDataXMLElement *currNode = (GDataXMLElement *) [currArray objectAtIndex:0];
    t.batch = [BatchDetailsType buildBatchDetails:currNode];
    
	NSLog(@"GetBatchStatisticsResponse: %@", t);

    return t;
}

// For unit testing.
+ (GetBatchStatisticsResponse *)loadGetBatchStatisticsResponseFromFilename:(NSString *)filename {
    
    NSString *filePath = [NSString dataFromFilename:filename];
	// TODO: Change this to process from HTTP response data
	// after initial testing.
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
	GetBatchStatisticsResponse *t = [self parseGetBatchStatisticsResponse:xmlData];
    return t;
}

@end
