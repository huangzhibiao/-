//
//  BGNetWorkMethod.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/3.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "BGAFN.h"
#import "global.h"
#import "NSString+Md5SignString.h"
#import "NSString+Md5String.h"

@interface BGAFN()

@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;

@end

@implementation BGAFN

-(AFHTTPRequestOperationManager *)manager{
    if (_manager == nil) {
        _manager = [AFHTTPRequestOperationManager manager];
        //申明请求的数据是json类型
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        //申明返回的结果是json类型
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        //_manager.requestSerializer.timeoutInterval = 15.0f;
    }
    return _manager;
}

/**
 GET方式
 */
-(void)BGGet:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    [self.manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
    
}

/**
 POST方式
 */
-(void)BGPost:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    [self.manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}
/**
 这里传入的method是获取密码密钥的
 */
-(void)loginWithName:(NSString*)uname password:(NSString*)password method:(NSString*)method
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[unameKey] = uname;
    dict[passwordKey] = password;
    dict[methodKey] = method;
    dict[signKey] = [NSString sign:dict];//加密
    [self BGGet:LoginUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"密码密钥-----------%@",responseObject);
        NSString* rsp = responseObject[rspKey];
        if ([rsp isEqualToString:fail]) {
            NSMutableDictionary* dictM = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
            NSDictionary* message = @{messageKey:@"用户名或密码错误",statusKey:@"false"};
            [dictM removeObjectForKey:dataKey];
            [dictM setValue:message forKey: dataKey];
            success(operation,dictM);
            return ;
        }
        NSDictionary *dataDict = responseObject[dataKey];
        [global intance].createtime = [dataDict objectForKey:createtimeKey];
        NSString *md5Password = [NSString md5SignStringWithPasswd:password uname:uname createtime:[global intance].createtime];
        dict[unameKey] = uname;
        dict[passwordKey] = md5Password;
        dict[methodKey] = signin;
        dict[signKey] = [NSString sign:dict];//加密
        //NSLog(@"登陆信息  －－ %@",dict);
        [self BGGet:LoginUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"登陆  －－ %@",responseObject[@"res"]);
            NSString* rsp = responseObject[rspKey];
            if ([rsp isEqualToString:fail]) {
                return ;
            }
            NSDictionary* dict = responseObject[dataKey];
            [global intance].message = (NSString*)[dict objectForKey:messageKey];
            [global intance].accesstoken = (NSString*)[dict objectForKey:accesstokenKey];
            [global intance].member_id = [[dict objectForKey:member_idKey] intValue];
            [global intance].status = [[dict objectForKey:statusKey] boolValue];
            success(operation,responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
            failure(operation,error);
        }];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error------%@",error);
    }];

}

/**
 获取根据会员member_id获取会员信息
 */
-(void)getmemberInfoWithID:(NSInteger)member_id method:(NSString*)method success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[member_idKey] = @(member_id);
    dict[accesstokenKey] = [global intance].accesstoken;
    dict[methodKey] = method;
    dict[signKey] = [NSString sign:dict];
    [self BGGet:LoginUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString* rsp = responseObject[rspKey];
        if ([rsp isEqualToString:fail]) {
            NSMutableDictionary* dictM = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
            NSDictionary* message = @{messageKey:@"操作错误",statusKey:@"false"};
            [dictM removeObjectForKey:dataKey];
            [dictM setValue:message forKey: dataKey];
            success(operation,dictM);
            return ;
        }
        
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(operation,error);
    }];
}
/**
 单个字符串参数请求
 */
-(void)requestWithValue:(NSString*)value forKey:(NSString*)key method:(NSString*)method success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[key] = value;
    dict[methodKey] = method;
    dict[signKey] = [NSString sign:dict];
    [self BGGet:LoginUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
       success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}
/**
 GET方式根据字典发送请求
 */
-(void)requestWithDict:(NSDictionary*)dict
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    [self BGGet:LoginUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* rsp = responseObject[rspKey];
        if ([rsp isEqualToString:fail]) {
            //NSLog(@"BGGet-----%@",responseObject);
            NSMutableDictionary* dictM = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
            NSDictionary* message = @{messageKey:@"操作错误",statusKey:@"false"};
            [dictM removeObjectForKey:dataKey];
            [dictM setValue:message forKey: dataKey];
            success(operation,dictM);
            return ;
        }
        
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}
/**
 POST方式传入字典请求
 */
-(void)PostRequestWithDict:(NSDictionary*)dict
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    [self BGPost:LoginUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"订单接口 -> %@",dict);
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}
@end
