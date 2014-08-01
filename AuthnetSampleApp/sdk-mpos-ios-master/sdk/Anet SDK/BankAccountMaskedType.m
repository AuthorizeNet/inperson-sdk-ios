//
//  BankAccountMaskedType.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/22/11.
//  Copyright 2011 none. All rights reserved.
//

#import "BankAccountMaskedType.h"
#import "NSString+stringValueOfXMLElement.h"

@implementation BankAccountMaskedType

@synthesize accountType;
@synthesize routingNumber;
@synthesize accountNumber;
@synthesize nameOnAccount;
@synthesize echeckType;
@synthesize bankName;

+ (BankAccountMaskedType *) bankAccountMaskedType {
    BankAccountMaskedType *b = [[BankAccountMaskedType alloc] init];
    return b;
}

- (id) init {
    self = [super init];
    if (self) {
        self.accountType = nil;
        self.routingNumber = nil;
        self.accountType = nil;
        self.nameOnAccount = nil;
        self.echeckType = nil;
        self.bankName = nil;
    }
    return self;
}

- (NSString *) description {
	
	NSString *output = [NSString stringWithFormat:@""
						"BankAccountMaskedType.accountType = %@\n"
						"BankAccountMaskedType.routingNumber = %@\n"
						"BankAccountMaskedType.accountType = %@\n"
						"BankAccountMaskedType.nameOnAccount = %@\n"
						"BankAccountMaskedType.echeckType = %@\n"
                        "BankAccountMaskedType.bankName = %@\n",
						self.accountType,
						self.routingNumber,
						self.accountType,
						self.nameOnAccount,
						self.echeckType,
						self.bankName];
	return output;
}



+ (BankAccountMaskedType *) buildBankAccountMaskedType:(GDataXMLElement *)element {
    BankAccountMaskedType *b = [BankAccountMaskedType bankAccountMaskedType];
    b.accountType = [NSString stringValueOfXMLElement:element withName:@"accountType"];
    b.routingNumber = [NSString stringValueOfXMLElement:element withName:@"routingNumber"];
    b.accountNumber = [NSString stringValueOfXMLElement:element withName:@"accountNumber"];
    b.nameOnAccount = [NSString stringValueOfXMLElement:element withName:@"nameOnAccount"];
    b.echeckType = [NSString stringValueOfXMLElement:element withName:@"echeckType"];
    b.bankName = [NSString stringValueOfXMLElement:element withName:@"bankName"];
    
    return b;
}
@end
