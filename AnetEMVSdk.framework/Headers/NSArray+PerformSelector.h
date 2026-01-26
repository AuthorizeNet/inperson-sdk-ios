//
//  NSArray+PerformSelector.h
//  MobileMerchant
//
//  Created by Shiun Hwang on 11/10/10.
//  Copyright 2010 none. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (PerformSelector)

- (NSArray *)arrayByPerformingSelector:(SEL)selector;

@end

