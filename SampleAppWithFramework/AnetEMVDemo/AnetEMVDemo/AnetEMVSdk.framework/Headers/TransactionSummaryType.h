//
//  TransactionSummaryType.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/24/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface TransactionSummaryType : NSObject {
    NSString *transId;
    NSString *submitTimeUTC;
    NSString *submitTimeLocal;
    NSString *transactionStatus;
    NSString *invoiceNumber;
    NSString *firstName;
    NSString *lastName;
    NSString *accountType;
    NSString *accountNumber;
    NSString *settleAmount;
}

@property (nonatomic, strong) NSString *transId;
@property (nonatomic, strong) NSString *submitTimeUTC;
@property (nonatomic, strong) NSString *submitTimeLocal;
@property (nonatomic, strong) NSString *transactionStatus;
@property (nonatomic, strong) NSString *invoiceNumber;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *accountType;
@property (nonatomic, strong) NSString *accountNumber;
@property (nonatomic, strong) NSString *settleAmount;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (TransactionSummaryType *) transactionSummaryType;

/**
 * TransactionSummaryType from parsing the XML response indexed by GDataXMLElement
 * @return TransactionSummaryType autorelease instance of the parser generated object.
 */
+ (TransactionSummaryType *) buildTransactionSummaryType:(GDataXMLElement *)element;
@end
