//
//  PaymentType.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/23/11.
//  Copyright 2011 none. All rights reserved.
//

#import "PaymentType.h"
#import "NSString+stringWithXMLTag.h"


@implementation PaymentType

@synthesize creditCard;
@synthesize bankAccount;
@synthesize trackData;
@synthesize swiperData;
@synthesize opData;

+ (PaymentType *) paymentType {
    PaymentType *p = [[PaymentType alloc] init];
    return p;
}

- (id) init {
    self = [super init];
    if (self) {
        self.creditCard = [CreditCardType creditCardType];
        self.bankAccount = [BankAccountType bankAccountType];
        self.trackData = [CreditCardTrackType creditCardTrackType];
        self.swiperData = [SwiperDataType swiperDataType];
        self.opData = [OpaqueDataType opDataType];
    }
    return self;
}

- (NSString *) description {
    NSString *output = [NSString stringWithFormat:@""
                        @"self.creditCard = %@"
                        @"self.bankAccount = %@"
                        @"self.trackData = %@"
                        @"self.swiperData = %@"
                        @"self.opData = %@",
                        self.creditCard,
                        self.bankAccount,
                        self.trackData,
                        self.swiperData,
                        self.opData];
    return output;
}

- (NSString *) stringOfXMLRequest {
    
    //TODO fix this.
    if (creditCard.cardNumber) {
        self.bankAccount = nil;
        self.trackData = nil;
        self.swiperData = nil;
        self.opData = nil;
    } 
    else if (bankAccount.accountNumber) {
        self.creditCard = nil;
        self.trackData = nil;
        self.swiperData = nil;
        self.opData = nil;
    }
    else if (trackData.track1) {
        self.creditCard = nil;
        self.trackData = nil;
        self.swiperData = nil;
        self.opData = nil;
    }
    else if (swiperData.deviceDescription) {
        self.creditCard = nil;
        self.bankAccount = nil;
        self.trackData = nil;
        self.opData = nil;
    }
    else if (self.opData){
        self.creditCard = nil;
        self.bankAccount = nil;
        self.trackData = nil;
        self.swiperData = nil;
    }
    
    NSString *s = [NSString stringWithFormat:@""
                   @"<payment>"
                   @"%@"       //creditCard
                   @"%@"       //bankAccount
                   @"%@"       //trackData
                   @"%@"       //swiperData
                   @"%@"       //opaqueData
                   @"</payment>",
                   (self.creditCard ? [self.creditCard stringOfXMLRequest] : @""),
                   (self.bankAccount ? [self.bankAccount stringOfXMLRequest] : @""),
                   (self.trackData ? [self.trackData stringOfXMLRequest] : @""),
                   (self.swiperData ? [self.swiperData stringOfXMLRequest] : @""),
                   (self.opData ? [self.opData stringOfXMLRequest] : @"")];
    return s;
}
@end
