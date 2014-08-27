//
//  CreditCardMaskedType.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/21/11.
//  Copyright 2011 none. All rights reserved.
//

#import "CreditCardMaskedType.h"
#import "NSString+stringValueOfXMLElement.h"


@implementation CreditCardMaskedType

@synthesize cardNumber;
@synthesize expirationDate;
@synthesize cardType;

+ (CreditCardMaskedType *) creditCardMaskedType {
    CreditCardMaskedType *c = [[CreditCardMaskedType alloc] init];
    return c;
}

- (id) init {
    self = [super init];
    if (self) {
        self.cardNumber = nil;
        self.expirationDate = nil;
        self.cardType = nil;
    }
    return self;
}

- (NSString *) description {
    NSString *s = [NSString stringWithFormat:@""
                   @"CreditCardMaskedType.cardNumber = %@\n"
                   @"CreditCardMaskedType.expirationDate = %@\n"
                   @"CreditCardMaskedType.cardType = %@\n",
                   self.cardNumber,
                   self.expirationDate,
                   self.cardType];
    return s;
}


+ (CreditCardMaskedType *) buildCreditCardMaskedType:(GDataXMLElement *)element {
    CreditCardMaskedType *c = [CreditCardMaskedType creditCardMaskedType];
    c.cardNumber = [NSString stringValueOfXMLElement:element withName:@"cardNumber"];
    c.expirationDate = [NSString stringValueOfXMLElement:element withName:@"expirationDate"];
    c.cardType = [NSString stringValueOfXMLElement:element withName:@"cardType"];
    
    return c;
}
@end
