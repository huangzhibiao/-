//
//  NSString+Md5SignString.m
//  Neptunus
//
//  Created by niuhenglei on 15/11/19.
//  Copyright © 2015年 niuhenglei. All rights reserved.
//

#import "NSString+Md5SignString.h"
#import "NSString+Md5String.h"
#import <ctype.h>
#import "global.h"

@implementation NSString (Md5SignString)

/**
 微信的sign加密
 */
+(NSString*)WXSign:(NSDictionary*)dict{
    
    NSMutableArray* arr = [[NSMutableArray alloc] initWithArray:[dict allKeys]];//@[@"ab",@"bc",@"hd",@"aa"];
    NSInteger length = arr.count;
    NSString* temp;
    for (int j = 0; j < length - 1; j++)
        for (int i = 0; i < length - 1 - j; i++)
        {
            NSString *one = arr[i];
            NSString* two = arr[i+1];
            if ([one compare:two]>0) {
                temp = arr[i];
                arr[i] = arr[i+1];
                arr[i+1] = temp;
            }
        }
    NSMutableString * append = [[NSMutableString alloc] init];
    for(int i=0;i<length;i++){
        if ([signKey isEqualToString:arr[i]]) {
            continue;
        }
        [append appendFormat:@"%@=%@&",arr[i],dict[arr[i]]];
    }
    //NSLog(@" --0--%@",append);
    [append appendFormat:@"key=%@",WXkey];
    //NSLog(@" --1--%@",append);
    //排序结束
    NSString* str = [NSString md5HexDigest:append].uppercaseString;//MD5加密后再转化为大写
    return  str;
}


/**
 sign加密
 */
+(NSString*)sign:(NSDictionary*)dict{
    
    NSMutableArray* arr = [[NSMutableArray alloc] initWithArray:[dict allKeys]];//@[@"ab",@"bc",@"hd",@"aa"];
    NSInteger length = arr.count;
    NSString* temp;
    for (int j = 0; j < length - 1; j++)
        for (int i = 0; i < length - 1 - j; i++)
        {
            NSString *one = arr[i];
            NSString* two = arr[i+1];
            if ([one compare:two]>0) {
                temp = arr[i];
                arr[i] = arr[i+1];
                arr[i+1] = temp;
            }
        }
    NSMutableString * append = [[NSMutableString alloc] init];
    for(int i=0;i<length;i++){
        if ([signKey isEqualToString:arr[i]]) {
            continue;
        }
        [append appendFormat:@"%@%@",arr[i],dict[arr[i]]];
    }
    //排序结束
    NSString* str = [NSString md5HexDigest:append].uppercaseString;//MD5加密后再转化为大写
    str = [NSString stringWithFormat:@"%@%@",str,token];//拼接token
    str = [NSString md5HexDigest:str];//MD5加密
    str = str.uppercaseString;
    return  str;
}
/**
 *  登陆密码加密
 */
+ (NSString *)md5SignStringWithPasswd:(NSString*)password uname:(NSString *)username createtime:(NSString *)createtime
{
    NSString * Allstr = [NSString stringWithFormat:@"%@%@%@",[NSString md5HexDigest:password],username,createtime];
    NSString* str = [NSString md5HexDigest:Allstr];
    NSString* sub = [str substringToIndex:31];
    NSString* data = [NSString stringWithFormat:@"s%@",sub];
    return data;
}
@end
