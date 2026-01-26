//
//  FDSFilterType.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 12/13/10.
//  Copyright 2010 none. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FDSFilterType : NSObject {
	NSString *name;
	NSString *action;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *action;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (FDSFilterType *) fdsFilter;

@end
