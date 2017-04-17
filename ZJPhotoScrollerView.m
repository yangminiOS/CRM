//
//  ScrollerView.m
//  照片测试
//
//  Created by mini on 16/9/9.
//  Copyright © 2016年 杨敏. All rights reserved.
//

#import "ZJPhotoScrollerView.h"

@interface ZJPhotoScrollerView ()<UIScrollViewDelegate>

//scrollView
@property(nonatomic,strong) UIScrollView *scrollerView;

//**imgView**//
@property(nonatomic,strong) NSMutableArray *imageViewArray;

//**imagescrollView**//
@property(nonatomic,copy) NSMutableArray *imageScrollerView;

//**删除按钮**//
@property(nonatomic,weak) UIButton *deleButton;
//**当前的imageview**//
@property(nonatomic,strong) UIImageView *contentImageView;

//**移动后的X**//
@property(nonatomic,assign)CGFloat offset;
@end
@implementation ZJPhotoScrollerView

-(NSMutableArray *)imageViewArray{
    if (!_imageViewArray) {
        
        _imageViewArray = [NSMutableArray array];
    }
    
    return _imageViewArray;
}

-(NSMutableArray *)imageScrollerView{
    if (!_imageScrollerView) {
        
        _imageScrollerView = [NSMutableArray array];
    }
    return _imageScrollerView;
}



-(void) clickItemIndex:(NSInteger)index{
    
    
    self.scrollerView.contentOffset = CGPointMake(index*self.width, 0);

 
}

-(instancetype)initWithFrame:(CGRect)frame PhotosArray:(NSMutableArray *)array viewType:(photosViewType)type{
    if (self = [super init]) {
        self.frame = frame;
        
        self.photoViewType = type;
        self.backgroundColor = [UIColor lightGrayColor];

        self.photosArray = array;
        
        [self setupUI];

        
    }
    return self;
}

-(void)setupUI{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTap)];
    
    [self addGestureRecognizer:tap];
    
    CGFloat scrollerY = 0;
    
    if (self.photoViewType == EditType) {
        
        scrollerY = 50;
        
        UIView *topView = [[UIView alloc]init];
        [self addSubview:topView];
        topView.backgroundColor = [UIColor lightGrayColor];
        topView.frame = CGRectMake(0, 20, zjScreenWidth, 30);
        
        //返回按钮
        UIButton *back = [[UIButton alloc]init];
        [topView addSubview:back];
        [back setTitle:@"返回" forState:UIControlStateNormal];
        [back setTitleColor:ZJColorFFFFFF forState:UIControlStateNormal];
        back.frame = CGRectMake(ZJmargin40, 0, 40, 30);
        [back addTarget:self action:@selector(clickBackButton:) forControlEvents:UIControlEventTouchUpInside];
        //删除
        UIButton *dele = [[UIButton alloc]init];
        self.deleButton = dele;
        [topView addSubview:dele];
        [dele setTitle:@"删除" forState:UIControlStateNormal];
        [dele setTitleColor:ZJColorFFFFFF forState:UIControlStateNormal];
        [dele addTarget:self action:@selector(clickDeleButton:) forControlEvents:UIControlEventTouchUpInside];
        [dele zj_changeImageAndTitel];
        dele.x = zjScreenWidth - 60 - ZJmargin40;
        dele.width = 60;
        dele.height = 30;
        
        
    }
    //scroller
    
    self.scrollerView = [[UIScrollView alloc]init];
    [self addSubview:self.scrollerView];
    self.scrollerView.frame = CGRectMake(0, scrollerY, zjScreenWidth, zjScreenHeight-scrollerY);
    self.scrollerView.delegate = self;
    
    NSInteger count = self.photosArray.count;
    
    CGFloat width = self.width;
    
    self.scrollerView.pagingEnabled = YES;
    
    self.scrollerView.contentSize = CGSizeMake(count *width, 0);
    
    for (NSInteger i = 0; i<count; i++) {
        
        UIScrollView *scroV = [[UIScrollView alloc]initWithFrame:CGRectMake(i*width, 0, width, zjScreenHeight-scrollerY)];
        
        scroV.contentSize = CGSizeMake(width, zjScreenHeight-scrollerY);
        scroV.delegate = self;
        scroV.minimumZoomScale = 1.0;
        scroV.maximumZoomScale = 2.5;
        [scroV setZoomScale:1.0];
        UIImageView *imgView = [[UIImageView alloc]init];
        
        
        UIImage *img = self.photosArray[i];
        
        imgView.image = img;
        
        CGFloat imgW = img.size.width;
        
        CGFloat imgH = img.size.height;
        
        imgView.width = width;
        
        imgView.height = (width/imgW)*imgH;
        
        imgView.centerY = self.centerY;
        
        imgView.x = 0;
        
        [scroV addSubview:imgView];
        
        [self.scrollerView addSubview:scroV];
        
        [self.imageViewArray addObject:imgView];
        
        [self.imageScrollerView addObject:scroV];
        
    }
    
    self.contentImageView = self.imageViewArray[0];
    
}


