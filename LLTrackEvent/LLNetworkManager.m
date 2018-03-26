//
//  LLNetworkManager.m
//  LLTrackEventSDK
//
//  Created by admin on 2018/3/19.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "LLNetworkManager.h"
#import "AFNetworking.h"


@interface LLNetworkManager ()

@property (nonatomic,strong) AFHTTPSessionManager *manager;

@end

@implementation LLNetworkManager

+ (LLNetworkManager *)sharedNetWorkManager
{
    static LLNetworkManager *sharedNetWorkManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedNetWorkManagerInstance = [[self alloc] init];
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        //         [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        manager.responseSerializer=[AFJSONResponseSerializer serializer];
        manager.responseSerializer=[AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain", nil];
        manager.securityPolicy.allowInvalidCertificates=NO;//是否验证证书
        manager.securityPolicy.validatesDomainName=NO; //是否验证域名
        
        sharedNetWorkManagerInstance.manager=manager;
    });
    return sharedNetWorkManagerInstance;
}


-(void)GETWithURL:(NSString *)strURL parameters:(id)parameters success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure
{
  
//    [_manager.requestSerializer setValue:model.token forHTTPHeaderField:@"token"];
    _manager.requestSerializer.timeoutInterval = 20;
  
    [_manager GET:strURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
      
        success(dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSDictionary *dic=error.userInfo;
        if (dic!=nil||![dic isEqual:[NSNull null]]) {
            NSString *failureReson;
            if (dic[@"NSLocalizedDescription"]!=nil) {
                failureReson=dic[@"NSLocalizedDescription"];
            }else{
                failureReson =@"服务器异常";
            }
            failure(failureReson);
        }
        
    }];
}



- (void)POSTWithURL:(NSString *)strURL parameters:(id)parameters success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure {
    
//    [_manager.requestSerializer setValue:model.token forHTTPHeaderField:@"token"];
    
    _manager.requestSerializer.timeoutInterval = 20;
  
    [_manager POST:strURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        success(dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSDictionary *dic=error.userInfo;
        if (dic!=nil||![dic isEqual:[NSNull null]]) {
            NSString *failureReson;
            if (dic[@"NSLocalizedDescription"]!=nil) {
                failureReson=dic[@"NSLocalizedDescription"];
            }else{
                failureReson =@"服务器异常";
            }
            failure(failureReson);
        }
        
    }];
    
}

@end
