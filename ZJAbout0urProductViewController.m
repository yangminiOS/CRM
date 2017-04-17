//
//  ZJAbout0urProductViewController.m
//  CRM
//
//  Created by 蒙建东 on 16/12/11.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJAbout0urProductViewController.h"
#import <WebKit/WebKit.h>
#import <SVProgressHUD.h>
@interface ZJAbout0urProductViewController ()<WKNavigationDelegate>

@end

@implementation ZJAbout0urProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = CGRectMake(0, 0, zjScreenWidth, self.view.height-64);
    
    
    WKWebView *webView = [[WKWebView alloc]initWithFrame:frame];
    webView.navigationDelegate = self;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    NSInteger time = [timeString integerValue];
    NSString *url = [NSString stringWithFormat:@"%@/ServiceAgreement/index.html?=%zd",THEURL,time];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: url]]];
    
    [self.view addSubview:webView];
    
    [SVProgressHUD show];
    
    //菊花样式
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [SVProgressHUD dismiss];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
