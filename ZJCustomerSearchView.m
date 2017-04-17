//
//  ZJCustomerSearchView.m
//  CRM
//
//  Created by mini on 16/11/10.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJCustomerSearchView.h"

@interface ZJCustomerSearchView ()<UITextFieldDelegate>



@end

@implementation ZJCustomerSearchView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = ZJRGBColor(220, 220, 220, 0.5);
        [self setupUI];

        
    }
    return self;
}

//设置UI
-(void)setupUI{
    
//    self.mysearch.delegate = self;
    //底部白色的View
    UIView *whiteView = [[UIView alloc]init];
    [self addSubview:whiteView];
    //修正为灰底的View    --mjd
    //whiteView.backgroundColor = ZJColorFFFFFF;
    whiteView.backgroundColor = ZJBackGroundColor;
    whiteView.frame = CGRectMake(0, 0, zjScreenWidth, PX2PT(132));
    
    //使用搜索控件UISearchBar--20161229-mjd
    
    self.mysearch = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, zjScreenWidth, PX2PT(132))];
    [whiteView addSubview: self.mysearch];
    self.mysearch.barTintColor = ZJColorFFFFFF;
    self.mysearch.searchBarStyle = UISearchBarStyleMinimal;
    
    
//    self.mysearch.delegate = self;
    self.mysearch.placeholder = @"可根据：姓名、电话、身份证";
  //  self.mysearch.showsCancelButton = YES;
    
//    for(UIView *searchViews in self.mysearch.subviews){
//        for(UIView *view in searchViews.subviews){
//            if([view isKindOfClass:[UIButton class]]){
//                UIButton *button = (UIButton *)view;
//                [button setTitle:@"取消" forState:UIControlStateNormal];
//                [button setTitleColor:ZJColor505050 forState:UIControlStateNormal];
//                [button setTitleColor:ZJColor505050 forState:UIControlStateHighlighted];
//                button.titleLabel.font = [UIFont systemFontOfSize:15];
//            }
//        }
//    }
 //   [self.mysearch setShowsCancelButton:YES animated:YES];
    /*
    //取消
    UIButton *candelButton = [[UIButton alloc]init];
    [whiteView addSubview:candelButton];
    [candelButton setTitle:@"取消" forState:UIControlStateNormal];
    [candelButton setTitleColor:ZJColor00D3A3 forState:UIControlStateNormal];
    candelButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize55PX];
    candelButton.x = zjScreenWidth - ZJmargin40 -40;
    candelButton.y= 0;
    candelButton.width = 40;
    candelButton.height = PX2PT(132);
    [candelButton addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //图片View
    UIImageView *searchImgView = [[UIImageView alloc]init];
    [whiteView addSubview:searchImgView];
    searchImgView.image = [UIImage imageNamed:@"search_icon"];
    searchImgView.x = ZJmargin40;
    searchImgView.height = PX2PT(90);
    searchImgView.width = zjScreenWidth - PX2PT(138) -40;
    searchImgView.centerY = candelButton.centerY;
    
    //
    self.searchTF = [[UITextField alloc]init];
    [searchImgView addSubview:self.searchTF];
    self.searchTF.delegate = self;
    self.searchTF.returnKeyType = UIReturnKeyGoogle;
    self.searchTF.textColor = ZJRGBColor(180, 180, 180, 1.0);
    self.searchTF.font = [UIFont systemFontOfSize:ZJTextSize35PX];
    self.searchTF.borderStyle = UITextBorderStyleNone;
    self.searchTF.placeholder = @"可根据：姓名、电话、身份证号";
    self.searchTF.x = 30;
    self.searchTF.y = 0;
    self.searchTF.height = searchImgView.height;
    self.searchTF.width = searchImgView.width - 30;
    */
}

//-(void)clickCancelButton:(UIButton *)button{
//    
//    [self.delegate ZJCustomerSearchView:self didClickCancleButton:button];
//}



//#pragma mark   searchBad 代理方法
//-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
//    
// 
//    
//    searchBar.showsCancelButton = YES;
//    for (UIView *searchViews in searchBar.subviews) {
//        for (UIView *view in searchViews.subviews) {
//            //是按钮
//            if ([view isKindOfClass:[UIButton class]]) {
//                UIButton *button = (UIButton *)view;
//                [button setTitle:@"取消" forState:UIControlStateNormal];
//                [button setTitleColor:ZJColor505050 forState:UIControlStateNormal];
//                [button setTitleColor:ZJColor505050 forState:UIControlStateHighlighted];
//                button.titleLabel.font = [UIFont systemFontOfSize:15];
//            }
//        }
//    }
//
//}
//
//-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
//    searchBar.text = nil;
//    
//
//    searchBar.showsCancelButton = NO;
//    
//    [searchBar resignFirstResponder];
//    [self.coverView removeFromSuperview];
//    self.coverView = nil;
//    
//}
//
//-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    
//    searchBar.showsCancelButton = NO;
//    
//    [searchBar resignFirstResponder];
//    [self.coverView removeFromSuperview];
//    self.coverView = nil;
//    
//    
//    NSString *select = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE (cName LIKE '%%%@%%' OR cCardID LIKE '%%%@%%' OR cPhone LIKE '%%%@%%')",ZJCustomerTableName,searchBar.text,searchBar.text,searchBar.text ];
//    
// 
//    //    searchC.enterModel = FirstFollowingModel;
// 
//    searchBar.text = nil;
// 
//}


@end
