//
//  FDSFilterType.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 12/13/10.
//  Copyright 2010 none. All rights reserved.
//

#import "FDSFilterType.h"


@implementation FDSFilterType

@synthesize name;
@synthesize action;

+ (FDSFilterType *) fdsFilter {
    FDSFilterType *f = [[FDSFilterType alloc] init];
    return f;
}

- (id) init {
    self = [super init];
	if (self) {
        self.name = nil;
        self.action = nil;        
	}
	return self;
}

- (NSString *) description {
	
	NSString *output = [NSString stringWithFormat:@""
						"FDSFilter.name = %@\n"
						"FDSFilter.action = %@\n",
						self.name,
						self.action];
	return output;
}
@end
