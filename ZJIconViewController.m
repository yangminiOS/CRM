//
//  ZJIconViewController.m
//  CRM
//
//  Created by mini on 16/12/3.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJIconViewController.h"
#import <TZImagePickerController.h>//选取照片第三方

@interface ZJIconViewController ()<TZImagePickerControllerDelegate,UIScrollViewDelegate>

//**scroll**//
@property(nonatomic,weak) UIScrollView *scrollView;

//**tupan**//
@property(nonatomic,weak) UIImageView *imageView;

//**是否发生改变**//
@property(nonatomic,assign)BOOL isEdit;
@end

@implementation ZJIconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavi];
    
    [self setupUI];

}

-(void)setupNavi{
    
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationItem.title = @"头像设置";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem zj_BarButtonItemWithButtonItemImage:@"menu" heightLightImage:@"menu" target:self action:@selector(clickIconMoreButton)];

}
-(void)setupUI{
    
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    
    [self.view addSubview:scroll];
    
    self.scrollView = scroll;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator = YES;
    scroll.delegate = self;
    scroll.minimumZoomScale = 0.5;
    
    scroll.maximumZoomScale = 3;
    
    scroll.contentSize = CGSizeMake(zjScreenWidth, self.view.height);
    
    CGFloat width = zjScreenWidth;
    
    UIImageView *imageView = [[UIImageView alloc]init];
    
    imageView.backgroundColor = ZJColor505050;
    
    [scroll addSubview:imageView];
    self.imageView = imageView;
    
    imageView.image = self.iconImg;
    
    CGFloat imgW = self.iconImg.size.width;
    
    CGFloat imgH = self.iconImg.size.height;
    
    imageView.width = width;
    
    imageView.height = (width/imgW)*imgH;
    
    imageView.centerY = scroll.height/2;
}


-(void)clickIconMoreButton{
    
    [self getPictureForIcon];

}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return self.imageView;
    
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    CGFloat offsetX = (scrollView.width>scrollView.contentSize.width)?(scrollView.width - scrollView.contentSize.width)*0.5:0.0;
    CGFloat offsetY = (scrollView.height>scrollView.contentSize.height)?(scrollView.height - scrollView.contentSize.height)*0.5:0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width*0.5+offsetX, scrollView.contentSize.height*0.5 +offsetY);
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (self.isEdit) {
        
        [self.delegate ZJIconViewController:self iconImg:self.retuImg];
    }
    
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    self.isEdit = YES;
    
    self.imageView.image = image;
    
    self.retuImg = image;
}


@end
