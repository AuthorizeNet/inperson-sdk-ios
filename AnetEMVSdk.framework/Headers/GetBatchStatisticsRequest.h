//
//  GetBatchStatisticsRequest.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/25/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthNetRequest.h"

/**
 * Requst object that has pointers to each of the different objects
 * required in the reporting API getBatchStatisticsRequest transaction.
 * NOTE: Consult Reporting XML Guide for the minimal fields required the transaction.
 */
@interface GetBatchStatisticsRequest : AuthNetRequest {
    NSString *batchId;
}

@property (nonatomic, strong) NSString *batchId;

/**
 * Creates an autoreleased  object;
 * @return  an autoreleased  object.
 */
+ (GetBatchStatisticsRequest *) getBatchStatisticsRequest;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *) stringOfXMLRequest;

@end
