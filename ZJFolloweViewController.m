//
//  ZJFolloweViewController.m
//  CRM
//
//  Created by mini on 16/11/2.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJFolloweViewController.h"
#import "ZJDatePickView.h"
#import "NSDate+Category.h"
#import "ZJFollowRAndPView.h"
#import <TZImagePickerController.h>//选取照片第三方
#import "ZJPhotoCollectionCell.h"//照片
#import <AVFoundation/AVFoundation.h>
#import "ZJFollowUpTableInfo.h"
#import "ZJFollowCustomerController.h"
#import "ZJFMdb.h"
#import "ZJSaveTool.h"
#import "ZJDirectorie.h"
#import "ZJcustomerTableInfo.h"

#import "NSMutableArray+Category.h"

#import "CalenderObject.h"//添加到日历提醒事件


@interface ZJFolloweViewController ()<ZJDatePickViewDelegate,ZJFollowRAndPViewDelegate,TZImagePickerControllerDelegate,UITextViewDelegate,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ZJFollowCustomerDelegate>
{
    NSInteger _timeButtonTag;//实际跟进Button还是提醒时间
    BOOL _isEdit;//**文本框是否编辑**//
    NSInteger _switchValues;//选择开关的值
    CGFloat _margin ;//图片集合视图间隙
    CGFloat _itemWidth;//集合视图items宽度
    CGFloat _reViewY;//需要重新布局视图开始的高度
    CGFloat _addFollowContentViewHeight;//的高度变化
    CGFloat _previousPhotosViewHeight;//照片视图的高度
    
    //**//播放**//
    AVAudioPlayer *_player;
    NSInteger _recodeCount;//当前录音的个数
    NSDate * _followDate;//实际跟进时间
    NSString *_weekSrtring;
    NSString *_remindDateString;
    
}
//**scroller**//
@property(nonatomic,weak) UIScrollView *scrollView;
//**底部内容视图**//
@property(nonatomic,weak) UIView *contentView;
//跟进内容
@property(nonatomic,weak) UIView *followContentView;
//**textView**//
@property(nonatomic,weak) UITextView *textView;
//**实际跟进时间View**//
@property(nonatomic,weak) UIView *followTimeView;
//**选择时间Button**//
@property(nonatomic,weak) UIButton *timeButton;
//**提醒视图**//
@property(nonatomic,weak) UIView *remaindView;
//**提醒时间**//
@property(nonatomic,weak) UIView *remaindTimeView;
//**跟进客户**//
@property(nonatomic,weak) UIView *followCView;
//**跟进客户名字**//
@property(nonatomic,weak) UILabel *customerNameLabel;
//**显示提醒时间Label**//
@property(nonatomic,weak) UILabel *remaindTimeLabel;
//**底部视图**//
@property(nonatomic,weak) UIView *bottomView;
//**录音**//
@property(nonatomic,weak) UIButton *recodeButton;
//**照片**//
@property(nonatomic,weak) UIButton *photoButton;
//时间选择器
@property(nonatomic,strong) ZJDatePickView *datePickiew;
//**弹出视图**//
@property(nonatomic,weak) ZJFollowRAndPView *FollowRAndPView;
//**照片collectionView**//
@property(nonatomic,strong) UICollectionView *photosCollectionView;
//**照片数组**//
@property(nonatomic,strong) NSMutableArray *photosArray;
//**照片数组**//
@property(nonatomic,strong) NSMutableArray *selectedAssets;

//**录音名字数组**//
@property(nonatomic,strong) NSMutableArray *recodeNameArray;
//**录音视图**//
@property(nonatomic,strong) NSMutableArray *recodeViewArray;
//**录音Button数组 **//
@property(nonatomic,strong) NSMutableArray *recodeButtonArray;
//**删除录音Button数组**//
@property(nonatomic,strong) NSMutableArray *delectrecodeArray;
//**录音文件所在地址**//
@property(nonatomic,strong) NSMutableArray *recodePathArray;
//**************


@end
static NSString *const identifier = @"itemCell";

@implementation ZJFolloweViewController
//懒加载
-(NSMutableArray *)selectedAssets{
    if (!_selectedAssets) {
        
        _selectedAssets = [NSMutableArray array];
    }
    return _selectedAssets;
}

//懒加载
-(NSMutableArray *)photosArray{
    if (!_photosArray) {
        
        _photosArray = [NSMutableArray array];
    }
    return _photosArray;
}

