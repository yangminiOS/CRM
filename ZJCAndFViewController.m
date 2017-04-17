//
//  ZJCAndFViewController.m
//  CRM
//
//  Created by mini on 16/11/10.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJCAndFViewController.h"
#import "ZJrankView.h"
#import "ZJFirstAndContiueCell.h"
#import "ZJcustomerTableInfo.h"
#import "ZJRemindTableInfo.h"
#import "ZJcustomerTableInfo.h"
#import "ZJFMdb.h"
#import "ZJCustomerInfoViewController.h"

@interface ZJCAndFViewController ()<ZJrankViewDelegate,UITableViewDelegate,UITableViewDataSource,ZJFirstAndContiueCellDelegate,UITextFieldDelegate,UIScrollViewDelegate,UISearchBarDelegate>

@property(nonatomic,strong) UITextField *searchTF;
//**排序按钮**//
@property(nonatomic,weak) UIButton *rankButton;

//**排序视图**//
@property(nonatomic,weak) ZJrankView *rankView;

//**tableView**//
@property(nonatomic,weak) UITableView *tableView;

//**选中的排序row**//
@property(nonatomic,assign)NSInteger rankRow;
//**数据模型**//
@property(nonatomic,strong) NSMutableArray *CdataArray;

//**数据模型**//
@property(nonatomic,strong) NSMutableArray *remindDataArray;

//**搜索展位图**//
@property(nonatomic,strong) UIImageView *holdPlaceImgV;


@end

static NSString *identifier = @"CAndFCell";

@implementation ZJCAndFViewController

-(NSMutableArray *)CdataArray{
    if (!_CdataArray) {
        
        _CdataArray = [NSMutableArray array];
    }
    return _CdataArray;
}

-(NSMutableArray *)remindDataArray{
    if (!_remindDataArray) {
        
        _remindDataArray = [NSMutableArray array];
    }
    return _remindDataArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self remindDataFromSql];
    [self setPlaceImage];


}

-(UIImageView *)holdPlaceImgV{
    if (!_holdPlaceImgV) {
        
        _holdPlaceImgV = [[UIImageView alloc]init];
        [self.view addSubview:_holdPlaceImgV];
    }
    return _holdPlaceImgV;
}

- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    [self setupNavi];
    [self setupTopView];
    [self setupTableView];

}
#pragma mark   站位图片
-(void)setPlaceImage{
    
    UIImageView *imgV = nil;
    
    if (self.ViewType == NSContinueViewController&&self.CdataArray.count==0) {
        
        imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"无续贷提醒"]];
        
        imgV.center = self.view.center;
        
        [self.view addSubview:imgV];
        
    }else if (self.ViewType == NSFirstViewController&&self.CdataArray.count==0){
        imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"首期还款日提醒"]];
        
        imgV.center = self.view.center;
        
        [self.view addSubview:imgV];
        
    }
    
}
#pragma mark   设置导航栏
-(void)setupNavi{
    self.view.backgroundColor = ZJColorFFFFFF;
}
#pragma mark   设置顶部视图
-(void)setupTopView{
    CGFloat height = PX2PT(132);

    //底部白色的View
    UIView *whiteView = [[UIView alloc]init];
    [self.view addSubview:whiteView];
    whiteView.backgroundColor = ZJColorFFFFFF;
    whiteView.frame = CGRectMake(0, 0, zjScreenWidth, height);
    //排序
    UIButton *rank = [[UIButton alloc]init];
    [whiteView addSubview:rank];
    self.rankButton = rank;
    [rank setTitle:@"排序"
          forState:UIControlStateNormal];
    rank.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    [rank setTitleColor:ZJColor505050
               forState:UIControlStateNormal];
    [rank setTitleColor:ZJColor00D3A3
               forState:UIControlStateSelected];
    [rank setImage:[UIImage imageNamed:@"An-arrow_505050"]
          forState:UIControlStateNormal];
    [rank setImage:[UIImage imageNamed:@"Contraction-arrow"]
     
          forState:UIControlStateSelected];
    rank.frame = CGRectMake(0, 0, PX2PT(256), height);
    [rank zj_changeImageAndTitel];
    [rank addTarget:self
             action:@selector(clickRankButton:)
   forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc]init];
    [rank addSubview:line];
    line.backgroundColor = ZJColorDCDCDC;
    line.frame = CGRectMake(rank.width -1, 5, 1, rank.height-10);
    
    
    //使用搜索控件UISearchBar --20161229-mjd
    
    self.mysearch = [[UISearchBar alloc]initWithFrame:CGRectMake(PX2PT(270), 0, zjScreenWidth - ZJmargin40 - PX2PT(270), height)];
    [whiteView addSubview: self.mysearch];
    self.mysearch.barTintColor = ZJColorFFFFFF;
    self.mysearch.searchBarStyle = UISearchBarStyleMinimal;
    self.mysearch.delegate = self;
    self.mysearch.placeholder = @"可根据：姓名、电话、身份证";
