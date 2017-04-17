//
//  ZJAddGoaldViewController.h
//  CRM
//
//  Created by mini on 16/10/22.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJBaseViewController.h"

@class ZJGoalTableInfo;
typedef NS_ENUM(NSInteger,ZJAddGoaldModel) {
    ZJAddGoaldModelWhite,
    ZJAddGoaldModelEdit,
};

@interface ZJAddGoaldViewController : ZJBaseViewController

//**模式**//
@property(nonatomic,assign)ZJAddGoaldModel addGoaldModel;
//**目标类型默认数据**//
@property(nonatomic,copy)NSString *goaldTypeString;

//**时间节点默认数据**//
@property(nonatomic,copy)NSString *dateString;

//**目标额度默认数据**//
@property(nonatomic,copy)NSString *countString;

//**修改状态下要用到的唯一标识**//
@property(nonatomic,assign)NSInteger iAutoID;


//**<#注释#>**//
@property(nonatomic,strong) ZJGoalTableInfo *editDataModel;
@end
