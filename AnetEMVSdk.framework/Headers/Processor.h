//
//  Processor.h
//  AnetEMVSdk
//
//  Created by Taneja, Pankaj on 7/5/17.
//  Copyright © 2017 Pankaj Taneja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface Processor : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSMutableArray *cardTypes;

+ (Processor *)buildProcessor:(GDataXMLElement *)element;

@end
