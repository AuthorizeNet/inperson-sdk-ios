//
//  GetTransactionListResponse.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/24/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthNetResponse.h"
#import "TransactionSummaryType.h"

/**
 * Response object that has pointers to each of the different objects
 * required in a GetTransactionListResponse transaction.
 * NOTE: Consult Reporting XML Guide for the minimal fields required for each transaction type.
 */
@interface GetTransactionListResponse : AuthNetResponse {
    NSMutableArray *transactions;
}

@property (nonatomic, strong) NSMutableArray *transactions;

+ (GetTransactionListResponse *) getTransactionListResponse;

/**
 * Class method that takes in NSData and returns a fully parsed
 * GetTransactionListResponse.  If the method was not able to parse the response,
 * a nil object is returned.
 * @return The parsed GetTransactionListResponse from parsing the NSData or nil if unable
 * to parse the data.
 */
+ (GetTransactionListResponse *)parseGetTransactionListResponse:(NSData *)xmlData;

// For unit testing.
+ (GetTransactionListResponse *)loadGetTransactionListResponseFromFilename:(NSString *)filename;

@end
