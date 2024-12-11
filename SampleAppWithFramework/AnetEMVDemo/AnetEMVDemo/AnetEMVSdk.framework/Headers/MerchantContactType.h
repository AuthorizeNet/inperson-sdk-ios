//
//  MerchantContactType.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface MerchantContactType : NSObject {
	NSString *merchantName;
	NSString *merchantAddress;
	NSString *merchantCity;
	NSString *merchantState;
	NSString *merchantZip;
	NSString *merchantPhone;
}

@property (nonatomic, strong) NSString *merchantName;
@property (nonatomic, strong) NSString *merchantAddress;
@property (nonatomic, strong) NSString *merchantCity;
@property (nonatomic, strong) NSString *merchantState;
@property (nonatomic, strong) NSString *merchantZip;
@property (nonatomic, strong) NSString *merchantPhone;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (MerchantContactType *) merchantContact;

/**
 * MerchantContactType from parsing the XML response indexed by GDataXMLElement
 * @return MerchantContactType autorelease instance of the parser generated object.
 */
+ (MerchantContactType *) buildMerchantContact:(GDataXMLElement *)element;
@end
