//
//  CreditCardMaskedType.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/21/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface CreditCardMaskedType : NSObject {
    NSString *cardNumber;
    NSString *expirationDate;
    NSString *cardType;
}

@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSString *expirationDate;
@property (nonatomic, strong) NSString *cardType;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (CreditCardMaskedType *) creditCardMaskedType;

/**
 * Class method that takes in GDataXMLElement and returns a fully parsed
 * CreditCardMaskedType.  If the method was not able to parse the response,
 * a nil object is returned.
 * @return The parsed CreditCardMaskedType from parsing the GDataXMLElement or nil if unable
 * to parse the data.
 */
+ (CreditCardMaskedType *) buildCreditCardMaskedType:(GDataXMLElement *)element;

@end