//    self.mysearch.showsCancelButton = YES;
//    
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
//    [self.mysearch setShowsCancelButton:YES animated:YES];
//    
   
//    
//    //搜索
//    UIButton *candelButton = [[UIButton alloc]init];
//    [whiteView addSubview:candelButton];
//    [candelButton setTitle:@"搜索" forState:UIControlStateNormal];
//    [candelButton setTitleColor:ZJColor505050 forState:UIControlStateNormal];
//    candelButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize55PX];
//    candelButton.x = zjScreenWidth - ZJmargin40 -40;
//    candelButton.y= 0;
//    candelButton.width = 40;
//    candelButton.height = height;
//    [candelButton addTarget:self action:@selector(clickSearchButton:) forControlEvents:UIControlEventTouchUpInside];
//    
//    //图片View
//    UIImageView *searchImgView = [[UIImageView alloc]init ];
//    searchImgView.image = [UIImage imageNamed:@"first_search_icon"];
//    
//    [whiteView addSubview:searchImgView];
//    searchImgView.height = searchImgView.image.size.height;
//    searchImgView.width = candelButton.x - PX2PT(270);
//    searchImgView.x = PX2PT(270);
//    searchImgView.centerY =candelButton.centerY;
//    searchImgView.userInteractionEnabled = YES;
//        //
//    self.searchTF = [[UITextField alloc]init];
//    self.searchTF.delegate = self;
//    [searchImgView addSubview:self.searchTF];
//    self.searchTF.textColor = ZJRGBColor(180, 180, 180, 1.0);
//    self.searchTF.font = [UIFont systemFontOfSize:ZJTextSize35PX];
//    self.searchTF.returnKeyType = UIReturnKeyGoogle;
//    self.searchTF.borderStyle = UITextBorderStyleNone;
//    self.searchTF.placeholder = @"根据姓名、电话、身份证号、标签搜索";
//    self.searchTF.x = 30;
//    self.searchTF.y = 0;
//    self.searchTF.height = searchImgView.height;
//    self.searchTF.width = searchImgView.width - 30;
    
    //分割性
    UIView *downline = [[UIView alloc]init];
    [whiteView addSubview:downline];
    downline.backgroundColor = ZJColorDCDCDC;
    downline.frame = CGRectMake(0, height -1, zjScreenWidth, 1);
}


#pragma mark   searchBad 代理方法
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    for (UIView *searchViews in searchBar.subviews) {
        for (UIView *view in searchViews.subviews) {
            //是按钮
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                [button setTitle:@"取消" forState:UIControlStateNormal];
                [button setTitleColor:ZJColor505050 forState:UIControlStateNormal];
                [button setTitleColor:ZJColor505050 forState:UIControlStateHighlighted];
                //button.titleLabel.font = [UIFont systemFontOfSize:15];
                button.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
            }
        }
    }
}


#pragma mark   点击搜索
//使用系统搜索--20161229-mjd
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self filterBySubstring:self.mysearch.text];
    [searchBar resignFirstResponder];
}

