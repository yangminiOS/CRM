//
//  ZJFMdb.m
//  CRM
//
//  Created by mini on 16/9/27.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJFMdb.h"
#import <FMDB.h>
#import "ZJcustomerTableInfo.h"//客户信息
#import "ZJFollowUpTableInfo.h"//跟进信息
#import "ZJRemindTableInfo.h"//提醒信息
#import "ZJGoalTableInfo.h"//目标信息
#import "ZJGtasksTableInfo.h"//代办事宜信息
#import "ZJCustomerItemsTableInfo.h"//客户标签信息

static FMDatabase *db;


@implementation ZJFMdb

//创建数据库
+(void)creatSqlWithFileName:(NSString *)fileName{
    
    NSString *path = ZJDocumentPath;
    
    NSString *dbPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",fileName]];
    
    db = [FMDatabase databaseWithPath:dbPath];
    
}

//创建表
+(void)sqlCreatTableWithName:(NSString *)tableName tableHead:(NSString *)head{
    
    [db open];
    
    NSString *creat = [NSString stringWithFormat:@"create table if not exists %@ %@",tableName,head];
    
    [db executeUpdate:creat];
    
    [db close];
    
}


#pragma mark   插入数据
+(NSInteger)sqlInsertData:(id)model  tableName:(NSString *)tableName{
    NSInteger ID = 0;
    NSString *path = ZJDocumentPath;
    
    NSString *dbPath = [path stringByAppendingPathComponent:@"mycrm.db"];
    
    db = [FMDatabase databaseWithPath:dbPath];
    
    BOOL open =[db open];
    if (open) {
        ZJLog(@"打开成功");
    }else{
        
        ZJLog(@"失败");
    }
    
    if ([model isKindOfClass:[ZJcustomerTableInfo class]]) {
        
        ZJcustomerTableInfo *msgModel = model;
        NSString *insert = [NSString stringWithFormat:@"insert into %@   (cPhotoUrl,cName,cFirstAlphabet,iSex,cBirthDay,cCardID,cPhone,fBorrowMoney,fMonthlyInterest,cLoanTimeLimit,cLoanDate,cCustomerState_Tags,cCustomerState_Remark,cCustomerSource_Tags,cCustomerSource_IntroducerName,cCustomerSource_IntroducerPhone,cLoanType_Tags,cRelatedPhotos,cCustomerRemark_Text,cCustomerRemark_VoiceUrl,iIndustryType,cCreateYear,cCreateMonth,cCreateDay,iSyncType,cLastSyncTime,cOwnerUser,GUID,iFrom)VALUES('%@','%@','%@',%zd,'%@','%@','%@',%f,%f,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',%zd,'%@','%@','%@',%zd,'%@','%@','%@',%zd)",tableName,msgModel.cPhotoUrl,msgModel.cName,msgModel.cFirstAlphabet,msgModel.iSex,msgModel.cBirthDay,msgModel.cCardID,msgModel.cPhone,msgModel.fBorrowMoney,msgModel.fMonthlyInterest,msgModel.cLoanTimeLimit,msgModel.cLoanDate,msgModel.cCustomerState_Tags,msgModel.cCustomerState_Remark,msgModel.cCustomerSource_Tags,msgModel.cCustomerSource_IntroducerName,msgModel.cCustomerSource_IntroducerPhone,msgModel.cLoanType_Tags,msgModel.cRelatedPhotos,msgModel.cCustomerRemark_Text,msgModel.cCustomerRemark_VoiceUrl,msgModel.iIndustryType,msgModel.cCreateYear,msgModel.cCreateMonth,msgModel.cCreateDay,msgModel.iSyncType,msgModel.cLastSyncTime,msgModel.cOwnerUser,msgModel.GUID,msgModel.iFrom];
        
        [db executeUpdate:insert];
        
        ID = [db lastInsertRowId];


    }else if ([model isKindOfClass:[ZJFollowUpTableInfo class]]){
        
        ZJFollowUpTableInfo *follow = model;
        
        NSString *insert = [NSString stringWithFormat:@"insert into %@ (iCustomerID,cText,cPhotoUrl,cVoiceUrl,iRemind,cRemindTime,cLogDate,cLogTime,cWeekDay)VALUES(%zd,'%@','%@','%@',%zd,'%@','%@','%@','%@')",tableName,follow.iCustomerID,follow.cText,follow.cPhotoUrl,follow.cVoiceUrl,follow.iRemind,follow.cRemindTime,follow.cLogDate,follow.cLogTime,follow.cWeekDay];
        
        [db executeUpdate:insert];
        
        
    }else if ([model isKindOfClass:[ZJRemindTableInfo class]]){
        
        ZJRemindTableInfo *remind = model;
        
        NSString *insert = [NSString stringWithFormat:@"insert into %@ (iCustomerID,iRemindType,cRemindTime,cRemindDate,iSwitch)VALUES(%zd,%zd,'%@','%@',%zd)",tableName,remind.iCustomerID,remind.iRemindType,remind.cRemindTime,remind.cRemindDate,remind.iSwitch];
        
        [db executeUpdate:insert];
        
    }else if ([model isKindOfClass:[ZJGoalTableInfo class]]){
        
        ZJGoalTableInfo *goal = model;
        
        NSString *insert = [NSString stringWithFormat:@"insert into %@ (type,goalCount,completeCount,tag,year)VALUES('%@',%zd,%f,'%@','%@')",tableName,goal.type,goal.goalCount,goal.completeCount,goal.tag,goal.year];
        
        [db executeUpdate:insert];

    }else if ([model isKindOfClass:[ZJGtasksTableInfo class]]){
        ZJGtasksTableInfo *gtasks = model;
        NSString *insert = [NSString stringWithFormat:@"insert into %@(contentText,dateString,timeString,weekString,completeOrGtasks)VALUES('%@','%@','%@','%@',%zd)",tableName,gtasks.contentText,gtasks.dateString,gtasks.timeString,gtasks.weekString,gtasks.completeOrGtasks];
        [db executeUpdate:insert];
        
    }else if ([model isKindOfClass:[ZJCustomerItemsTableInfo class]]){
        ZJCustomerItemsTableInfo *items = model;
        NSString *insert = [NSString stringWithFormat:@"insert into %@(type,itemString,delect)VALUES('%@','%@',%zd)",tableName,items.type,items.itemString,items.delect];
        
        [db executeUpdate:insert];

        ID = [db lastInsertRowId];
    }
    
    
    [db close];
    return ID;
    
}

