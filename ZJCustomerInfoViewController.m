//
//  ZJCustomerInfoViewController.m
//  CRM
//
//  Created by mini on 16/9/29.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJCustomerInfoViewController.h"
#import "ZJcustomerTableInfo.h"
#import "ZJCustomerMsgView.h"
#import "ZJCustomerBrithViewController.h"
#import "ZJCustomerContinueRViewController.h"
#import "ZJFirstRefundViewController.h"
#import "ZJremindSetView.h"
#import "NSDate+Category.h"
#import "ZJFollowHeadView.h"
#import "ZJFollowTableViewCell.h"
#import "ZJFollowUpTableInfo.h"
#import "ZJFMdb.h"
#import "ZJCustomerInfoScanController.h"
#import "ZJRemindTableInfo.h"
#import "ZJMuneIamgeView.h"
#import "ZJDirectorie.h"
#import "ZJFolloweViewController.h"


@interface ZJCustomerInfoViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,ZJremindSetViewDelegate,ZJCustomerBrithViewDelegate,ZJCustomerContinueDelegate,ZJFirstRefundViewDelegate,ZJMuneIamgeViewDelegte,CustomerInfoScanControllerDelegate,ZJFollowTableViewCellDelegate,ZJFolloweViewDelegate>
{
    //顶部视图
    UIImageView *_topImgView;
    UIButton *_phoneButton;
    UILabel *_phoneLabel;
    UILabel *_nameLabel;
    UIImageView *_sexImageView;
    //指示器View
    
    UIImageView *_indexView;
    UIButton *_followButton;
    UIButton *_msgButton;
    UIButton *_remaindButton;
    UIButton* _tempButtom;
    CGFloat iconWH;
    
    NSString *_continueS;//续贷时间字符串
    NSString *_firstS;//首期还款字符串
    
    NSInteger _openBirthRemind;//是否打开生日提醒
    
    NSInteger _openContinueRemind;//是否打开续贷提醒

    NSInteger _openFirstRemind;//是否打开首期还款提醒

    
    
    
}

//**scrollerView**//
@property(nonatomic,weak)UIScrollView *scrollerView;

//**内容视图**//
@property(nonatomic,weak)UIView *contentView;


//**客户资料**//
@property(nonatomic,strong) ZJCustomerMsgView *CustomerMsgView;

//**提醒视图**//
@property(nonatomic,weak) ZJremindSetView *remindView;

//**跟进视图**//
@property(nonatomic,weak)UITableView *followTable;

//**遮盖视图**//
@property(nonatomic,strong)UIView *converView;

//**tebleView数组**//
@property(nonatomic,strong) NSMutableArray *tableDataArray;

//**mune**//
@property(nonatomic,strong) ZJMuneIamgeView *muneImgView;

//**站位图片**//
@property(nonatomic,weak) UIImageView *holdPlaceImageView;

//**生日提醒数据**//
@property(nonatomic,strong) NSMutableArray *birthRemindArray;

//**续贷提醒数据**//
@property(nonatomic,strong) NSMutableArray *continueRemindArray;

//**首期还款提醒数据**//
@property(nonatomic,strong) NSMutableArray *firstRemindArray;
@end

static  NSString *identifier = @"followCell";

static NSString *followHead = @"followHead";

@implementation ZJCustomerInfoViewController

-(UIView *)converView{
    if (!_converView) {
        
        _converView = [[UIView alloc]init];
        CGFloat Y = CGRectGetMaxY(_indexView.frame)+ZJmargin40;

        _converView.backgroundColor = ZJBackGroundColor;
        _converView.frame = CGRectMake(0, Y, zjScreenWidth, self.view.height -Y);
    }
    return _converView;
}


-(NSMutableArray *)tableDataArray{
    
    if (!_tableDataArray) {
        
        _tableDataArray = [NSMutableArray array];
        
    }
    return _tableDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUPNavagation];
    [self setUpUI];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi"] forBarMetrics:UIBarMetricsDefault];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self getRemindData];

}
#pragma mark   设置导航栏

