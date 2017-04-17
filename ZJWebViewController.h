//
//  ZJWebViewController.h
//  CRM
//
//  Created by mini on 16/12/9.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface ZJWebViewController : UIViewController<WKNavigationDelegate>

//定义一个属性，方便外接调用
@property (nonatomic, strong) WKWebView *webView;

//声明一个方法，外接调用时，只需要传递一个URL即可
- (void)loadHTML:(NSString *)htmlString;

@end
