//
//  NSString+Md5SignString.h
//  Neptunus
//
//  Created by niuhenglei on 15/11/19.
//  Copyright © 2015年 niuhenglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Md5SignString)

/*
 微信的sign加密
 */
+(NSString*)WXSign:(NSDictionary*)dict;
/**
 自己的后台sign加密
 */
+(NSString*)sign:(NSDictionary*)dict;

/**
 *  public function extends_md5($source_str,$username,$createtime){
 
 
 
 $string_md5 = md5(md5($source_str).$username.$createtime);
 $front_string = substr($string_md5,0,31);
 $end_string = 's'.$front_string;
 return $end_string;
 }
 */
/**
 *  登陆密码加密
 */
+ (NSString *)md5SignStringWithPasswd:(NSString*)password uname:(NSString *)username createtime:(NSString *)createtime;

@end

