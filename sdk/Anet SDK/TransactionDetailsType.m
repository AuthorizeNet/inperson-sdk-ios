//
//  TransactionDetailsType.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/21/11.
//  Copyright 2011 none. All rights reserved.
//

#import "TransactionDetailsType.h"
#import "FDSFilterType.h"
#import "LineItemType.h"
#import "NSString+stringValueOfXMLElement.h"

@implementation TransactionDetailsType

@synthesize transId;
@synthesize refTransId;
@synthesize splitTenderId;
@synthesize submitTimeUTC;
@synthesize submitTimeLocal;

@synthesize transactionType;
@synthesize transactionStatus;
@synthesize responseCode;
@synthesize responseReasonCode;
@synthesize responseReasonDescription;
@synthesize authCode;
@synthesize AVSResponse;
@synthesize cardCodeResponse;
@synthesize CAVVResponse;
@synthesize FDSFilterAction;
@synthesize FDSFilters;
@synthesize batchDetails;
@synthesize order;
@synthesize requestedAmount;
@synthesize authAmount;
@synthesize settleAmount;
@synthesize tax;
@synthesize shipping;
@synthesize duty;
@synthesize lineItems;
@synthesize prepaidBalanceRemaining;
@synthesize taxExempt;
@synthesize payment;
@synthesize customer;
@synthesize billTo;
@synthesize shipTo;
@synthesize recurringBilling;
@synthesize customerIP;

+ (TransactionDetailsType *) transactionDetails {
    TransactionDetailsType *t = [[TransactionDetailsType alloc] init];
    return t;
}

- (id) init {
    self = [super init];
    if (self) {
        self.transId = nil;
        self.refTransId = nil;
        self.splitTenderId = nil;
        self.submitTimeUTC = nil;
        self.submitTimeLocal = nil;
        
        self.transactionType = nil;
        self.transactionStatus = nil;
        self.responseCode = nil;
        self.responseReasonCode = nil;
        self.responseReasonDescription = nil;
        self.authCode = nil;
        self.AVSResponse = nil;
        self.cardCodeResponse = nil;
        self.CAVVResponse = nil;
        self.FDSFilterAction = nil;
        self.FDSFilters = [NSMutableArray array];
        self.batchDetails = [BatchDetailsType batchDetails];
        self.order = [OrderType order];
        self.requestedAmount = nil;
        self.authAmount = nil;
        self.settleAmount = nil;
        self.lineItems = [NSMutableArray array];
        self.prepaidBalanceRemaining = nil;
        self.taxExempt = nil;
        self.payment = [PaymentMaskedType paymentMaskedType];
        self.customer = [CustomerDataType customerDataType];
        self.billTo = [CustomerAddressType customerAddressType];
        self.shipTo = [NameAndAddressType nameAndAddressType];
        self.recurringBilling = nil;
        self.customerIP = nil;
    }
    return self;
}

- (NSString *) description {
	
	NSString *output = [NSString stringWithFormat:@""
						"TransactionDetails.transId = %@\n"
						"TransactionDetails.refTransId = %@\n"
						"TransactionDetails.splitTenderId = %@\n"
						"TransactionDetails.submitTimeUTC = %@\n"
						"TransactionDetails.submitTimeLocal = %@\n"
						"TransactionDetails.transactionType = %@\n"
                        "TransactionDetails.transactionStatus = %@\n"
						"TransactionDetails.responseCode = %@\n"
						"TransactionDetails.responseReasonCode = %@\n"
						"TransactionDetails.responseReasonDescription = %@\n"
						"TransactionDetails.authCode = %@\n"
						"TransactionDetails.AVSResponse = %@\n"
                        "TransactionDetails.cardCodeResponse = %@\n"
						"TransactionDetails.CAVVResponse = %@\n"
						"TransactionDetails.FDSFilterAction = %@\n"
						"TransactionDetails.FDSFilters = %@\n"
						"TransactionDetails.batchDetails = %@\n"
                        "TransactionDetails.order = %@\n"
                        "TransactionDetails.requestedAmount = %@\n"
						"TransactionDetails.authAmount = %@\n"
						"TransactionDetails.settleAmount = %@\n"
						"TransactionDetails.lineItems = %@\n"
                        "TransactionDetails.prepaidBalanceRemaining = %@\n"
						"TransactionDetails.taxExempt = %@\n"
						"TransactionDetails.payment = %@\n"
                        "TransactionDetails.customer = %@\n"
                        "TransactionDetails.billTo = %@\n"
                        "TransactionDetails.shipTo = %@\n"
						"TransactionDetails.recurringBilling = %@\n"
						"TransactionDetails.customerIP = %@\n",
						self.transId,
						self.refTransId,
						self.splitTenderId,
						self.submitTimeUTC,
                        self.submitTimeLocal,
                        self.transactionType,
                        self.transactionStatus,
                        self.responseCode,
                        self.responseReasonCode,
                        self.responseReasonDescription,
                        self.authCode,
                        self.AVSResponse,
                        self.cardCodeResponse,
                        self.CAVVResponse,
                        self.FDSFilterAction,
                        self.FDSFilters,
                        self.batchDetails,
                        self.order,
                        self.requestedAmount,
                        self.authAmount,
                        self.settleAmount,
                        self.lineItems,
                        self.prepaidBalanceRemaining,
                        self.taxExempt,
                        self.payment,
                        self.customer,
                        self.billTo,
                        self.shipTo,
                        self.recurringBilling,
                        self.customerIP];
    
	return output;
}


