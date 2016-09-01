//
//  CreditCardType.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 9/1/10.
//  Copyright 2010 Authorize.Net. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * Credit Card related information
 */

#define EXPIRATION_DATE_LENGTH 4

/**
 * CreditCard. Contains the values that are common to the
 * credit card information of a  object.
 */
@interface CreditCardType : NSObject {
	NSString * cardNumber;
	NSString * expirationDate;
	NSString * cardCode;
}

@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSString *expirationDate;
@property (nonatomic, strong) NSString *cardCode;

/**
 * Creates an autoreleased CreditCardType object;
 * @return CreditCardType an autoreleased credit card object.
 */
+ (id) creditCardType;
/**
 * Validate that fields are valid in terms of length and acceptable values.
 * @return BOOL returns whether values are valid.
 */
- (BOOL) isValid;

/**
 * Runs the Luhn Algorithm check against a credit card number.
 * @return BOOL returns whether the credit card is valid.
 */
+ (BOOL) isValidCreditCardNumber:(NSString *)number;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *) stringOfXMLRequest;
@end
