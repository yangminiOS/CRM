//
//  CartoonUtils.h
//  CRM
//
//  Created by 蒙建东 on 16/11/30.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^MyCallback)(id obj);
@interface CartoonUtils : NSObject

//发送验证码
+(void)requestWithAnimation:(NSString *)animation andType:(NSString *)type andCallback:(MyCallback)callback;
//注册
+(void)requestWithRegistered:(NSString *)Registered andPhone:(NSString *)Phone andCity:(NSString *)City andPassword:(NSString *)Password andCallback:(MyCallback)callback;
//短信登陆
+(void)requestWithPhone:(NSString *)Phone andPassword:(NSString *)Password andDevicename:(NSString *) devicename andMeid:(NSString *) meid andCallback:(MyCallback)callback;
//账户登陆
+(void)requestWithPasswordLoginPhone:(NSString *)Phone andPassword:(NSString *)Password andDevicename:(NSString *) devicename andMeid:(NSString *) meid andCallback:(MyCallback)callback;
//修改密码
+(void)requestWithModifythe:(NSString *)Phone andSmscode:(NSString *)Code andPassword:(NSString *) Password andToken:(NSString *) token andMeid:(NSString *) meid andCallback:(MyCallback)callback;
//修改个人资料
+(void)requestWithModifyUser:(NSString *)user andType:(NSString *)type andToken:(NSString *) token andMeid:(NSString *)meid andCallback:(MyCallback)callback;

//更换手机号
+(void)requestWithReplacePhone:(NSString *) phone andVerification:(NSString *)verification andToken:(NSString *) token andMeid:(NSString *)meid andCallback:(MyCallback)callback;
// 注销登陆
+(void)requestWithThecanToken:(NSString *) token andMeid:(NSString *)meid andCallback:(MyCallback)callback;
// 找回密码
+(void)requestWithRetrievepasswordPhone:(NSString *) phone andSmscode:(NSString *) token andPwd:(NSString *)pwd andCallback:(MyCallback)callback;
// Token登陆
+(void)requestWithToken:(NSString *)token andDevice:(NSString *)device andMeid:(NSString *)meid andCallback:(MyCallback)callback;

//数据投递
+(void)requestWithDatadeliveryType:(NSString *)type andMeid:(NSString *)meid andName:(NSString *)name andSource:(NSString *)soure andVersion:(NSString *)version andIsfirst:(NSString *)isfirst;
@end
