//
//  BankAccountType.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/23/11.
//  Copyright 2011 none. All rights reserved.
//

#import "BankAccountType.h"
#import "NSString+stringWithXMLTag.h"


@implementation BankAccountType

@synthesize accountType;
@synthesize routingNumber;
@synthesize accountNumber;
@synthesize nameOnAccount;
@synthesize echeckType;
@synthesize checkNumber;

+ (BankAccountType *) bankAccountType {
    BankAccountType *b = [[BankAccountType alloc] init];
    return b;
}

- (id) init {
    self = [super init];
    if (self) {
        self.accountType = nil;
        self.routingNumber = nil;
        self.accountNumber = nil;
        self.nameOnAccount = nil;
        self.echeckType = nil;
        self.checkNumber = nil;
    }
    return self;
}

- (NSString *) description {
    NSString *output = [NSString stringWithFormat:@""
                        @"BankAccountType.accountType = %@"
                        @"BankAccountType.routingNumber = %@"
                        @"BankAccountType.accountNumber = %@"
                        @"BankAccountType.nameOnAccount = %@"
                        @"BankAccountType.echeckType = %@"
                        @"BankAccountType.checkNumber = %@",
                        self.accountType,
                        self.routingNumber,
                        self.accountNumber,
                        self.nameOnAccount,
                        self.echeckType,
                        self.checkNumber];
    return output;
                        
}

- (NSString *) stringOfXMLRequest {
    NSString *s = [NSString stringWithFormat:@""
                   @"<bankAccount>"
                        @"%@"       //accountType
                        @"%@"       //routingNumber
                        @"%@"       //accountNumber
                        @"%@"       //nameOnAccount
                        @"%@"       //echeckType
                        @"%@"       //checkNumber
                   @"</bankAccount>",
                   [NSString stringWithXMLTag:@"accountType" andValue:self.accountType],
                   [NSString stringWithXMLTag:@"routingNumber" andValue:self.routingNumber],
                   [NSString stringWithXMLTag:@"accountNumber" andValue:self.accountNumber],
                   [NSString stringWithXMLTag:@"nameOnAccount" andValue:self.nameOnAccount],
                   [NSString stringWithXMLTag:@"echeckType" andValue:self.echeckType],
                   [NSString stringWithXMLTag:@"checkNumber" andValue:self.checkNumber]];
    return s;
}


@end