-(UICollectionView *)photosCollectionView{
    if (!_photosCollectionView) {
        
        [self addPhotosViewWithPhotosCount:self.photosArray.count];
    }
    return _photosCollectionView;
}
-(NSMutableArray *)recodeNameArray{
    if (!_recodeNameArray) {
        
        _recodeNameArray = [NSMutableArray array];
        _recodeButtonArray = [NSMutableArray array];
        _delectrecodeArray = [NSMutableArray array];
        _recodePathArray = [NSMutableArray array];
        _recodeViewArray = [NSMutableArray array];
    }
    return _recodeNameArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    //监听键盘出现和退出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}


-(void)setupUI{
    //导航
    [self setupNavi];
    [self setupScrollView];
    //跟进视图
    [self setupFollowUI];
}
#pragma mark   设置导航
-(void)setupNavi{
    self.view.backgroundColor = ZJBackGroundColor;
    self.navigationItem.title = @"跟进提醒";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem zj_BarButtonItemWithTitle:@"保存" titleColor:ZJColorFFFFFF target:self action:@selector(clickSaveButton:)];
}

-(void)setupScrollView{
    CGRect frame = CGRectMake(0, 0, zjScreenWidth, self.view.height -64- PX2PT(145));
    UIScrollView *scroller = [[UIScrollView alloc]initWithFrame:frame];
    [self.view addSubview:scroller];
    scroller.contentSize = CGSizeMake(0, 800);
    self.scrollView = scroller;
    scroller.delegate = self;
    
    UIView *content = [[UIView alloc]init];
    [scroller addSubview:content];
    content.frame = CGRectMake(0, 0, zjScreenWidth, 800);
    content.backgroundColor = ZJBackGroundColor;
    self.contentView = content;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [content addGestureRecognizer:tap];
}
-(void)tap{
    [self.textView resignFirstResponder];
    
    if (_datePickiew) {
        
        [_datePickiew removeFromSuperview];
        _datePickiew = nil;
    }
}
#pragma mark   跟进
-(void)setupFollowUI{
    
    NSDate *defaul = [NSDate new];
    
    NSString *afterDay = [defaul zj_getDateAfterDays:1 dateFormat:@"yyyy-MM-dd"];
    
    afterDay = [NSString stringWithFormat:@"%@ 08:00",afterDay];
    

    NSDate *remin = [afterDay zj_getDateFromStringWithFormatter:@"yyyy-MM-dd HH:mm"];
    
    _remindDateString = [remin zj_getStringFromDatWithFormatter:@"yyyy-MM-dd HH:mm"];
    _margin = 3;
    _reViewY = PX2PT(512);
    _itemWidth = (self.view.width - 2*ZJmargin40 - 3*_margin)/4;
    //跟进内容底部视图
    UIView *follow = [[UIView alloc]init];
    follow.backgroundColor = ZJColorFFFFFF;
    [_contentView addSubview:follow];
    follow.frame = CGRectMake(0, 0, zjScreenWidth, PX2PT(512));
    self.followContentView = follow;
    
        //跟进内容label
    UILabel *Flabel = [[UILabel alloc]init];
    [Flabel zj_labelText:@"跟进内容" textColor:ZJColor00D3A3 textSize:ZJTextSize45PX];
    [_followContentView addSubview:Flabel];
    [Flabel zj_adjustWithMin];
    Flabel.x = ZJmargin40;
    Flabel.y = PX2PT(60);
        //textField
    UITextView *textView = [[UITextView alloc]init];
    [follow addSubview:textView];
    self.textView = textView;
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    textView.textColor = ZJColor505050;
    textView.text = @"请输入客户跟进内容...";
    CGFloat textViewY = CGRectGetMaxY(Flabel.frame);
    textView.frame = CGRectMake(PX2PT(25), textViewY, zjScreenWidth-PX2PT(50), PX2PT(512)-textViewY);
    
    //实际跟进时间视图
    CGFloat timeVY = CGRectGetMaxY(follow.frame);
    UIView *timeView = [[UIView alloc]init];
    timeView.backgroundColor = ZJColorFFFFFF;
    timeView.frame = CGRectMake(0, timeVY, zjScreenWidth, PX2PT(200));
    [_contentView addSubview:timeView];
    self.followTimeView = timeView;
        //分割线
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = ZJColorDCDCDC;
    [timeView addSubview:line];
    line.frame = CGRectMake(0, 0, zjScreenWidth, 1);
    
        //分割线
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = ZJColorDCDCDC;
    [timeView addSubview:line2];
    line2.frame = CGRectMake(0, timeView.height-1, zjScreenWidth, 1);
    
    
        //选择时间Button
    UIButton *timeButton = [[UIButton alloc]init];
    timeButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    [timeView addSubview:timeButton];
    self.timeButton = timeButton;
    timeButton.tag = 1;
    timeButton.frame = CGRectMake(ZJmargin40, PX2PT(50), PX2PT(700), PX2PT(100));
    [timeButton addTarget:self action:@selector(clickFollewDateButton:) forControlEvents:UIControlEventTouchUpInside];
        //设置边框  宽度  颜色 圆角
    [timeButton.layer setMasksToBounds:YES];
    [timeButton.layer setBorderWidth:1];
    timeButton.layer.borderColor = ZJColor00D3A3.CGColor;
    timeButton.layer.cornerRadius = 3;
    [timeButton clipsToBounds];
    self.timeButton = timeButton;
    [timeButton setTitleColor:ZJColor00D3A3 forState:UIControlStateNormal];
    _followDate = [[NSDate alloc]init];
    NSString * buttonS = [NSString stringWithFormat:@"实际跟进时间：%@",[_followDate zj_getStringFromDatWithFormatter:@"MM-dd HH:mm"]];
    [timeButton setTitle:buttonS forState:UIControlStateNormal];
    
    //提醒
    CGFloat remaindY = CGRectGetMaxY(timeView.frame)+ZJmargin40;
    UIView *remaind = [[UIView alloc]init];
    remaind.backgroundColor = ZJColorFFFFFF;
    [_contentView addSubview:remaind];
    self.remaindView = remaind;
    remaind.frame = CGRectMake(0, remaindY, zjScreenWidth, PX2PT(128));
    
    //分割线
    UIView *line3 = [[UIView alloc]init];
    line3.backgroundColor = ZJColorDCDCDC;
    [remaind addSubview:line3];
    line3.frame = CGRectMake(0, 0, zjScreenWidth, 1);
        //左边label
    UILabel *Rlabel = [[UILabel alloc]init];
    [remaind addSubview:Rlabel];
    [Rlabel zj_labelText:@"提醒" textColor:ZJColor00D3A3 textSize:ZJTextSize45PX];
    [Rlabel zj_adjustWithMin];
    Rlabel.x = ZJmargin40;
    Rlabel.centerY = PX2PT(128)/2.0;
        //右边switch
    UISwitch *Rswitch = [[UISwitch alloc]init];
    [remaind addSubview:Rswitch];
    Rswitch.on = NO;
    Rswitch.onTintColor = ZJColor00D3A3;
    [Rswitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    Rswitch.centerY = PX2PT(128)/2.0;
    Rswitch.x = zjScreenWidth - ZJmargin40-51;
    
    //提醒时间View
    CGFloat remaindTVY = CGRectGetMaxY(remaind.frame)+1;
    UIView *remaindTV =[[UIView alloc]init];
    self.remaindTimeView = remaindTV;
    remaindTV.backgroundColor = ZJColorFFFFFF;
    remaindTV.frame = CGRectMake(0, remaindTVY, zjScreenWidth, PX2PT(200));
    [_contentView addSubview:remaindTV];
        //  提醒时间
    UILabel *rtLabel = [[UILabel alloc]init];
    [remaindTV addSubview:rtLabel];
    [rtLabel zj_labelText:@"提醒时间" textColor:ZJColor00D3A3 textSize:ZJTextSize45PX];
    [rtLabel zj_adjustWithMin];
    rtLabel.x = ZJmargin40;
    rtLabel.y = ZJmargin40;
        //日期
    UILabel *dateLabel = [[UILabel alloc]init];
    [remaindTV addSubview:dateLabel];
    self.remaindTimeLabel = dateLabel;
    dateLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    dateLabel.textColor = ZJColorDCDCDC;
    dateLabel.x = ZJmargin40;
    dateLabel.y = CGRectGetMaxY(rtLabel.frame)+PX2PT(30);
    dateLabel.width = 200;
    dateLabel.height = 15;
    NSDate *now = [NSDate new];
    NSString * dateString = [now zj_getDateAfterDays:1 dateFormat:@"yyyy-MM-dd HH:mm"];
    dateLabel.text =dateString;
    remaindTV.hidden = YES;
        //  点击的Button
    UIButton *coverButton = [[UIButton alloc]init];
    coverButton.tag = 2;
    [remaindTV addSubview:coverButton];
    coverButton.width = zjScreenWidth;
    coverButton.height =31;
    coverButton.centerY = dateLabel.centerY;
    [coverButton setImage:[UIImage imageNamed:@"arrows"] forState:UIControlStateNormal];
    coverButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    coverButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, ZJmargin40);
    [coverButton addTarget:self action:@selector(clickRemaindButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.FollowEnterModel == FirstEnterModel) {
        
        UIView *customer = [[UIView alloc]init];
        [_contentView addSubview:customer];
        self.followCView = customer;
        customer.backgroundColor = ZJColorFFFFFF;
        CGFloat FY = CGRectGetMaxY(remaind.frame)+1;
        customer.frame = CGRectMake(0, FY, zjScreenWidth, PX2PT(128));
        
        
        //分割线
        UIView *line4 = [[UIView alloc]init];
        line4.backgroundColor = ZJColorDCDCDC;
        [customer addSubview:line4];
        line4.frame = CGRectMake(0, customer.height -1, zjScreenWidth, 1);
        
        UILabel *followLable = [[UILabel alloc]init];
        [customer addSubview:followLable];
        [followLable zj_labelText:@"跟进客户：" textColor:ZJColor505050 textSize:ZJTextSize45PX];
        [followLable zj_adjustWithMin];
        followLable.x = ZJmargin40;
        followLable.centerY = PX2PT(128)/2;
        UILabel *customerName = [[UILabel alloc]init];
        self.customerNameLabel = customerName;
        [customer addSubview:customerName];
        customerName.textColor = ZJColor505050;
        customerName.font = [UIFont systemFontOfSize:ZJTextSize45PX];
        customerName.textAlignment = NSTextAlignmentCenter;
        
        customerName.width = 100;
        customerName.height = 16;
        customerName.centerY= followLable.centerY;
        customerName.x = followLable.width +ZJmargin40;
        
        UIButton *customerButton = [[UIButton alloc]init];
        [customer addSubview:customerButton];
        customerButton.width = zjScreenWidth;
        customerButton.height =31;
        customerButton.centerY = followLable.centerY;
        [customerButton setImage:[UIImage imageNamed:@"arrows"] forState:UIControlStateNormal];
        customerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        customerButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, ZJmargin40);
        [customerButton addTarget:self action:@selector(clickCustomerButton:) forControlEvents:UIControlEventTouchUpInside];

    }
    //底部录音和图片
    UIView *bottomV = [[UIView alloc]init];
    [self.view addSubview:bottomV];
    bottomV.backgroundColor = ZJColorFFFFFF;
    self.bottomView = bottomV;
    bottomV.frame = CGRectMake(0, self.view.height - 64-PX2PT(145), zjScreenWidth, PX2PT(145));
    
    UIView *Hline = [[UIView alloc]init];
    [bottomV addSubview:Hline];
    Hline.backgroundColor = ZJColorDCDCDC;
    Hline.frame = CGRectMake(0, 0, zjScreenWidth, 1);
    
    CGFloat buttonWidth = (zjScreenWidth -1)/2.0;
    
    UIView *Vline = [[UIView alloc]init];
    [bottomV addSubview:Vline];
    [bottomV addSubview:Vline];
    Vline.backgroundColor = ZJColorDCDCDC;
    Vline.frame = CGRectMake(buttonWidth, 0, 1, PX2PT(145));
    
    //录音button
    UIButton *recodeB = [[UIButton alloc]init];
    [bottomV addSubview:recodeB];
    self.recodeButton = recodeB;
    [recodeB setImage:[UIImage imageNamed:@"follow-record"] forState:UIControlStateNormal];
    [recodeB setImage:[UIImage imageNamed:@"UN-record"] forState:UIControlStateSelected];
    recodeB.frame = CGRectMake(0, 1, buttonWidth, PX2PT(145)-1);
    [recodeB addTarget:self action:@selector(clickBottonRecodeButton) forControlEvents:UIControlEventTouchUpInside];
    //照片Button
    UIButton *photoButton = [[UIButton alloc]init];
    [bottomV addSubview:photoButton];
    self.photoButton = photoButton;
    [photoButton setImage:[UIImage imageNamed:@"follow-photo"] forState:UIControlStateNormal];
    [photoButton setImage:[UIImage imageNamed:@"UN-photo"] forState:UIControlStateSelected];
    photoButton.frame = CGRectMake(buttonWidth+1, 1, buttonWidth, PX2PT(145)-1);
    [photoButton addTarget:self action:@selector(clickBottonPhotoButton) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark   放照片的视图

-(void)addPhotosViewWithPhotosCount:(NSInteger)count{

    CGFloat itemHeight = _itemWidth;
    NSInteger row = count/5+1;
    CGFloat photosViewHeight = _itemWidth*row+2*PX2PT(52)+(count/5)*3;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(_itemWidth, itemHeight);
    flowLayout.minimumLineSpacing = _margin;
    flowLayout.minimumInteritemSpacing = _margin;
    flowLayout.sectionInset = UIEdgeInsetsMake(PX2PT(52), ZJmargin40, PX2PT(52), ZJmargin40);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

    CGRect frame = CGRectMake(0, _reViewY, zjScreenWidth, photosViewHeight);
    _photosCollectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:flowLayout];
    [_contentView addSubview:_photosCollectionView];

    _photosCollectionView.scrollEnabled = NO;
    _photosCollectionView.backgroundColor = ZJColorFFFFFF;
    _photosCollectionView.showsVerticalScrollIndicator = NO;
    _photosCollectionView.showsHorizontalScrollIndicator = NO;
    _photosCollectionView.delegate = self;
    _photosCollectionView.dataSource = self;
    [_photosCollectionView registerClass:[ZJPhotoCollectionCell class] forCellWithReuseIdentifier:identifier];
    //分割线
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = ZJBackGroundColor ;
    [_photosCollectionView addSubview:line];
    line.frame = CGRectMake(0, 0, zjScreenWidth, 1);
    
}


#pragma mark   监听键盘弹出收回的通知方法
-(void) keyBoardChange:(NSNotification *)note{
    //获取键盘弹出或收回时frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //获取键盘弹出所需时长
    float duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //添加弹出动画
    [UIView animateWithDuration:duration animations:^{
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, keyboardFrame.origin.y - self.view.height-64);
    }];
    
    _recodeButton.selected = !_recodeButton.selected;
    _photoButton.selected = !_photoButton.selected;
}

