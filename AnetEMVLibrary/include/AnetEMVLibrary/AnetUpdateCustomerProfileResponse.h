//
//  AnetUpdateCustomerProfileResponse.h
//  AnetEMVSdk
//
//  Created by Manjappa, Chinthan on 7/31/18.
//  Copyright © 2018 Pankaj Taneja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Messages.h"
#import "AuthNetResponse.h"

@interface AnetUpdateCustomerProfileResponse : AuthNetResponse

@property (nonatomic, strong) NSString *refId;
@property (nonatomic, strong) Messages *messages;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (AnetUpdateCustomerProfileResponse *) transactionResponse;

/**
 * UpdateCustomerProfileResponse from parsing the XML response indexed by GDataXMLElement
 * @return UpdateCustomerProfileResponse autorelease instance of the parser generated object.
 */
+ (AnetUpdateCustomerProfileResponse *) buildTransactionResponse:(NSData *)xmlData;
+ (AnetUpdateCustomerProfileResponse *)loadResponseFromFilename:(NSString *)filename;

@end