//相应键盘-搜索-按键    --20161229-mjd
-(void)filterBySubstring:(NSString *)subString{
    
    [self.mysearch resignFirstResponder];
    
    if (self.remindDataArray.count==0) return;
    
    NSString *ID = [self customerID];
    
    NSString *select = [NSString stringWithFormat:@"%@ AND (cName LIKE '%%%@%%' OR cCardID LIKE '%%%@%%' OR cPhone LIKE '%%%@%%')",ID,subString,subString,subString];
    
    [self customerDataFromSql:select];
}

//响应搜索-取消按键 --20161229-mjd
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = nil;
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    
}

#pragma mark   设置排序视图
-(void)setupRankView{
    
    CGRect frame =CGRectMake(0, PX2PT(132), zjScreenWidth, self.view.height- PX2PT(132));
    ZJrankView *rank = [[ZJrankView alloc]initWithFrame:frame];
    rank.selectCell = self.rankRow;
    self.rankView = rank;
    rank.delegate = self;
    [self.view addSubview:rank];
}
#pragma mark---------设置tableview
-(void)setupTableView{
    
    CGRect frame = CGRectMake(0, PX2PT(132), zjScreenWidth, self.view.height -PX2PT(132)-ZJTNHeight);
    
    UITableView *table = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = PX2PT(350);
    self.tableView = table;
    [self.view addSubview:table];
    [table registerClass:[ZJFirstAndContiueCell class]forCellReuseIdentifier:identifier];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark   点击排序按钮
-(void)clickRankButton:(UIButton *)button{
    
    button.selected = !button.selected;

    if (button.selected) {//加载
        
        [self setupRankView];
        
    }else{//删除
        
        [self.rankView removeFromSuperview];
        self.rankView = nil;
    }
}

#pragma mark---------tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.CdataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZJFirstAndContiueCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.delegate = self;
    ZJcustomerTableInfo *cuetomer = self.CdataArray[indexPath.row];
    
    ZJRemindTableInfo *remind  =self.remindDataArray[indexPath.row];
    cell.model = cuetomer;
    if (_ViewType==NSContinueViewController) {
        
        cell.continueString = remind.cRemindDate;
        
    }else{
        
        cell.firstDateString = remind.cRemindDate;
    }
    cell.selectionStyle  =UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    return cell;
    
}

#pragma mark   cell代理方法
-(void)ZJFirstAndContiueCell:(ZJFirstAndContiueCell *)view viewTag:(NSInteger)tag{
    
    ZJCustomerInfoViewController *customerInfo = [[ZJCustomerInfoViewController alloc]init];
    
    ZJcustomerTableInfo *cuetomer = self.CdataArray[tag];
    
    customerInfo.CustomerModel =cuetomer;
    
    [self.navigationController pushViewController:customerInfo animated:YES];
    
}

-(void)ZJFirstAndContiueCell:(ZJFirstAndContiueCell *)view viewTag:(NSInteger)tag Switch:(BOOL)isSwitch{
    
    ZJcustomerTableInfo *customer = self.CdataArray[tag];
    
    NSInteger iSwitch = isSwitch;
    NSString *select = nil;
    if (_ViewType == NSContinueViewController) {
        
        select = [NSString stringWithFormat:@"UPDATE %@ SET  iSwitch=%zd WHERE iRemindType =2 AND iCustomerID=%zd ",ZJRemindTableName,iSwitch,customer.iAutoID];
        
    }else{
        select = [NSString stringWithFormat:@"UPDATE %@ SET  iSwitch=%zd WHERE iRemindType =3 AND iCustomerID=%zd ",ZJRemindTableName,iSwitch,customer.iAutoID];
        ZJLog(@"%@",select);

    }
    
    [ZJFMdb sqlUpdataWithString:select];
    
}

//UPDATE crm_Remind SET  iSwitch=0 WHERE iRemindType =2 AND iCustomerID=13

#pragma mark   代理方法

