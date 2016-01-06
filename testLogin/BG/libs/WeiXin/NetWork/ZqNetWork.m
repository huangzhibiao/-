//
//  ZqNetWork.m
//  NetWork
//
//  Created by 周琦 on 15/10/15.
//  Copyright (c) 2015年 蓝鸥科技. All rights reserved.
//

#import "ZqNetWork.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation ZqNetWork


+ (void)getRequestWithURLString:(NSString *)urlString
                     Parameters:(id)parameters
                    RequestHead:(NSDictionary *)requestHead
                 DataReturnType:(DataReturnType) dataReturnType
                   SuccessBlock:(void (^)(NSData *data))successBlock
                   FailureBlock:(void (^)(NSError *error))failureBlock
{
    // 有网
    if ([self isNetWorkConnectionAvailable]) {
        // 获得请求管理者
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        // 支持https
        manager.securityPolicy.allowInvalidCertificates = YES;
        
        // 状态栏加载指示器
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        
        // 网络数据形式
        switch (dataReturnType) {
            case DataReturnTypeData: {
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                break;
            }
            case DataReturnTypeXml: {
                manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
                break;
            }
            case DataReturnTypeJson: {
                manager.responseSerializer = [AFJSONResponseSerializer serializer];
                break;
            }
            default: {
                break;
            }
        }
        // 响应数据支持的类型
        [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain", @"application/x-javascript", @"application/javascript", nil]];
        
        // url转码
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        // 如果有请求头,添加请求头
        if (requestHead) {
            for (NSString *key in requestHead) {
                [manager.requestSerializer setValue:[requestHead objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        // 请求数据
        [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            successBlock(operation.responseData);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failureBlock(error);
            
            
        }];
    } else {
        NSLog(@"无网络连接!");
    }
}


+ (void)postRequestWithURLString:(NSString *)urlString
                      Parameters:(id)parameters
                     RequestHead:(NSDictionary *)requestHead
                  DataReturnType:(DataReturnType) dataReturnType
                 RequestBodyType:(RequstBodyType)requestBodyType
                    SuccessBlock:(void (^)(NSData *data))successBlock
                    FailureBlock:(void (^)(NSError *error))failureBlock
{
    // 有网
    if ([self isNetWorkConnectionAvailable]) {
        // 获得请求管理者
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        // 支持https
        manager.securityPolicy.allowInvalidCertificates = YES;
        
        // 开启状态栏加载指示器
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        
        // 上传数据时body的类型
        switch (requestBodyType) {
            case RequstBodyTypeString:
                // 保持字符串样式
                [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, id parameters, NSError *__autoreleasing *error) {
                    return parameters;
                }];
                break;
            case RequstBodyTypeDictionaryToString:
                break;
            case RequstBodyTypeJson:
                // 保持JSON格式
                manager.requestSerializer = [AFJSONRequestSerializer serializer];
                break;
            case RequstBodyTypeXml:
                manager.requestSerializer = [AFPropertyListRequestSerializer serializer];
                break;
            default:
                break;
        }
        // 网络数据形式
        switch (dataReturnType) {
            case DataReturnTypeData: {
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                break;
            }
            case DataReturnTypeXml: {
                manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
                break;
            }
            case DataReturnTypeJson: {
                manager.responseSerializer = [AFJSONResponseSerializer serializer];
                break;
            }
            default: {
                break;
            }
        }
        // 响应数据支持的类型
        [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain", @"application/x-javascript", @"application/javascript", nil]];
        
        // url转码
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        // 如果有请求头,添加请求头
        if (requestHead) {
            for (NSString *key in requestHead) {
                [manager.requestSerializer setValue:[requestHead objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        // 请求数据
        [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            successBlock(operation.responseData);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failureBlock(error);
        }];
    } else {
        NSLog(@"无网络连接!");
    }
    
}

/**
 *  @brief 网络判断
 *
 *  @return YES 有网 WIFI/WWAN  NO 无网络连接
 */

+ (BOOL)isNetWorkConnectionAvailable
{
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    return isExistenceNetwork;
}










@end