#pragma mark---------点击实际跟进时间
-(void)clickFollewDateButton:(UIButton *)button{
    [self.textView resignFirstResponder];
    _timeButtonTag = button.tag;
    if (_datePickiew) return;
    _datePickiew = [[ZJDatePickView alloc]init];
    _datePickiew.delegate = self;
    _datePickiew.minDate = [NSDate new];
    _datePickiew.dateModel= ZJDatePickViewDateAndHoursModel;
    [self.view addSubview:_datePickiew];
    _datePickiew.frame = CGRectMake(0, self.view.height, self.view.width,0);
    [UIView animateWithDuration:0.3 animations:^{
        
        _datePickiew.frame = CGRectMake(0, self.view.height-zjScreenHeight/3.0, self.view.width, zjScreenHeight/3.0);

    }];
    NSString * buttonS = [NSString stringWithFormat:@"实际跟进时间：%@",[[NSDate new] zj_getStringFromDatWithFormatter:@"MM-dd HH:mm"]];
    [button setTitle:buttonS forState:UIControlStateNormal];
    
}
#pragma mark   点击提醒时间button
-(void)clickRemaindButton:(UIButton *)button{
    [self.textView resignFirstResponder];

    _timeButtonTag = button.tag;
    if (_datePickiew) return;
    _datePickiew = [[ZJDatePickView alloc]init];
    _datePickiew.delegate = self;
    _datePickiew.minDate = [NSDate new];
    _datePickiew.dateModel= ZJDatePickViewDateAndHoursModel;
    [self.view addSubview:_datePickiew];
    _datePickiew.frame = CGRectMake(0, self.view.height, self.view.width,0);
    [UIView animateWithDuration:0.3 animations:^{
        
        _datePickiew.frame = CGRectMake(0, self.view.height-zjScreenHeight/3.0, self.view.width, zjScreenHeight/3.0);
        
    }];
    NSString * dateString = [NSString stringWithFormat:@"%@",[[NSDate new] zj_getStringFromDatWithFormatter:@"yyyy-MM-dd HH:mm"]];
    self.remaindTimeLabel.text =dateString;

}
#pragma mark  点击获取客户
-(void)clickCustomerButton:(UIButton *)button{
    ZJFollowCustomerController *followCustomer = [[ZJFollowCustomerController alloc]init];
    followCustomer.delegate = self;
    
    [self.navigationController pushViewController:followCustomer animated:YES];
}
#pragma mark   滑动switch
-(void)changeSwitch:(UISwitch *)Rswitch{
    
    self.remaindTimeView.hidden = !Rswitch.on;
    _switchValues = Rswitch.on ;
    if (self.FollowEnterModel == FirstEnterModel &&Rswitch.on) {
        
        self.followCView.y = CGRectGetMaxY(self.remaindTimeView.frame)+1;
    }else if (self.FollowEnterModel == FirstEnterModel &&!Rswitch.on){
        
        self.followCView.y  = CGRectGetMaxY(self.remaindView.frame)+1;
    }
}
#pragma mark   //封装弹出视图
-(void)alateView{
    CGRect frame = CGRectMake(0, 0, zjScreenWidth, zjScreenHeight);
    ZJFollowRAndPView *followRAndPView = [[ZJFollowRAndPView alloc]initWithFrame:frame];
    self.FollowRAndPView = followRAndPView;
    followRAndPView.delegate = self;
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [root.view addSubview:followRAndPView];
}