//更新某个值
+(void)sqlUpdataWithString:(NSString *)update{
    
    NSString *path = ZJDocumentPath;
    
    NSString *dbPath = [path stringByAppendingPathComponent:@"mycrm.db"];
    
    db = [FMDatabase databaseWithPath:dbPath];
    
    [db open];
    
    [db executeUpdate:update];

    [db close];
}


//更新
+(void)sqlUpdata:(id)model tableName:(NSString *)tableName{
    
    NSString *path = ZJDocumentPath;
    
    NSString *dbPath = [path stringByAppendingPathComponent:@"mycrm.db"];
    
    db = [FMDatabase databaseWithPath:dbPath];
    
    [db open];
    
    if ([model isKindOfClass:[ZJcustomerTableInfo class]]) {
        
        ZJcustomerTableInfo *msgModel = model;
        
        NSString *update = [NSString stringWithFormat:@"update %@ set cPhotoUrl='%@',cName='%@',cFirstAlphabet='%@',iSex=%zd,cBirthDay='%@',cCardID='%@',cPhone='%@',fBorrowMoney=%f,fMonthlyInterest=%f,cLoanTimeLimit='%@',cLoanDate='%@',cCustomerState_Tags='%@',cCustomerState_Remark='%@',cCustomerSource_Tags='%@',cCustomerSource_IntroducerName='%@',cCustomerSource_IntroducerPhone='%@',cLoanType_Tags='%@',cRelatedPhotos='%@',cCustomerRemark_Text='%@',cCustomerRemark_VoiceUrl='%@',iIndustryType=%zd,cCreateYear='%@',cCreateMonth='%@',cCreateDay='%@',iSyncType=%zd,cLastSyncTime='%@',cOwnerUser='%@',GUID='%@',iFrom=%zd WHERE iAutoID=%zd",tableName,msgModel.cPhotoUrl,msgModel.cName,msgModel.cFirstAlphabet,msgModel.iSex,msgModel.cBirthDay,msgModel.cCardID,msgModel.cPhone,msgModel.fBorrowMoney,msgModel.fMonthlyInterest,msgModel.cLoanTimeLimit,msgModel.cLoanDate,msgModel.cCustomerState_Tags,msgModel.cCustomerState_Remark,msgModel.cCustomerSource_Tags,msgModel.cCustomerSource_IntroducerName,msgModel.cCustomerSource_IntroducerPhone,msgModel.cLoanType_Tags,msgModel.cRelatedPhotos,msgModel.cCustomerRemark_Text,msgModel.cCustomerRemark_VoiceUrl,msgModel.iIndustryType,msgModel.cCreateYear,msgModel.cCreateMonth,msgModel.cCreateDay,msgModel.iSyncType,msgModel.cLastSyncTime,msgModel.cOwnerUser,msgModel.GUID,msgModel.iFrom,msgModel.iAutoID];
        
        [db executeUpdate:update];
        
        
    }else if ([model isKindOfClass:[ZJFollowUpTableInfo class]]){
        
        
        
    }else if ([model isKindOfClass:[ZJRemindTableInfo class]]){
        
        ZJRemindTableInfo *remind = model;
        
        NSString *update = [NSString stringWithFormat:@"update %@ set iRemindType = %zd,cRemindDate='%@',cRemindTime='%@',iSwitch = %zd WHERE iCustomerID = %zd",tableName,remind.iRemindType,remind.cRemindDate,remind.cRemindTime,remind.iSwitch,remind.iCustomerID];
        
        [db executeUpdate:update];
        
    
    }else if ([model isKindOfClass:[ZJGoalTableInfo class]]){
        ZJGoalTableInfo *goal = model;
        
        NSString *update = [NSString stringWithFormat:@"update %@ set type='%@',goalCount = %zd,completeCount=%f,tag='%@',year='%@' where iAutoID=%zd",ZJGoalTableName,goal.type,goal.goalCount,goal.completeCount,goal.tag,goal.year,goal.iAutoID];
        [db executeUpdate:update];
        
    }else if ([model isKindOfClass:[ZJGtasksTableInfo class]]){
        
        ZJGtasksTableInfo *gtasks = model;
        
        NSString *update = [NSString stringWithFormat:@"update %@ set completeOrGtasks=%zd where iAutoID = %zd",tableName,gtasks.completeOrGtasks,gtasks.iAutoID];
        
        [db executeUpdate:update];


    }else if ([model isKindOfClass:[ZJCustomerItemsTableInfo class]]){
        

        
    }

    
    [db close];
    
    
}
//删除

