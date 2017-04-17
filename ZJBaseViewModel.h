//
//  ZJBaseViewModel.h
//  CRM
//
//  Created by 杨敏 on 16/9/25.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJBaseViewModel : NSObject

//**头像路径**//
@property(nonatomic,copy)NSString *iconPath;
//**性别**//
@property(nonatomic,assign)NSInteger sex;
//**姓名**//
@property(nonatomic,copy)NSString *name;

//**生日**//
@property(nonatomic,copy)NSString *birthDay;

//**身份证号**//
@property(nonatomic,copy)NSString *codeID;

//**手机号**//
@property(nonatomic,copy)NSString *iphone;

//**借贷金额**//
@property(nonatomic,copy)NSString *loanCount;

//**每月利息**//
@property(nonatomic,copy)NSString *interest;

//**借款日期**//
@property(nonatomic,copy)NSString *loanDate;

//**借款期限**//
@property(nonatomic,copy)NSString *loanTime;


@end
