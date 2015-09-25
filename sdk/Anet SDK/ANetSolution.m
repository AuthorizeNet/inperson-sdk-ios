//
//  ANetSolution.m
//  Anet SDK
//
//  Created by Senthil Kumar Periyasamy on 7/28/15.
//  Copyright (c) 2015 MMA. All rights reserved.
//

#import "ANetSolution.h"
#import <UIKit/UIDevice.h>

@implementation ANetSolution

 + (ANetSolution *) sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        if (_sharedObject == nil) {
            _sharedObject = [[ANetSolution alloc] init];
        }
    });
    return _sharedObject;
}


- (id) init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}


- (NSString *)anetSolutionID {
    if ([self.delegate respondsToSelector:@selector(solutionID)]) {
        return [self.delegate solutionID];
    } else {
        return @"A1000025";
    }
}

@end
