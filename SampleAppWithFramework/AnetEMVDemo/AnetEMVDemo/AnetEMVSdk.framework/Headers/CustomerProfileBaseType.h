//
//  AnetCustomerProfile.h
//  AnetEMVSdk
//
//  Created by Manjappa, Chinthan on 7/27/18.
//  Copyright © 2018 Pankaj Taneja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerPaymentProfileType.h"

@interface CustomerProfileBaseType : NSObject<NSCoding>

@property (nonatomic, strong) NSString *merchantCustomerId;

@property (nonatomic, strong) NSString *desc;

@property (nonatomic, strong) NSString *email;

@property (nonatomic, strong) NSString *customerProfileId;

@property (nonatomic, strong) NSString *profileType;

@property (nonatomic, strong) CustomerPaymentProfileType *paymentProfiles;


+ (CustomerProfileBaseType *) customerProfileBaseType;

- (NSString *)stringOfXMLRequest;

@end
