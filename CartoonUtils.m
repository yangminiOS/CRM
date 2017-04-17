//
//  CartoonUtils.m
//  CRM
//
//  Created by 蒙建东 on 16/11/30.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "CartoonUtils.h"
#import "AFNetworking.h"
#import "AESCrypt.h"
#import "ZJUser.h"

@implementation CartoonUtils

//发送验证码
+(void)requestWithAnimation:(NSString *)animation andType:(NSString *)type andCallback:(MyCallback)callback{
    NSString *path = [NSString stringWithFormat:@"%@/crm/interface/fun_SendSmsCode.php",THEURL];
    NSString *message = [NSString stringWithFormat:@"phone=%@&type=%@",animation,type];
    NSString *password = CIPHER;
    NSString *encryptedData = [AESCrypt encrypt:message password:password];
    NSString *Ecode = [encryptedData encodeString];
    NSDictionary *params = @{@"params":Ecode};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;

    [manager POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData* data=[str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict =[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

        //对返回的网络参数进行分析
        NSString *temp =   [CartoonUtils ReturnsParameter:dict];
        callback(temp);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       // NSLog(@"请求失败：%@",error);
        NSString *error1 = @"网络异常，请稍后重试";
        callback(error1);
    }];
}

//注册新用户
+(void)requestWithRegistered:(NSString *)Registered andPhone:(NSString *)Phone andCity:(NSString *)City andPassword:(NSString *)Password andCallback:(MyCallback)callback{
  //  getMd5_32Bit
    NSString *Md5 = [[NSString alloc]init];
    NSString *str = [Md5 zj_getMd5_32Bit:Password];
   
    NSString *path = [NSString stringWithFormat:@"%@/crm/interface/user_RegisterUserToken.php",THEURL];
    NSString *message = [NSString stringWithFormat:@"phone=%@&smscode=%@&city=%@&pwd=%@",Phone,Registered,City,str];
    
    NSString *password = CIPHER;
    NSString *encryptedData = [AESCrypt encrypt:message password:password];
    NSString *Ecode = [encryptedData encodeString];
    NSDictionary *params = @{@"params":Ecode};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    [manager POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData* data=[str dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (dic == NULL) {
            NSString *error = @"网络异常，请稍后重试";
            callback(error);
        }else {
            NSString *code = dic[@"code"];
            if ([code isEqualToString:@"0000"]) {
                NSString *temp = NULL;
                callback(temp);
            }else {
                NSString *msg = dic [@"msg"];
                callback(msg);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *error1 = @"网络异常，请稍后重试";
        callback(error1);

    }];

}
//短信验证码登陆
+(void)requestWithPhone:(NSString *)Phone andPassword:(NSString *)Password andDevicename:(NSString *) devicename andMeid:(NSString *) meid andCallback:(MyCallback)callback{
    
    NSString *path = [NSString stringWithFormat:@"%@/crm/interface/user_LoginBySms.php",THEURL];
   
    NSString *message = [NSString stringWithFormat:@"phone=%@&smscode=%@&devicename=%@&meid=%@",Phone,Password,devicename,meid];
    NSString *password = CIPHER;
    NSString *encryptedData = [AESCrypt encrypt:message password:password];
    
    NSString *Ecode = [encryptedData encodeString];

    NSDictionary *params = @{@"params":Ecode};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    [manager POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData* data=[str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (dic == NULL) {
            NSString *error = @"网络异常，请稍后重试";
            callback(error);
        }else {
            NSString *code = dic[@"code"];
            if ([code isEqualToString:@"0000"]) {
                ZJUser *User = [ZJUser shareUser];
                User.Phone = dic[@"phone"];
                User.Name = dic[@"name"];
                User.Sex = dic[@"sex"];
                User.City = dic[@"city"];
                //NSString *str = [NSString stringWithFormat:@"%@",dic[@"photourl"]];
                User.Head = dic[@"photourl"];
                User.Logintype = dic[@"tokentype"];
                NSString *documentsPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/ZJHAOKE"];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:User];
                [data writeToFile:documentsPath atomically:YES];
                
                //存储Token到本地
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *token = dic[@"token"];
                [userDefaults setObject:token forKey:@"TOKEN"];
                [userDefaults synchronize];
                
                NSString *temp = @"1111111";
                callback(temp);
            }else {
                NSString *msg = dic[@"msg"];
                callback(msg);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSString *error1 = @"网络异常，请稍后重试";
        callback(error1);
    }];

}


//账户密码登陆
+(void)requestWithPasswordLoginPhone:(NSString *)Phone andPassword:(NSString *)Password andDevicename:(NSString *) devicename andMeid:(NSString *) meid andCallback:(MyCallback)callback{
    NSString *Md5 = [[NSString alloc]init];
    NSString *str = [Md5 zj_getMd5_32Bit:Password];
    
    NSString *path = [NSString stringWithFormat:@"%@/crm/interface/user_Login.php",THEURL];
    
    NSString *message = [NSString stringWithFormat:@"uname=%@&upwd=%@&devicename=%@&meid=%@",Phone,str,devicename,meid];
    
    NSString *password = CIPHER;
    
    NSString *encryptedData = [AESCrypt encrypt:message password:password];
    NSString *Ecode = [encryptedData encodeString];
   
    NSDictionary *params = @{@"params":Ecode};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    [manager POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData* data=[str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if (dic == NULL) {
            NSString *error = @"网络异常，请稍后重试";
            callback(error);
        }else {
            NSString *code = dic[@"code"];
            if ([code isEqualToString:@"0000"]) {
                
                ZJUser *User = [ZJUser shareUser];
               
                User.Name = dic[@"name"];
                User.Sex = dic[@"sex"];
                
                User.City = dic[@"city"];
                User.Phone = dic[@"phone"];
                //THEURL
                User.Head = dic[@"photourl"];
                NSString *documentsPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/ZJHAOKE"];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:User];
                [data writeToFile:documentsPath atomically:YES];
                
                //存储Token到本地
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *token = dic[@"token"];
               
                [userDefaults setObject:token forKey:@"TOKEN"];
                [userDefaults synchronize];
                NSString *temp = NULL;
                callback(temp);
            }else {
                NSString *msg = dic[@"msg"];
                callback(msg);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *error1 = @"网络异常，请稍后重试";
        callback(error1);
    }];

}

//修改密码
+(void)requestWithModifythe:(NSString *)Phone andSmscode:(NSString *)Code andPassword:(NSString *) Password andToken:(NSString *) token andMeid:(NSString *) meid andCallback:(MyCallback)callback{
    //  getMd5_32Bit
    NSString *Md5 = [[NSString alloc]init];
    NSString *str = [Md5 zj_getMd5_32Bit:Password];
    
    NSString *path = [NSString stringWithFormat:@"%@/crm/interface/user_ChangePwd.php",THEURL];
    
    NSString *message = [NSString stringWithFormat:@"phone=%@&smscode=%@&pwd=%@&token=%@&meid=%@",Phone,Code,str,token,meid];
    NSString *password = CIPHER;
    NSString *encryptedData = [AESCrypt encrypt:message password:password];
    NSString *Ecode = [encryptedData encodeString];

    NSDictionary *params = @{@"params":Ecode};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    [manager POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData* data=[str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        //对返回的网络参数进行分析
        NSString *temp =   [CartoonUtils ReturnsParameter:dic];
        callback(temp);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *error1 = @"网络异常，请稍后重试";
        callback(error1);

    }];
}

//修改个人资料
+(void)requestWithModifyUser:(NSString *)user andType:(NSString *)type andToken:(NSString *) token andMeid:(NSString *)meid andCallback:(MyCallback)callback{
    NSString *path = [NSString stringWithFormat:@"%@/crm/interface/user_UpdateUserInfo.php",THEURL];
    
    NSString *message = [NSString stringWithFormat:@"type=%@&value=%@&token=%@&meid=%@",type,user,token,meid];
    NSString *password = CIPHER;
    NSString *encryptedData = [AESCrypt encrypt:message password:password];
    NSString *Ecode = [encryptedData encodeString];

    NSDictionary *params = @{@"params":Ecode};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    [manager POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData* data=[str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
       
        //对返回的网络参数进行分析
     NSString *temp =   [CartoonUtils ReturnsParameter:dic];
        callback(temp);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       // NSLog(@"请求失败：%@",error);
        NSString *error1 = @"网络异常，请稍后重试";
        callback(error1);
    }];
}


//更换手机号
+(void)requestWithReplacePhone:(NSString *) phone andVerification:(NSString *)verification andToken:(NSString *) token andMeid:(NSString *)meid andCallback:(MyCallback)callback{
    
    NSString *path = [NSString stringWithFormat:@"%@/crm/interface/user_UpdatePhone.php",THEURL];
    
    NSString *message = [NSString stringWithFormat:@"newphone=%@&smscode=%@&token=%@&meid=%@",phone,verification,token,meid];
    NSString *password = CIPHER;
    NSString *encryptedData = [AESCrypt encrypt:message password:password];
    
    NSString *Ecode = [encryptedData encodeString];

    NSDictionary *params = @{@"params":Ecode};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    [manager POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData* data=[str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        //对返回的网络参数进行分析
        NSString *temp =   [CartoonUtils ReturnsParameter:dic];
        callback(temp);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *error1 = @"网络异常，请稍后重试";
        callback(error1);

    }];
}
// 注销登陆
+(void)requestWithThecanToken:(NSString *) token andMeid:(NSString *)meid andCallback:(MyCallback)callback{
  
    NSString *path = [NSString stringWithFormat:@"%@/crm/interface/user_LoginOut.php",THEURL];
    NSString *message = [NSString stringWithFormat:@"token=%@&meid=%@",token,meid];
    NSString *password = CIPHER;
    NSString *encryptedData = [AESCrypt encrypt:message password:password];
    NSString *Ecode = [encryptedData encodeString];

    NSDictionary *params = @{@"params":Ecode};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    [manager POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData* data=[str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (dic == NULL) {
            NSString *error = @"网络异常，请稍后重试";
            callback(error);
        }else {
            NSString *code = dic[@"code"];
            if ([code isEqualToString:@"0000"]) {
                
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud removeObjectForKey:@"TOKEN"];
                [ud synchronize];
                
                NSString *temp = NULL;
                callback(temp);
            }else if([code isEqualToString:@"1023"]){
                callback(code);
                return ;
            }else{
                NSString *msg = dic[@"msg"];
                callback(msg);
            }
        }

//        //对返回的网络参数进行分析
//        NSString *temp =   [CartoonUtils ReturnsParameter:dic];
//        callback(temp);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"请求失败：%@",error);
        NSString *error1 = @"网络异常，请稍后重试";
        callback(error1);
    }];
}

// 找回密码
+(void)requestWithRetrievepasswordPhone:(NSString *) phone andSmscode:(NSString *) token andPwd:(NSString *)pwd andCallback:(MyCallback)callback{
    //  getMd5_32Bit
    NSString *Md5 = [[NSString alloc]init];
    NSString *str = [Md5 zj_getMd5_32Bit:pwd];
    NSString *path = [NSString stringWithFormat:@"%@/crm/interface/user_FindUserPwd.php",THEURL];
    NSString *message = [NSString stringWithFormat:@"phone=%@&smscode=%@&pwd=%@",phone,token,str];
    NSString *password = CIPHER;
    NSString *encryptedData = [AESCrypt encrypt:message password:password];
    NSString *Ecode = [encryptedData encodeString];

    NSDictionary *params = @{@"params":Ecode};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    [manager POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData* data=[str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        //对返回的网络参数进行分析
        NSString *temp =   [CartoonUtils ReturnsParameter:dic];
        callback(temp);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *error1 = @"网络异常，请稍后重试";
        callback(error1);

    }];
}
// Token登陆
+(void)requestWithToken:(NSString *)token andDevice:(NSString *)device andMeid:(NSString *)meid andCallback:(MyCallback)callback{
    NSString *path = [NSString stringWithFormat:@"%@/crm/interface/user_LoginByToken.php",THEURL];
    NSString *message = [NSString stringWithFormat:@"token=%@&devicename=%@&meid=%@",token,device,meid];
    NSString *password = CIPHER;
    NSString *encryptedData = [AESCrypt encrypt:message password:password];
    NSString *Ecode = [encryptedData encodeString];

    NSDictionary *params = @{@"params":Ecode};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    [manager POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData* data=[str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if (dic == NULL) {
            NSFileManager * fileManager = [[NSFileManager alloc]init];
            NSString *documentsPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/ZJHAOKE"];
            [fileManager removeItemAtPath:documentsPath error:nil];
        }else {
            NSString *code = dic[@"code"];
            if ([code isEqualToString:@"0000"]) {
                
                //更新归档对象中取出用户的信息
                NSString *documentsPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/ZJHAOKE"];
                NSData *data = [NSData dataWithContentsOfFile:documentsPath];
                ZJUser * User = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                User.Phone = dic[@"phone"];
                User.Name = dic[@"name"];
                User.Sex = dic[@"sex"];
                User.City = dic[@"city"];
                NSString *str = [NSString stringWithFormat:@"%@",dic[@"photourl"]];
                User.Head = str;
                NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:User];
                [data1 writeToFile:documentsPath atomically:YES];
                
                NSString *temp = NULL;
                callback(temp);
            }else {
                NSString *error = dic[@"msg"];
                callback(error);
                NSFileManager * fileManager = [NSFileManager defaultManager];
                NSString *documentsPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/ZJHAOKE"];
                [fileManager removeItemAtPath:documentsPath error:nil];
                
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *error1 = @"网络异常，请稍后重试";
        callback(error1);
    }];
}


//数据投递
+(void)requestWithDatadeliveryType:(NSString *)type andMeid:(NSString *)meid andName:(NSString *)name andSource:(NSString *)soure andVersion:(NSString *)version andIsfirst:(NSString *)isfirst{

    NSString *message = [NSString stringWithFormat:@"type=%@&meid=%@&name=%@&source=%@&version=%@&isfirst=%@",type,meid,name,soure,version,isfirst];
    NSString *password = CIPHER;
    NSString *encryptedData = [AESCrypt encrypt:message password:password];
    NSString *Ecode = [encryptedData encodeString];
    NSString *path = [NSString stringWithFormat:@"%@/crm/interface/postdata/postdata.php?params=%@",THEURL,Ecode];
   // NSDictionary *params = @{@"params":Ecode};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    [manager GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    } failure:nil];
    
}

//判断返回值参数
+ (NSString *)ReturnsParameter:(NSDictionary *)dict{
    
    if (dict == NULL) {
        NSString *error = @"网络异常，请稍后重试";
        return error;
    }else {
        NSString *code = dict[@"code"];
        if ([code isEqualToString:@"0000"]) {
            NSString *temp = NULL;
            return temp;
        }else if([code isEqualToString:@"1023"]){
            //token错误
            NSString *temp = @"token错误，请重新登录";
            NSFileManager * fileManager = [NSFileManager defaultManager];
            NSString *documentsPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/ZJHAOKE"];
            [fileManager removeItemAtPath:documentsPath error:nil];
            return temp;
        }else{
            NSString *msg = dict[@"msg"];
            return msg;
        }
    
    }
}
@end
