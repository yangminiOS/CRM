//
//  ZJGeneralize ViewController.m
//  CRM
//
//  Created by mini on 16/11/10.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJGeneralizeViewController.h"
#import <SVProgressHUD.h>


@interface ZJGeneralizeViewController ()

@end

@implementation ZJGeneralizeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    NSString *url = [NSString stringWithFormat:@"%@/crm/weixin/QutuList.php?type=1&px=date",THEURL];
    
//    self.webView.delegate = self;
    [self loadHTML:url];
    

    
}

-(void)setupNavi{
    self.navigationItem.title = @"展业海报";
}

@end
