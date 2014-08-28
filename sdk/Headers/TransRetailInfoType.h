//
//  TransRetailInfoType.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/23/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TransRetailInfoType : NSObject {
    NSString *marketType;
    NSString *deviceType;
}

@property (nonatomic, strong) NSString *marketType;
@property (nonatomic, strong) NSString *deviceType;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (TransRetailInfoType *) transRetailInfoType;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *)stringOfXMLRequest;
@end
