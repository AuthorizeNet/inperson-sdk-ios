//
//  AnetGetCustomerProfileResponse.h
//  AnetEMVSdk
//
//  Created by Manjappa, Chinthan on 9/4/18.
//  Copyright © 2018 Pankaj Taneja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Messages.h"
#import "AuthNetResponse.h"
#import "CustomerProfileInfoExType.h"

@interface AnetGetCustomerProfileResponse : AuthNetResponse

@property (nonatomic, strong) NSString *refId;
@property (nonatomic, strong) Messages *messages;
@property (nonatomic, strong) CustomerProfileInfoExType *profile;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (AnetGetCustomerProfileResponse *) transactionResponse;

/**
 * GetCustomerPaymentProfileResponse from parsing the XML response indexed by GDataXMLElement
 * @return GetCustomerPaymentProfileResponse autorelease instance of the parser generated object.
 */
+ (AnetGetCustomerProfileResponse *) buildTransactionResponse:(NSData *)xmlData;
+ (AnetGetCustomerProfileResponse *)loadResponseFromFilename:(NSString *)filename;

@end
