//
//  MarketType.h
//  AnetEMVSdk
//
//  Created by Taneja, Pankaj on 7/5/17.
//  Copyright © 2017 Pankaj Taneja. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarketType : NSObject
@property (nonatomic, strong) NSString *value;
+ (MarketType *)marketType;
@end