#pragma mark   点击底部录音BUtton
-(void)clickBottonRecodeButton{

    if (_recodeCount ==3) {
        
        [self autorAlertViewWithMsg:@"最多只能录3条"];
        return;
    }
    [_textView resignFirstResponder];
    [self alateView];
}

#pragma mark   点击底部照片Button
-(void)clickBottonPhotoButton{
    [self clickAddPhotos];
}

#pragma mark   UICollectionView代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photosArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZJPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.imageV.image = [self compressImage:self.photosArray[indexPath.row]];
    return cell;


}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:self.photosArray index:indexPath.row];
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.isSelectOriginalPhoto = NO;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.photosArray = [NSMutableArray arrayWithArray:photos];
        _selectedAssets = [NSMutableArray arrayWithArray:assets];
        isSelectOriginalPhoto = NO;
        [_photosCollectionView reloadData];
        //判断高度
        CGFloat photosViewHeight = 0;
        if (self.photosArray.count>4) {
            
            photosViewHeight = _itemWidth*2+PX2PT(52)+ZJmargin40+_margin;
            
        }else{
            photosViewHeight = _itemWidth+PX2PT(52)+ZJmargin40;
            
        }
        _addFollowContentViewHeight = photosViewHeight - _previousPhotosViewHeight;
        _previousPhotosViewHeight =photosViewHeight;
        [self reLayoutViewFrame];

    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
    
}


