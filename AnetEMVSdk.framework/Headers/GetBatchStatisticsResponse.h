//
//  GetBatchStatisticsResponse.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/25/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BatchDetailsType.h"
#import "AuthNetResponse.h"

/**
 * Response object that has pointers to each of the different objects
 * required in a GetBatchStatisticsResponse transaction.
 * NOTE: Consult Reporting XML Guide for the minimal fields required for each transaction type.
 */
@interface GetBatchStatisticsResponse : AuthNetResponse {
    BatchDetailsType *batch;
    
}

@property (nonatomic, strong) BatchDetailsType *batch;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (GetBatchStatisticsResponse *) getBatchStatisticsResponse;

/**
 * Class method that takes in NSData and returns a fully parsed
 * GetBatchStatisticsResponse.  If the method was not able to parse the response,
 * a nil object is returned.
 * @return The parsed GetBatchStatisticsResponse from parsing the NSData or nil if unable
 * to parse the data.
 */
+ (GetBatchStatisticsResponse *)parseGetBatchStatisticsResponse:(NSData *)xmlData;

/// For unit testing.
+ (GetBatchStatisticsResponse *)loadGetBatchStatisticsResponseFromFilename:(NSString *)filename;

@end