-(void)setUPNavagation{
    self.view.backgroundColor = ZJBackGroundColor;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem zj_BarButtonItemWithButtonItemImage:@"menu" heightLightImage:@"menu" target:self action:@selector(clickMoreButton:)];
}

#pragma mark   设置UI
-(void)setUpUI{
    //顶部视图
    [self setupTopView];
    //选择  跟进  资料  提醒
    [self setupIndexView];
    [self getDateFromSql];
//    [self getRemindData];

    self.birthRemindArray = [NSMutableArray array];
    
    self.firstRemindArray = [NSMutableArray array];
    
    self.continueRemindArray = [NSMutableArray array];
}

#pragma mark   设置顶部视图
-(void)setupTopView{

    //顶部视图
    _topImgView = [[UIImageView alloc]init];
    _topImgView.image = [UIImage imageNamed:@"background"];
    _topImgView.frame  = CGRectMake(0, 0, self.view.width, PX2PT(677)+20);
    [self.view addSubview:_topImgView];
    _topImgView.userInteractionEnabled = YES;
    UIImageView *icon = [[UIImageView alloc]init];
    icon.layer.cornerRadius = 3;
    icon.clipsToBounds = YES;
    
    iconWH = PX2PT(customerIcon);
    
    if (self.CustomerModel.cPhotoUrl.length>0) {
        
        icon.image = [UIImage imageWithContentsOfFile:self.CustomerModel.iconPath];
    }else{
        icon.image = [UIImage imageNamed:@"head-portrait"];
    }
    
    icon.width =iconWH;
    icon.height = iconWH;
    icon.centerX = _topImgView.centerX;
    icon.y = ZJTNHeight;
    

    [_topImgView addSubview:icon];
    
    
    UILabel *namelabel = [[UILabel alloc]init];
    _nameLabel = namelabel;
    [namelabel zj_labelText:self.CustomerModel.cName textColor:ZJColorFFFFFF textSize:ZJTextSize45PX];
    [namelabel zj_adjustWithMin];
    namelabel.y = (CGRectGetMaxY(icon.frame)+PX2PT(50));
    namelabel.centerX = _topImgView.centerX;

    [_topImgView addSubview:namelabel];


    //性别
    UIImageView *sexImgV = [[UIImageView alloc]init];
    [_topImgView addSubview:sexImgV];
    _sexImageView = sexImgV;

    
    UIImage *image = nil;
    if (self.CustomerModel.iSex == 0) {
        
        image = [UIImage imageNamed:@"MAN_iocn"];
    }else{
        image = [UIImage imageNamed:@"WOMAN_icon"];
    }
    sexImgV.image = image;
    
    sexImgV.size = image.size;
    
    sexImgV.x = CGRectGetMaxX(namelabel.frame)+3;
    sexImgV.centerY = namelabel.centerY;
    
    //手机号码
    UILabel *Phonelbel = [[UILabel alloc]init];
    [_topImgView addSubview:Phonelbel];
    [Phonelbel zj_labelText:self.CustomerModel.cPhone textColor:ZJColorFFFFFF textSize:ZJTextSize45PX];
    [Phonelbel zj_adjustWithMin];
    Phonelbel.y = (CGRectGetMaxY(namelabel.frame)+PX2PT(18));
    Phonelbel.centerX = _topImgView.centerX;

    //
    _phoneButton = [[UIButton alloc]init];
    [_phoneButton setImage:[UIImage imageNamed:@"PHONE-0"] forState:UIControlStateNormal];
    [_topImgView addSubview:_phoneButton];
    _phoneButton.width = Phonelbel.width +20;
    _phoneButton.height = 16;
    _phoneButton.x = Phonelbel.x - 20;
    _phoneButton.centerY = Phonelbel.centerY;
    _phoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_phoneButton addTarget:self action:@selector(clickPhoneButton:) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark   设置跟进  资料  提醒
-(void)setupIndexView{
    UIImageView *indexView = [[UIImageView alloc]init];
    indexView.userInteractionEnabled = YES;
    indexView.backgroundColor = ZJColorFFFFFF;
    
    //按客户修正：跟进与资料互换位置。  --20161221  mjd
    indexView.image = [UIImage imageNamed:@"left"];
    //indexView.image = [UIImage imageNamed:@"centre"];
    CGFloat indexViewY = CGRectGetMaxY(_topImgView.frame)+ZJmargin40;
    indexView.frame = CGRectMake(ZJmargin40, indexViewY, self.view.width - 2*ZJmargin40, 39);
    [self.view addSubview:indexView];
    _indexView = indexView;
    
    CGFloat buttonW = indexView.width/3;
    CGFloat buttonH = indexView.height;
    
    
    _followButton = [[UIButton alloc]init];
    //按客户修正：跟进与资料互换位置。  --20161221  mjd
    [self clickFollowButton:_followButton];
    [self indexButton:_followButton title:@"跟进"];
    [indexView addSubview:_followButton];
    [_followButton addTarget:self action:@selector(clickFollowButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _msgButton = [[UIButton alloc]init];
    [self clickMsgButton:_msgButton];
    [self indexButton:_msgButton title:@"资料"];
    [indexView addSubview:_msgButton];
    [_msgButton addTarget:self action:@selector(clickMsgButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _remaindButton = [[UIButton alloc]init];
//[self clickRemindButton:_remaindButton];
    [self indexButton:_remaindButton title:@"提醒"];
    [indexView addSubview:_remaindButton];
    [_remaindButton addTarget:self action:@selector(clickRemindButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    _followButton.frame =CGRectMake(0,0,buttonW,buttonH);
//    
//    _msgButton.frame = CGRectMake(buttonW, 0, buttonW, buttonH);
    //按客户修正：跟进与资料互换位置。  --20161221  mjd
    _msgButton.frame =CGRectMake(0,0,buttonW,buttonH);
    
    _followButton.frame = CGRectMake(buttonW, 0, buttonW, buttonH);
    
    _remaindButton.frame = CGRectMake(2*buttonW, 0, buttonW, buttonH);

    
}

#pragma mark---------设置资料视图
-(void)setupCustomerMsgView{
    if (!_converView) {
        
        [self.view addSubview:self.converView];
    }
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:scrollView];
    
    self.scrollerView = scrollView;
    scrollView.delegate = self;
    scrollView.bounces = YES;
    
    CGFloat scrollY = CGRectGetMaxY(_indexView.frame)+ZJmargin40;
    
    scrollView.frame = CGRectMake(0, scrollY, self.view.width, self.view.height - scrollY);
//    scrollView.contentSize = CGSizeMake(0, 1000);
    //内容视图
    UIView *contentView = [[UIView alloc]init];
    [self.scrollerView addSubview:contentView];
    self.contentView  = contentView;
    contentView.frame = CGRectMake(0, 0, self.view.width, 1000);
    
    //分割线
    UIView *line = [[UIView alloc]init];
    [self.contentView addSubview:line];
    line.backgroundColor = ZJColorDCDCDC;
    line.frame = CGRectMake(0, 0, zjScreenWidth, 1);
    //基本信息
    CGRect frame = CGRectMake(0, 1, self.view.width, 800);
    ZJCustomerMsgView *msgView = [[ZJCustomerMsgView alloc]initWithFrame:frame withModel:self.CustomerModel];
    self.CustomerMsgView = msgView;
    
    scrollView.contentSize = CGSizeMake(0, self.CustomerMsgView.msgViewHeight);
    
    contentView.frame = CGRectMake(0, 0, self.view.width, self.CustomerMsgView.msgViewHeight);

    [self.contentView addSubview:self.CustomerMsgView];

}

#pragma mark---------设置提醒视图
-(void)setupCustomerRemindView{
    
    if (!_converView) {
        
        [self.view addSubview:self.converView];
    }
    
    CGFloat RemindViewY = CGRectGetMaxY(_indexView.frame)+ZJmargin40;
    CGRect frame = CGRectMake(0, RemindViewY, self.view.width, PX2PT(600)+2);
    //跟进VIew
    ZJremindSetView *RSView = [[ZJremindSetView alloc]initWithType:ZJremindSetViewExamine];
    [self.view addSubview:RSView];
    self.remindView  = RSView;
    RSView.delegate = self;
    RSView.frame = frame;
    //设置生日提醒
    NSString *birth= self.CustomerModel.cBirthDay;
    if (![birth isEqualToString:@"未填写"]) {
        
        NSString*temp = [birth zj_dateStringFormatter:@"yyyy-MM-dd" toFromatter:@"yyyy年MM月dd日"];

        RSView.birthText = [temp stringByAppendingString:@"为客户生日"];

    }


    //设置续贷提醒
    if (self.continueRemindArray.count>0) {
        
        ZJRemindTableInfo *model = self.continueRemindArray.firstObject;

        _continueS = model.cRemindDate;
        NSString*continu = [_continueS zj_dateStringFormatter:@"yyyy-MM-dd" toFromatter:@"yyyy年MM月dd日"];

        RSView.continueText = [continu stringByAppendingString:@"之后可续贷"];

    }
    
    //设置首期还款
    if (self.firstRemindArray.count>0) {
        
        ZJRemindTableInfo *model = self.firstRemindArray.firstObject;
        
        _firstS = model.cRemindDate;
        NSString*first = [_firstS zj_dateStringFormatter:@"yyyy-MM-dd" toFromatter:@"yyyy年MM月dd日"];

        RSView.firstText = [first stringByAppendingString:@"为首期还款日"];
        
    }

}

#pragma mark   获取提醒数据
-(void)getRemindData{
    
    self.birthRemindArray = [NSMutableArray array];
    
    self.firstRemindArray = [NSMutableArray array];
    
    self.continueRemindArray = [NSMutableArray array];
    
    self.birthRemindArray = [self dataFromSql:1];

    self.continueRemindArray = [self dataFromSql:2];
    
    self.firstRemindArray = [self dataFromSql:3];
    
    ZJRemindTableInfo *model = self.birthRemindArray.firstObject;
    
    _openBirthRemind = model.iSwitch;
    
    model = self.continueRemindArray.firstObject;

    _openContinueRemind = model.iSwitch;
    
    model = self.firstRemindArray.firstObject;

    _openFirstRemind = model.iSwitch;

    
}

-(NSMutableArray *)dataFromSql:(NSInteger )iRemindType{
    
    ZJRemindTableInfo *remind = [[ZJRemindTableInfo alloc]init];
    
    __block NSMutableArray *array= [NSMutableArray array];
    NSString *select = [NSString stringWithFormat:@"select *from %@ where iCustomerID=%zd and iRemindType=%zd",ZJRemindTableName,self.CustomerModel.iAutoID,iRemindType];
    [ZJFMdb sqlSelecteData:remind selecteString:select success:^(NSMutableArray *successMsg) {
        
        array  = successMsg;
        
    }];
    
    return array;
}
#pragma mark---------设置跟进视图

-(void)setupCustomerFolloeView{
    
    
    if (_converView) {
        
        [_converView removeFromSuperview];
        
        _converView = nil;
    }
    
    if (self.followTable)return;

    CGFloat followViewY = CGRectGetMaxY(_indexView.frame)+ZJmargin40;

    CGRect frame = CGRectMake(0, followViewY, zjScreenWidth, self.view.height - followViewY);
    
    UITableView *table = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    table.contentInset =  UIEdgeInsetsMake(0, 0, 64, 0);
    [self.view addSubview:table];
    table.delegate = self;
    table.dataSource = self;
    self.followTable = table;
    
    [table registerClass:[ZJFollowTableViewCell class] forCellReuseIdentifier:identifier];
    
//    [table registerClass:[ZJFollowHeadView class] forHeaderFooterViewReuseIdentifier:followHead];
    table.sectionHeaderHeight = PX2PT(75);

    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIButton *addButton= [[UIButton alloc]init];
    
    [self.view addSubview:addButton];
    UIImage *addImg = [UIImage imageNamed:@"-Add-click"];
    
    [addButton setImage:addImg forState:UIControlStateNormal];
    
    [addButton addTarget:self action:@selector(clickFollowAddButton:) forControlEvents:UIControlEventTouchUpInside];
    
    addButton.width = addImg.size.width;
    
    addButton.height = addImg.size.height;
    
    addButton.x = self.view.width - PX2PT(40)- addButton.width;
    
    addButton.y = self.view.height -addButton.height - PX2PT(200);
}

#pragma mark   点击加号按钮


-(void)clickFollowAddButton:(UIButton *)button{
    
    ZJFolloweViewController *follow = [[ZJFolloweViewController alloc]init];
    follow.FollowEnterModel =DirectEnterModel;
    follow.delegate = self;
    follow.customerModel = self.CustomerModel;
    
    [self.navigationController pushViewController:follow animated:YES];
    ZJLogFunc;
}
#pragma mark---------UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tableDataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    ZJFollowUpTableInfo *follow = self.tableDataArray[section];
    
    return follow.followModelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZJFollowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    ZJFollowUpTableInfo *follow = self.tableDataArray[indexPath.section];
    
    cell.dirName = self.CustomerModel.GUID;

    cell.model = follow.followModelArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.indexPath = indexPath;
    cell.delegate = self;

    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    ZJFollowHeadView *HeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:followHead];
    if (!HeadView) {
        
        HeadView = [[ZJFollowHeadView alloc]initWithReuseIdentifier:followHead];
    }
    HeadView.model = self.tableDataArray[section];
    
    return HeadView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZJFollowUpTableInfo *follow = self.tableDataArray[indexPath.section];
    
    ZJFollowUpTableInfo *followHeiht = follow.followModelArray[indexPath.row];
    
    return followHeiht.cellHeight;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    ZJFollowUpTableInfo *follow = self.tableDataArray[section];
    
    return [NSString stringWithFormat:@"%@ %@",follow.cLogDate,follow.cWeekDay];
}

-(void)ZJFollowTableViewCell:(ZJFollowTableViewCell *)view cellIndexPath:(NSIndexPath *)indexPath{
    
 
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定删除这条跟进？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        ZJFollowUpTableInfo *followSec = self.tableDataArray[indexPath.section];
        
        ZJFollowUpTableInfo *followRow = followSec.followModelArray[indexPath.row];
        
        [ZJFMdb sqlDelecteData:followRow tableName:ZJFollowTableName headString:followRow.iAutoID];
        [followSec.followModelArray removeObject:followRow];
        
        NSIndexSet  *set = [NSIndexSet indexSetWithIndex:indexPath.section];
        [self.followTable reloadSections:set withRowAnimation:UITableViewRowAnimationFade];

    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancel];
    [alert addAction:done];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark   跟进信息返回刷新界面

-(void)ZJFolloweViewController:(ZJFolloweViewController *)view{
    
    [self getDateFromSql];

    [self.followTable reloadData];
}
#pragma mark   ZJMuneIamgeViewDelegate
-(void)ZJMuneIamgeView:(ZJMuneIamgeView *)view didDlickButton:(UIButton *)button{
    
        [self getRemindData];

    
        if (button.tag ==1) {
            ZJRemindTableInfo *remind = self.firstRemindArray.firstObject;
            
            self.CustomerModel.firstDate = remind.cRemindDate;
    
        
        if (self.continueRemindArray.count>0) {
            
            ZJRemindTableInfo *remind = self.continueRemindArray.firstObject;

            self.CustomerModel.continueLoanDate = remind.cRemindDate;

            
        }
    
        ZJCustomerInfoScanController *edit = [[ZJCustomerInfoScanController alloc]init];
        edit.delegate = self;
        edit.entingModel = ZJCustomerEntingEdit;
        self.CustomerModel.openBirthRemind = _openBirthRemind;
        self.CustomerModel.openContinueRemind = _openContinueRemind;
        self.CustomerModel.openFirstRemind = _openFirstRemind;
        
        edit.customerModel = self.CustomerModel;
        
        [self.navigationController pushViewController:edit animated:YES];
        
    }else if (button.tag ==2){
        
        
        NSString *message = [NSString stringWithFormat:@"确定要删除%@吗?",self.CustomerModel.cName];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //删除照片 录音  数据库  跟进  提醒等等
            [self packageDelete];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancel];
        [alert addAction:done];
        
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        [root presentViewController:alert animated:YES completion:nil];
        
    }
        
    [view removeFromSuperview];
        
    view = nil;
 
}

#pragma mark   customerInfo代理
-(void)ZJCustomerInfoScanController:(ZJCustomerInfoScanController *)view customerInfo:(ZJcustomerTableInfo *)cusromerInfo{
    self.CustomerModel = cusromerInfo;
    
    if (_msgButton.selected) {
        
        [self clickFollowButton:_followButton];
        
        [self clickMsgButton:_msgButton];
        
    }else if (_remaindButton.selected){
        
        [self clickFollowButton:_followButton];
        
        [self clickRemindButton:_remaindButton];
    }
    
    _nameLabel.text = cusromerInfo.cName;
    [_nameLabel zj_adjustWithMin];
    _nameLabel.centerX = _topImgView.centerX;

    _phoneLabel.text = cusromerInfo.cPhone;
    
    UIImage *image = nil;
    if (self.CustomerModel.iSex == 0) {
        
        image = [UIImage imageNamed:@"MAN_iocn"];
    }else{
        image = [UIImage imageNamed:@"WOMAN_icon"];
    }
    _sexImageView.image = image;
    
    _sexImageView.x = CGRectGetMaxX(_nameLabel.frame)+3;

    
}
//设置顶部索引视图button属性
-(void)indexButton:(UIButton *)button title:(NSString *)title{
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:ZJColor00D3A3 forState:UIControlStateNormal];
    [button setTitleColor:ZJColorFFFFFF forState:UIControlStateSelected];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
}
#pragma mark   点击跟进按钮
-(void)clickFollowButton:(UIButton *)button{
    _tempButtom.selected = NO;
    _tempButtom = button;
    _tempButtom.selected = YES;
    //按客户修正：跟进与资料互换位置。  --20161221  mjd
    //_indexView.image = [UIImage imageNamed:@"left"];
    _indexView.image = [UIImage imageNamed:@"centre"];
    if (_remindView) {
        [_remindView removeFromSuperview];
        _remindView = nil;
        
    }else if (_scrollerView){
        
        [_scrollerView removeFromSuperview];
        _scrollerView = nil;
    }else if(_followTable){
        return;
    }
    [self setupCustomerFolloeView];
    
}
#pragma mark   点击资料按钮
-(void)clickMsgButton:(UIButton *)button{

    _tempButtom.selected = NO;
    _tempButtom = button;
    _tempButtom.selected = YES;
    //按客户修正：跟进与资料互换位置。  --20161221  mjd
    //_indexView.image = [UIImage imageNamed:@"centre"];
    _indexView.image = [UIImage imageNamed:@"left"];    if (_remindView) {
        [_remindView removeFromSuperview];
        _remindView = nil;

    }
    
    if (_scrollerView) return;
    //内容视图
    [self setupCustomerMsgView];
}
#pragma mark   点击提醒按钮

-(void)clickRemindButton:(UIButton *)button{

    _tempButtom.selected = NO;
    _tempButtom = button;
    _tempButtom.selected = YES;
    _indexView.image = [UIImage imageNamed:@"right"];
    
    if (_scrollerView) {
        
        [_scrollerView removeFromSuperview];
        _scrollerView = nil;
    }
    if (_remindView)return;
    
    [self setupCustomerRemindView];
}

#pragma mark   点击导航栏上更多
-(void)clickMoreButton:(UIButton *)button{
    
    if (_muneImgView) {
        [_muneImgView removeFromSuperview];
        _muneImgView = nil;
    }else{
        
        ZJMuneIamgeView *mune = [[ZJMuneIamgeView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        mune.delegate = self;
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:mune];
  

    }
   
}

#pragma mark   ZJremindSetViewView代理方法
-(void)ZJremindSetViewView:(ZJremindSetView *)view didClickButton:(NSInteger)tap{
    if (tap == 2) {
        ZJCustomerBrithViewController *birth = [[ZJCustomerBrithViewController alloc]init];
        birth.delegate = self;
        birth.cPhotoUrl = self.CustomerModel.iconPath;
        birth.cName = self.CustomerModel.cName;
        birth.iSex = self.CustomerModel.iSex;
        birth.cBirthDay = self.CustomerModel.cBirthDay;
        birth.openRemind = _openBirthRemind;
        [self.navigationController pushViewController:birth animated:YES];
    }else if (tap==3){
        ZJCustomerContinueRViewController*continueView = [[ZJCustomerContinueRViewController alloc]init];
        continueView.delegate = self;
        continueView.CTimeString = _continueS;
        continueView.loanTimeString = self.CustomerModel.cLoanDate;
        continueView.openRemind = _openContinueRemind;

        [self.navigationController pushViewController:continueView animated:YES];
    }else if(tap==4){
        
        ZJFirstRefundViewController *first = [[ZJFirstRefundViewController alloc]init];
        first.delegate = self;
        first.ReTimeString = _firstS;
        first.loanTimeString = self.CustomerModel.cLoanDate;
        first.openRemind = _openFirstRemind;
        [self.navigationController pushViewController:first animated:YES];
    }

}
#pragma mark   //点击打电话或者发短信
-(void)clickPhoneButton:(UIButton *)button{
    UIAlertController *phoneMsg = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    NSString *phoneNumber = self.CustomerModel.cPhone ;
    
    UIAlertAction * phone= [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        NSString *url = [NSString stringWithFormat:@"telprompt://%@",phoneNumber];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
        
    }];
    
    UIAlertAction * sendMsg= [UIAlertAction actionWithTitle:@"短信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *url=[NSString stringWithFormat:@"sms://%@",phoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [phoneMsg addAction:phone];

    [phoneMsg addAction:sendMsg];
    [phoneMsg addAction:cancel];
    
    [self presentViewController:phoneMsg animated:YES completion:nil];

}
#pragma mark   生日控制器代理方法

-(void)ZJCustomerBrith:(ZJCustomerBrithViewController *)view switctButton:(NSInteger)isSelect{
    
    if (isSelect ==_openBirthRemind)return;
    
    _openBirthRemind = isSelect;
    
    [self revampRemindTableWithiRemindType:1 customerID:self.CustomerModel.iAutoID iSwitch:isSelect];

}

#pragma mark   续贷提醒控制器代理方法
-(void)ZJCustomerContinue:(ZJCustomerContinueRViewController *)view switctButton:(NSInteger)isSelect date:(NSString *)date {
    _continueS = date;
    
    NSString*temp = [_continueS zj_dateStringFormatter:@"yyyy-MM-dd" toFromatter:@"yyyy年MM月dd日"];
    
    self.remindView.continueText = [NSString stringWithFormat:@"%@之后可续贷",temp];
    if (isSelect ==_openContinueRemind) return;
    _openContinueRemind = isSelect;
    
    [self revampRemindTableWithiRemindType:2 customerID:self.CustomerModel.iAutoID iSwitch:isSelect];
    
}
#pragma mark   首期还款控制器代理方法
-(void)ZJFirstView:(ZJFirstRefundViewController *)view switctButton:(NSInteger)isSelect date:(NSString *)date{
    
    _firstS = date;
    NSString*temp = [_firstS zj_dateStringFormatter:@"yyyy-MM-dd" toFromatter:@"yyyy年MM月dd日"];
    
    self.remindView.firstText = [NSString stringWithFormat:@"%@为首期还款日",temp];
    if (isSelect ==_openFirstRemind ) return;
    
    _openFirstRemind = isSelect;
    
    [self revampRemindTableWithiRemindType:3 customerID:self.CustomerModel.iAutoID iSwitch:isSelect];
}

#pragma mark  从数据库获取数据
-(void)getDateFromSql{
    
    ZJFollowUpTableInfo *follow = [[ZJFollowUpTableInfo alloc]init];
    
    NSString *selectOnece = [NSString stringWithFormat:@"select * from %@ where iCustomerID=%zd group by cLogDate",ZJFollowTableName,self.CustomerModel.iAutoID];
    
    [ZJFMdb sqlSelecteData:follow selecteString:selectOnece success:^(NSMutableArray *successMsg) {
        
        self.tableDataArray = successMsg;
        
        self.tableDataArray = (NSMutableArray *)[[_tableDataArray reverseObjectEnumerator]allObjects];
    }];
    
    for (NSInteger i = 0; i<self.tableDataArray.count; i++) {
        
        ZJFollowUpTableInfo *follow = self.tableDataArray[i];
        
        NSString *date = follow.cLogDate;
        
        NSString *selectTwice = [NSString stringWithFormat:@"select *from %@ where cLogDate='%@' and iCustomerID=%zd",ZJFollowTableName,date,self.CustomerModel.iAutoID];
        [ZJFMdb sqlSelecteData:follow selecteString:selectTwice success:^(NSMutableArray *successMsg) {
            
            [follow.followModelArray addObjectsFromArray:successMsg];
            
            follow.followModelArray = (NSMutableArray *)[[follow.followModelArray reverseObjectEnumerator]allObjects];
            
        }];
        
    }
    if (self.tableDataArray.count==0 &&!self.holdPlaceImageView) {
        
        UIImageView *imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"跟进信息"]];
        [self.followTable addSubview:imgV];
        self.holdPlaceImageView = imgV;
        imgV.centerX = self.followTable.width/2;
        imgV.centerY = self.followTable.height/2;
    }else {
        
        [self.holdPlaceImageView removeFromSuperview];
        
        self.holdPlaceImageView = nil;
    }
}

#pragma mark---------封装删除方法

-(void)packageDelete{
    
    //删除数据库数据
    
    ZJcustomerTableInfo * model = self.CustomerModel;
    
    [ZJFMdb sqlDelecteData:model tableName:ZJCustomerTableName headString:model.iAutoID];
    //文件夹
    [ZJDirectorie deleteDirWithPath:model.GUID];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark   封装修改提醒的数据库
-(void)revampRemindTableWithiRemindType:(NSInteger)iRemindType customerID:(NSInteger)ID iSwitch:(NSInteger)iSwitch{
    
    NSString *upDate = [NSString stringWithFormat:@"UPDATE %@ SET iSwitch=%zd WHERE iRemindType =%zd AND iCustomerID=%zd",ZJRemindTableName,iSwitch,iRemindType,ID];
    
    [ZJFMdb sqlUpdataWithString:upDate];
    
}
@end