+(void)sqlDelecteData:(id)model tableName:(NSString *)tableName headString:(NSInteger) headItem{
    
    //删除图片以及语音
    NSString *path = ZJDocumentPath;
    
    NSString *dbPath = [path stringByAppendingPathComponent:@"mycrm.db"];
    
    db = [FMDatabase databaseWithPath:dbPath];
    
    [db open];
    
    
    if ([model isKindOfClass:[ZJcustomerTableInfo class]]) {
        
        //客户资料
        NSString *deleteCUS = [NSString stringWithFormat:@"delete from %@ where iAutoID = %zd",ZJCustomerTableName,headItem];
        //跟进
        NSString *deleteFOW = [NSString stringWithFormat:@"delete from %@ where iCustomerID = %zd",ZJFollowTableName,headItem];
        //提醒
        NSString *deleteRIN = [NSString stringWithFormat:@"delete from %@ where iCustomerID = %zd",ZJRemindTableName,headItem];
        
        [db executeUpdate:deleteCUS];
        
        [db executeUpdate:deleteFOW];
        
        [db executeUpdate:deleteRIN];
        
    }else if ([model isKindOfClass:[ZJFollowUpTableInfo class]]){
        
        
        NSString *delete = [NSString stringWithFormat:@"delete from %@ where iAutoID = %zd",tableName,headItem];
        
        [db executeUpdate:delete];
        
        
    }else if ([model isKindOfClass:[ZJRemindTableInfo class]]){
        
        NSString *delete = [NSString stringWithFormat:@"delete from %@ where iCustomerID = %zd",tableName,headItem];
        
        [db executeUpdate:delete];
        
    }else if ([model isKindOfClass:[ZJGoalTableInfo class]]){
        
        NSString *delete = [NSString stringWithFormat:@"delete from %@ where iAutoID = %zd",tableName,headItem];
        
        [db executeUpdate:delete];
        
    }else if ([model isKindOfClass:[ZJGtasksTableInfo class]]){
        NSString *delete = [NSString stringWithFormat:@"delete from %@ where iAutoID=%zd",tableName,headItem];
        [db executeUpdate:delete];
        
    }else if ([model isKindOfClass:[ZJCustomerItemsTableInfo class]]){
        NSString *delete = [NSString stringWithFormat:@"delete from %@ where iAutoID=%zd",tableName,headItem];
        [db executeUpdate:delete];
    }
    
    
    [db close];
    
}
//查询数据
+(void)sqlSelecteData:(id)model tableName:(NSString *)tableName success:(customerType)success{
    
    NSString *path = ZJDocumentPath;
    
    NSString *dbPath = [path stringByAppendingPathComponent:@"mycrm.db"];
    db = [FMDatabase databaseWithPath:dbPath];
    
    BOOL open = [db open];
    
    if (open) {
        ZJLog(@"打开成功");
    }else{
        
        ZJLog(@"shiabia");
    }
    NSMutableArray *array = [NSMutableArray array];
    
    if ([model isKindOfClass:[ZJcustomerTableInfo class]]) {
        
        NSString *selecte = [NSString stringWithFormat:@"select * from %@",tableName];
        FMResultSet *result =[db executeQuery:selecte];
        while ([result next]) {
            
            ZJcustomerTableInfo *msgModel = [[ZJcustomerTableInfo alloc]init];

            msgModel.iAutoID = [result intForColumn:@"iAutoID"];
            msgModel.cPhotoUrl = [result stringForColumn:@"cPhotoUrl"];
            msgModel.cName = [result stringForColumn:@"cName"];
            msgModel.cFirstAlphabet = [result stringForColumn:@"cFirstAlphabet"];
            msgModel.iSex = [result intForColumn:@"iSex"];

            msgModel.cBirthDay = [result stringForColumn:@"cBirthDay"];

            msgModel.cCardID = [result stringForColumn:@"cCardID"];

            msgModel.cPhone = [result stringForColumn:@"cPhone"];
            msgModel.fBorrowMoney = [result doubleForColumn:@"fBorrowMoney"];
             msgModel.fMonthlyInterest = [result doubleForColumn:@"fMonthlyInterest"];

            msgModel.cLoanTimeLimit = [result stringForColumn:@"cLoanTimeLimit"];
            msgModel.cLoanDate = [result stringForColumn:@"cLoanDate"];
            
            msgModel.cCustomerState_Tags = [result stringForColumn:@"cCustomerState_Tags"];

            msgModel.cCustomerState_Remark = [result stringForColumn:@"cCustomerState_Remark"];

            msgModel.cCustomerSource_Tags = [result stringForColumn:@"cCustomerSource_Tags"];

            msgModel.cCustomerSource_IntroducerName = [result stringForColumn:@"cCustomerSource_IntroducerName"];

            msgModel.cCustomerSource_IntroducerPhone = [result stringForColumn:@"cCustomerSource_IntroducerPhone"];

            msgModel.cLoanType_Tags = [result stringForColumn:@"cLoanType_Tags"];

            msgModel.cRelatedPhotos = [result stringForColumn:@"cRelatedPhotos"];

            msgModel.cCustomerRemark_Text = [result stringForColumn:@"cCustomerRemark_Text"];

            msgModel.cCustomerRemark_VoiceUrl = [result stringForColumn:@"cCustomerRemark_VoiceUrl"];
            
            msgModel.iIndustryType = [result intForColumn:@"iIndustryType"];
            
            msgModel.cCreateYear = [result stringForColumn:@"cCreateYear"];
            msgModel.cCreateMonth = [result stringForColumn:@"cCreateMonth"];
            msgModel.cCreateDay = [result stringForColumn:@"cCreateDay"];

            
            msgModel.iSyncType = [result intForColumn:@"iSyncType"];

            msgModel.cLastSyncTime = [result stringForColumn:@"cLastSyncTime"];
            
            msgModel.cOwnerUser = [result stringForColumn:@"cOwnerUser"];
            
            msgModel.GUID = [result stringForColumn:@"GUID"];
            
            msgModel.iFrom = [result intForColumn:@"iFrom"];
            
            [array addObject:msgModel];

        }
        success(array);
        
        
    }else if ([model isKindOfClass:[ZJFollowUpTableInfo class]]){
        
        ZJFollowUpTableInfo *follow = model;
        NSString *selecte = [NSString stringWithFormat:@"select * from %@",tableName];
        FMResultSet *result = [db executeQuery:selecte];
        while ([result next]) {
            
        }
        
        
    }else if ([model isKindOfClass:[ZJRemindTableInfo class]]){
        
        ZJRemindTableInfo *remind = model;
        NSString *selecte = [NSString stringWithFormat:@"select * from %@",tableName];
        FMResultSet *result =[db executeQuery:selecte];
        while ([result next]) {
            
        }
    }else if ([model isKindOfClass:[ZJGoalTableInfo class]]){
        
        ZJGoalTableInfo *goal = model;
        NSString *selecte = [NSString stringWithFormat:@"select * from %@",tableName];

        FMResultSet *result =[db executeQuery:selecte];
        while ([result next]) {
            
            goal.iAutoID = [result intForColumn:@"iAutoID"];
            goal.type = [result stringForColumn:@"type"];
            goal.goalCount = [result intForColumn:@"goalCount"];
            goal.completeCount = [result doubleForColumn:@"completeCount"];
            goal.tag = [result stringForColumn:@"tag"];
            goal.year = [result stringForColumn:@"year"];
            [array addObject:goal];
        }
        success(array);
        

        
    }
    
    
    [db close];
    
}

