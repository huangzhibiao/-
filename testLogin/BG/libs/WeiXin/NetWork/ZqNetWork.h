//
//  ZqNetWork.h
//  NetWork
//
//  Created by 周琦 on 15/10/15.
//  Copyright (c) 2015年 蓝鸥科技. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, DataReturnType) {
    DataReturnTypeData, /**< 返回Data数据*/
    DataReturnTypeXml,  /**< 返回XML数据 */
    DataReturnTypeJson  /**< 返回Json数据*/
};

typedef NS_ENUM(NSInteger, RequstBodyType) {
    RequstBodyTypeXml,  /**< XML格式 */
    RequstBodyTypeJson, /**< JSon格式*/
    RequstBodyTypeDictionaryToString, /**< 字典转字符串*/
    RequstBodyTypeString /**< 字符串*/
};

@interface ZqNetWork : NSObject


/**
 *  @brief GET请求
 *
 *  @param urlString      请求的url
 *  @param parameters     请求参数
 *  @param requestHead    请求头
 *  @param dataReturnType 请求数据类型
 *  @param successBlock   请求成功的回调
 *  @param failureBlock   请求失败的回调
 */
+ (void)getRequestWithURLString:(NSString *)urlString
                     Parameters:(id)parameters
                    RequestHead:(NSDictionary *)requestHead
                 DataReturnType:(DataReturnType) dataReturnType
                   SuccessBlock:(void (^)(NSData *data))successBlock
                   FailureBlock:(void (^)(NSError *error))failureBlock;

/**
 *  @brief POST请求
 *
 *  @param urlString       请求的url
 *  @param parameters      请求参数
 *  @param requestHead     请求头
 *  @param dataReturnType  请求数据类型
 *  @param requestBodyType 请求body的类型
 *  @param successBlock    请求成功的回调
 *  @param failureBlock    请求失败的回调
 */
+ (void)postRequestWithURLString:(NSString *)urlString
                      Parameters:(id)parameters
                     RequestHead:(NSDictionary *)requestHead
                  DataReturnType:(DataReturnType) dataReturnType
                 RequestBodyType:(RequstBodyType)requestBodyType
                    SuccessBlock:(void (^)(NSData *data))successBlock
                    FailureBlock:(void (^)(NSError *error))failureBlock;

/**
 *  @brief 网络判断
 *
 *  @return YES 有网 WIFI/WWAN  NO 无网络连接
 */

+ (BOOL)isNetWorkConnectionAvailable;

@end
