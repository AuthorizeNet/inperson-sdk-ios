//
//  Permission.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import "PermissionType.h"
#import "NSString+stringValueOfXMLElement.h"

@implementation PermissionType
@synthesize permissionName;

+ (PermissionType *) permission {
	PermissionType *p = [[PermissionType alloc] init];
	return p;
}

- (id) init {
    self = [super init];
	if (self) {
		self.permissionName = nil;
	}
	return self;
}


- (NSString *) description {
	
	NSString *output = [NSString stringWithFormat:@""
						"Permission.permissionName = %@\n",
						self.permissionName];
	return output;
}


+ (PermissionType *) buildPermission:(GDataXMLElement *)element {
	PermissionType *p = [PermissionType permission];
    
	p.permissionName = [NSString stringValueOfXMLElement:element withName:@"permissionName"];
	
	return p;
}

@end
