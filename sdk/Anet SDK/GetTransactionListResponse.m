//
//  GetTransactionListResponse.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/24/11.
//  Copyright 2011 none. All rights reserved.
//

#import "GetTransactionListResponse.h"
#import "NSString+dataFromFilename.h"


@implementation GetTransactionListResponse

@synthesize transactions;


+ (GetTransactionListResponse *) getTransactionListResponse {
    GetTransactionListResponse *g = [[GetTransactionListResponse alloc] init];
    return g;
}

- (id) init {
    self = [super init];
    if (self) {
        self.transactions = [NSMutableArray array];
    }
    return self;
}

- (NSString *) description {
    NSString *output = [NSString stringWithFormat:@""
                        @"GetTransactionResponse.anetApiResponse = %@"
                        @"GetTransactionResponse.transactions = %@",
                        self.anetApiResponse,
                        self.transactions];
    return output;
}



+ (GetTransactionListResponse *)parseGetTransactionListResponse:(NSData *)xmlData {
    NSError *error;
	
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData 
														   options:0 error:&error];
	
	NSLog(@"Error = %@", error);
	
    if (doc == nil) { return nil; }
	
	GetTransactionListResponse *t = [GetTransactionListResponse getTransactionListResponse];
	
	t.anetApiResponse = [ANetApiResponse buildANetApiResponse:doc.rootElement];
    
    
    NSArray *currArray = [doc.rootElement elementsForName:@"transactions"];
	GDataXMLElement *currNode = (GDataXMLElement *) [currArray objectAtIndex:0];
	
	
	currArray = [currNode elementsForName:@"transaction"];
	for (GDataXMLElement *node in currArray) {
        TransactionSummaryType *ts = [TransactionSummaryType buildTransactionSummaryType:node];
		[t.transactions addObject:ts];
	}
    
    return t;
}


// For unit testing.
+ (GetTransactionListResponse *)loadGetTransactionListResponseFromFilename:(NSString *)filename {
    NSString *filePath = [NSString dataFromFilename:filename];
	// TODO: Change this to process from HTTP response data
	// after initial testing.
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
	GetTransactionListResponse *t = [self parseGetTransactionListResponse:xmlData];
    return t;
}


@end
