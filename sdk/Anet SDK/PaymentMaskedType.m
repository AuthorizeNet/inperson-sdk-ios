//
//  PaymentMaskedType.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/21/11.
//  Copyright 2011 none. All rights reserved.
//

#import "PaymentMaskedType.h"


@implementation PaymentMaskedType

@synthesize bankAccount;
@synthesize creditCard;

+ (PaymentMaskedType *) paymentMaskedType {
    PaymentMaskedType *p = [[PaymentMaskedType alloc] init];
    return p;
}

- (id) init {
    self = [super init];
    if (self) {
        self.creditCard = [CreditCardMaskedType creditCardMaskedType];
        self.bankAccount = [BankAccountMaskedType bankAccountMaskedType];
    }
    return self;
}

- (NSString *) description {
    NSString *output = [NSString stringWithFormat:@""
                        @"PaymentMaskedType.bankAccount = %@\n"
                        @"PaymentMaskedType.creditCard = %@\n",
                        self.bankAccount,
                        self.creditCard];
    return output;
}


+ (PaymentMaskedType *)buildPaymentMaskedType:(GDataXMLElement *)element {
    PaymentMaskedType *p = [PaymentMaskedType paymentMaskedType];
    NSArray* currArray = [element elementsForName:@"creditCard"];
    GDataXMLElement *currNode;
    if ([currArray count]) {
        currNode = [currArray objectAtIndex:0];
        p.creditCard = [CreditCardMaskedType buildCreditCardMaskedType:currNode];
    } else {
        currArray = [element elementsForName:@"bankAccount"];
        currNode = [currArray objectAtIndex:0];
        p.bankAccount = [BankAccountMaskedType buildBankAccountMaskedType:currNode];
    }
    return p;
}
@end
