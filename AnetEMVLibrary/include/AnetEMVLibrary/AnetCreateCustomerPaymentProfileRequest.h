//
//  AnetCreateCustomerPaymentProfileRequest.h
//  AnetEMVSdk
//
//  Created by Manjappa, Chinthan on 8/1/18.
//  Copyright © 2018 Pankaj Taneja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerDataType.h"
#import "AuthNetRequest.h"
#import "CustomerPaymentProfileType.h"

@interface AnetCreateCustomerPaymentProfileRequest :  AuthNetRequest 

@property (nonatomic, strong) NSString *refID;
@property (nonatomic, strong) NSString *customerProfileId;
@property (nonatomic, strong) CustomerPaymentProfileType *profile;
@property (nonatomic, strong) NSString *transactionProfileId;
@property (nonatomic, strong) NSString *validationMode;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (AnetCreateCustomerPaymentProfileRequest *) transactionRequest;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *)stringOfXMLRequest;



@end
