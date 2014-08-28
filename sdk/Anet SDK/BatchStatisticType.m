//
//  BatchStatisticType.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/21/11.
//  Copyright 2011 none. All rights reserved.
//

#import "BatchStatisticType.h"
#import "NSString+stringValueOfXMLElement.h"

@implementation BatchStatisticType

@synthesize accountType;
@synthesize chargeAmount;
@synthesize refundAmount;
@synthesize refundCount;
@synthesize voidCount;
@synthesize declineCount;
@synthesize errorCount;
@synthesize returnedItemAmount;
@synthesize returnedItemCount;
@synthesize chargebackAmount;
@synthesize chargebackCount;
@synthesize correctionNoticeCount;
@synthesize chargeChargeBackAmount;
@synthesize chargeChargeBackCount;
@synthesize refundChargeBackAmount;
@synthesize refundChargeBackCount;
@synthesize chargeReturnedItemsAmount;
@synthesize chargeReturnedItemsCount;
@synthesize refundReturnedItemsAmount;
@synthesize refundReturnedItemsCount;

+ (BatchStatisticType *) batchStaticistic {
    BatchStatisticType *b = [[BatchStatisticType alloc] init];
    return b;
}

- (id) init {
    self = [super init];
    if (self) {
        self.accountType = nil;
        self.chargeAmount = nil;
        self.refundAmount = nil;
        self.refundCount = nil;
        self.voidCount = nil;
        self.declineCount = nil;
        self.errorCount = nil;
        self.returnedItemAmount = nil;
        self.returnedItemCount = nil;
        self.chargebackAmount = nil;
        self.chargebackCount = nil;
        self.correctionNoticeCount = nil;
        self.chargeChargeBackAmount = nil;
        self.chargeChargeBackCount = nil;
        self.refundChargeBackAmount = nil;
        self.refundChargeBackCount = nil;
        self.chargeReturnedItemsAmount = nil;
        self.chargeReturnedItemsCount = nil;
        self.refundReturnedItemsAmount = nil;
        self.refundReturnedItemsCount = nil;
    }
    return self;
}

- (NSString *) description {
	
	NSString *output = [NSString stringWithFormat:@""
						"BatchStatistics.accountType = %@\n"
						"BatchStatistics.chargeAmount = %@\n"
						"BatchStatistics.refundAmount = %@\n"
						"BatchStatistics.refundCount = %@\n"
						"BatchStatistics.voidCount = %@\n"
						"BatchStatistics.declineCount = %@\n"
                        "BatchStatistics.errorCount = %@\n"
						"BatchStatistics.returnedItemAmount = %@\n"
						"BatchStatistics.returnedItemCount = %@\n"
						"BatchStatistics.chargebackAmount = %@\n"
						"BatchStatistics.chargebackCount = %@\n"
                        "BatchStatistics.correctionNoticeCount = %@\n"
						"BatchStatistics.chargeChargeBackAmount = %@\n"
						"BatchStatistics.chargeChargeBackCount = %@\n"
						"BatchStatistics.refundChargeBackAmount = %@\n"
						"BatchStatistics.refundChargeBackCount = %@\n"
                        "BatchStatistics.chargeReturnedItemsAmount = %@\n"
						"BatchStatistics.chargeReturnedItemsCount = %@\n"
						"BatchStatistics.refundReturnedItemsAmount = %@\n"
						"BatchStatistics.refundReturnedItemsCount = %@\n",
						self.accountType,
						self.chargeAmount,
						self.refundAmount,
						self.refundCount,
                        self.voidCount,
                        self.declineCount,
                        self.errorCount,
                        self.returnedItemAmount,
                        self.returnedItemCount,
                        self.chargebackAmount,
                        self.chargebackCount,
                        self.correctionNoticeCount,
                        self.chargeChargeBackAmount,
                        self.chargeChargeBackCount,
                        self.refundChargeBackAmount,
                        self.refundChargeBackCount,
                        self.chargeReturnedItemsAmount,
                        self.chargeReturnedItemsCount,
                        self.refundReturnedItemsAmount,
                        self.refundReturnedItemsCount];
    
	return output;
}


+ (BatchStatisticType *)buildBatchStatistics:(GDataXMLElement *)element {
    BatchStatisticType *bs = [BatchStatisticType batchStaticistic];
    bs.accountType = [NSString stringValueOfXMLElement:element withName:@"accountType"];
    bs.chargeAmount = [NSString stringValueOfXMLElement:element withName:@"chargeAmount"];
    bs.refundAmount = [NSString stringValueOfXMLElement:element withName:@"refundAmount"];
    bs.refundCount = [NSString stringValueOfXMLElement:element withName:@"refundCount"];
    bs.voidCount = [NSString stringValueOfXMLElement:element withName:@"voidCount"];
    bs.declineCount = [NSString stringValueOfXMLElement:element withName:@"declineCount"];
    bs.errorCount = [NSString stringValueOfXMLElement:element withName:@"errorCount"];
    bs.returnedItemAmount = [NSString stringValueOfXMLElement:element withName:@"returnedItemAmount"];
    bs.returnedItemCount = [NSString stringValueOfXMLElement:element withName:@"returnedItemCount"];
    bs.chargebackAmount = [NSString stringValueOfXMLElement:element withName:@"chargebackAmount"];
    bs.chargebackCount = [NSString stringValueOfXMLElement:element withName:@"chargebackCount"];
    bs.correctionNoticeCount = [NSString stringValueOfXMLElement:element withName:@"correctionNoticeCount"];
    bs.chargeChargeBackAmount = [NSString stringValueOfXMLElement:element withName:@"chargeChargeBackAmount"];
    bs.chargeChargeBackCount = [NSString stringValueOfXMLElement:element withName:@"chargeChargeBackCount"];
    bs.refundChargeBackAmount = [NSString stringValueOfXMLElement:element withName:@"refundChargeBackAmount"];
    bs.refundChargeBackCount = [NSString stringValueOfXMLElement:element withName:@"refundChargeBackCount"];
    bs.chargeReturnedItemsAmount = [NSString stringValueOfXMLElement:element withName:@"chargeReturnedItemsAmount"];
    bs.chargeReturnedItemsCount = [NSString stringValueOfXMLElement:element withName:@"chargeReturnedItemsCount"];
    bs.refundReturnedItemsAmount = [NSString stringValueOfXMLElement:element withName:@"refundReturnedItemsAmount"];
    bs.refundReturnedItemsCount = [NSString stringValueOfXMLElement:element withName:@"refundReturnedItemsCount"];
    return bs;
}
@end
