//
//  GetSettledBatchListResponse.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/24/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthNetResponse.h"

/**
 * Response object that has pointers to each of the different objects
 * required in a GetSettledBatchListResponse transaction.
 * NOTE: Consult Reporting XML Guide for the minimal fields required for each transaction type.
 */
@interface GetSettledBatchListResponse : AuthNetResponse {
    NSMutableArray *batchList;
}

@property (nonatomic, strong) NSMutableArray *batchList;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (GetSettledBatchListResponse *) getSettledBatchListResponse;

/**
 * Class method that takes in NSData and returns a fully parsed
 * GetSettledBatchListResponse.  If the method was not able to parse the response,
 * a nil object is returned.
 * @return The parsed GetSettledBatchListResponse from parsing the NSData or nil if unable
 * to parse the data.
 */
+ (GetSettledBatchListResponse *)parseGetSettledBatchListResponse:(NSData *)xmlData;

// For unit testing.
+ (GetSettledBatchListResponse *)loadGetSettledBatchListResponseFromFilename:(NSString *)filename;
@end
