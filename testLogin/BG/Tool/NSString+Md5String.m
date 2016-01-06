//
//  NSString+Md5String.m
//  Neptunus
//
//  Created by niuhenglei on 15/11/19.
//  Copyright © 2015年 niuhenglei. All rights reserved.
//

#import "NSString+Md5String.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Md5String)


+(NSString *) md5HexDigest:(NSString *)string
{
    const char *original_str = [string UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(original_str, strlen(original_str), result);
    
    NSMutableString *hash = [NSMutableString string];
    
    for (int i = 0; i < 16; i++)
        
        [hash appendFormat:@"%02X", result[i]];
    
    return [hash lowercaseString];
}
@end
