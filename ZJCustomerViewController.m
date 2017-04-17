//
//  ZJCustomerViewController.m
//  CRM
//
//  Created by mini on 16/9/14.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJCustomerViewController.h"
#import "ZJCustomerSettingViewController.h"
#import "ZJHeaderView.h"
#import "ZJCustomerTableViewCell.h"
#import "ZJFMdb.h"
#import "ZJcustomerTableInfo.h"
#import "ZJCustomerInfoViewController.h"
#import "ZJSelectView.h"
#import "ZJrankView.h"
#import "ZJCustomerItemsTableInfo.h"
#import "ZJCustomerSearchView.h"


@interface ZJCustomerViewController ()<UITableViewDataSource,UITableViewDelegate,ZJHeaderViewDelegate,ZJSelectViewDelegate,ZJCustomerSearchViewDelegate,ZJrankViewDelegate,UITextFieldDelegate,UISearchBarDelegate>

{
    
    CGFloat _topHeight;
    
    NSInteger _selectCellRow;//筛选视图中点击的哪一个cell
    
    NSInteger _rankCellRow;//排序视图中点击的哪一个cell
    
    NSInteger _selectItemsID;//筛选中选中标签文字的ID
    

    
    NSInteger _customerCount;//客户数量
    
    NSString *_temp;
    
    BOOL _isSearch;//本地搜索—

    
}
//**筛选按钮**//
@property(nonatomic,weak) UIButton *selecteButton;
//**排序按钮**//
@property(nonatomic,weak) UIButton *rankButton;
//**收索条**//
@property(nonatomic,weak) UIButton *searchButton;
//**设置**//
@property(nonatomic,weak) UIButton *setButton;

//**客户资料展示视图**//
@property(nonatomic,weak)UITableView *customerTable;
//**筛选View**//
@property(nonatomic,weak) UIView *selectView;
//**排序视图**//
@property(nonatomic,weak) UIView *rankView;
//**获取数据库数据**//
@property(nonatomic,strong) NSMutableArray *dataModel;

//**筛选模型**//
@property(nonatomic,strong) NSMutableArray *selectDataArray;
//**搜索视图**//
@property(nonatomic,weak) ZJCustomerSearchView *searchView;

//**无客户的遮盖视图**//
@property(nonatomic,strong) UIImageView *noCudtomerImaageView;

@end

@implementation ZJCustomerViewController

-(NSMutableArray *)dataModel{
    
    if (!_dataModel) {
        
        _dataModel = [NSMutableArray array];
    }
    return _dataModel;
}

-(NSMutableArray *)selectDataArray{
    
    if (!_selectDataArray) {
        
        _selectDataArray = [NSMutableArray array];
    }
    
    return _selectDataArray;
}