+ (TransactionDetailsType *) buildTransactionDetails:(GDataXMLElement *)element {
    GDataXMLElement *currNode;
	GDataXMLElement *childNode;
    
    TransactionDetailsType *t = [TransactionDetailsType transactionDetails];
    
    
	NSArray *currArray = [element elementsForName:@"transaction"];
	currNode = (GDataXMLElement *) [currArray objectAtIndex:0];
    
	t.transId = [NSString stringValueOfXMLElement:currNode withName:@"transId"];
	t.refTransId = [NSString stringValueOfXMLElement:currNode withName:@"refTransId"];
	t.splitTenderId = [NSString stringValueOfXMLElement:currNode withName:@"splitTenderId"];
	t.submitTimeUTC = [NSString stringValueOfXMLElement:currNode withName:@"submitTimeUTC"];
	t.submitTimeLocal = [NSString stringValueOfXMLElement:currNode withName:@"submitTimeLocal"];
	t.transactionType = [NSString stringValueOfXMLElement:currNode withName:@"transactionType"];
	t.transactionStatus = [NSString stringValueOfXMLElement:currNode withName:@"transactionStatus"];
	t.responseCode = [NSString stringValueOfXMLElement:currNode withName:@"responseCode"];
	t.responseReasonCode = [NSString stringValueOfXMLElement:currNode withName:@"responseReasonCode"];
	t.responseReasonDescription = [NSString stringValueOfXMLElement:currNode withName:@"responseReasonDescription"];
	t.authCode = [NSString stringValueOfXMLElement:currNode withName:@"authCode"];
	t.AVSResponse = [NSString stringValueOfXMLElement:currNode withName:@"AVSResponse"];
	t.cardCodeResponse = [NSString stringValueOfXMLElement:currNode withName:@"cardCodeResponse"];
	t.CAVVResponse = [NSString stringValueOfXMLElement:currNode withName:@"CAVVResponse"];
	
    t.requestedAmount = [NSString stringValueOfXMLElement:currNode withName:@"requestedAmount"];
	t.authAmount = [NSString stringValueOfXMLElement:currNode withName:@"authAmount"];
	t.settleAmount = [NSString stringValueOfXMLElement:currNode withName:@"settleAmount"];
    
	t.recurringBilling = [NSString stringValueOfXMLElement:currNode withName:@"recurringBilling"];
	t.customerIP = [NSString stringValueOfXMLElement:currNode withName:@"customerIP"];
    
	t.FDSFilterAction = [NSString stringValueOfXMLElement:currNode withName:@"FDSFilterAction"];
    
    currArray = [currNode elementsForName:@"FDSFilters"];
	childNode = [currArray objectAtIndex:0];
	currArray = [childNode elementsForName:@"FDSFilter"];
	
	for (GDataXMLElement *filter in currArray) {
		FDSFilterType *f = [FDSFilterType fdsFilter];
        
		f.name = [NSString stringValueOfXMLElement:filter withName:@"name"];
		f.action = [NSString stringValueOfXMLElement:filter withName:@"action"];
		[t.FDSFilters addObject:f];
	}
    
    currArray = [currNode elementsForName:@"batch"];
	childNode = [currArray objectAtIndex:0];
	t.batchDetails = [BatchDetailsType buildBatchDetails:childNode];
	
	currArray = [currNode elementsForName:@"order"];
	childNode = [currArray objectAtIndex:0];
	t.order = [OrderType buildOrder:childNode];
    
	currArray = [currNode elementsForName:@"tax"];
	childNode = [currArray objectAtIndex:0];
	t.tax = [ExtendedAmountType buildExtendedAmountType:childNode];
    
	currArray = [currNode elementsForName:@"shipping"];
	childNode = [currArray objectAtIndex:0];
	t.shipping = [ExtendedAmountType buildExtendedAmountType:childNode];
	
	currArray = [currNode elementsForName:@"duty"];
	childNode = [currArray objectAtIndex:0];
	t.duty = [ExtendedAmountType buildExtendedAmountType:childNode];
	
	currArray = [currNode elementsForName:@"lineItems"];
	childNode = [currArray objectAtIndex:0];
	currArray = [childNode elementsForName:@"lineItem"];
	for (GDataXMLElement *item in currArray) {
		LineItemType *l = [LineItemType buildLineItem:item];
		[t.lineItems addObject:l];
	}
	
	t.prepaidBalanceRemaining = [NSString stringValueOfXMLElement:currNode withName:@"prepaidBalanceRemaining"];
	t.taxExempt = [NSString stringValueOfXMLElement:currNode withName:@"taxExempt"];
    
	currArray = [currNode elementsForName:@"payment"];
	childNode = [currArray objectAtIndex:0];
    t.payment = [PaymentMaskedType buildPaymentMaskedType:childNode];
    
	currArray = [currNode elementsForName:@"customer"];
	childNode = [currArray objectAtIndex:0];
	t.customer = [CustomerDataType buildCustomerDataType:childNode];
    
	currArray = [currNode elementsForName:@"billTo"];
	childNode = [currArray objectAtIndex:0];
	t.billTo = [CustomerAddressType buildCustomerAddressType:childNode];
    
	currArray = [currNode elementsForName:@"shipTo"];
	childNode = [currArray objectAtIndex:0];
	t.shipTo = [NameAndAddressType buildNameAndAddressType:childNode];
	
	NSLog(@"TransactionDetails output:\n%@", t);
	
    
    return t;
}
@end
