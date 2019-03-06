//
//  AnetGetCustomerPaymentProfileResponse.h
//  AnetEMVSdk
//
//  Created by Manjappa, Chinthan on 8/16/18.
//  Copyright © 2018 Pankaj Taneja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Messages.h"
#import "AuthNetResponse.h"
#import "CustomerPaymentProfileType.h"

@interface AnetGetCustomerPaymentProfileResponse : AuthNetResponse

@property (nonatomic, strong) NSString *refId;
@property (nonatomic, strong) Messages *messages;
@property (nonatomic, strong) CustomerPaymentProfileType *paymentProfile;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (AnetGetCustomerPaymentProfileResponse *) transactionResponse;

/**
 * GetCustomerPaymentProfileResponse from parsing the XML response indexed by GDataXMLElement
 * @return GetCustomerPaymentProfileResponse autorelease instance of the parser generated object.
 */
+ (AnetGetCustomerPaymentProfileResponse *) buildTransactionResponse:(NSData *)xmlData;
+ (AnetGetCustomerPaymentProfileResponse *)loadResponseFromFilename:(NSString *)filename;

@end
