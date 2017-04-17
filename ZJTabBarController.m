//
//  MainViewController.m
//  SinaWeibo
//
//  Created by user on 15/10/13.
//  Copyright © 2015年 ZT. All rights reserved.
//

#import "ZJTabBarController.h"
#import "ZJNavigationController.h"

//*****

#import "ZJHomePageViewController.h"//首页
#import "ZJCustomerViewController.h"//客户
#import "ZJAddMsgViewController.h"//加号
#import "ZJAnalyzeViewController.h"//分析
#import "ZJMainTableViewController.h"//我
#import "ZJLoanCustonerController.h"
#import "ZJCustomerTabBar.h"

@interface ZJTabBarController () <ZJCustomerTabBarDelegate>

@end

@implementation ZJTabBarController

+(void)initialize{
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    
    attrs[NSForegroundColorAttributeName] =[UIColor whiteColor];
    
    NSMutableDictionary *selecteAttrs = [NSMutableDictionary dictionary];
    
    selecteAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    
    selecteAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    UITabBarItem *itme = [UITabBarItem appearance];
    
    
    [itme setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
    [itme setTitleTextAttributes:selecteAttrs forState:UIControlStateSelected];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZJHomePageViewController *homePage = [[ZJHomePageViewController alloc]init];
    
    [self addChildViewController:homePage
                       imageName:@"home-page"
               selectedImageName:@"home-page_2"
                           title:@"首页"];
    
    ZJCustomerViewController *customer = [[ZJCustomerViewController alloc]init];
    customer.enterModel = CustomerModel;
    [self addChildViewController:customer
                       imageName:@"User-Icon"
               selectedImageName:@"User-Icon_2"
                           title:@"客户"];
    
    ZJAnalyzeViewController *study = [[ZJAnalyzeViewController alloc]init];
    
    [self addChildViewController:study
                       imageName:@"analyze"
               selectedImageName:@"analyze_2"
                           title:@"分析"];
    
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    
    ZJMainTableViewController *main =  [story instantiateViewControllerWithIdentifier:@"login"];
    
    [self addChildViewController:main
                       imageName:@"me"
               selectedImageName:@"me_2"
                           title:@"我"];
    
    ZJCustomerTabBar *tabBar = [[ZJCustomerTabBar alloc] init];
    tabBar.delegate = self;
    // KVC：如果要修系统的某些属性，但被设为readOnly，就是用KVC，即setValue：forKey：。
    [self setValue:tabBar forKey:@"tabBar"];
    
    self.tabBar.barTintColor = ZJColor00D3A3;

}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字(可以设置tabBar和navigationBar的文字)
    childVc.title = title;
    
    // 设置子控制器的tabBarItem图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    // 禁用图片渲染
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]} forState:UIControlStateSelected];
//    childVc.view.backgroundColor = RandomColor; // 这句代码会自动加载主页，消息，发现，我四个控制器的view，但是view要在我们用的时候去提前加载
    
    // 为子控制器包装导航控制器
    ZJNavigationController *navigationVc = [[ZJNavigationController alloc] initWithRootViewController:childVc];
    // 添加子控制器
    [self addChildViewController:navigationVc];
}

-(void)addChildViewController:(UIViewController *)childController imageName:(NSString *)name selectedImageName:(NSString*)selectedName title:(NSString*)title{
    
    childController.tabBarItem.image = [[UIImage imageNamed:name]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    childController.tabBarItem.title = title;
    
    ZJNavigationController *navi = [[ZJNavigationController alloc]initWithRootViewController:childController];
    
    [self addChildViewController:navi];
}

#pragma ZTTabBarDelegate
/**
 *  加号按钮点击
 */
- (void)tabBarDidClickPlusButton:(ZJCustomerTabBar *)tabBar
{
    ZJLoanCustonerController *loanC = [[ZJLoanCustonerController alloc]init];
    ZJNavigationController *loanCustomerNavi = [[ZJNavigationController alloc]initWithRootViewController:loanC];
    [self presentViewController:loanCustomerNavi animated:YES completion:nil];
}

@end
