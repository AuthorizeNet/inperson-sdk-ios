//
//  ANetSolution.h
//  Anet SDK
//
//  Created by Senthil Kumar Periyasamy on 7/28/15.
//  Copyright (c) 2015 MMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AnetSolutionDelegate <NSObject>
- (NSString *)solutionID;
@end

@interface ANetSolution : NSObject

+ (ANetSolution *)sharedInstance;
- (NSString *)anetSolutionID;
@property (nonatomic, assign) id <AnetSolutionDelegate> delegate;
@end