//条件查询
//查询条件数据
+(void)sqlSelecteData:(id)model selecteString:(NSString *)selecteString success:(customerType)success{
    
    NSString *path = ZJDocumentPath;
    
    NSString *dbPath = [path stringByAppendingPathComponent:@"mycrm.db"];

    db = [FMDatabase databaseWithPath:dbPath];
    
    [db open];

    NSMutableArray *array = [NSMutableArray array];
    if ([model isKindOfClass:[ZJcustomerTableInfo class]]) {
        
        FMResultSet *result =[db executeQuery:selecteString];
        while ([result next]) {
            
            ZJcustomerTableInfo *msgModel =  [[ZJcustomerTableInfo alloc]init];
            
            msgModel.iAutoID = [result intForColumn:@"iAutoID"];
            msgModel.cPhotoUrl = [result stringForColumn:@"cPhotoUrl"];
            msgModel.cName = [result stringForColumn:@"cName"];
            msgModel.cFirstAlphabet = [result stringForColumn:@"cFirstAlphabet"];

            msgModel.iSex = [result intForColumn:@"iSex"];
            
            msgModel.cBirthDay = [result stringForColumn:@"cBirthDay"];
            
            msgModel.cCardID = [result stringForColumn:@"cCardID"];
            
            msgModel.cPhone = [result stringForColumn:@"cPhone"];
            msgModel.fBorrowMoney = [result doubleForColumn:@"fBorrowMoney"];
            msgModel.fMonthlyInterest = [result doubleForColumn:@"fMonthlyInterest"];
            
            msgModel.cLoanTimeLimit = [result stringForColumn:@"cLoanTimeLimit"];
            
            msgModel.cLoanDate = [result stringForColumn:@"cLoanDate"];
            
            
            msgModel.cCustomerState_Tags = [result stringForColumn:@"cCustomerState_Tags"];
            
            msgModel.cCustomerState_Remark = [result stringForColumn:@"cCustomerState_Remark"];
            
            msgModel.cCustomerSource_Tags = [result stringForColumn:@"cCustomerSource_Tags"];
            
            msgModel.cCustomerSource_IntroducerName = [result stringForColumn:@"cCustomerSource_IntroducerName"];
            
            msgModel.cCustomerSource_IntroducerPhone = [result stringForColumn:@"cCustomerSource_IntroducerPhone"];
            
            msgModel.cLoanType_Tags = [result stringForColumn:@"cLoanType_Tags"];
            
            msgModel.cRelatedPhotos = [result stringForColumn:@"cRelatedPhotos"];
            
            msgModel.cCustomerRemark_Text = [result stringForColumn:@"cCustomerRemark_Text"];
            
            msgModel.cCustomerRemark_VoiceUrl = [result stringForColumn:@"cCustomerRemark_VoiceUrl"];
            
            msgModel.iIndustryType = [result intForColumn:@"iIndustryType"];
            
            msgModel.cCreateYear = [result stringForColumn:@"cCreateYear"];
            msgModel.cCreateMonth = [result stringForColumn:@"cCreateMonth"];
            msgModel.cCreateDay = [result stringForColumn:@"cCreateDay"];
            
            msgModel.iSyncType = [result intForColumn:@"iSyncType"];
            
            msgModel.cLastSyncTime = [result stringForColumn:@"cLastSyncTime"];
            
            msgModel.cOwnerUser = [result stringForColumn:@"cOwnerUser"];
            
            msgModel.GUID = [result stringForColumn:@"GUID"];
            
            msgModel.iFrom = [result intForColumn:@"iFrom"];

            
            [array addObject:msgModel];
            
        }
        success(array);
        
        
    }else if ([model isKindOfClass:[ZJFollowUpTableInfo class]]){
        
        FMResultSet *result = [db executeQuery:selecteString];
        
        while ([result next]) {
            
            ZJFollowUpTableInfo *followModel = [[ZJFollowUpTableInfo alloc]init];
            
            followModel.iAutoID = [result intForColumn:@"iAutoID"];
            
            followModel.iCustomerID = [result intForColumn:@"iCustomerID"];
            
            followModel.cText = [result stringForColumn:@"cText"];
            
            followModel.cPhotoUrl = [result stringForColumn:@"cPhotoUrl"];
            
            followModel.cVoiceUrl = [result stringForColumn:@"cVoiceUrl"];
            
            followModel.iRemind = [result intForColumn:@"iRemind"];
            
            followModel.cRemindTime = [result stringForColumn:@"cRemindTime"];
            
            followModel.cLogDate = [result stringForColumn:@"cLogDate"];
            followModel.cLogTime = [result stringForColumn:@"cLogTime"];
            
            followModel.cWeekDay = [result stringForColumn:@"cWeekDay"];
            
            [array addObject:followModel];

        }
        success(array);
        
        
    }else if ([model isKindOfClass:[ZJRemindTableInfo class]]){
        
        FMResultSet *result =[db executeQuery:selecteString];
        while ([result next]) {
            ZJRemindTableInfo *remind = [[ZJRemindTableInfo alloc]init];
            remind.iAutoID = [result intForColumn:@"iAutoID"];
            
            remind.iCustomerID = [result intForColumn:@"iCustomerID"];
            
            remind.iRemindType = [result intForColumn:@"iRemindType"];
            
            remind.iSwitch = [result intForColumn:@"iSwitch"];
            
            remind.cRemindTime = [result stringForColumn:@"cRemindTime"];
            
            remind.cRemindDate = [result stringForColumn:@"cRemindDate"];
            
            [array addObject:remind];
            
        }
        
        success(array);

    }else if ([model isKindOfClass:[ZJGoalTableInfo class]]){
        
        FMResultSet *result =[db executeQuery:selecteString];
        while ([result next]) {
            ZJGoalTableInfo *goal = [[ZJGoalTableInfo alloc]init];

            goal.iAutoID = [result intForColumn:@"iAutoID"];
            goal.type = [result stringForColumn:@"type"];
            goal.goalCount = [result intForColumn:@"goalCount"];
            goal.completeCount = [result doubleForColumn:@"completeCount"];
            goal.tag = [result stringForColumn:@"tag"];
            goal.year = [result stringForColumn:@"year"];
            [array addObject:goal];
        }
        success(array);

    }else if ([model isKindOfClass:[ZJGtasksTableInfo class]]){
        FMResultSet *result =[db executeQuery:selecteString];
        while ([result next]) {
            ZJGtasksTableInfo *gtasks = [[ZJGtasksTableInfo alloc]init];
            gtasks.iAutoID = [result intForColumn:@"iAutoID"];
            gtasks.contentText = [result stringForColumn:@"contentText"];
            gtasks.dateString = [result stringForColumn:@"dateString"];
            gtasks.timeString = [result stringForColumn:@"timeString"];
            gtasks.weekString = [result stringForColumn:@"weekString"];
            gtasks.completeOrGtasks = [result intForColumn:@"completeOrGtasks"];
            [array addObject:gtasks];
        }
        success(array);
        
    }else if ([model isKindOfClass:[ZJCustomerItemsTableInfo class]]){
        
        FMResultSet *result = [db executeQuery:selecteString];
        while ([result next]) {
            ZJCustomerItemsTableInfo *items = [[ZJCustomerItemsTableInfo alloc]init];
            items.iAutoID = [result intForColumn:@"iAutoID"];
            items.itemString = [result stringForColumn:@"itemString"];
            items.delect =[result intForColumn:@"delect"];
            [array addObject:items];
        }
        success(array);
        
    }
    
    
    [db close];

}
//数据库子标题查询

