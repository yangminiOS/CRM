//
//  ZJWebViewController.m
//  CRM
//
//  Created by mini on 16/12/9.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJWebViewController.h"

#import <AFNetworking.h>

#import <SVProgressHUD.h>

@interface ZJWebViewController ()

@property (nonatomic, strong) NSURLRequest *request;
//判断是否是HTTPS的
@property (nonatomic, assign) BOOL isAuthed;

//返回按钮
@property (nonatomic, strong) UIBarButtonItem *backItem;
//关闭按钮
@property (nonatomic, strong) UIBarButtonItem *closeItem;

//**<#注释#>**//
@property(nonatomic,strong) AFNetworkReachabilityManager *manger;
@end

@implementation ZJWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.view addSubview:self.webView];
    self.webView.navigationDelegate = self;
    [self addLeftButton];

    //监听网络

    _manger = [AFNetworkReachabilityManager sharedManager];
    
    [_manger startMonitoring];
    
    [_manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status ==AFNetworkReachabilityStatusNotReachable) {
            [SVProgressHUD showErrorWithStatus:@"亲，您的网络开小差了~"];
        }else{
            
            [SVProgressHUD show];
            [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//加载URL
- (void)loadHTML:(NSString *)htmlString
{
    self.request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:htmlString]];
    [self.webView loadRequest:self.request];
}
//开始加载
- (BOOL)webView:(UIWebView *)awebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* scheme = [[request URL] scheme];
    //判断是不是https
    if ([scheme isEqualToString:@"https"]) {
        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
        if (!self.isAuthed) {
            NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [conn start];
            [awebView stopLoading];
            return NO;
        }
    }
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.isAuthed = YES;
    //webview 重新加载请求。
    [self.webView loadRequest:self.request];
    [connection cancel];
}
#pragma mark - 添加关闭按钮

- (void)addLeftButton
{
    self.navigationItem.leftBarButtonItem = self.backItem;
}

//点击返回的方法
- (void)backNative
{
    //判断是否有上一层H5页面
    if ([self.webView canGoBack]) {
        //如果有则返回
        [self.webView goBack];
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
    } else {
        [self closeNative];
    }
}

//关闭H5页面，直接回到原生页面
- (void)closeNative
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] init];
        

        UIButton*back = [UIButton buttonWithType:UIButtonTypeCustom];
        
        back.size = CGSizeMake(60, 30);
        
        [back setImage:[UIImage imageNamed:@"Returns--arrow"] forState:UIControlStateNormal];
        [back setImage:[UIImage imageNamed:@"Returns--arrow"] forState:UIControlStateHighlighted];
        
        [back setTitle:@"返回" forState:UIControlStateNormal];
        
        back.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        back.contentEdgeInsets  = UIEdgeInsetsMake(0, -10, 0, 0);
        
        [back addTarget:self action:@selector(backNative) forControlEvents:UIControlEventTouchUpInside];


        _backItem.customView = back;
    }
    return _backItem;
}

- (UIBarButtonItem *)closeItem
{
    if (!_closeItem) {
        _closeItem = [[UIBarButtonItem alloc] init];

        UIButton*close = [UIButton buttonWithType:UIButtonTypeCustom];
        
        close.size = CGSizeMake(50, 30);
        close.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [close setTitle:@"关闭" forState:UIControlStateNormal];
        
        [close addTarget:self action:@selector(closeNative) forControlEvents:UIControlEventTouchUpInside];
        
        _closeItem.customView = close;
    

//        _closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeNative)];
    }
    return _closeItem;
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{

}

//-(void)webViewDidStartLoad:(UIWebView *)webView{
//    
//
//    
//}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [SVProgressHUD dismiss];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
    [self.manger stopMonitoring];
}
@end
