//
//  NSString+dataFromFilename.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/25/11.
//  Copyright 2011 none. All rights reserved.
//

#import "NSString+dataFromFilename.h"


@implementation NSString (dataFromFilename)

+ (NSString *)dataFromFilename:(NSString *)filename {
	
	for (NSBundle *bundle in [NSBundle allBundles]) {
		if ([bundle bundleIdentifier] != nil) {
			return [bundle pathForResource:filename ofType:@"xml"];
		}
	}
	return nil;
}
@end