+(NSInteger)sqlSelecteCountWithString:(NSString *)selecteString{
    NSInteger result = 0;
    NSString *path = ZJDocumentPath;
    
    NSString *dbPath = [path stringByAppendingPathComponent:@"mycrm.db"];
    db = [FMDatabase databaseWithPath:dbPath];
    
    [db open];
    result =[db intForQuery:selecteString];
    
    [db close];
    return result;
}



+(CGFloat)sqlSelecteResultValueWithString:(NSString *)selecteString;{
    
    CGFloat result = 0;
    NSString *path = ZJDocumentPath;
    
    NSString *dbPath = [path stringByAppendingPathComponent:@"mycrm.db"];
    db = [FMDatabase databaseWithPath:dbPath];
    
    [db open];
    result =[db doubleForQuery:selecteString];
    
    [db close];
    return result;
}

//插入原始数据
+(void)sqlInsertOriginalDate{
    
    NSString *path = ZJDocumentPath;
    
    NSString *dbPath = [path stringByAppendingPathComponent:@"mycrm.db"];
    
    db = [FMDatabase databaseWithPath:dbPath];
    
    [db open];
    NSString *insert = @"insert into crm_CustomerItems(type,itemString,delect)VALUES('customerState','意向客户',1),('customerState','已贷',1),('customerState','续贷',1),('customerState','被拒',1),('customerState','跟进中',1),('customerState','没做成',1),('customerSource','寿险转介绍',0),('customerSource','电销',0),('customerSource','同行转介绍',0),('customerSource','传单',0),('customerSource','陌拜',0),('customerSource','上门咨询',0),('customerType','有抵押',0),('customerType','房抵贷',0),('customerType','车抵贷',0),('customerType','宅E贷',0),('customerType','无抵押',0),('customerType','按揭房贷',0),('customerType','按揭车贷',0),('customerType','工资贷',0),('customerType','公积金贷',0),('customerType','保单贷',0),('customerType','法人贷',0),('customerType','担保贷',0)";
    
    [db executeUpdate:insert];
    [db close];
}