-(UIImageView *)noCudtomerImaageView{
    
    if (!_noCudtomerImaageView) {
        
        _noCudtomerImaageView = [[UIImageView alloc]init];
        
        [self.view addSubview:_noCudtomerImaageView];
    }
    
    return _noCudtomerImaageView;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    

    
    if (self.enterModel == CustomerModel) {
    
        
        self.select = [NSString stringWithFormat:@"SELECT * FROM %@",ZJCustomerTableName];
    }
    
    [self allDataFromFMdb];
    
    [self selectdataFromFMdb];//筛选表中的的文字

//    ZJLog(@"%@",ZJDocumentPath);
    
    if (self.enterModel != CustomerModel &&_customerCount!=0) {
        
        NSString *cusCount = [NSString stringWithFormat:@"%zd位",
                              _customerCount];
        
        _temp = [cusCount stringByAppendingString:self.naviTitle];
        
    }else if (self.enterModel != CustomerModel&&self.dataModel.count==0){
        
        _temp = self.naviTitle;
        
    }else if (self.enterModel == CustomerModel&&self.dataModel.count>0){
        
        _temp = [NSString stringWithFormat:@"%zd位客户",self.dataModel.count];
    }else if (self.enterModel == CustomerModel&&self.dataModel.count==0){
        
        _temp = @"客户";
    }
    
    [self setupNavi];
////    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:@"2016-12-04" forKey:@"firstMarker"];
//    [defaults setObject:@"2016-12-04" forKey:@"continueMarker"];
//
//    [defaults synchronize];
//
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //视图消失的时候   退出选择视图
    if (self.selecteButton.selected) {
        
        [self clickSelecteButton:self.selecteButton];
    }
    
    //退出排序视图
    if (self.rankButton.selected) {
        
        [self clickRankButton:self.rankButton];
    }
    
    _temp = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
   // [self addnotification];
    [self setupTableView];

    if (_enterModel ==CustomerModel) {
        
        [self addTopView];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(thismysearch)
//                                                 name:@"clickSearchButton"
//                                               object:nil];

}


- (void) keyboardWillHide : (NSNotification*)notification {
    
    [self.searchView removeFromSuperview];
    
    self.searchView = nil;
    
}

#pragma mark   s设置顶部视图

-(void)setupNavi{

    self.view.backgroundColor = ZJBackGroundColor;
    self.navigationItem.title = _temp;
   
}

#pragma mark   顶部视图

-(void)addTopView{
    
    UIView *topView = [[UIView alloc]init];
    [self.view addSubview:topView];
    topView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1.0];
    
    topView.frame = CGRectMake(0, 0, self.view.width, _topHeight);
    //筛选
    CGFloat buttonWith = (self.view.width -3)/6.0;
    UIButton *selecte = [[UIButton alloc]init];
    [topView addSubview:selecte];
    self.selecteButton = selecte;
    [selecte setTitle:@"筛选"
             forState:UIControlStateNormal];
    
    selecte.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [selecte setTitleColor:ZJColor505050
                  forState:UIControlStateNormal];
    [selecte setTitleColor:ZJColor00D3A3
                  forState:UIControlStateSelected];
    [selecte setImage:[UIImage imageNamed:@"An-arrow_505050"]
             forState:UIControlStateNormal];
    [selecte setImage:[UIImage imageNamed:@"Contraction-arrow"]
             forState:UIControlStateSelected];
    selecte.frame = CGRectMake(0, 0, 2*buttonWith, _topHeight);
    [selecte zj_changeImageAndTitel];
    [selecte addTarget:self
                action:@selector(clickSelecteButton:)
      forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line1 = [[UIView alloc]init];
    [selecte addSubview:line1];
    line1.backgroundColor = ZJColorDCDCDC;
    line1.frame = CGRectMake(selecte.width -1, 5, 1, selecte.height-10);
    
    //排序
    UIButton *rank = [[UIButton alloc]init];
    [topView addSubview:rank];
    self.rankButton = rank;
    [rank setTitle:@"排序"
          forState:UIControlStateNormal];
    rank.titleLabel.font = [UIFont systemFontOfSize:18];
    [rank setTitleColor:ZJColor505050
               forState:UIControlStateNormal];
    [rank setTitleColor:ZJColor00D3A3
               forState:UIControlStateSelected];
    [rank setImage:[UIImage imageNamed:@"An-arrow_505050"]
          forState:UIControlStateNormal];
    [rank setImage:[UIImage imageNamed:@"Contraction-arrow"]
          forState:UIControlStateSelected];
    rank.frame = CGRectMake(2*buttonWith+1, 0, 2*buttonWith, _topHeight);
    [rank zj_changeImageAndTitel];
    [rank addTarget:self
             action:@selector(clickRankButton:)
   forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line2 = [[UIView alloc]init];
    [rank addSubview:line2];
    line2.backgroundColor = ZJColorDCDCDC;
    line2.frame = CGRectMake(rank.width -1, 5, 1, rank.height-10);
    //搜索
    UIButton *searchButton = [[ UIButton alloc]init];
    [topView addSubview:searchButton];
    self.searchButton = searchButton;
    [searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(clickSearchButton:) forControlEvents:UIControlEventTouchUpInside];
    searchButton.frame = CGRectMake(4*buttonWith+2, 0, buttonWith, _topHeight);
    
    UIView *line3 = [[UIView alloc]init];
    [searchButton addSubview:line3];
    line3.backgroundColor = ZJColorDCDCDC;
    line3.frame = CGRectMake(searchButton.width -1, 5, 1, searchButton.height-10);
    //设置
    UIButton *set = [[ UIButton alloc]init];
    [topView addSubview:set];
    self.setButton = set;
    [set setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
    
    [set addTarget:self action:@selector(clickSetButton:) forControlEvents:UIControlEventTouchUpInside];
    set.frame = CGRectMake(5*buttonWith+3, 0, buttonWith, _topHeight);
    //分割性
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = ZJColorDCDCDC;
    [topView addSubview:line];
    line.frame = CGRectMake(0, topView.height-PX2PT(1), zjScreenWidth, PX2PT(1));

}
#pragma mark   设置tableview
-(void)setupTableView{
    
    if (self.enterModel == CustomerModel) {
        
        _topHeight = PX2PT(132);
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGRect frame = CGRectMake(0, 0, self.view.width, self.view.height - ZJTNHeight);
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.customerTable = tableView;
    tableView.contentInset = UIEdgeInsetsMake(_topHeight, 0, ZJTBHeight, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}
#pragma mark   设置筛选视图
-(void)setupSelectTableView{
    //底部半透明视图
    
    CGRect frame =CGRectMake(0, PX2PT(132), zjScreenWidth, self.view.height- PX2PT(132));
    ZJSelectView *selectView = [[ZJSelectView alloc]initWithFrame:frame tableViewData:self.selectDataArray];
    self.selectView = selectView;
    selectView.delegate = self;
    selectView.selectCell = _selectCellRow;
    
    [self.view addSubview:selectView];

}
#pragma mark   设置排序视图
-(void)setupRankTableView{
    CGRect frame =CGRectMake(0, PX2PT(132), zjScreenWidth, self.view.height- PX2PT(132));
    ZJrankView *rank = [[ZJrankView alloc]initWithFrame:frame];
    rank.selectCell = _rankCellRow;
    self.rankView = rank;
    rank.delegate = self;
    [self.view addSubview:rank];
    
}


#pragma mark---------customerTable代理方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataModel.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ZJcustomerTableInfo *model = self.dataModel[section];
    
    return model.isExplain?1:0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"ExplainCell";
    ZJCustomerTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ZJCustomerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    ZJcustomerTableInfo *model = self.dataModel[indexPath.section];

    cell.model = model;
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static NSString *headerIdentifier = @"HeaderCell";
    ZJHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    if (nil == headerView) {
        
        headerView = [[ZJHeaderView alloc]initWithReuseIdentifier:headerIdentifier];
        headerView.delegate = self;

    }
    ZJcustomerTableInfo *model = self.dataModel[section];
    headerView.customerModel = model;
    headerView.tag = section;
    headerView.rotageImgView = model.isExplain;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    ZJcustomerTableInfo *model = self.dataModel[section];
    
    
    return model.headViewHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZJcustomerTableInfo *model = self.dataModel[indexPath.section];

    return model.cellHeight;
}

#pragma mark   ZJSelectViewDelegate代理方法

-(void)ZJSelectView:(ZJSelectView *)view didSelectItemID:(NSInteger)ID clickRow:(NSInteger)row {
    
    //判断是否重复点击
//    if (_selectCellRow !=row){
    
        _selectCellRow = row;
        
        _rankCellRow = 0;//设置排序的row位0
        
        if (row ==0) {//提取全部数据
            self.select = [NSString stringWithFormat:@"SELECT * FROM %@",ZJCustomerTableName];

            [self allDataFromFMdb];

            
        }else{//提取对应的标签数据
            _selectItemsID = ID;
            [self selectCellAddDataFromSql:ID rankSelectRow:0];
            
        }
    
    if (self.dataModel.count>0) {
        
        self.navigationItem.title = [NSString stringWithFormat:@"%zd位客户",self.dataModel.count];
    }else{
        
        self.navigationItem.title = @"客户";
    }
    
//    }
    self.selecteButton.selected = NO;
    
    [view removeFromSuperview];
    
    view = nil;
    
}


#pragma mark   ZJCustomerSearchViewDelegate

-(void)ZJCustomerSearchView:(ZJCustomerSearchView *)view didClickCancleButton:(UIButton *)button{
    
    _isSearch = NO;
    [self.searchView removeFromSuperview];
    self.searchView =  nil;
}


#pragma mark   ZJrankViewDelegate

-(void)ZJrankView:(ZJrankView *)view clickRow:(NSInteger)row{
    if(row != _rankCellRow){
        _rankCellRow = row;
        [self selectCellAddDataFromSql:_selectItemsID  rankSelectRow:_rankCellRow];
    }
    self.rankButton.selected = NO;
    [self.rankView removeFromSuperview];
    self.rankView = nil;
}
#pragma mark   //点击展开Button
- (void)headerView:(ZJHeaderView *)headerView didClickDecoilButton:(UIButton *)button{
    
    
    NSInteger section = headerView.tag;
        
    ZJcustomerTableInfo *model = self.dataModel[section];

    model.explain = !model.isExplain;
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
    
    [self.customerTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    headerView.rotageImgView = YES;

    

}
#pragma mark   //点击进入Button

-(void)headerView:(ZJHeaderView *)headerView didClickCoverButton:(UIButton *)button{
    
    ZJCustomerInfoViewController *customerInfo = [[ZJCustomerInfoViewController alloc]init];
    
    customerInfo.CustomerModel = self.dataModel[headerView.tag];
    
    [self.navigationController pushViewController:customerInfo animated:YES];
    
}

#pragma mark   站位图片
-(void)addHoldPlaceImg{
    if (_enterModel ==CustomerModel) {
        
//        self.noCudtomerImaageView.y = -64;
//        self.noCudtomerImaageView.width = 282;
//        self.noCudtomerImaageView.height = 411;
        self.noCudtomerImaageView.image = [UIImage imageNamed:@"无客户箭头"];
        self.noCudtomerImaageView.size = self.noCudtomerImaageView.image.size;
        self.noCudtomerImaageView.centerY = self.view.height/2;
        self.noCudtomerImaageView.centerX = self.view.width/2;
        
    }else if (_enterModel ==FirstPurposeModel||_enterModel==FirstNewAddModel||_enterModel==FirstFollowingModel||_enterModel==FirstLoanModel) {
//        self.noCudtomerImaageView.width = 282;
//        self.noCudtomerImaageView.height = 340;
        self.noCudtomerImaageView.image = [UIImage imageNamed:@"无客户"];
        self.noCudtomerImaageView.size = self.noCudtomerImaageView.image.size;

        self.noCudtomerImaageView.centerY = self.view.height/2;
        self.noCudtomerImaageView.centerX = self.view.width/2;
    }else if (_enterModel ==FirstSearchModel){
//        self.noCudtomerImaageView.width = 282;
//        self.noCudtomerImaageView.height = 300;
        self.noCudtomerImaageView.image = [UIImage imageNamed:@"客户搜索"];

        self.noCudtomerImaageView.size = self.noCudtomerImaageView.image.size;

        self.noCudtomerImaageView.image = [UIImage imageNamed:@"客户搜索"];
        self.noCudtomerImaageView.centerY = self.view.height/2;
        self.noCudtomerImaageView.centerX = self.view.width/2;
    }else if (_isSearch){
//        self.noCudtomerImaageView.width = 282;
//        self.noCudtomerImaageView.height = 300;
        self.noCudtomerImaageView.image = [UIImage imageNamed:@"客户搜索"];
        self.noCudtomerImaageView.size = self.noCudtomerImaageView.image.size;

        self.noCudtomerImaageView.centerY = self.view.height/2;
        self.noCudtomerImaageView.centerX = self.view.width/2;
    }
    
}
//SELECT * FROM crm_CustomerInfo WHERE cCreateYear='2016' AND cCreateMonth='11'
#pragma mark   //获取数据库数据
-(void)allDataFromFMdb{
    ZJcustomerTableInfo *customer = [[ZJcustomerTableInfo alloc]init];
    
    [ZJFMdb sqlSelecteData:customer selecteString:self.select success:^(NSMutableArray *successMsg) {
        
        [self.dataModel removeAllObjects];
        
        [self.dataModel addObjectsFromArray:successMsg];
        _customerCount = successMsg.count;
        self.dataModel = (NSMutableArray *)[[_dataModel reverseObjectEnumerator]allObjects];
        [self.customerTable reloadData];
    }];
    
    //判断是否加站位图片
    if (self.dataModel.count==0) {
        
        [self addHoldPlaceImg];
    }else{
        
        if (_noCudtomerImaageView) {
            
            [self.noCudtomerImaageView removeFromSuperview];
            
            self.noCudtomerImaageView = nil;
        }
        
        
    }
}
#pragma mark   //获取数据库数据
-(void)selectdataFromFMdb{
    //筛选的数据
    ZJCustomerItemsTableInfo *items = [[ZJCustomerItemsTableInfo alloc]init];
    
    NSString *select = [NSString stringWithFormat:@"select * from %@ where type='customerState'",ZJCustomerItemsTableName];
    
    [ZJFMdb sqlSelecteData:items selecteString:select success:^(NSMutableArray *successMsg) {
        
        [self.selectDataArray removeAllObjects];
        
        [self.selectDataArray addObjectsFromArray:successMsg];
        
    }];
    
    items.itemString = @"全部";
    
    [self.selectDataArray insertObject:items atIndex:0];
}
#pragma mark   //获取数据库数据
-(void)selectCellAddDataFromSql:(NSInteger)autoID rankSelectRow:(NSInteger)rankSelectRow{
    
    ZJcustomerTableInfo *model = [[ZJcustomerTableInfo alloc]init];
    

    NSString *select = nil;
    
    if (_selectCellRow == 0) {//全部数据
        
        select =[NSString stringWithFormat:@"SELECT * FROM %@",ZJCustomerTableName];
        
    }else{
        
        select = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE (cCustomerState_Tags LIKE '%zd;%%' OR cCustomerState_Tags LIKE '%%;%zd;%%' OR cCustomerState_Tags LIKE '%%;%zd')",ZJCustomerTableName,autoID,autoID,autoID];
        
    }

    if (_rankCellRow ==0) {


    }else if (_rankCellRow ==1){
        
        select =  [NSString stringWithFormat:@"%@ ORDER BY cName DESC",select];
        
        
    }else if (_rankCellRow == 2){
        
        select =  [NSString stringWithFormat:@"%@ ORDER BY fBorrowMoney DESC",select];
    }

    
    [ZJFMdb sqlSelecteData:model selecteString:select success:^(NSMutableArray *successMsg) {
        
        [self.dataModel removeAllObjects];
        
        [self.dataModel addObjectsFromArray:successMsg];
        self.dataModel = (NSMutableArray *)[[_dataModel reverseObjectEnumerator]allObjects];
        [self.customerTable reloadData];
        
//        if (successMsg.count>0) {
//            
//            self.navigationItem.title = [NSString stringWithFormat:@"%zd位客户",successMsg.count];
//        }else{
//            
//            self.navigationItem.title = @"客户";
//        }
        
    }];
    
}

#pragma mark   点击topView上的筛选

-(void)clickSelecteButton:(UIButton *)button{

    self.rankButton.selected = NO;
    button.selected = !button.selected;
    
    if (self.rankView) {
        
        [self.rankView removeFromSuperview];
        self.rankView = nil;
    }
    
    if (button.selected) {
        
        [self setupSelectTableView];

        
    }else{
        
        [self.selectView removeFromSuperview];
        
        self.selectView = nil;
        
    }

}

#pragma mark   点击排序
-(void)clickRankButton:(UIButton *)button{

    self.selecteButton.selected = NO;
    button.selected = !button.selected;
    
    //判断筛选视图是否存在
    if (self.selectView) {
        [self.selectView removeFromSuperview];
        
        self.selectView = nil;
        
    }
    
    if (button.selected) {//加载
        
        [self setupRankTableView];
    }else{//删除
        
        [self.rankView removeFromSuperview];
        self.rankView = nil;
    }
}

#pragma mark   点击搜索
-(void)clickSearchButton:(UIButton *)button{
    self.rankButton.selected = NO;
    self.selecteButton.selected = NO;

    if (self.selectView) {
        [self.selectView removeFromSuperview];
        
        self.selectView = nil;
    }
    
    if (self.rankView) {
        
        [self.rankView removeFromSuperview];
        self.rankView = nil;
    }
    
    //加载搜索视图
    CGRect frame = CGRectMake(0, 0, zjScreenWidth, self.view.height);
    ZJCustomerSearchView *searchView =[[ZJCustomerSearchView alloc]initWithFrame:frame];
    searchView.delegate = self;
   // searchView.searchTF.delegate = self;
    self.searchView = searchView;
    [self.view addSubview:searchView];
    [self searchBarTextDidBeginEditing:searchView.mysearch];
    [searchView.mysearch becomeFirstResponder];

    //使用系统搜索--20161229-mjd
    searchView.mysearch.delegate = self;
    searchView.mysearch.searchResultsButtonSelected = YES;
    //==
    
    
    
    
 
}

#pragma mark   点击设置
-(void)clickSetButton:(UIButton *)button{
    self.rankButton.selected = NO;
    self.selecteButton.selected = NO;
    
    if (self.selectView) {
        [self.selectView removeFromSuperview];
        
        self.selectView = nil;
        
    }
    
    if (self.rankView) {
        
        [self.rankView removeFromSuperview];
        self.rankView = nil;
    }
    
    ZJCustomerSettingViewController *set = [[ZJCustomerSettingViewController alloc]init];
    [self.navigationController pushViewController:set animated:YES];
}
////开始编辑时
//-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//     [searchBar resignFirstResponder];
//    return true;
//}


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
                button.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
            }
        }
    }

}



//使用系统搜索--20161229-mjd
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
 
    
    [self filterBySubstring:self.searchView.mysearch.text];
    [searchBar resignFirstResponder];
}

