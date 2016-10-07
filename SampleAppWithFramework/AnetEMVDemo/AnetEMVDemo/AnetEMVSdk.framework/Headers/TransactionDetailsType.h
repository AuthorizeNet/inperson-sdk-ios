//
//  TransactionDetailsType.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/21/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BatchDetailsType.h"
#import "CCAuthenticationType.h"
#import "CustomerAddressType.h"
#import "CustomerDataType.h"
#import "ExtendedAmountType.h"
#import "NameAndAddressType.h"
#import "PaymentMaskedType.h"
#import "OrderType.h"

@interface TransactionDetailsType : NSObject {
    NSString *transId;
    NSString *refTransId;
    NSString *splitTenderId;
    NSString *submitTimeUTC;
    NSString *submitTimeLocal;
    
	NSString *transactionType;
	NSString *transactionStatus;
	NSString *responseCode;
	NSString *responseReasonCode;
	NSString *responseReasonDescription;
	NSString *authCode;
	NSString *AVSResponse;
	NSString *cardCodeResponse;
	NSString *CAVVResponse;
	
	NSString *FDSFilterAction;
	NSMutableArray *FDSFilters;
    
	BatchDetailsType *batchDetails;
	OrderType *order;
    
	NSString *requestedAmount;
	NSString *authAmount;
	NSString *settleAmount;
	
	ExtendedAmountType *tax;
	ExtendedAmountType *shipping;
	ExtendedAmountType *duty;
	
	NSMutableArray *lineItems;
	NSString *prepaidBalanceRemaining;
  	NSString *taxExempt;
	PaymentMaskedType *payment;
	CustomerDataType *customer;
    CustomerAddressType *billTo;
    NameAndAddressType *shipTo;
	NSString *recurringBilling;
	NSString *customerIP;
    CCAuthenticationType *cardholderAuthentication;
    
}

@property (nonatomic, strong) NSString *transId;
@property (nonatomic, strong) NSString *refTransId;
@property (nonatomic, strong) NSString *splitTenderId;
@property (nonatomic, strong) NSString *submitTimeUTC;
@property (nonatomic, strong) NSString *submitTimeLocal;

@property (nonatomic, strong) NSString *transactionType;
@property (nonatomic, strong) NSString *transactionStatus;
@property (nonatomic, strong) NSString *responseCode;
@property (nonatomic, strong) NSString *responseReasonCode;
@property (nonatomic, strong) NSString *responseReasonDescription;
@property (nonatomic, strong) NSString *authCode;
@property (nonatomic, strong) NSString *AVSResponse;
@property (nonatomic, strong) NSString *cardCodeResponse;
@property (nonatomic, strong) NSString *CAVVResponse;
@property (nonatomic, strong) NSString *FDSFilterAction;
@property (nonatomic, strong) NSMutableArray *FDSFilters;
@property (nonatomic, strong) BatchDetailsType *batchDetails;
@property (nonatomic, strong) OrderType *order;
@property (nonatomic, strong) NSString *requestedAmount;
@property (nonatomic, strong) NSString *authAmount;
@property (nonatomic, strong) NSString *settleAmount;
@property (nonatomic, strong) ExtendedAmountType *tax;
@property (nonatomic, strong) ExtendedAmountType *shipping;
@property (nonatomic, strong) ExtendedAmountType *duty;
@property (nonatomic, strong) NSMutableArray *lineItems;
@property (nonatomic, strong) NSString *prepaidBalanceRemaining;
@property (nonatomic, strong) NSString *taxExempt;
@property (nonatomic, strong) PaymentMaskedType *payment;
@property (nonatomic, strong) CustomerDataType *customer;
@property (nonatomic, strong) CustomerAddressType *billTo;
@property (nonatomic, strong) NameAndAddressType *shipTo;
@property (nonatomic, strong) NSString *recurringBilling;
@property (nonatomic, strong) NSString *customerIP;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (TransactionDetailsType *)transactionDetails;

/**
 * TransactionDetailsType from parsing the XML response indexed by GDataXMLElement
 * @return TransactionDetailsType autorelease instance of the parser generated object.
 */
+ (TransactionDetailsType *) buildTransactionDetails:(GDataXMLElement *)element;
@end
