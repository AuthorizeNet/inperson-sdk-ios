//
//  AuthNet+CustomerProfile.h
//  AnetEMVSdk
//
//  Created by Manjappa, Chinthan on 8/6/18.
//  Copyright © 2018 Pankaj Taneja. All rights reserved.
//

#import <AnetEMVSdk/AnetEMVSdk.h>

@interface AuthNet (CustomerProfile)

- (void) createCustomerProfileTransactionRequest:(AnetCreateCustomerProfileFromTransactionRequest *) r;

- (void) updateCustomerProfileRequest:(AnetUpdateCustomerProfileRequest *) r;

- (void) createCustomerPaymentProfileRequest:(AnetCreateCustomerPaymentProfileRequest *) r;

- (void) updateCustomerPaymentProfileRequest:(AnetUpdateCustomerPaymentProfileRequest *) r;

- (void) getCustomerPaymentProfileRequest:(AnetGetCustomerPaymentProfileRequest *) r;

- (void) getCustomerProfileRequest:(AnetGetCustomerProfileRequest *) r;

@end
