//
//  SplitTenderPayment.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 1/28/11.
//  Copyright 2011 none. All rights reserved.
//

#import "SplitTenderPayment.h"
#import "NSString+stringValueOfXMLElement.h"

@implementation SplitTenderPayment

@synthesize transId;
@synthesize responseCode;
@synthesize responseToCustomer;
@synthesize authCode;
@synthesize accountNumber;
@synthesize accountType;
@synthesize requestedAmount;
@synthesize approvedAmount;
@synthesize balanceOnCard;



+ (SplitTenderPayment *) splitTenderPayment {
	
	SplitTenderPayment *s = [[SplitTenderPayment alloc] init];
	return s;
}


- (id) init {
	if (self = [super init]) {
		self.transId = nil;
		self.responseCode = nil;
		self.responseToCustomer = nil;
		self.authCode = nil;
		self.accountNumber = nil;
		self.accountType = nil;
		self.requestedAmount = nil;
		self.approvedAmount = nil;
		self.balanceOnCard = nil;
		
	}
	return self;
}

- (NSString *) description {
	
	NSString *output = [NSString stringWithFormat:@""
						"SplitTenderPayment.transId = %@\n"
						"SplitTenderPayment.responseCode = %@\n"
						"SplitTenderPayment.responseToCustomer = %@\n"
						"SplitTenderPayment.authCode = %@\n"
						"SplitTenderPayment.accountNumber = %@\n"
						"SplitTenderPayment.accountType = %@\n"
						"SplitTenderPayment.requestedAmount = %@\n"
						"SplitTenderPayment.approvedAmount = %@\n"
						"SplitTenderPayment.balanceOnCard = %@\n",
						self.transId,
						self.responseCode,
						self.responseToCustomer,
						self.authCode,
						self.accountNumber,
						self.accountType,
						self.requestedAmount,
						self.approvedAmount,
						self.balanceOnCard];
	return output;
}


+ (SplitTenderPayment *)buildSplitTenderPayment:(GDataXMLElement *)element {
	SplitTenderPayment *s = [SplitTenderPayment splitTenderPayment];
	
	s.transId = [NSString stringValueOfXMLElement:element withName:@"transId"];
	s.responseCode = [NSString stringValueOfXMLElement:element withName:@"responseCode"];
	s.responseToCustomer = [NSString stringValueOfXMLElement:element withName:@"responseToCustomer"];
	s.authCode = [NSString stringValueOfXMLElement:element withName:@"authCode"];
	s.accountNumber = [NSString stringValueOfXMLElement:element withName:@"accountNumber"];
	s.accountType = [NSString stringValueOfXMLElement:element withName:@"accountType"];
	s.requestedAmount = [NSString stringValueOfXMLElement:element withName:@"requestedAmount"];
	s.approvedAmount = [NSString stringValueOfXMLElement:element withName:@"approvedAmount"];
	s.balanceOnCard = [NSString stringValueOfXMLElement:element withName:@"balanceOnCard"];
	
	//Debugging
	NSLog(@"SplitTenderPayment = %@", s);
	
	return s;
}
@end
