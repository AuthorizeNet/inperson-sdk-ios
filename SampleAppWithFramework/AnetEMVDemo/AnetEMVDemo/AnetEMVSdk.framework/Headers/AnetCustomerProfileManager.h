//
//  AnetProfileTransactionManager.h
//  AnetEMVSdk
//
//  Created by Manjappa, Chinthan on 7/27/18.
//  Copyright © 2018 Pankaj Taneja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AuthNet.h"
#import "AnetCreateCustomerProfileFromTransactionRequest.h"
#import "AnetUpdateCustomerProfileRequest.h"
#import "AnetCreateCustomerPaymentProfileRequest.h"
#import "AnetCustomerProfileTransactionResponse.h"
#import "AnetUpdateCustomerPaymentProfileRequest.h"
#import "AnetGetCustomerPaymentProfileRequest.h"
#import "AnetGetCustomerProfileRequest.h"

@class AnetCustomerProfileError;

//-----------------------------EVENTS BLOCK-----------------------------//
/**
 The completion handler, if provided, will be invoked on completion of Customer Profile request
 * @param response AnetCustomerProfileTransactionResponse response object
 */
typedef void (^CustomerProfileSuccessBlock) (id _Nullable response);
/**
 The completion handler, will be invoked on error of Customer Profile request
 * @param error AnetCustomerProfileError object
 */
typedef void (^FailureBlock) (AnetCustomerProfileError *_Nullable error);


@interface AnetCustomerProfileManager : NSObject<AuthNetDelegate>


+ (AnetCustomerProfileManager *_Nonnull)sharedInstance;

/**
 * Create a Customer Payment Profile.
 * @param iTransactionRequest and CustomerAddressType: A request object of AnetCreateCustomerProfileFromTransactionRequest
 AnetCustomerProfileManager will provide success and failure block.
 * @param iRequestCompletionBlock A completion block. Block will be executed on success with response object
 * @param iRequestFailureBlock A failure block. Block will be executed when request is failure with AnetCustomerProfileError object
 */
- (void)createCustomerProfileAndPaymentProfile:(NSString * _Nonnull)iTransactionId withMerchantAuthentication:(MerchantAuthenticationType *_Nonnull)iMerchant withCustomerProfile:(CustomerProfileBaseType *_Nonnull)iCustomerProfile withCustomerPaymentProfile:(CustomerPaymentProfileType *_Nonnull)iCustomerPaymentProfile successBlock:(CustomerProfileSuccessBlock _Nonnull)iRequestCompletionBlock failureBlock:(FailureBlock _Nonnull)iRequestFailureBlock;

/**
 * Create a Additional Payment Profile.
 * @param iProfileID CustomerAddressType iTransactionID: Profile ID, Transaction ID and AnetCustomerProfileManager will provide success and failure block.
 * @param iRequestCompletionBlock A completion block. Block will be executed on success with response object
 * @param iRequestFailureBlock A failure block. Block will be executed when request is failure with AnetCustomerProfileError object
 */
- (void)createAdditionalPaymentProfileWithProfileID:(NSString *_Nonnull)iProfileID withCustomerPaymentProfile:(CustomerPaymentProfileType *_Nonnull)iCustomerPaymentProfile withTransactionID:(NSString *_Nonnull)iTransactionID withMerchantAuthentication:(MerchantAuthenticationType *_Nonnull)iMerchant successBlock:(CustomerProfileSuccessBlock _Nonnull)iRequestCompletionBlock failureBlock:(FailureBlock _Nonnull)iRequestFailureBlock;

@end
