//
//  CRMGuideViewController.m
//  CRM
//
//  Created by mini on 16/8/16.
//  Copyright © 2016年 mini. All rights reserved.
//

#import "ZJGuideViewController.h"

#import "ZJGuideScrollerView.h"

@interface ZJGuideViewController ()

//引导界面scrollerView
//@property(strong,nonatomic) CRMGuideScrollerView *guideScrollerView;

@end

@implementation ZJGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];

}

-(void)setupUI{
    
    NSArray *imageArray = @[@"001.jpg",@"002.jpg",@"003.jpg",@"004.jpg"];
    
    ZJGuideScrollerView *guide = [[ZJGuideScrollerView alloc]init];
    
    [guide guideViewWithFrame:self.view.bounds
              guideImagesName:imageArray];
    
    [self.view addSubview:guide];
    
}


@end
