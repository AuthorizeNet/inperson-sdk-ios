//
//  AnetUpdateCustomerPaymentProfileResponse.h
//  AnetEMVSdk
//
//  Created by Manjappa, Chinthan on 8/14/18.
//  Copyright © 2018 Pankaj Taneja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Messages.h"
#import "AuthNetResponse.h"

@interface AnetUpdateCustomerPaymentProfileResponse : AuthNetResponse

@property (nonatomic, strong) NSString *refId;
@property (nonatomic, strong) Messages *messages;
@property (nonatomic, strong) NSString *customerPaymentProfileId;
@property (nonatomic, strong) NSString *validationDirectResponse;
@property (atomic, assign) BOOL isSuccessful;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (AnetUpdateCustomerPaymentProfileResponse *) transactionResponse;

/**
 * UpdateCustomerPaymentProfileResponse from parsing the XML response indexed by GDataXMLElement
 * @return UpdateCustomerPaymentProfileResponse autorelease instance of the parser generated object.
 */
+ (AnetUpdateCustomerPaymentProfileResponse *) buildTransactionResponse:(NSData *)xmlData;
+ (AnetUpdateCustomerPaymentProfileResponse *)loadResponseFromFilename:(NSString *)filename;

@end