//查询贷款金额

+(NSMutableArray *)sqlMoney:(NSString *)selectString{
    
    NSMutableArray *muteble = [NSMutableArray array];
    
    NSString *path = ZJDocumentPath;
    
    NSString *dbPath = [path stringByAppendingPathComponent:@"mycrm.db"];
    db = [FMDatabase databaseWithPath:dbPath];
    
    [db open];
    
    FMResultSet * result = [db executeQuery:selectString];
    while ([result next]) {
        int money= [result intForColumn:@"val"];
        
        NSString *sMonry = [NSString stringWithFormat:@"%d",money];
        [muteble addObject:sMonry];
        
    }
    
    [db close];

    return muteble;
}

//******************

//根据关键字动态获取月份的人数
+ (NSMutableArray *)sqlMothSums:(NSString *)selecteString{
    NSArray *temp = @[@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0)];
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:temp];
    NSString *path = ZJDocumentPath;
    
    NSString *dbPath = [path stringByAppendingPathComponent:@"mycrm.db"];
    db = [FMDatabase databaseWithPath:dbPath];
    
    
    [db open];
    FMResultSet * result = [db executeQuery:selecteString];
    while ([result next]) {
        int month = [result intForColumn:@"cCreateMonth"];
        int num= [result intForColumn:@"NUM"];
        
        [array replaceObjectAtIndex:month-1 withObject:@(num)];
    }
    
    [db close];
    return array;
    
}

