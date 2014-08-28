//
//  NSArray+PerformSelector.m
//  MobileMerchant
//
//  Created by Shiun Hwang on 11/10/10.
//  Copyright 2010 none. All rights reserved.
//

#import "NSArray+PerformSelector.h"


@implementation NSArray (PerformSelector)

- (NSArray *)arrayByPerformingSelector:(SEL)selector {
    NSMutableArray * results = [NSMutableArray array];
	
    for (id object in self)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id result = [object performSelector:selector];
#pragma clang diagnostic pop
        [results addObject:result];
    }
    return results;
}

@end
