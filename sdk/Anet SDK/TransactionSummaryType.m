//
//  TransactionSummaryType.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/24/11.
//  Copyright 2011 none. All rights reserved.
//

#import "TransactionSummaryType.h"
#import "NSString+stringValueOfXMLElement.h"

@implementation TransactionSummaryType

@synthesize transId;
@synthesize submitTimeUTC;
@synthesize submitTimeLocal;
@synthesize transactionStatus;
@synthesize invoiceNumber;
@synthesize firstName;
@synthesize lastName;
@synthesize accountType;
@synthesize accountNumber;
@synthesize settleAmount;

+ (TransactionSummaryType *) transactionSummaryType {
    TransactionSummaryType *t = [[TransactionSummaryType alloc] init];
    return t;
}

- (id) init {
    self = [super init];
    if (self) {
        self.transId = nil;
        self.submitTimeUTC = nil;
        self.submitTimeLocal = nil;
        self.transactionStatus = nil;
        self.invoiceNumber = nil;
        self.firstName = nil;
        self.lastName = nil;
        self.accountType = nil;
        self.accountNumber = nil;
        self.settleAmount = nil;
    }
    return self;
}


- (NSString *) description {
    NSString *output = [NSString stringWithFormat:@""
						"TransactionSummaryType.transId = %@\n"
						"TransactionSummaryType.submitTimeUTC = %@\n"
						"TransactionSummaryType.submitTimeLocal = %@\n"
						"TransactionSummaryType.transactionStatus = %@\n"
						"TransactionSummaryType.invoiceNumber = %@\n"
						"TransactionSummaryType.firstName = %@\n"
						"TransactionSummaryType.lastName = %@\n"
						"TransactionSummaryType.accountType = %@\n"
						"TransactionSummaryType.accountNumber = %@\n"
						"TransactionSummaryType.settleAmount = %@\n",
						self.transId,
						self.submitTimeUTC,
						self.submitTimeLocal,
						self.transactionStatus,
						self.invoiceNumber,
						self.firstName,
						self.lastName,
						self.accountType,
						self.accountNumber,
						self.settleAmount];
	return output;
}



+ (TransactionSummaryType *) buildTransactionSummaryType:(GDataXMLElement *)element {
    TransactionSummaryType *t = [TransactionSummaryType transactionSummaryType];
    
	t.transId = [NSString stringValueOfXMLElement:element withName:@"transId"];
	t.submitTimeUTC = [NSString stringValueOfXMLElement:element withName:@"submitTimeUTC"];
	t.submitTimeLocal = [NSString stringValueOfXMLElement:element withName:@"submitTimeLocal"];
	t.transactionStatus = [NSString stringValueOfXMLElement:element withName:@"transactionStatus"];
	t.invoiceNumber = [NSString stringValueOfXMLElement:element withName:@"invoiceNumber"];
	t.firstName = [NSString stringValueOfXMLElement:element withName:@"firstName"];
	t.lastName = [NSString stringValueOfXMLElement:element withName:@"lastName"];
	t.accountType = [NSString stringValueOfXMLElement:element withName:@"accountType"];
	t.accountNumber = [NSString stringValueOfXMLElement:element withName:@"accountNumber"];
	t.settleAmount = [NSString stringValueOfXMLElement:element withName:@"settleAmount"];
	
    return t;
}
@end
