//
//  OrderExType.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/23/11.
//  Copyright 2011 none. All rights reserved.
//

#import "OrderExType.h"


@implementation OrderExType

@synthesize purchaseOrderNumber;

+ (OrderExType *) orderExType {
    OrderExType *o = [[OrderExType alloc] init];
    return o;
}

- (id) init {
    self = [super init];
    if (self) {
        self.purchaseOrderNumber = nil;
    }
    return self;
}

- (NSString *) description {
    NSString *output = [NSString stringWithFormat:@""
                        @"OrderExType super = %@"
                        @"OrderExType.purchaseOrderNumber = %@",
                        [super description],
                        self.purchaseOrderNumber];
    return output;
}

@end
