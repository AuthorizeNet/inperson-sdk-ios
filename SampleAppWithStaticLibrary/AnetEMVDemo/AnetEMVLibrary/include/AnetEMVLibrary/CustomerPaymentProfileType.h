//
//  PaymentProfileType.h
//  AnetEMVSdk
//
//  Created by Manjappa, Chinthan on 8/2/18.
//  Copyright © 2018 Pankaj Taneja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerAddressType.h"
#import "PaymentMaskedType.h"

@interface CustomerPaymentProfileType : NSObject<NSCoding>

@property (nonatomic, strong) NSString *customerType;
@property (nonatomic, strong) CustomerAddressType *billTo;
@property (nonatomic, strong) PaymentMaskedType *payment;
@property (atomic, assign) BOOL defaultPaymentProfile;
@property (nonatomic, strong) NSString *customerPaymentProfileId;

+ (CustomerPaymentProfileType *) customerPaymentProfileType;

- (NSString *)stringOfXMLRequest;

+ (CustomerPaymentProfileType *) buildCustomerPaymentProfile:(GDataXMLElement *)element;

@end
