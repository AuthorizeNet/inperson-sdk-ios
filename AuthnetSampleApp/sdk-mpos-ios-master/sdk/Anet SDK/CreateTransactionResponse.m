//
//  CreateTransactionResponse.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 1/17/11.
//  Copyright 2011 none. All rights reserved.
//

#import "CreateTransactionResponse.h"
#import "NSString+dataFromFilename.h"
#import "NSString+stringValueOfXMLElement.h"

@implementation CreateTransactionResponse

@synthesize transactionResponse;
@synthesize sessionToken;

+ (CreateTransactionResponse *) createTransactionResponse {

	CreateTransactionResponse *t = [[CreateTransactionResponse alloc] init];
	return t;
}

- (id)init {
	if ((self = [super init])) {
		self.transactionResponse = nil;
        self.sessionToken = nil;
	}
	return self;
}

- (NSString *)description {
	NSString *output = [NSString stringWithFormat:@""
						"createTransactionResponse.anetAPIResponse = %@\n"
						"createTransactionResponse.transactionResponse = %@\n"
                        "createTransactionResponse.sessionToken = %@\n",
						self.anetApiResponse,
						self.transactionResponse,
                        self.sessionToken];
	return output;
}

+ (CreateTransactionResponse *)parseCreateTransactionResponse:(NSData *)xmlData {
    NSError *error;
	
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData 
														   options:0 error:&error];
	
	NSLog(@"Error = %@", error);
	
    if (doc == nil) { return nil; }
	
	CreateTransactionResponse *t = [CreateTransactionResponse createTransactionResponse];
	
	t.anetApiResponse = [ANetApiResponse buildANetApiResponse:doc.rootElement]; 
	t.transactionResponse = [TransactionResponse buildTransactionResponse:doc.rootElement];
	t.sessionToken = [NSString stringValueOfXMLElement:doc.rootElement withName:@"sessionToken"];
	
	NSLog(@"CreateTransactionResponse: %@", t);

    return t;
	
}

+ (CreateTransactionResponse *)loadCreateTransactionResponseFromFilename:(NSString *)filename {
    NSString *filePath = [NSString dataFromFilename:filename];
    
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    
	NSLog(@"filePath = %@", filePath);
	
	CreateTransactionResponse *r = [self parseCreateTransactionResponse:xmlData];
    return r;
}

@end
