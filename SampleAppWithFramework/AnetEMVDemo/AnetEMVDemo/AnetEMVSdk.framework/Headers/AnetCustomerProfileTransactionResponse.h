//
//  AnetCustomerProfileTransactionResponse.h
//  AnetEMVSdk
//
//  Created by Manjappa, Chinthan on 7/27/18.
//  Copyright © 2018 Pankaj Taneja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Messages.h"
#import "AuthNetResponse.h"

@interface AnetCustomerProfileTransactionResponse : AuthNetResponse

@property (nonatomic, strong) NSString *refId;
@property (nonatomic, strong) Messages *messages;
@property (nonatomic, strong) NSString *customerProfileId;
@property (nonatomic, strong) NSString *customerPaymentProfileIdList;
@property (nonatomic, strong) NSString *customerShippingAddressIdList;
@property (nonatomic, strong) NSString *validationDirectResponseList;
@property (atomic, assign) BOOL isTransactionSuccessful;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (AnetCustomerProfileTransactionResponse *) transactionResponse;

/**
 * TransactionResponse from parsing the XML response indexed by GDataXMLElement
 * @return TransactionResponse autorelease instance of the parser generated object.
 */
+ (AnetCustomerProfileTransactionResponse *) buildTransactionResponse:(NSData *)xmlData;
+ (AnetCustomerProfileTransactionResponse *)loadResponseFromFilename:(NSString *)filename;


@end
