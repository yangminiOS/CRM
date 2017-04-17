//
//  ZJNavigationController.m
//  CRM
//
//  Created by mini on 16/8/22.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJNavigationController.h"
#import "UIButton+Cagetory.h"

@interface ZJNavigationController ()



@end

@implementation ZJNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationBar.translucent = NO;
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi"] forBarMetrics:UIBarMetricsDefault];

    [self.navigationBar setShadowImage:[UIImage new]];
}

+(void)initialize{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    
    dict[NSForegroundColorAttributeName] = ZJColorFFFFFF;
    
    UINavigationBar *bar = [UINavigationBar appearance];
        
    [bar setTitleTextAttributes:dict];
}


/**
 *  系统方法  拦截push控制器时加入事件
 */
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count > 0) {
        
//        UIButton*back = [UIButton buttonWithType:UIButtonTypeCustom];
//        
//        back.size = CGSizeMake(70, 30);
//        
//        [back setImage:[UIImage imageNamed:@"Returns--arrow"] forState:UIControlStateNormal];
//        [back setImage:[UIImage imageNamed:@"Returns--arrow"] forState:UIControlStateHighlighted];
//        
//        [back setTitle:@"返回" forState:UIControlStateNormal];
//        
//        [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//        
//        back.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//                
//        back.contentEdgeInsets  = UIEdgeInsetsMake(0, -10, 0, 0);
//        
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:back];
        
        UIButton *back = [UIButton zj_creatDefaultLeftButton];
        
        [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:back];


        viewController.hidesBottomBarWhenPushed = YES;
    }
    

    
    [super pushViewController:viewController animated:animated];
    
    
}


-(void)back{
    
    [self popViewControllerAnimated:YES];
    
}

@end
