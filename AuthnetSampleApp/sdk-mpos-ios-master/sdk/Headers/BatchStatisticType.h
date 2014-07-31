//
//  BatchStatisticType.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/21/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface BatchStatisticType : NSObject {
    NSString *accountType;
    NSString *chargeAmount;
    NSString *refundAmount;
    NSString *refundCount;
    NSString *voidCount;
    NSString *declineCount;
    NSString *errorCount;
    NSString *returnedItemAmount;
    NSString *returnedItemCount;
    NSString *chargebackAmount;
    NSString *chargebackCount;
    NSString *correctionNoticeCount;
    NSString *chargeChargeBackAmount;
    NSString *chargeChargeBackCount;
    NSString *refundChargeBackAmount;
    NSString *refundChargeBackCount;
    NSString *chargeReturnedItemsAmount;
    NSString *chargeReturnedItemsCount;
    NSString *refundReturnedItemsAmount;
    NSString *refundReturnedItemsCount;
}

@property (nonatomic, strong) NSString *accountType;
@property (nonatomic, strong) NSString *chargeAmount;
@property (nonatomic, strong) NSString *refundAmount;
@property (nonatomic, strong) NSString *refundCount;
@property (nonatomic, strong) NSString *voidCount;
@property (nonatomic, strong) NSString *declineCount;
@property (nonatomic, strong) NSString *errorCount;
@property (nonatomic, strong) NSString *returnedItemAmount;
@property (nonatomic, strong) NSString *returnedItemCount;
@property (nonatomic, strong) NSString *chargebackAmount;
@property (nonatomic, strong) NSString *chargebackCount;
@property (nonatomic, strong) NSString *correctionNoticeCount;
@property (nonatomic, strong) NSString *chargeChargeBackAmount;
@property (nonatomic, strong) NSString *chargeChargeBackCount;
@property (nonatomic, strong) NSString *refundChargeBackAmount;
@property (nonatomic, strong) NSString *refundChargeBackCount;
@property (nonatomic, strong) NSString *chargeReturnedItemsAmount;
@property (nonatomic, strong) NSString *chargeReturnedItemsCount;
@property (nonatomic, strong) NSString *refundReturnedItemsAmount;
@property (nonatomic, strong) NSString *refundReturnedItemsCount;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (BatchStatisticType *) batchStaticistic;

/**
 * Class method that takes in GDataXMLElement and returns a fully parsed
 * BatchStatisticType.  If the method was not able to parse the response,
 * a nil object is returned.
 * @return The parsed BatchStatisticType from parsing the GDataXMLElement or nil if unable
 * to parse the data.
 */
+ (BatchStatisticType *)buildBatchStatistics:(GDataXMLElement *)element;

@end
