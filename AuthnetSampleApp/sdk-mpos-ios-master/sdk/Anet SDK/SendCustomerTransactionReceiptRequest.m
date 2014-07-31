//
//  SendCustomerTransactionReceiptRequest.m
//  ANMobilePaymentLib
//
//  Created by Shiun Hwang on 6/16/11.
//  Copyright 2011 none. All rights reserved.
//

#import "SendCustomerTransactionReceiptRequest.h"
#import "NSString+stringWithXMLTag.h"

@implementation SendCustomerTransactionReceiptRequest
@synthesize transId;
@synthesize customerEmail;
@synthesize emailSettings;


+ (SendCustomerTransactionReceiptRequest *) sendCustomerTransactionReceiptRequest {
    SendCustomerTransactionReceiptRequest *s = [[SendCustomerTransactionReceiptRequest alloc] init];
    return s;
}

- (id) init {
    self = [super init];
    if (self) {
        self.transId = nil;
        self.customerEmail = nil;
        self.emailSettings = [NSMutableArray array];
    }
    return self;
}


- (NSString *) description {
    NSString *output = [NSString stringWithFormat:@""
                        @"SendCustomerTransactionReceiptRequest.anetApiRequest = %@,"
                        @"SendCustomerTransactionReceiptRequest.transId = %@,"
                        @"SendCustomerTransactionReceiptRequest.customerEmail = %@,"
                        @"SendCustomerTransactionReceiptRequest.emailSettings = %@",
                        super.anetApiRequest,
                        self.transId,
                        self.customerEmail,
                        self.emailSettings];
    return output;
}


- (NSString *) stringOfXMLRequest {
    // create the transactionSettings XML
    NSString *ts = [NSString string];
    for (SettingType *st in self.emailSettings) {
        ts = [ts stringByAppendingFormat:@"%@", [st stringOfXMLRequest]];
    }
    
    NSString *s = [NSString stringWithFormat:@""
                   "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<sendCustomerTransactionReceiptRequest xmlns=\"AnetApi/xml/v1/schema/AnetApiSchema.xsd\">"
                   @"%@"
                   @"%@"
                   @"%@"
                   @"%@"
                   "</sendCustomerTransactionReceiptRequest>",
				   [super.anetApiRequest stringOfXMLRequest],
                   [NSString stringWithXMLTag:@"transId" andValue:self.transId],
                   [NSString stringWithXMLTag:@"customerEmail" andValue:self.customerEmail],
                   ([ts length] ? [NSString stringWithFormat:@"<emailSettings version=\"1\">%@</emailSettings>", ts] : @"")];
	return s;
}

@end
