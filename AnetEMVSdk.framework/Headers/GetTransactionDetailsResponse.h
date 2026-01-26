//
//  GetTransactionDetailsResponse.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 12/13/10.
//  Copyright 2010 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthNetResponse.h"
#import "TransactionDetailsType.h"

@interface GetTransactionDetailsResponse : AuthNetResponse {
    TransactionDetailsType *transactionDetails;
}

@property (nonatomic, strong) TransactionDetailsType *transactionDetails;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (GetTransactionDetailsResponse *) getTransactionDetailsResponse;

/**
 * Class method that takes in NSData and returns a fully parsed
 * GetTransactionDetailsResponse.  If the method was not able to parse the response,
 * a nil object is returned.
 * @return The parsed GetTransactionDetailsResponse from parsing the NSData or nil if unable
 * to parse the data.
 */
+ (GetTransactionDetailsResponse *)parseTransactionDetail:(NSData *)xmlData;

// For unit testing.
+ (GetTransactionDetailsResponse *)loadTransactionDetailFromFilename:(NSString *)filename;

@end
