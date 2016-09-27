//
//  GetUnsettledTransactionListResponse.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/24/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthNetResponse.h"

/**
 * Response object that has pointers to each of the different objects
 * required in a GetUnsettledTransactionListResponse transaction.
 * NOTE: Consult Reporting XML Guide for the minimal fields required for each transaction type.
 */
@interface GetUnsettledTransactionListResponse : AuthNetResponse {
    NSMutableArray *transactions;
}

@property (nonatomic, strong) NSMutableArray *transactions;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (GetUnsettledTransactionListResponse *) getUnsettledTransactionListResponse;

/**
 * Class method that takes in NSData and returns a fully parsed
 * GetUnsettledTransactionListResponse.  If the method was not able to parse the response,
 * a nil object is returned.
 * @return The parsed GetUnsettledTransactionListResponse from parsing the NSData or nil if unable
 * to parse the data.
 */
+ (GetUnsettledTransactionListResponse *)parseGetUnsettledTransactionListResponse:(NSData *)xmlData;

// For unit testing.
+ (GetUnsettledTransactionListResponse *)loadGetUnsettledTransactionListResponseFromFilename:(NSString *)filename;
@end
