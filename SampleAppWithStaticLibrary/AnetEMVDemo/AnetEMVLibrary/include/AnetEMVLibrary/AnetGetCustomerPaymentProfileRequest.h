//
//  AnetGetCustomerPaymentProfile.h
//  AnetEMVSdk
//
//  Created by Manjappa, Chinthan on 8/16/18.
//  Copyright © 2018 Pankaj Taneja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthNetRequest.h"

@interface AnetGetCustomerPaymentProfileRequest : AuthNetRequest

@property (nonatomic, strong) NSString *refID;
@property (nonatomic, strong) NSString *customerProfileId;
@property (nonatomic, strong) NSString *customerPaymentProfileId;
@property (atomic, assign) BOOL unmaskExpirationDate;
@property (atomic, assign) BOOL includeIssuerInfo;

+ (AnetGetCustomerPaymentProfileRequest *) getRequest;


@end
