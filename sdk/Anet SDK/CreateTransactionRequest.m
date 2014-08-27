//
//  CreateTransactionRequest.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 8/17/10.
//  Copyright 2010 Authorize.Net. All rights reserved.
//

#import "CreateTransactionRequest.h"

@interface CreateTransactionRequest (private)
+ (NSString *) getTransactionTypeString:(AUTHNET_ACTION) action;
- (NSString *) stringOfXMLTransactionSettings;
- (NSString *) stringOfXMLUserFields;
@end


@implementation CreateTransactionRequest

@synthesize transactionRequest;
@synthesize transactionType;


+ (CreateTransactionRequest *) createTransactionRequest {
	CreateTransactionRequest *request = [[CreateTransactionRequest alloc] init];
	return request;
}

- (id) init {
	self = [super init];
	
	if (self) {
        self.transactionRequest = [TransactionRequestType transactionRequest];
        self.transactionType = ACTION_UNKNOWN;
	}
	
	return self;
}

- (BOOL) isValid {

//	if (self.customerIPAddress != nil && self.customerIPAddress.length > MAX_CUSTOMER_IP_LENGTH) {
//		return NO;
//	}
//
//	if (self.billingAddress != nil && ![self.billingAddress isValid]) {
//		return NO;
//	}
//	
//	if (self.creditCard != nil && ![self.creditCard isValid]) {
//		return NO;
//	}
//
//	if (self.customer != nil && ![self.customer isValid]) {
//		return NO;
//	}
//	
//	if (self.bankAccount != nil && ![self.bankAccount isValid]) {
//		return NO;
//	}
//	
//	if (self.emailReceipt != nil && ![self.emailReceipt isValid]) {
//		return NO;
//	}
//	
//	if (self.order != nil && ![self.order isValid]) {
//		return NO;
//	}
//
//	if (self.shippingAddress != nil && ![self.shippingAddress isValid]) {
//		return NO;
//	}
//	
//	if (self.shippingCharges != nil && ![self.shippingCharges isValid]) {
//		return NO;
//	}
	
	return YES;
}

- (NSString *) stringOfXMLRequest {
    NSString *s = [NSString stringWithFormat:@""
                   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>" 
                   @"<createTransactionRequest xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns=\"AnetApi/xml/v1/schema/AnetApiSchema.xsd\">"
                   @"%@"    //anetApiRequest
                   @"%@"    //transactionRequest
                   @"</createTransactionRequest>",
                   [super.anetApiRequest stringOfXMLRequest],
                   [self.transactionRequest stringOfXMLRequest]];
    
    NSLog(@"Create Transaction Request: %@", s);
    return s;
}

+ (NSString *) getTransactionTypeString:(AUTHNET_ACTION) action {
	switch (action) {
		case AUTH_ONLY:
			return @"authOnlyTransaction";
			break;
		case AUTH_CAPTURE:
			return @"authCaptureTransaction";
			break;
		case PRIOR_AUTH_CAPTURE:
			return @"priorAuthCaptureTransaction";
			break;
		case CAPTURE_ONLY:
			return @"captureOnlyTransaction";
			break;
		case VOID:
			return @"voidTransaction";
			break;
		case CREDIT:
			return @"refundTransaction";
			break;
		case UNLINKED_CREDIT:
			return @"refundTransaction";   //Unlinked Credit is still CREDIT but no associated transaction_id.
			break;
		default:
			return @"";
			break;
	}
}

@end