//相应键盘-搜索-按键    --20161229-mjd
-(void)filterBySubstring:(NSString *)subString{
    _isSearch = YES;
    
  
    NSString *select = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE (cName LIKE '%%%@%%' OR cCardID LIKE '%%%@%%' OR cPhone LIKE '%%%@%%')",ZJCustomerTableName,subString,subString,subString];
    
    self.select = select;
    
    [self allDataFromFMdb];
    
    [self.searchView removeFromSuperview];
    
    self.searchView = nil;
}

//响应搜索-取消按键 --20161229-mjd
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.text = nil;
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
  //  [searchBar removeFromSuperview];
   // searchBar = nil;
    
    _isSearch = NO;
    [self.searchView.mysearch removeFromSuperview];
    
    [self.searchView removeFromSuperview];
    self.searchView = nil;
}




//
//-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    
//    _isSearch = YES;
//    
//    NSString *select = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE (cName LIKE '%%%@%%' OR cCardID LIKE '%%%@%%' OR cPhone LIKE '%%%@%%')",ZJCustomerTableName,textField.text,textField.text,textField.text];
//    
//    self.select = select;
//    
//    [self allDataFromFMdb];
//    
//    [self.searchView removeFromSuperview];
//    
//    self.searchView = nil;
//
//    
//    return YES;
//}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *temp = [textField.text stringByAppendingString:string];
    
    if (temp.length<=25) {
        
        return YES;
    }
    return NO;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
