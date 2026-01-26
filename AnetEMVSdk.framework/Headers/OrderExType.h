//
//  OrderExType.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/23/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderType.h"


@interface OrderExType : OrderType {
 	NSString *purchaseOrderNumber;   
}

@property (nonatomic, strong) NSString *purchaseOrderNumber;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (OrderExType *) orderExType;

@end