#pragma mark   点击删除
-(void)clickDeleButton:(UIButton *)button{
    
    
    NSInteger  index = self.scrollerView.contentOffset.x/self.width;
    
    UIScrollView *scrollV = [self.imageScrollerView objectAtIndex:index];
    
    
    [self.imageScrollerView removeObjectAtIndex:index];
    
    //删除照片
    [self.photosArray removeObjectAtIndex:index];
    
    [scrollV removeFromSuperview];
    
    scrollV = nil;
    
    
    
    NSInteger count = self.imageScrollerView.count;
    
    for (NSInteger i= index; i<count; i++) {
        
        UIScrollView *scrollimgV = self.imageScrollerView[i];
        
        scrollimgV.x-=self.width;
    }
    
    self.scrollerView.contentSize =CGSizeMake(count *self.width, 0);
    
    if (index == count) {
        
        self.scrollerView.contentOffset = CGPointMake((index-1)*self.width, 0);
        
        
    }else{
        
        self.scrollerView.contentOffset = CGPointMake(index*self.width, 0);
        
    }
    
    if (count == 0) {
        
        [self.delegate ZJPhotoScrollerView:self];
    }
    
    
}

#pragma mark   点击返回

-(void)clickBackButton:(UIButton *)button{
    
    [self.delegate ZJPhotoScrollerView:self];
    
}

#pragma mark   点击视图

-(void)clickTap{
    [self.delegate ZJPhotoScrollerView:self];
}

#pragma mark   scrollerView代理方法
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    for (UIView *v in scrollView.subviews){
        return v;
    }
    return nil;
    //    return self.contentImageView;
    
}
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat offsetX = (scrollView.width>scrollView.contentSize.width)?(scrollView.width - scrollView.contentSize.width)*0.5:0.0;
    CGFloat offsetY = (scrollView.height>scrollView.contentSize.height)?(scrollView.height - scrollView.contentSize.height)*0.5:0.0;
    self.contentImageView.center = CGPointMake(scrollView.contentSize.width*0.5+offsetX, scrollView.contentSize.height*0.5 +offsetY);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    
    if (scrollView == self.scrollerView){
        
        NSInteger index = scrollView.contentOffset.x /zjScreenWidth;
        self.contentImageView = self.imageViewArray[index];
        
        CGFloat x = scrollView.contentOffset.x;
        if (x==_offset){
            
        }
        else {
            _offset = x;
            for (UIScrollView *s in scrollView.subviews){
                if ([s isKindOfClass:[UIScrollView class]]){
                    [s setZoomScale:1.0];
                    for (UIImageView *imgV in self.imageViewArray) {
                        
                        imgV.centerY = self.centerY;
                    }
                }
            }
        }
    }
}



@end
