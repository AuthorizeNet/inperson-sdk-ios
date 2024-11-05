//
//  CreateTransactionResponse.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 1/17/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthNetResponse.h"
#import "GDataXMLNode.h"
#import "TransactionResponse.h"

/**
 * Enumeration of the response code
 */
typedef enum AuthNetAIMResponseCode{
	APPROVED = 1,
	DECLINED = 2,
	ERROR = 3,
	FRAUD_REVIEW = 4,
}AUTHNET_RESPONSE_CODE;

@interface CreateTransactionResponse : AuthNetResponse {

	TransactionResponse *transactionResponse;
    NSString *sessionToken;
}

@property (nonatomic, strong) TransactionResponse *transactionResponse;
@property (nonatomic, strong) NSString *sessionToken;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (CreateTransactionResponse *) createTransactionResponse;

/**
 * Class method that takes in NSData and returns a fully parsed
 * LogoutResponse.  If the method was not able to parse the response,
 * a nil object is returned.
 * @return The parsed LogoutResponse from parsing the NSData or nil if unable
 * to parse the data.
 */
+ (CreateTransactionResponse *)parseCreateTransactionResponse:(NSData *)xmlData;

// For unit testing.
+ (CreateTransactionResponse *)loadCreateTransactionResponseFromFilename:(NSString *)filename;

    
@end
