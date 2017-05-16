//
//  ZZHttpTool.m
//  企业教室
//
//  Created by APP on 14-7-10.
//  Copyright (c) 2014年 ZZDL. All rights reserved.
//

#import "ZZHttpTool.h"
#import "AFNetworking.h"


@implementation ZZHttpTool
{
//    AFHTTPSessionManager *mgr;
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建请求管理对象
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"*.orenda.com.cn 1" ofType:@".cer"];
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    NSSet *cerSet = [NSSet setWithObjects:cerData, nil];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = YES;
    [securityPolicy setPinnedCertificates:cerSet];
    mgr.securityPolicy = securityPolicy;
    [self setHttpHeaderFileFor:mgr];
    mgr.securityPolicy.allowInvalidCertificates = YES;
    [securityPolicy setAllowInvalidCertificates:YES];
    mgr.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    mgr.securityPolicy.allowInvalidCertificates = YES;
    [mgr.securityPolicy setValidatesDomainName:NO];
    mgr.requestSerializer.timeoutInterval = 65;
    if ([[AppDelegate networkStatus]isEqualToString:@"unicom"]) {
        mgr.requestSerializer.timeoutInterval = 0;
    }
    else
    {
        mgr.requestSerializer.timeoutInterval = 10;
    }
    /**设置相应的缓存策略*/
//    mgr.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    //这里进行设置；
    [mgr setSecurityPolicy:securityPolicy];
     mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableSet *contentTypes = [NSMutableSet setWithSet:((AFHTTPResponseSerializer *)mgr.responseSerializer).acceptableContentTypes];
    [contentTypes addObject:@"text/plain"];
    [contentTypes addObject:@"text/html"];
    [contentTypes addObject:@"text/json"];
    ((AFHTTPResponseSerializer *)mgr.responseSerializer).acceptableContentTypes = contentTypes;
    
    // 2.发送请求
    [mgr POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);

        }
        NSLog(@"请求成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        NSLog(@"请求失败");
        
    }];
}






+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 1.创建请求管理对象
    [self setHttpHeaderFileFor:mgr];
    mgr.requestSerializer.timeoutInterval = 65;
    
    NSMutableSet *contentTypes = [NSMutableSet setWithSet:((AFHTTPResponseSerializer *)mgr.responseSerializer).acceptableContentTypes];
    [contentTypes addObject:@"text/plain"];
    [contentTypes addObject:@"text/html"];
    [contentTypes addObject:@"text/json"];
    [contentTypes addObject:@"charset=utf-8"];
    ((AFHTTPResponseSerializer *)mgr.responseSerializer).acceptableContentTypes = contentTypes;
    mgr.requestSerializer.timeoutInterval = 30;
    // 2.发送请求
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (ZZFormData *formData1 in formDataArray) {
    [formData appendPartWithFileData:formData1.data name:formData1.name fileName:formData1.filename mimeType:formData1.mimeType];
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建请求管理对象
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"*.orenda.com.cn 1" ofType:@".cer"];
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    NSSet *cerSet = [NSSet setWithObjects:cerData, nil];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.securityPolicy.allowInvalidCertificates = YES;
    [self setHttpHeaderFileFor:mgr];
    mgr.requestSerializer.timeoutInterval = 65;
    mgr.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    mgr.securityPolicy.allowInvalidCertificates = YES;
    [mgr.securityPolicy setValidatesDomainName:NO];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = YES;
    [securityPolicy setPinnedCertificates:cerSet];
    mgr.securityPolicy = securityPolicy;

    NSMutableSet *contentTypes = [NSMutableSet setWithSet:((AFHTTPResponseSerializer *)mgr.responseSerializer).acceptableContentTypes];
    [contentTypes addObject:@"text/plain"];
    [contentTypes addObject:@"text/html"];
    [contentTypes addObject:@"text/json"];
    [contentTypes addObject:@"charset=utf-8"];
    ((AFHTTPResponseSerializer *)mgr.responseSerializer).acceptableContentTypes = contentTypes;
    
    mgr.requestSerializer.timeoutInterval = 30;
    // 2.发送请求
    [mgr GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)setHttpHeaderFileFor:(AFHTTPSessionManager *)mgr
{
    [mgr.requestSerializer setValue:k_imei forHTTPHeaderField:@"did"];
    [mgr.requestSerializer setValue:k_deviceId forHTTPHeaderField:@"deviceId"];
    [mgr.requestSerializer setValue:k_Apn forHTTPHeaderField:@"apn"];
    [mgr.requestSerializer setValue:k_NetworkType forHTTPHeaderField:@"net"];
    [mgr.requestSerializer setValue:k_latitude forHTTPHeaderField:@"lat"];
    [mgr.requestSerializer setValue:k_longitude forHTTPHeaderField:@"lon"];
    [mgr.requestSerializer setValue:k_ua forHTTPHeaderField:@"ua"];
    [mgr.requestSerializer setValue:k_os forHTTPHeaderField:@"os"];
    [mgr.requestSerializer setValue:k_osv forHTTPHeaderField:@"osv"];
    [mgr.requestSerializer setValue:k_ver forHTTPHeaderField:@"ver"];
    [mgr.requestSerializer setValue:k_brand forHTTPHeaderField:@"brand"];
    [mgr.requestSerializer setValue:k_channelId forHTTPHeaderField:@"channelId"];
    [mgr.requestSerializer setValue:k_r forHTTPHeaderField:@"r"];
    [mgr.requestSerializer setValue:k_platform forHTTPHeaderField:@"platform"];
    if ([Tool isBlankString:[Singleton sharedSingleton].userId]) {
        [mgr.requestSerializer setValue:@"0" forHTTPHeaderField:@"userId"];
        [mgr.requestSerializer setValue:@"" forHTTPHeaderField:@"lId"];
    }
    else{
        [mgr.requestSerializer setValue:[NSString stringWithFormat:@"%@",[Singleton sharedSingleton].userId] forHTTPHeaderField:@"userId"];
        [mgr.requestSerializer setValue:[NSString stringWithFormat:@"%@",[Singleton sharedSingleton].lId] forHTTPHeaderField:@"lId"];
    }
    

}

@end

/**
 *  用来封装文件数据的模型
 */
@implementation ZZFormData

@end
