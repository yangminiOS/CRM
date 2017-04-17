//
//  CRMScanMsg.h
//  CRM
//
//  Created by mini on 16/8/29.
//  Copyright © 2016年 mini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJcustomerTableInfo : NSObject//ZJcustomerTableInfo

//**ID**//
@property(nonatomic,assign)NSInteger iAutoID;
//**头像路径**//
@property(nonatomic,copy)NSString *cPhotoUrl;

//**名字首字母**//
@property(nonatomic,copy)NSString *cFirstAlphabet;

//**姓名**//
@property(nonatomic,copy) NSString*cName;

//**性别**//

//性别1:男  0:女
@property(nonatomic,assign) NSInteger iSex;

//**生日**//
@property(nonatomic,copy) NSString *cBirthDay;

//**身份证号码**//
@property(nonatomic,copy) NSString *cCardID;

//**手机号码**//
@property(nonatomic,copy) NSString *cPhone;

//**贷款金额**//
@property(nonatomic,assign) double fBorrowMoney;

//**月息**//
@property(nonatomic,assign) double fMonthlyInterest;

//**贷款期限**//
@property(nonatomic,copy) NSString *cLoanTimeLimit;

//**贷款日期**//
@property(nonatomic,copy) NSString *cLoanDate;

//**首期还款日**//
//@property(nonatomic,copy) NSString *cFirstRepaymentDate;

//**续贷提醒日**//
//@property(nonatomic,copy) NSString *cContinueLoanDate;

//**客户状态标签**//
@property(nonatomic,copy)NSString *cCustomerState_Tags;

//**客户状态对应的备注信息**//
@property(nonatomic,copy)NSString *cCustomerState_Remark;

//**客户来源标签**//
@property(nonatomic,copy)NSString *cCustomerSource_Tags;

//**介绍人姓名**//
@property(nonatomic,copy)NSString *cCustomerSource_IntroducerName;

//**介绍人电话**//
@property(nonatomic,copy)NSString *cCustomerSource_IntroducerPhone;

//**贷款类型标签**//
@property(nonatomic,copy)NSString *cLoanType_Tags;

//**资料照片地址**//
@property(nonatomic,copy)NSString *cRelatedPhotos;
//**备注信息**//
@property(nonatomic,copy)NSString *cCustomerRemark_Text;
//**语音信息地址**//
@property(nonatomic,copy)NSString *cCustomerRemark_VoiceUrl;

//**业务类型**//
/*业务类型，为了以后扩展
 1:贷款
 2:车险
 3:寿险
 4:理财
 */
@property(nonatomic,assign)NSInteger iIndustryType;

//**数据创建时间**//
@property(nonatomic,copy)NSString *cCreateYear;
//**数据创建时间**//
@property(nonatomic,copy)NSString *cCreateMonth;
//**数据创建时间**//
@property(nonatomic,copy)NSString *cCreateDay;


//**同步状体**//
/*1:本地原生数据
 2:从云端同步下来的数据
 */
@property(nonatomic,assign)NSInteger iSyncType;

//**最后一次同步时间**//
@property(nonatomic,copy)NSString *cLastSyncTime;

//**当前客户归属那个账户**//
@property(nonatomic,copy)NSString *cOwnerUser;

//**GUID文件夹名字**//
@property(nonatomic,copy)NSString *GUID;

//**客户来源  完整客户录入1   意向客户录入2 扫描录入3**//
@property(nonatomic,assign) NSInteger iFrom;

//**************************************************************
//自定义属性

//**装客户标签的数组**//
@property(nonatomic,strong)NSMutableArray *itemsString;

//**客户状态标签数组**//
@property(nonatomic,strong)NSMutableArray *stateArray;
//**客户来源标签数组**//
@property(nonatomic,strong)NSMutableArray *sourceArray;
//**贷款类型标签数组**//
@property(nonatomic,strong)NSMutableArray *typeArray;
//**装照片路径的数组**//
@property(nonatomic,strong)NSMutableArray *photosPath;
//**录音路径数组**//
@property(nonatomic,strong)NSMutableArray *recodePath;

//**头像的路径**//
@property(nonatomic,copy)NSString *iconPath;

//**是否展开**//
@property(nonatomic,assign,getter=isExplain)BOOL explain;

//**头部高度**//
@property(nonatomic,assign)CGFloat headViewHeight;

//**cell的高度**//
@property(nonatomic,assign)CGFloat cellHeight;

//**装模型的数组**//
@property(nonatomic,strong) NSMutableArray *customerModelArray;

//**续贷提醒日期**//
@property(nonatomic,copy)NSString *continueLoanDate;

//**首期还款日提醒日期**//
@property(nonatomic,copy)NSString *firstDate;

//**生日提醒是否开启**//
@property(nonatomic,assign)NSInteger openBirthRemind;

//**生日提醒是否开启**//
@property(nonatomic,assign)NSInteger openContinueRemind;

//**生日提醒是否开启**//
@property(nonatomic,assign)NSInteger openFirstRemind;

@end

















