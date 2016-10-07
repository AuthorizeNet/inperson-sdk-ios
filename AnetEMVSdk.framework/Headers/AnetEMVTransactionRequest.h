//
//  AnetEMVTransactionRequest.h
//  AnetEMVSdk
//
//  Created by Pankaj Taneja on 10/23/15.
//  Copyright © 2015 Authorize.Net. All rights reserved.
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
#import "AuthNetRequest.h"

typedef NS_ENUM (NSInteger, EMVTransactionType) {
    EMVTransactionType_Goods = 0,
    EMVTransactionType_Services,
    EMVTransactionType_Cashback,
    EMVTransactionType_Inquiry,
    EMVTransactionType_Transfer,
    EMVTransactionType_Payment,
    EMVTransactionType_Refund
};

@interface AnetEMVTransactionRequest : AuthNetRequest {
    NSString *transactionType;
    NSString *amount;
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
    NSString *terminalID;
}

@property (nonatomic, assign) EMVTransactionType emvTransactionType;
@property (nonatomic, strong) NSString *transactionType;
@property (nonatomic, strong) NSString *amount;
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
@property (nonatomic, strong) NSString *terminalID;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (AnetEMVTransactionRequest *) transactionRequest;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *)stringOfXMLRequest;
@end
