//
//  SendCustomerTransactionReceiptResponse.m
//  ANMobilePaymentLib
//
//  Created by Shiun Hwang on 6/16/11.
//  Copyright 2011 none. All rights reserved.
//

#import "SendCustomerTransactionReceiptResponse.h"
#import "NSString+dataFromFilename.h"


@implementation SendCustomerTransactionReceiptResponse

+ (SendCustomerTransactionReceiptResponse *) sendCustomerTransactionReceiptResponse {
    
	SendCustomerTransactionReceiptResponse *s = [[SendCustomerTransactionReceiptResponse alloc] init];
	return s;
}

- (id)init {
	if ((self = [super init])) {
	}
	return self;
}


- (NSString *)description {
	NSString *output = [NSString stringWithFormat:@""
						"SendCustomerTransactionReceiptResponse.anetAPIResponse = %@\n",
						self.anetApiResponse];
	return output;
}


+ (SendCustomerTransactionReceiptResponse *) parseSendCustomerTransactionReceiptResponse:(NSData *)xmlData {
    NSError *error;
	
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData 
														   options:0 error:&error];
	
	NSLog(@"Error = %@", error);
	
    if (doc == nil) { return nil; }
	
	SendCustomerTransactionReceiptResponse *s = [SendCustomerTransactionReceiptResponse sendCustomerTransactionReceiptResponse];
	
	s.anetApiResponse = [ANetApiResponse buildANetApiResponse:doc.rootElement]; 

	NSLog(@"SendCustomerTransactionReceiptResponse: %@", s);

    return s;
	
}

+ (SendCustomerTransactionReceiptResponse *) loadSendCustomerTransactionReceiptResponseFromFilename:(NSString *)filename {
    NSString *filePath = [NSString dataFromFilename:filename];
    
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    
	NSLog(@"filePath = %@", filePath);
	
	SendCustomerTransactionReceiptResponse *s = [self parseSendCustomerTransactionReceiptResponse:xmlData];

    return s;
}
@end
