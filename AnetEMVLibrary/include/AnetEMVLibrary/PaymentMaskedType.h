//
//  PaymentMaskedType.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/21/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BankAccountMaskedType.h"
#import "CreditCardMaskedType.h"
#import "GDataXMLNode.h"


@interface PaymentMaskedType : NSObject {
    BankAccountMaskedType *bankAccount;
    CreditCardMaskedType *creditCard;
}

@property (nonatomic, strong) BankAccountMaskedType *bankAccount;
@property (nonatomic, strong) CreditCardMaskedType *creditCard;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (PaymentMaskedType *) paymentMaskedType;

/**
 * PaymentMaskedType from parsing the XML response indexed by GDataXMLElement
 * @return PaymentMaskedType autorelease instance of the parser generated object.
 */
+ (PaymentMaskedType *)buildPaymentMaskedType:(GDataXMLElement *)element;

@end
