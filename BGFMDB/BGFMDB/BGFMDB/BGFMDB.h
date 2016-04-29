//
//  BGFMDB.h
//  BGFMDB
//
//  Created by huangzhibiao on 16/4/28.
//  Copyright © 2016年 Biao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGFMDB : NSObject

/**
 获取单例函数
 */
+(instancetype)intance;
/** 
 数据库中是否存在表 
 */
- (BOOL)isExistWithTableName:(NSString*)name;
/**
 默认建立主键id
 创建表(如果存在久不创建) keys 数据存放要求@[字段名称1,字段名称2]
 */
-(BOOL)createTableWithTableName:(NSString*)name keys:(NSArray*)keys;
/**
 插入 只关心key和value @{key:value,key:value}
 */
-(BOOL)insertIntoTableName:(NSString*)name Dict:(NSDictionary*)dict;
/**
 根据条件查询字段 返回的数组是字典( @[@{key:value},@{key:value}] ) ,where形式 @[@"key",@"=",@"value",@"key",@">=",@"value"]
 */
-(NSArray*)queryWithTableName:(NSString*)name keys:(NSArray*)keys where:(NSArray*)where;
/**
 全部查询 返回的数组是字典( @[@{key:value},@{key:value}] )
 */
-(NSArray*)queryWithTableName:(NSString*)name;
/**
 根据key更新value 形式 @[@"key",@"=",@"value",@"key",@">=",@"value"]
 */
-(BOOL)updateWithTableName:(NSString*)name valueDict:(NSDictionary*)valueDict where:(NSArray*)where;
/**
 根据表名和表字段删除表内容 where形式 @[@"key",@"=",@"value",@"key",@">=",@"value"]
 */
-(BOOL)deleteWithTableName:(NSString*)name where:(NSArray*)where;
/**
 根据表名删除表格全部内容
 */
-(BOOL)clearTable:(NSString*)name;
/**
 删除表
 */
-(BOOL)dropTable:(NSString*)name;
@end