#pragma mark---------ZJDatePickViewdelegate
-(void)ZJDatePickView:(ZJDatePickView *)view datePickView:(UIDatePicker *)datePick{
    if (_timeButtonTag ==1) {
        _followDate = datePick.date;
        NSString * buttonS = [NSString stringWithFormat:@"实际跟进时间：%@",[datePick.date zj_getStringFromDatWithFormatter:@"MM-dd HH:mm"]];
        [_timeButton setTitle:buttonS forState:UIControlStateNormal];
    }else{
        NSString * labelS = [NSString stringWithFormat:@"%@",[datePick.date zj_getStringFromDatWithFormatter:@"yyyy-MM-dd HH:mm"]];

        self.remaindTimeLabel.text = labelS;
        _remindDateString = labelS;
    }

    
}

-(void)ZJDatePickView:(ZJDatePickView *)view isChoose:(BOOL)choose{
    
    [_datePickiew removeFromSuperview];
    _datePickiew = nil;
}
#pragma mark   ZJFollowCustomerControllerDelegate
-(void)ZJFollowCustomerController:(ZJFollowCustomerController *)view customerModel:(ZJcustomerTableInfo *)customerModel{
    self.customerNameLabel.text = customerModel.cName;
    self.customerModel = customerModel;
    
}
#pragma mark   ZJFollowRAndPViewDelegate
//照片
-(void)ZJFollowRAndPView:(ZJFollowRAndPView *)view clickButton:(UIButton *)button{
    
    [self clickAddPhotos];
}
//弹框
-(void)ZJFollowRAndPView:(ZJFollowRAndPView *)view isActive:(BOOL)active{
    if (active) {
    
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"正在录音" preferredStyle:UIAlertControllerStyleAlert];
        
        [root presentViewController:alert animated:YES completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
        
    }else{
        [view removeFromSuperview];
        view = nil;
    }
}
//添加录音View
-(void)ZJFollowRAndPView:(ZJFollowRAndPView *)view recodePath:(NSString *)path recodeFileName:(NSString *)name recodeTime:(NSInteger)time{
    [self addRecodeViewWithPath:path name:name time:time];
    [view removeFromSuperview];
    view = nil;
    [self reLayoutViewFrame];

}

