//
//  BGNetWorkMethod.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/3.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"



@interface BGAFN : NSObject

/**
 GET方式
 */
-(void)BGGet:(NSString *)URLString
parameters:(id)parameters
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 POST方式
 */
-(void)BGPost:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)loginWithName:(NSString*)uname password:(NSString*)password method:(NSString*)method
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)getmemberInfoWithID:(NSInteger)member_id method:(NSString*)method success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
-(void)requestWithValue:(NSString*)value forKey:(NSString*)key method:(NSString*)method success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 GET方式传入字典请求
 */
-(void)requestWithDict:(NSDictionary*)dict
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 POST方式传入字典请求
 */
-(void)PostRequestWithDict:(NSDictionary*)dict
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
