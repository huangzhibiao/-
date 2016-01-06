//
//  NSString+Md5String.h
//  Neptunus
//
//  Created by niuhenglei on 15/11/19.
//  Copyright © 2015年 niuhenglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Md5String)
+(NSString *) md5HexDigest:(NSString *)string;
@end
