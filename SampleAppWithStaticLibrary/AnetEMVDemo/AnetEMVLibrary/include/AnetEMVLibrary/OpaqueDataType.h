//
//  OpaqueDataType.h
//  Anet SDK
//
//  Created by Authorize.Net on 25/06/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Opaque Data related information
 */

@interface OpaqueDataType : NSObject {
	NSString *dataDescriptor;
	NSString *dataValue;
}

@property (nonatomic, strong) NSString *dataDescriptor;
@property (nonatomic, strong) NSString *dataValue;

/**
 * Creates an autoreleased OpaqueDataType object;
 * @return FingerPrintObjectType an autoreleased OpaqueDataType object.
 */
+ (id) opaqueDataType;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *) stringOfXMLRequest;



@end
