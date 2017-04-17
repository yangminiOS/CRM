//
//  CRMCustomerFMdb.h
//  CRM
//
//  Created by mini on 16/8/9.
//  Copyright © 2016年 mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@class CRMDataBaseMsg;


typedef void(^customerType)(NSMutableArray *successMsg);

@interface ZJFMdb : NSObject

//创建数据库

+(void)creatSqlWithFileName:(NSString *)fileName;

//创建表

+(void)sqlCreatTableWithName:(NSString *)tableName tableHead:(NSString *)head;
//插入数据
+(NSInteger)sqlInsertData:(id)model  tableName:(NSString *)tableName;


//删除数据

+(void)sqlDelecteData:(id)model tableName:(NSString *)tableName headString:(NSInteger) headItem;

//更新数据

+(void)sqlUpdata:(id)model tableName:(NSString *)tableName;

+(void)sqlUpdataWithString:(NSString *)update;
//查询全部数据

+(void)sqlSelecteData:(id)model tableName:(NSString *)tableName success:(customerType)success;
//查询条件数据
+(void)sqlSelecteData:(id)model selecteString:(NSString *)selecteString success:(customerType)success;
//数据库子标题查询
+(NSInteger)sqlSelecteCountWithString:(NSString *)selecteString;

//数据库子标题查询
+(CGFloat)sqlSelecteResultValueWithString:(NSString *)selecteString;
//插入原始数据
+(void)sqlInsertOriginalDate;

//查询贷款金额

+(NSMutableArray *)sqlMoney:(NSString *)selectString;

//***************
//根据关键字动态获取月份的人数
+ (NSMutableArray *)sqlMothSums:(NSString *)selecteString;
//查询对比数据
+(NSMutableArray *)text:(NSString *)selecteString;
//查询介绍人数据
+ (NSMutableArray *)references:(NSString *)selecteString;
@end
