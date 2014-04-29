//
//  TransactionRequestType.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/23/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentType.h"
#import "ExtendedAmountType.h"
#import "CustomerDataType.h"
#import "CustomerAddressType.h"
#import "LineItemType.h"
#import "NameAndAddressType.h"
#import "OrderType.h"
#import "SettingType.h"
#import "TransRetailInfoType.h"
#import "UserField.h"

@interface TransactionRequestType : NSObject {
    NSString *transactionType;
    NSString *amount;
    PaymentType *payment;
    NSString *authCode;
    NSString *refTransId;
    NSString *splitTenderId;
    OrderType *order;
    NSMutableArray *lineItems;
    ExtendedAmountType *tax;
    ExtendedAmountType *duty;
    ExtendedAmountType *shipping;
    NSString *taxExempt;
    NSString *poNumber;
    CustomerDataType *customer;
    CustomerAddressType *billTo;
    NameAndAddressType *shipTo;
    NSString *customerIP;
    TransRetailInfoType *retail;
    NSMutableArray *transactionSettings;
    NSMutableArray *userFields;

}


@property (nonatomic, strong) NSString *transactionType;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) PaymentType *payment;
@property (nonatomic, strong) NSString *authCode;
@property (nonatomic, strong) NSString *refTransId;
@property (nonatomic, strong) NSString *splitTenderId;
@property (nonatomic, strong) OrderType *order;
@property (nonatomic, strong) NSMutableArray *lineItems;
@property (nonatomic, strong) ExtendedAmountType *tax;
@property (nonatomic, strong) ExtendedAmountType *duty;
@property (nonatomic, strong) ExtendedAmountType *shipping;
@property (nonatomic, strong) NSString *taxExempt;
@property (nonatomic, strong) NSString *poNumber;
@property (nonatomic, strong) CustomerDataType *customer;
@property (nonatomic, strong) CustomerAddressType *billTo;
@property (nonatomic, strong) NameAndAddressType *shipTo;
@property (nonatomic, strong) NSString *customerIP;
@property (nonatomic, strong) TransRetailInfoType *retail;
@property (nonatomic, strong) NSMutableArray *transactionSettings;
@property (nonatomic, strong) NSMutableArray *userFields;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (TransactionRequestType *) transactionRequest;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *)stringOfXMLRequest;
@end
