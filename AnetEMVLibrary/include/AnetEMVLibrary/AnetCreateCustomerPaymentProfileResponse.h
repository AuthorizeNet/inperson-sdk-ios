//
//  AnetCreateCustomerPaymentProfileResponse.h
//  AnetEMVSdk
//
//  Created by Manjappa, Chinthan on 8/2/18.
//  Copyright © 2018 Pankaj Taneja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Messages.h"
#import "AuthNetResponse.h"

@interface AnetCreateCustomerPaymentProfileResponse : AuthNetResponse 

@property (nonatomic, strong) NSString *refId;
@property (nonatomic, strong) Messages *messages;
@property (nonatomic, strong) NSString *customerPaymentProfileId;
@property (nonatomic, strong) NSString *validationDirectResponse;
@property (nonatomic, strong) NSString *defaultPaymentProfile;
@property (atomic, assign) BOOL isSuccessful;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (AnetCreateCustomerPaymentProfileResponse *) transactionResponse;

/**
 * CreateCustomerPaymentProfileResponse from parsing the XML response indexed by GDataXMLElement
 * @return CreateCustomerPaymentProfileResponse autorelease instance of the parser generated object.
 */
+ (AnetCreateCustomerPaymentProfileResponse *) buildTransactionResponse:(NSData *)xmlData;
+ (AnetCreateCustomerPaymentProfileResponse *)loadResponseFromFilename:(NSString *)filename;

@end
