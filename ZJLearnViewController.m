//
//  ZJLearnViewController.m
//  CRM
//
//  Created by mini on 16/11/10.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJLearnViewController.h"
#import <SVProgressHUD.h>

@interface ZJLearnViewController ()

@end

@implementation ZJLearnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    
     NSString *url = [NSString stringWithFormat:@"%@/crm/weixin/ArticleList.php",THEURL];

//    self.webView.delegate = self;
    [self loadHTML:url];
    
    
}
-(void)setupNavi{
    
    self.navigationItem.title = @"精选干货";
}

@end