//查询对比数据
+ (NSMutableArray *)text:(NSString *)selecteString{
    NSMutableArray *array = [NSMutableArray array];
    NSString *path = ZJDocumentPath;
    
    NSString *dbPath = [path stringByAppendingPathComponent:@"mycrm.db"];
    db = [FMDatabase databaseWithPath:dbPath];
    
    [db open];
    FMResultSet * result = [db executeQuery:selecteString];
    while ([result next]) {
        NSMutableDictionary * DIC = [NSMutableDictionary dictionary];
        
        DIC[@"num"] = @([result intForColumn:@"NUM1"]);
        DIC[@"pk"] = @([result intForColumn:@"NUM2"]);
        DIC[@"contrast"] = @([result intForColumn:@"SUB"]);
        
        [array addObject:DIC];
        
    }
    
    [db close];
    return array;
    
}

//查询介绍人数据
+ (NSMutableArray *)references:(NSString *)selecteString{
    NSMutableArray *array = [NSMutableArray array];
    NSString *path = ZJDocumentPath;
    
    NSString *dbPath = [path stringByAppendingPathComponent:@"mycrm.db"];
    db = [FMDatabase databaseWithPath:dbPath];
    
    [db open];
    FMResultSet * result = [db executeQuery:selecteString];
    while ([result next]) {
        NSMutableDictionary * DIC = [NSMutableDictionary dictionary];
        
        DIC[@"name"] = [result stringForColumn:@"NAME"];
        DIC[@"num"] = @([result intForColumn:@"NUM"]);
        DIC[@"rightnum"] = @([result intForColumn:@"RIGHTNUM"]);
        
        [array addObject:DIC];
        
    }
    
    [db close];
    return array;
    
}



@end

















