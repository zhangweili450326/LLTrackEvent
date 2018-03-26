//
//  LLNetworkManager.h
//  LLTrackEventSDK
//
//  Created by admin on 2018/3/19.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLNetworkManager : NSObject

+ (LLNetworkManager *)sharedNetWorkManager;

-(void)GETWithURL:(NSString *)strURL
       parameters:(id)parameters
          success:(void (^)(NSDictionary *dit))success
          failure:(void (^)( NSString *error))failure;

- (void)POSTWithURL:(NSString *)strURL
         parameters:(id)parameters
            success:(void (^)(NSDictionary *dit))success
            failure:(void (^)( NSString *error))failure;

@end
