//
//  MerchantAccountType.h
//  MobileMerchant
//
//  Created by Rajesh T on 3/7/13.
//
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface MerchantAccountType : NSObject
{
NSString *marketType;
NSString *deviceType;
}

@property (nonatomic, strong) NSString *marketType;
@property (nonatomic, strong) NSString *deviceType;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (MerchantAccountType *) merchantAccount;

/**
 * MerchantAccountType from parsing the XML response indexed by GDataXMLElement
 * @return MerchantAccountType autorelease instance of the parser generated object.
 */
+ (MerchantAccountType *) buildMerchantAccount:(GDataXMLElement *)element;
@end