-(void)ZJrankView:(ZJrankView *)view clickRow:(NSInteger)row{
    //当客户为0时
    if (self.remindDataArray.count ==0){
        
        [self clickRankButton:self.rankButton];
        return;
    }
    //与上一次保持相同就不退出
    if (self.rankRow ==row) {
        
        [self clickRankButton:self.rankButton];
        return;
    }
    NSString *select = nil;
    NSString *idString = [self customerID];
    if (row ==0) {
        
        select = idString;
        
    }else if (row ==1){
        
        select = [NSString stringWithFormat:@"%@ ORDER BY cName DESC",idString];
    }else{
        
        select = [NSString stringWithFormat:@"%@ ORDER BY fBorrowMoney DESC",idString];
    }
    [self customerDataFromSql:select];
    
    [self.tableView reloadData];
    self.rankRow = row;
    
    [self clickRankButton:self.rankButton];
    
}

#pragma mark   数据库 提醒
-(void)remindDataFromSql{
    NSString *select = nil;
    NSDate *nowDate = [NSDate new];
    NSString *nowAfter = [nowDate zj_getDateAfterDays:7 dateFormat:@"yyyy-MM-dd"];

    NSString *nowString = [nowDate zj_getStringFromDatWithFormatter:@"yyyy-MM-dd"];

    if (self.ViewType==NSContinueViewController) {
        
        select = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE iRemindType=2 AND iSwitch=1 AND cRemindDate Between '%@' and '%@'",ZJRemindTableName,nowString,nowAfter];
    }else{
        
        select = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE iRemindType=3 AND iSwitch=1 AND cRemindDate Between '%@' and '%@'",ZJRemindTableName,nowString,nowAfter];
    }
    ZJRemindTableInfo *remind = [[ZJRemindTableInfo alloc]init];
    
    [ZJFMdb sqlSelecteData:remind selecteString:select success:^(NSMutableArray *successMsg) {
        
        if (successMsg.count==0)return ;
        [self.remindDataArray addObjectsFromArray:successMsg];
        NSString *select = [self customerID];
        [self customerDataFromSql:select];
        
    }];
    
}

#pragma mark   数据库  客户

-(void)customerDataFromSql:(NSString *)select{
    
    ZJcustomerTableInfo *customer = [[ZJcustomerTableInfo alloc]init];
    
    [ZJFMdb sqlSelecteData:customer selecteString:select success:^(NSMutableArray *successMsg) {
        
        [self.CdataArray removeAllObjects];
        
        [self.CdataArray  addObjectsFromArray:successMsg];
        self.CdataArray = (NSMutableArray *)[[_CdataArray reverseObjectEnumerator]allObjects];
        [self.tableView reloadData];
        
        
    }];
    
    if (self.CdataArray.count==0) {
        
        self.holdPlaceImgV.image = [UIImage imageNamed:@"客户搜索"];
        
        self.holdPlaceImgV.size = self.holdPlaceImgV.image.size;
        
        self.holdPlaceImgV.centerX = zjScreenWidth/2;
        
        self.holdPlaceImgV.centerY = (self.view.height -PX2PT(132))/2;
    }else{
        
        [self.holdPlaceImgV removeFromSuperview];
        
        _holdPlaceImgV =nil;
    }
    

}

-(NSString *)customerID{
    
    ZJRemindTableInfo *remindFirst = self.remindDataArray.firstObject;
    
    
    NSString *idString = [NSString stringWithFormat:@"iAutoID=%zd",remindFirst.iCustomerID];
    
    for (NSInteger i = 1; i<self.remindDataArray.count; i++) {
        
        ZJRemindTableInfo *remind = self.remindDataArray[i];
        
        NSString *temp = [NSString stringWithFormat:@" OR iAutoID=%zd",remind.iCustomerID];
        
        idString = [idString stringByAppendingString:temp];
    }
    
    idString = [NSString stringWithFormat:@"select *from %@ where (%@)",ZJCustomerTableName,idString];
    
    return idString;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * temp = [textField.text stringByAppendingString:string];
    
    if (temp.length>25) {
        
        return NO;
        
    }else{
        return YES;
    }
    

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.searchTF resignFirstResponder];
}

@end
