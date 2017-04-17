//
//  AppDelegate.m
//  CRM
//
//  Created by mini on 16/8/22.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "ZJTabBarController.h"//tabbar
#import "ZJGuideViewController.h"//首次登陆引导界面
#import "ZJFMdb.h"
#import "ZJDirectorie.h"
//网络请求
#import "CartoonUtils.h"
//友盟框架
#import "UMMobClick/MobClick.h"
#import "ZJNotification.h"
//UUID
#import "ZJUUID.h"
//账户登录
#import "ZJLoginViewControllerViewController.h"

//第三方获取当前控制器
#import "NSObject+UIViewController.h"
@interface AppDelegate ()
@property (nonatomic,assign)NSInteger Day;
@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
   //友盟统计
   UMConfigInstance.appKey = @"584a13078f4a9d0ffd0013f8";
   UMConfigInstance.channelId = @"App Store";
   [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    //初始化日历事件库
    self.eventStore = [[EKEventStore alloc]init];
    
    //判断是否是第一次登陆
    
    [self isFirstUsed];
   
    //通知相关事件
      // 设置应用程序的图标右上角的数字
   [application setApplicationIconBadgeNumber:0];
   
   if([[UIDevice currentDevice].systemVersion doubleValue]>=8.0){//8.0以后使用这种方法来注册推送通知
      UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
      [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
      [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
   }else{
      [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
   }

   
    return YES;
}

//第一次使用
-(void)isFirstUsed{
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    //0代表首次登陆
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[defaults objectForKey:@"isGuide"]intValue] == 1) {
        
        ZJTabBarController *TBC = [[ZJTabBarController alloc]init];
        
        self.window.rootViewController = TBC;
        
    }else{
        
        ZJGuideViewController*guide = [[ZJGuideViewController alloc]init];
        
        self.window.rootViewController = guide;

        //创建数据库
        [ZJFMdb creatSqlWithFileName:@"mycrm"];
        //创建表
        [ZJFMdb sqlCreatTableWithName:@"crm_CustomerInfo" tableHead:@"(iAutoID integer not null primary key,cPhotoUrl text,cName text,cFirstAlphabet text,iSex integer,cBirthDay text,cCardID text,cPhone text,fBorrowMoney real,fMonthlyInterest real,cLoanTimeLimit text,cLoanDate text,cCustomerState_Tags text,cCustomerState_Remark text,cCustomerSource_Tags text,cCustomerSource_IntroducerName text,cCustomerSource_IntroducerPhone text,cLoanType_Tags text,cRelatedPhotos text,cCustomerRemark_Text text,cCustomerRemark_VoiceUrl text,iIndustryType integer,cCreateYear text,cCreateMonth texe,cCreateDay text,iSyncType integer,cLastSyncTime text,cOwnerUser text,GUID text,iFrom integer)"];
        
        [ZJFMdb sqlCreatTableWithName:@"crm_FollowUp" tableHead:@"(iAutoID integer not null primary key,iCustomerID interger,cText text,cPhotoUrl text ,cVoiceUrl text,iRemind integer,cRemindTime text,cLogDate text,cLogTime text,cWeekDay text)"];
        
        [ZJFMdb sqlCreatTableWithName:@"crm_Remind" tableHead:@"(iAutoID integer not null primary key,iCustomerID integer,iRemindType integer,cRemindTime text,cRemindDate text,iSwitch integer)"];
        
        [ZJFMdb sqlCreatTableWithName:@"crm_Goal" tableHead:@"(iAutoID integer not null primary key,type text,goalCount integer,completeCount real,tag text,year text)"];
        
        [ZJFMdb sqlCreatTableWithName:@"crm_Gtasks" tableHead:@"(iAutoID integer not null primary key,contentText text,dateString text,timeString text,weekString text,completeOrGtasks integer)"];
        
        [ZJFMdb sqlCreatTableWithName:@"crm_CustomerItems" tableHead:@"(iAutoID integer not null primary key,type text,itemString text,delect integer)"];
        
        //创建文件夹
        [ZJDirectorie crecteRootDirectoryWithPath:ZJDocumentPath];
       
              //进行数据投递
              UIDevice *device = [[UIDevice alloc]init];
              NSString *name = device.name;
       
              NSString *identifierForVendor = [ZJUUID getUUID];
              NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
              // app版本
              NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
              [CartoonUtils requestWithDatadeliveryType:@"boot" andMeid:identifierForVendor andName:name andSource:@"apple" andVersion:app_Version andIsfirst:@"1"];
    }
    
    [self.window makeKeyAndVisible];
}

//进入通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
   
   [application setApplicationIconBadgeNumber:0];

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
//进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {

   //获取当前时间
   NSDate *date = [NSDate new];
   NSInteger day = [date zj_getRealTimeForRequire:NSCalendarUnitDay];
   
   self.Day = day;
   [ZJNotification isAddLocalNotification];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   
   [application setApplicationIconBadgeNumber:0];

   
   //利用TOKEN值进行登录
   UIDevice *device = [[UIDevice alloc]init];
   NSString *name = device.name;
   NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
   NSString *identifierForVendor = [ZJUUID getUUID];
   NSString *Token = [ud stringForKey:@"TOKEN"];
   if (Token != NULL) {
      __weak __typeof(self) weakself=self;
      [CartoonUtils requestWithToken:Token andDevice:name andMeid:identifierForVendor andCallback:^(id obj) {
         NSString *str = obj;
         if (str != NULL) {
            
            [ud removeObjectForKey:@"TOKEN"];
            [ud synchronize];
            [weakself.fl_viewController.navigationController pushViewController:[[ZJLoginViewControllerViewController alloc]init] animated:YES];
         }
      }];
   }
   
      NSDate *date = [NSDate new];
      NSInteger day = [date zj_getRealTimeForRequire:NSCalendarUnitDay];
      
      if (self.Day != day) {
         //进行数据投递
         UIDevice *device = [[UIDevice alloc]init];
         NSString *name = device.name;
   
         NSString *identifierForVendor = [ZJUUID getUUID];
         NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
         // app版本
         NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
         [CartoonUtils requestWithDatadeliveryType:@"boot" andMeid:identifierForVendor andName:name andSource:@"apple" andVersion:app_Version andIsfirst:@"0"];
      }

}


//杀死进程
- (void)applicationWillTerminate:(UIApplication *)application {

   
   [ZJNotification isAddLocalNotification];

}

@end
