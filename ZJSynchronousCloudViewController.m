//
//  ZJSynchronousCloudViewController.m
//  CRM
//
//  Created by 蒙建东 on 16/12/7.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJSynchronousCloudViewController.h"

@interface ZJSynchronousCloudViewController ()

@end

@implementation ZJSynchronousCloudViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"云同步";
    self.view.backgroundColor = ZJBackGroundColor;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(zjScreenWidth - PX2PT(902) - PX2PT(180), PX2PT(100), PX2PT(929), PX2PT(902))];
    
    imageView.image = [UIImage imageNamed:@"程序猿正在玩命开发中"];
    [self.view addSubview:imageView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
