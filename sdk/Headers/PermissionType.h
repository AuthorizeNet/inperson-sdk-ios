//
//  Permission.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface PermissionType : NSObject {
	NSString *permissionName;
}

@property (nonatomic, strong) NSString *permissionName;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (PermissionType *) permission;

/**
 * PermissionType from parsing the XML response indexed by GDataXMLElement
 * @return PermissionType autorelease instance of the parser generated object.
 */
+ (PermissionType *) buildPermission:(GDataXMLElement *)element;
@end
