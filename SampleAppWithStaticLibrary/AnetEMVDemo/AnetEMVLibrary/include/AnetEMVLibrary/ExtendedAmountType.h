//
//  ExtendedAmountType.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/21/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface ExtendedAmountType : NSObject {
    NSString *amount;
    NSString *name;
    NSString *amountDescription;
}

@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *amountDescription;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (ExtendedAmountType *) extendedAmountType;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *)stringOfXMLRequest;

/**
 * ExtendedAmountType from parsing the XML response indexed by GDataXMLElement
 * @return ExtendedAmountType autorelease instance of the parser generated object.
 */
+ (ExtendedAmountType *)buildExtendedAmountType:(GDataXMLElement *)element;
@end
