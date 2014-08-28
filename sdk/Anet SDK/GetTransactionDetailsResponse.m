//
//  GetTransactionDetailsResponse.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 12/13/10.
//  Copyright 2010 none. All rights reserved.
//

#import "GetTransactionDetailsResponse.h"
#import "NSString+dataFromFilename.h"

@implementation GetTransactionDetailsResponse
@synthesize transactionDetails;


+ (GetTransactionDetailsResponse *) getTransactionDetailsResponse {
	GetTransactionDetailsResponse *t = [[GetTransactionDetailsResponse alloc] init];
	return t;
}

- (id)init {
	if ((self = [super init])) {
        self.transactionDetails = [TransactionDetailsType transactionDetails];
	}
	return self;
}

- (NSString *)description {
	NSString *output = [NSString stringWithFormat:@""
                        "GetTransactionDetailsResponse.anetApiResponse = %@"
                        "GetTransactionDetailsResponse.transactionDetails = %@",
						self.anetApiResponse,
                        self.transactionDetails];
	return output;
}

+ (GetTransactionDetailsResponse *)parseTransactionDetail:(NSData *)xmlData {
    NSError *error;
	
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData 
														   options:0 error:&error];
	
	NSLog(@"Error = %@", error);
	
    if (doc == nil) { return nil; }
	
	GetTransactionDetailsResponse *t = [GetTransactionDetailsResponse getTransactionDetailsResponse];
	
	t.anetApiResponse = [ANetApiResponse buildANetApiResponse:doc.rootElement];
    
    t.transactionDetails = [TransactionDetailsType buildTransactionDetails:doc.rootElement];
    
	NSLog(@"TransactionDetail: %@", t);
	
    return t;
	
}

+ (GetTransactionDetailsResponse *)loadTransactionDetailFromFilename:(NSString *)filename {
    NSString *filePath = [NSString dataFromFilename:filename];
    // TODO: Change this to process from HTTP response data
    // after initial testing.
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    GetTransactionDetailsResponse *t = [self parseTransactionDetail:xmlData];
    return t;

}


@end
