//
//  CreditCardType.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 9/1/10.
//  Copyright 2010 Authorize.Net. All rights reserved.
//

#import "CreditCardType.h"
#import "NSString+stringWithXMLTag.h"

@implementation CreditCardType

@synthesize cardNumber;
@synthesize expirationDate;
@synthesize cardCode;


+ (id) creditCardType {
	CreditCardType *cc = [[CreditCardType alloc] init];
	return cc;
}

- (id) init {
    self = [super init];
	if (self) {
		cardNumber = nil;
		expirationDate = nil;
		cardCode = nil;
	}
	return self;
}

/*
 * Checks whether a string of digits is a valid credit card number according to
 * the Luhn algorithm.
 *
 * 1. Starting with the second to last digit and moving left, double the value
 *    of all the alternating digits. For any digits that thus become 10 or more,
 *    add their digits together. For example, 1111 becomes 2121, while 8763
 *    becomes 7733 (from (1+6)7(1+2)3).
 *
 * 2. Add all these digits together. For example, 1111 becomes 2121, then
 *    2+1+2+1 is 6; while 8763 becomes 7733, then 7+7+3+3 is 20.
 *
 * 3. If the total ends in 0 (put another way, if the total modulus 10 is 0),
 *    then the number is valid according to the Luhn formula, else it is not
 *    valid. So, 1111 is not valid (as shown above, it comes out to 6), while
 *    8763 is valid (as shown above, it comes out to 20).
 */

+ (BOOL) isValidCreditCardNumber:(NSString *)number {

	NSString *toTest = [number stringByReplacingOccurrencesOfString:@"-" withString:@""];
	
    int n, i, alternate, sum;
	
    n = [toTest length];
	
    if (n < 13 || n > 19)
        return 0;
	
    for (alternate = 0, sum = 0, i = n - 1; i > -1; --i) {
        if (!isdigit([toTest characterAtIndex:i]))
            return 0;
		
        n = [toTest characterAtIndex:i] - '0';
		
        if (alternate) {
            n *= 2;
            if (n > 9)
                n = (n % 10) + 1;
        }
        alternate = !alternate;
		
        sum += n;
    }
	
    return (sum % 10 == 0);
}


- (BOOL) isValid
{
	if (self.expirationDate != nil && self.expirationDate.length != EXPIRATION_DATE_LENGTH) {
		return NO;
	}
	
	if (![CreditCardType isValidCreditCardNumber:self.cardNumber])
		return NO;
	
	return YES;
}	


- (NSString *) stringOfXMLRequest 
{
    NSString *s = nil;
    
    // Be forgiving on 3 digits (ex. 912 instead of 0912)
    if ([self.expirationDate length] == 3) {
        s = [NSString stringWithFormat:@""
                       @"<creditCard>"
                            @"%@" 
                            @"%@" 
                            @"%@"	//cardCode
                       @"</creditCard>",
                       [NSString stringWithXMLTag:@"cardNumber" andValue: self.cardNumber],
                       [NSString stringWithXMLTag:@"expirationDate" andValue:[@"0" stringByAppendingString:self.expirationDate]],
                       [NSString stringWithXMLTag:@"cardCode" andValue:self.cardCode]];
    } else {
        s = [NSString stringWithFormat:@""
             @"<creditCard>"
             @"%@" 
             @"%@" 
             @"%@"	//cardCode
             @"</creditCard>",
             [NSString stringWithXMLTag:@"cardNumber" andValue: self.cardNumber],
             [NSString stringWithXMLTag:@"expirationDate" andValue:self.expirationDate],
             [NSString stringWithXMLTag:@"cardCode" andValue:self.cardCode]];
    }
	return s;
}

- (NSString *)description {
	NSString *output = [NSString stringWithFormat:@""
						"CreditCard.cardNumber = %@\n"
						"CreditCard.expirationDate = %@\n"
						"CreditCard.cardCode = %@",
						self.cardNumber,
						self.expirationDate,
						self.cardCode];
	return output;
}

@end