#pragma mark   UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (!_isEdit) {
        
        textView.text = @"";
    }
    _isEdit = YES;
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length<1) {
        
        textView.text = @"请输入客户跟进内容...";
        _isEdit = NO;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString *temp = [textView.text stringByAppendingString:text];
    
    if (temp.length<=300) {
        
        return YES;
    }else{
        [self autorAlertViewWithMsg:@"您最多可以输入300个字符"];
        return NO;
        
    }
    
}


#pragma mark   UIScrollViewDelegate
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (_datePickiew) {
//        
//        [_datePickiew removeFromSuperview];
//        _datePickiew = nil;
//    }
//    [_textView resignFirstResponder];
//}

#pragma mark   添加录音视图
-(void)addRecodeViewWithPath:(NSString *)path name:(NSString *)name time:(NSInteger)time{
    UIView *recodeView = [[UIView alloc]init];
    recodeView.backgroundColor = ZJColorFFFFFF;
    [_contentView addSubview:recodeView];
    recodeView.frame = CGRectMake(0, _reViewY, zjScreenWidth, PX2PT(125));
    
    //播放按钮
    UIButton *recodeButton = [[UIButton alloc]init];
    [recodeView addSubview:recodeButton];
    [recodeButton setImage:[UIImage imageNamed:@"trumpet"] forState:UIControlStateNormal];
    [recodeButton setTitle:[NSString stringWithFormat:@"%zd\"",time] forState:UIControlStateNormal];
    [recodeButton setTitleColor:ZJColor505050 forState:UIControlStateNormal];
    recodeButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    recodeButton.height = PX2PT(78);
    recodeButton.width = 3*ZJmargin40 +31+(zjScreenWidth - 6*ZJmargin40 - 61)*time/180;
    recodeButton.x = ZJmargin40;
    recodeButton.centerY = PX2PT(124)/2.0;
    [recodeButton addTarget:self action:@selector(clickRecodeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    recodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    recodeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    recodeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    
    //边框
    [recodeButton.layer setMasksToBounds:YES];
    [recodeButton.layer setBorderWidth:1.0];
    recodeButton.layer.borderColor = ZJColor505050.CGColor;
    //    圆角
    recodeButton.layer.cornerRadius = 2.0;

    //删除按钮
    UIButton *deleteButton =[[UIButton  alloc]init];
    [recodeView addSubview:deleteButton];
    [deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    deleteButton.width = 26;
    deleteButton.height = 26;
    deleteButton.centerY = recodeButton.centerY;
    deleteButton.x = zjScreenWidth - ZJmargin40 - 26;
    [deleteButton addTarget:self action:@selector(clickDelectButton:) forControlEvents:UIControlEventTouchUpInside];
    //分割线
    UIView *line = [[UIView alloc]init];
    [recodeView addSubview:line];
    line.backgroundColor = ZJBackGroundColor;
    line.frame = CGRectMake(0, 0, zjScreenWidth, 1);
    //添加进数组
    [self.recodeNameArray addObject:name];
    [self.recodeViewArray addObject:recodeView];
    [self.recodeButtonArray addObject:recodeButton];
    [self.delectrecodeArray addObject:deleteButton];
    [self.recodePathArray addObject:path];
    _reViewY += PX2PT(125);
    _addFollowContentViewHeight=PX2PT(125);
    _recodeCount++;
}
//播放录音
-(void)clickRecodeButton:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        NSInteger index = [self.recodeButtonArray indexOfObject:button];
        NSString *path = self.recodePathArray[index];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSURL alloc]initFileURLWithPath:path isDirectory:YES] error:nil];
        [_player play];
        
    }else{
        
        [_player pause];
    }
    
}
//删除
-(void )clickDelectButton:(UIButton *)button{
    
    NSInteger index = [self.delectrecodeArray indexOfObject:button];
    UIView *view = self.recodeViewArray[index];

    [self.recodeViewArray removeObjectAtIndex:index];
    [self.recodeButtonArray removeObjectAtIndex:index];
    [self.recodePathArray removeObjectAtIndex:index];
    [self.recodeNameArray removeObjectAtIndex:index];
    [self.delectrecodeArray removeObjectAtIndex:index];
    [view removeFromSuperview];
    view = nil;
    _reViewY -=PX2PT(125);
    _addFollowContentViewHeight = -PX2PT(125);
    [self reLayoutViewFrame];
    _recodeCount--;
}

