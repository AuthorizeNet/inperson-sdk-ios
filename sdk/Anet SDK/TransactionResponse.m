//
//  TransactionResponse.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 1/17/11.
//  Copyright 2011 none. All rights reserved.
//

#import "TransactionResponse.h"
#import "NSString+stringValueOfXMLElement.h"

@implementation TransactionResponse

@synthesize responseCode;
@synthesize authCode;
@synthesize avsResultCode;
@synthesize cvvResultCode;
@synthesize cavvResultCode;
@synthesize transId;
@synthesize splitTenderId;
@synthesize refTransID;
@synthesize transHash;
@synthesize testRequest;
@synthesize accountNumber;
@synthesize accountType;
@synthesize messages;
@synthesize errors;
@synthesize splitTenderPayment;
@synthesize userFields;


+ (TransactionResponse *) transactionResponse {
	
	TransactionResponse *t = [[TransactionResponse alloc] init];
	return t;
}


- (id) init {
	if ((self = [super init])) {
		self.responseCode = nil;
		self.authCode = nil;
		self.avsResultCode = nil;
		self.cvvResultCode = nil;
		self.cavvResultCode = nil;
		self.transId = nil;
		self.refTransID = nil;
		self.transHash = nil;
		self.testRequest = nil;
		self.accountNumber = nil;
		self.accountType = nil;
        self.splitTenderId = nil;
		self.messages = [NSMutableArray array];
		self.errors = [NSMutableArray array];
		self.splitTenderPayment = nil;
		self.userFields = [NSMutableArray array];
	}
	return self;
}

- (NSString *) description {
	
	NSString *output = [NSString stringWithFormat:@""
						"TransactionResponse.responseCode = %@\n"
						"TransactionResponse.authCode = %@\n"
						"TransactionResponse.avsResultCode = %@\n"
						"TransactionResponse.cvvResultCode = %@\n"
						"TransactionResponse.cavvResultCode = %@\n"
						"TransactionResponse.transId = %@\n"
						"TransactionResponse.refTransID = %@\n"
						"TransactionResponse.transHash = %@\n"
						"TransactionResponse.testRequest = %@\n"
						"TransactionResponse.accountNumber = %@\n"
						"TransactionResponse.accountType = %@\n"
						"TransactionResponse.splitTenderId = %@\n"                        
						"TransactionResponse.messages = %@\n"
						"TransactionResponse.errors = %@\n"
						"TransactionResponse.splitTenderPayment = %@\n"
						"TransactionResponse.userFields = %@\n",
						self.responseCode,
						self.authCode,
						self.avsResultCode,
						self.cvvResultCode,
						self.cavvResultCode,
						self.transId,
						self.refTransID,
						self.transHash,
						self.testRequest,
						self.accountNumber,
						self.accountType,
                        self.splitTenderId,
						self.messages,
						self.errors,
						self.splitTenderPayment,
						self.userFields];
	return output;
}


+ (TransactionResponse *) buildTransactionResponse:(GDataXMLElement *)element {
	
	GDataXMLElement *currNode;
	GDataXMLElement *childNode;
	TransactionResponse *t = [TransactionResponse transactionResponse];
	
	NSArray *currArray = [element elementsForName:@"transactionResponse"];
	currNode = (GDataXMLElement *) [currArray objectAtIndex:0];
    
	t.responseCode = [NSString stringValueOfXMLElement:currNode withName:@"responseCode"];
	t.authCode = [NSString stringValueOfXMLElement:currNode withName:@"authCode"];
	t.avsResultCode = [NSString stringValueOfXMLElement:currNode withName:@"avsResultCode"];
	t.cvvResultCode = [NSString stringValueOfXMLElement:currNode withName:@"cvvResultCode"];
	t.cavvResultCode = [NSString stringValueOfXMLElement:currNode withName:@"cavvResultCode"];
	t.transId = [NSString stringValueOfXMLElement:currNode withName:@"transId"];
	t.refTransID = [NSString stringValueOfXMLElement:currNode withName:@"refTransID"];
	t.transHash = [NSString stringValueOfXMLElement:currNode withName:@"transHash"];
	t.testRequest = [NSString stringValueOfXMLElement:currNode withName:@"testRequest"];
	t.accountNumber = [NSString stringValueOfXMLElement:currNode withName:@"accountNumber"];
	t.accountType = [NSString stringValueOfXMLElement:currNode withName:@"accountType"];
	t.splitTenderId = [NSString stringValueOfXMLElement:currNode withName:@"splitTenderId"];
    
    t.messages = [Messages buildMessages:currNode];
	
	currArray = [currNode elementsForName:@"userFields"];
	childNode = [currArray objectAtIndex:0];
	currArray = [childNode elementsForName:@"userField"];
	
	for (GDataXMLElement *userField in currArray) {
		UserField *u = [UserField userField];
		
		u.name = [NSString stringValueOfXMLElement:userField withName:@"name"];
		u.value = [NSString stringValueOfXMLElement:userField withName:@"value"];
		[t.userFields addObject:u];
	}
	
	currArray = [currNode elementsForName:@"errors"];
	childNode = [currArray objectAtIndex:0];
	currArray = [childNode elementsForName:@"error"];
	
	for (GDataXMLElement *error in currArray) {
		Error *e = [Error error];
		
		e.errorCode = [NSString stringValueOfXMLElement:error withName:@"errorCode"];
		e.errorText = [NSString stringValueOfXMLElement:error withName:@"errorText"];
		[t.errors addObject:e];
	}
    
	currArray = [currNode elementsForName:@"splitTenderPayments"];
	childNode = [currArray objectAtIndex:0];
	currArray = [childNode elementsForName:@"splitTenderPayment"];	
	childNode = [currArray objectAtIndex:0];
	t.splitTenderPayment = [SplitTenderPayment buildSplitTenderPayment:childNode];
	
	return t;
}
@end
