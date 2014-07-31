//
//  BatchDetailsType.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 12/13/10.
//  Copyright 2010 none. All rights reserved.
//

#import "BatchDetailsType.h"
#import "NSString+stringValueOfXMLElement.h"
#import "BatchStatisticType.h"

@implementation BatchDetailsType

@synthesize batchId;
@synthesize settlementTimeUTC;
@synthesize settlementTimeLocal;
@synthesize settlementState;
@synthesize paymentMethod;
@synthesize batchStatistics;

+ (BatchDetailsType *) batchDetails {
    BatchDetailsType *b = [[BatchDetailsType alloc] init];
    return b;
}

- (id) init {
    self = [super init];
	if (self) {
        self.batchId = nil;
        self.settlementTimeUTC = nil;
        self.settlementTimeLocal = nil;
        self.settlementState = nil;
        self.paymentMethod = nil;
        self.batchStatistics = [NSMutableArray array];
	}
	return self;
}

- (NSString *) description {
	
	NSString *output = [NSString stringWithFormat:@""
						"Batch.batchId = %@\n"
						"Batch.settlementTimeUTC = %@\n"
						"Batch.settlementTimeLocal = %@\n"
						"Batch.settlementState = %@\n"
						"Batch.paymentMethod = %@\n"
						"Batch.batchStatistics = %@\n",
						self.batchId,
						self.settlementTimeUTC,
						self.settlementTimeLocal,
						self.settlementState,
                        self.paymentMethod,
                        self.batchStatistics];
						
	return output;
}

- (void) addBatchStatistic: (BatchStatisticType *)b {
    [self.batchStatistics addObject:b];
}


+ (BatchDetailsType *)buildBatchDetails:(GDataXMLElement *)element {
    
	BatchDetailsType *b = [[BatchDetailsType alloc] init];
	
    
	b.batchId = [NSString stringValueOfXMLElement:element withName:@"batchId"];
	b.settlementTimeUTC = [NSString stringValueOfXMLElement:element withName:@"settlementTimeUTC"];
	b.settlementTimeLocal = [NSString stringValueOfXMLElement:element withName:@"settlementTimeLocal"];
	b.settlementState = [NSString stringValueOfXMLElement:element withName:@"settlementState"];
    b.paymentMethod = [NSString stringValueOfXMLElement:element withName:@"paymentMethod"];
    
    NSArray *currArray = [element elementsForName:@"statistic"];
    
	for (GDataXMLElement *s in currArray) {
		BatchStatisticType *bs = [BatchStatisticType buildBatchStatistics:s];
		[b.batchStatistics addObject:bs];
	}
    
    
	//Debug
	NSLog(@"BatchDetails: \n%@", b);
	
	return b;
}
@end