#pragma mark   从新布局视图
-(void)reLayoutViewFrame{
    
    if (_photosCollectionView) {
        
        _photosCollectionView.y=_reViewY;
        _photosCollectionView.height = _previousPhotosViewHeight;
    
    }
    //实际跟进时间
    self.followTimeView.y += _addFollowContentViewHeight;
    //提醒
    self.remaindView.y += _addFollowContentViewHeight;
    //提醒时间
    self.remaindTimeView.y += _addFollowContentViewHeight;
    //联系人
    if (self.FollowEnterModel == FirstEnterModel) {
        
        self.followCView.y += _addFollowContentViewHeight;
    }
}
#pragma mark   //点击保存
-(void)clickSaveButton:(UIButton *)button{
    
    if (_datePickiew) {
        
        [_datePickiew removeFromSuperview];
        _datePickiew = nil;
    }
    
    [self.textView resignFirstResponder];
    
    if (!_isEdit&&self.recodeViewArray.count==0&&self.photosArray.count==0) {
        
        [self autorAlertViewWithMsg:@"请设定跟进内容"];
        return;
    }
    
    if (_FollowEnterModel ==FirstEnterModel &&self.customerNameLabel.text.length==0) {
        [self autorAlertViewWithMsg:@"请选择客户"];
        
        return;
        
    }
    ZJFollowUpTableInfo *follow = [[ZJFollowUpTableInfo alloc]init];
    if (_isEdit) {
        
        follow.cText = self.textView.text;
    }
    follow.iRemind = _switchValues;
    follow.cRemindTime = self.recodeButton.titleLabel.text ;
    follow.cLogDate = [_followDate zj_getStringFromDatWithFormatter:@"yyyy-MM-dd"];
    follow.cLogTime = [_followDate zj_getStringFromDatWithFormatter:@"HH:mm"];
    follow.photosArray = self.photosArray;
    follow.recodeNameArray = self.recodeNameArray;
    
    
    NSArray *weekDay = @[@"星期天",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    
    NSInteger weekIndex = [_followDate zj_getRealTimeForRequire:NSCalendarUnitWeekday];

    follow.cWeekDay = weekDay[weekIndex-1];
    
    if (self.FollowEnterModel ==AddEnterModel) {
        
        follow.dateString = _remindDateString;
//        self.model(follow);

    }else if (self.FollowEnterModel ==FirstEnterModel||self.FollowEnterModel ==DirectEnterModel){
        
        NSString *picturePath = [ZJDirectorie getImagePathWithDirectoryName:self.customerModel.GUID];
        
        NSString *voicePath = [ZJDirectorie getVoicePathWithDirectoryName:self.customerModel.GUID];

        follow.iCustomerID = self.customerModel.iAutoID;
        
        if (follow.iRemind) {
            
            NSString *starTime = _remindDateString;
            
            
            NSString *idefitier = [NSString stringWithFormat:@"%zd",follow.iCustomerID];
            
            NSString *title = [NSString stringWithFormat:@"[好客]：客户%@有跟进提醒",self.customerModel.cName];
            
            [CalenderObject initWithTitle:title andIdetifider:idefitier WithStartTime:starTime andEndTime:starTime Location:nil andNoticeFirTime:0 withNoticeEndTime:0];

        }
        
        //录音名字
        [ZJSaveTool zj_moveFileFromPath:NSTemporaryDirectory()
                                 toPath:voicePath
                               fileName:self.recodeNameArray];
        
        follow.cVoiceUrl = [self.recodeNameArray zj_stringFromArrayString];
        
        NSMutableArray *followPhotosName = [ZJSaveTool zj_savePhotos:self.photosArray path:picturePath UUIDName:[ZJSaveTool zj_stringWithGUID]];
        
        follow.cPhotoUrl = [followPhotosName zj_stringFromArrayString];
        
        [ZJFMdb sqlInsertData:follow tableName:ZJFollowTableName];

    }
    
    if (self.FollowEnterModel ==DirectEnterModel){
        
        [self.delegate ZJFolloweViewController:self];
    }
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark   点击添加照片按钮
-(void)clickAddPhotos{
    
    TZImagePickerController *tzpc = [[TZImagePickerController alloc] initWithMaxImagesCount:8 - self.photosArray.count delegate:self];
    tzpc.allowPickingOriginalPhoto = NO;
    tzpc.allowPickingVideo = NO;
    
    [tzpc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto){
        
        [self.photosArray addObjectsFromArray:photos];
        [self.selectedAssets addObjectsFromArray:assets];
        
        //判断是否获取了照片
        if (photos.count>0) {
            [self.photosCollectionView reloadData];
            NSInteger count = self.photosArray.count;
            
            CGFloat photosViewHeight = _itemWidth*(count/5+1)+2*PX2PT(52)+(count/5)*3;
            if (photosViewHeight - _previousPhotosViewHeight>0) {
                
                _addFollowContentViewHeight = photosViewHeight - _previousPhotosViewHeight;
                _previousPhotosViewHeight =photosViewHeight;
                [self reLayoutViewFrame];
            }
            
        }
        
        
    }];
    
    [self presentViewController:tzpc animated:YES completion:nil];
    
}

#pragma mark   按照比例返回照片
-(UIImage *)compressImage:(UIImage *)originalImg{
    
    
    CGSize originalSize = originalImg.size;
    
    CGFloat height = originalSize.height;
    
    CGFloat width = originalSize.width;
    
    CGFloat newHW = height > width?width:height;
    
    UIGraphicsBeginImageContext(CGSizeMake(newHW , newHW));
    
    [originalImg drawInRect:CGRectMake(0, 0, newHW, newHW)];
    
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndPDFContext();
    
    return newImg;
}


#pragma mark   移除通知
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
