//
//  ZJCustomerInfoScanController.m
//  CRM
//
//  Created by mini on 16/9/20.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJCustomerInfoScanController.h"
#import <TZImagePickerController.h>//选取照片第三方
#import "ZJBaseMsgView.h"//基本信息
#import "ZJCustomerTypeView.h"//客户状态
#import "ZJremindSetView.h"//提醒
#import "ZJPhotoCollectionCell.h"//照片
#import "ZJRecodeView.h"//录音
#import "ZJcustomerTableInfo.h"//数据库模型
#import "ZJDirectorie.h"//文件夹
#import "ZJSaveTool.h"//

#import "NSMutableArray+Category.h"
#import "NSDate+Category.h"

#import "ZJFMdb.h"
#import "ZJFolloweViewController.h"//跟进视图
#import "ZJCustomerBrithViewController.h"//生日提醒
#import "ZJCustomerContinueRViewController.h"//续贷提醒
#import "ZJFirstRefundViewController.h"//首期还款提醒
#import "ZJDatePickView.h"
#import "ZJFollowUpTableInfo.h"//跟进模型
#import "UIViewController+getContactInfor.h"//获取通讯录分类
#import "ZJRemindTableInfo.h"//提醒
#import "Pinyin.h"

#import "ZJPhotoScrollerView.h"//照片

#import "ZJIconViewController.h"
//身份证识别
//#import "Globaltypedef.h"
//#import "SCCaptureCameraController.h"
//#import <SVProgressHUD.h>

@interface ZJCustomerInfoScanController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate,ZJBaseMsgViewDelegate,ZJCustomerTypeViewDelegate,ZJRecodeViewDelegate,ZJremindSetViewDelegate,ZJDatePickViewDelegate,ZJCustomerBrithViewDelegate,ZJCustomerContinueDelegate,ZJFirstRefundViewDelegate,ZJPhotoScrollerViewDeleagte,ZJIconViewDelegate>
//SCNavigationControllerDelegate
{
    UIButton *_iconImgButton;//头像
    NSString *_iconPath;//头像存储地址
    UIImageView *_sexImageView;//性别图像
    UIButton *_manButton;//男
    UIButton *_womanButton;//女
    NSInteger sexNum;//性别标识
    CGFloat baseViewHeight;//基本内容视图高度
    CGFloat contentVHeight;//内容视图的高度
    CGFloat stateViewHeight;//客户状态高度
    CGFloat sourceViewHeight;//客户来源高度
    CGFloat recodeViewHeight;//记录更多资料高度
    CGFloat photosViewHeight;//照片视图高度
    CGFloat loanViewHeight;//贷款类型高度
    UILabel *_remindLabel;//跟进提醒
    UILabel *_infoPhotoLabel;//资料照片
    NSString *_phoneNumber;//推荐人手机号码
    NSDate *_loanDate;//客户贷款日期
    NSDate *_birthDate;//客户生日
    NSString *_firstS;//首期还款日期字符串
    NSString *_continueS;//续贷日期字符串
    NSInteger _birthSwitch;
    NSInteger _continueSwitch;
    NSInteger _firstSwitch;
    NSString *_birthS;//生日期字符串
    BOOL _isSelectOriginalPhoto;
    CGFloat margin ;//图片集合视图间隙
    CGFloat itemWidth;//集合视图items宽度
    NSInteger buttonTag;//判断是点击生日还是贷款日期button
    
    NSInteger _firstdays;//默认首期还款的天数
    NSInteger _continueMonth;//默认续贷提醒的月数
   
}
//**scrollerView**//
@property(nonatomic,weak) UIScrollView *scrollerView;
//**内容视图**//
@property(nonatomic,weak) UIView *contentView;
//**基本信息**//
@property(nonatomic,weak) ZJBaseMsgView *baseView;//基本信息
@property(nonatomic,weak)ZJCustomerTypeView *customerStateView;//客户状态
@property(nonatomic,weak)ZJCustomerTypeView *customerSourceView;//客户来源
@property(nonatomic,weak)ZJCustomerTypeView *customerLoanView;//客户类型
//提醒视图
@property(nonatomic,weak)ZJremindSetView *remindSetView;
//**点击录音视图**//
@property(nonatomic,weak) ZJRecodeView *recodeView;
//**照片collectionView**//
@property(nonatomic,weak) UICollectionView *photosCollectionView;
//**照片数组**//
@property(nonatomic,strong) NSMutableArray *photosArray;
//**照片数组**//
@property(nonatomic,strong) NSMutableArray *selectedAssets;
//***********
//照片选择控制器
@property(nonatomic,strong) UIImagePickerController *imagePickerController;
//**//判断头像是否改变**//
@property(nonatomic,assign)BOOL isChangeIcon ;
////**判断动态加载视图**//
//@property(nonatomic,assign)BOOL addView;
//**判断是手机号码还是手机号码和姓名**//
@property(nonatomic,assign)BOOL phoneORPhoneAndName;
//**时间选择器**//
@property(nonatomic,strong) ZJDatePickView *dateView;

//**点击照片变大视图**//
@property(nonatomic,strong) ZJPhotoScrollerView *bigPhotoScrollerView;
@end

static NSString *const identifier = @"itemCell";
@implementation ZJCustomerInfoScanController

//懒加载   照片选择控制器

-(UIImagePickerController *)imagePickerController{
    
    if (!_imagePickerController) {
        
        _imagePickerController = [[UIImagePickerController alloc]init];
    }
    
    return _imagePickerController;
}

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

-(ZJDatePickView *)dateView{
    if (!_dateView) {
        
        _dateView = [[ZJDatePickView alloc]initWithFrame:CGRectMake(0, zjScreenHeight, zjScreenWidth, 0)];
        _dateView.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:_dateView];
        
    }
    return _dateView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    

//    
//    if (self.entingModel == ZJCustomerEntingScan) {
//        [SVProgressHUD showWithStatus:@"就要打开了"];
//        
//        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
//        
//        SCCaptureCameraController *con = [[SCCaptureCameraController alloc] init];
//        con.scNaigationDelegate = self;
//        con.iCardType = TIDCARD2;
//        con.isDisPlayTxt = YES;
//        [self presentViewController:con animated:YES completion:NULL];
////
//    }
    [self typeViewHeight];
    
    //设置导航栏
    [self setupNavigation];
    //设置UI
    [self baseMessageView];
    //获取默认的首期还款天数和续贷月数
    [self getFirstDaysAndContinueMonth];
    __block UIView *cover = nil;
    if (self.entingModel == ZJCustomerEntingScan){
        
        cover = [[UIView alloc]init];
        
        [self.view addSubview:cover];
        
        cover.backgroundColor = ZJColorFFFFFF;
        
        cover.frame = self.view.bounds;
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
//        [SVProgressHUD dismiss];

        [cover removeFromSuperview];
        cover = nil;
    });
    
}

-(void)getFirstDaysAndContinueMonth{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *first =[defaults objectForKey:@"firstloan"];
    _firstdays  = first.integerValue;
    
    NSString *month =[defaults objectForKey:@"continueloan"];
    _continueMonth = month.integerValue;
}


#pragma mark   设置导航栏
-(void)setupNavigation{
    
    
    if (self.entingModel == ZJCustomerEntingEdit){
        
        self.navigationItem.title = @"客户资料编辑";

        UIButton *back = [UIButton zj_creatDefaultLeftButton];
        
        [back addTarget:self action:@selector(addBack) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:back];

    }else{
        self.navigationItem.title = @"客户资料录入";

        self.navigationItem.leftBarButtonItem = [UIBarButtonItem zj_BarButtonItemWithTitle:@"取消"titleColor:[UIColor whiteColor]target:self action:@selector(clickCancelButton)];

        
    }
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem zj_BarButtonItemWithTitle:@"保存"titleColor:[UIColor whiteColor]target:self action:@selector(clickDoneButton)];
}
#pragma mark   设置scrollerview
-(void)addScrollerViewAndContentView{
    //设置scrollerview
    UIScrollView *scroller = [[UIScrollView alloc]initWithFrame:self.view.frame];
    
    scroller.delegate = self;
    [self.view addSubview:scroller];
    scroller.contentSize = CGSizeMake(0, contentViewHeight);
    self.scrollerView = scroller;
    
    UIView *content = [[UIView alloc]init];
    content.backgroundColor = ZJBackGroundColor;
    
    [self.scrollerView addSubview:content];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.contentView = content;
    self.contentView.frame = CGRectMake(0, 0, self.scrollerView.width, contentVHeight);
}

#pragma mark   设置UI
-(void)baseMessageView{
    
    _birthSwitch = 1;
    _firstSwitch = 1;
    _continueSwitch = 1;
    
//    if (self.entingModel== ZJCustomerEntingEdit) {
    
//        _birthSwitch = self.customerModel.openBirthRemind;
//        _firstSwitch = self.customerModel.openContinueRemind;
//        _continueSwitch = self.customerModel.openFirstRemind;
//        
//        
//    }else{
//        
      
//    }
    sexNum = 0;
    self.view.backgroundColor = ZJBackGroundColor;
    //设置scrollerview
    [self addScrollerViewAndContentView];
    CGFloat iconViewheight = PX2PT(256);
    
    UIView *iconView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, iconViewheight)];
    iconView.backgroundColor = ZJColorFFFFFF;
    [self.contentView addSubview:iconView];
    UILabel *iconlabel = [[UILabel alloc]init];
    [iconlabel zj_labelText:@"头像" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    iconlabel.width = 40;
    iconlabel.height = 20;
    iconlabel.x = ZJmargin40;
    iconlabel.y = (iconViewheight - 20)/2;
    [iconView addSubview:iconlabel];
    
    _iconImgButton = [[UIButton alloc]init];
    _iconImgButton.layer.cornerRadius = 8.0;
    _iconImgButton.clipsToBounds = YES;
    [_iconImgButton setImage:[UIImage imageNamed:@"KHCD-head-portrait"] forState:UIControlStateNormal];
    _iconImgButton.width = 70;
    _iconImgButton.height = 70;
    _iconImgButton.x = self.view.width - 70 - 2*ZJmargin40 - 31;
    _iconImgButton.y = (iconViewheight - 70)/2;
    [iconView addSubview:_iconImgButton];
    [_iconImgButton addTarget:self action:@selector(clickIconButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *iconButton = [[UIButton alloc]init];
    [iconView addSubview:iconButton];
    [iconButton setImage:[UIImage imageNamed:@"arrows"] forState:UIControlStateNormal];
    [iconButton addTarget:self action:@selector(clickIconButton:) forControlEvents:UIControlEventTouchUpInside];
    iconButton.width = 31;
    iconButton.height = 31;
    iconButton.x = self.view.width - ZJmargin40 - 31;
    iconButton.y = (iconViewheight - 31)/2;
    //性别
    UIImageView *sexMsgView = [[UIImageView alloc]init];
    [self.contentView addSubview:sexMsgView];
    _sexImageView = sexMsgView;
    sexMsgView.image = [UIImage imageNamed:@"gender_man"];
    CGFloat sexY = CGRectGetMaxY(iconView.frame)+ZJmargin40;
    sexMsgView.frame = CGRectMake(ZJmargin40*2, sexY, self.view.width -4*ZJmargin40, 39);
    sexMsgView.userInteractionEnabled = YES;
    
    UIButton *manButton = [[UIButton alloc]init];
    manButton.enabled = NO;
    [sexMsgView addSubview:manButton];
    _manButton = manButton;
    [manButton setImage:[UIImage imageNamed:@"MAN-USER"] forState:UIControlStateDisabled];
    [manButton setImage:[UIImage imageNamed:@"MAN_iocn"] forState:UIControlStateNormal];
    [manButton setTitle:@"男" forState:UIControlStateNormal];
    [manButton setTitleColor:ZJColorFFFFFF forState:UIControlStateDisabled];
    [manButton setTitleColor:ZJColor00D3A3 forState:UIControlStateNormal];
    manButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize35PX];
    manButton.frame = CGRectMake(0, 0, sexMsgView.width/2.0, 37);
    [manButton addTarget:self action:@selector(clickManButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *womanButton = [[UIButton alloc]init];
    [sexMsgView addSubview:womanButton];
    _womanButton = womanButton;
    [womanButton setImage:[UIImage imageNamed:@"WOMAN_icon"] forState:UIControlStateNormal];
    [womanButton setImage:[UIImage imageNamed:@"WOMAN-USER"] forState:UIControlStateDisabled];
    [womanButton setTitle:@"女" forState:UIControlStateNormal];
    [womanButton setTitleColor:ZJRGBColor(255, 171, 195, 1.0) forState:UIControlStateNormal];
    [womanButton setTitleColor:ZJColorFFFFFF forState:UIControlStateDisabled];
    womanButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize35PX];
    womanButton.frame = CGRectMake(sexMsgView.width/2.0, 0, sexMsgView.width/2.0, 37);
    [womanButton addTarget:self action:@selector(clickWoManButton:) forControlEvents:UIControlEventTouchUpInside];
    //判断是否是编辑
    if (self.entingModel== ZJCustomerEntingEdit) {
        UIImage *icon = [UIImage imageWithContentsOfFile:self.customerModel.iconPath];
        
        if (icon == nil) {
            
            icon = [UIImage imageNamed:@"KHCD-head-portrait"];
        }else{
            _isChangeIcon = YES;
        }
        
        [_iconImgButton setImage:icon forState:UIControlStateNormal];
        
        
        if (self.customerModel.iSex==0) {
            
            [self clickManButton:manButton];

            
        }else{
            
            [self clickWoManButton:womanButton];

        }
        
    }
    
    
    //基本信息
    CGFloat baseY = CGRectGetMaxY(_sexImageView.frame)+ZJmargin40;
    ZJBaseMsgView *baseView = [[ZJBaseMsgView alloc]initWithFrame:CGRectMake(0, baseY, self.view.width, baseViewHeight)];
    baseView.delegate = self;
    [self.contentView addSubview:baseView];
    self.baseView = baseView;
    if (self.entingModel== ZJCustomerEntingEdit) {
        
        baseView.model = self.customerModel;
        _loanDate = [baseView.loanDateTF.text zj_getDateFromStringWithFormatter:@"yyyy-MM-dd"];
        _birthDate = [baseView.birthDayTF.text zj_getDateFromStringWithFormatter:@"yyyy-MM-dd"];
        
    }
    //客户状态
    ZJCustomerTypeView *stateView = [[ZJCustomerTypeView alloc]initZJCustomerTypeViewWithTitle:@"客户状态" viewType:ZJCustomerStateView];
    stateView.delegate = self;
    self.customerStateView = stateView;
    [self.contentView addSubview:stateView];
   
    if (self.entingModel== ZJCustomerEntingEdit) {
        
        stateView.model = self.customerModel;
    }
    
    stateViewHeight = stateView.customerItemsHeight;

    CGFloat typeViewY = CGRectGetMaxY(self.baseView.frame) +ZJmargin40;
    stateView.frame = CGRectMake(0, typeViewY, zjScreenWidth, stateViewHeight);
    
    //客户来源
    ZJCustomerTypeView *sourceView = [[ZJCustomerTypeView alloc]initZJCustomerTypeViewWithTitle:@"客户来源" viewType:ZJCustomerSourceView];
    sourceView.delegate = self;
    sourceViewHeight = sourceView.customerItemsHeight;
    self.customerSourceView = sourceView;
    [self.contentView addSubview:sourceView];
    CGFloat sourceViewY = CGRectGetMaxY(self.customerStateView.frame)+ZJmargin40;
    self.customerSourceView.frame = CGRectMake(0, sourceViewY, zjScreenWidth, sourceViewHeight);
    if (self.entingModel== ZJCustomerEntingEdit) {
        
        sourceView.model = self.customerModel;
    }
    
    [self readdView];

    
}
-(void)clickManButton:(UIButton *)button{
    _womanButton.enabled = YES;
    button.enabled = NO;
    _sexImageView.image = [UIImage imageNamed:@"gender_man"];
    sexNum = 0;
    
}

-(void)clickWoManButton:(UIButton *)button{
    
    _manButton.enabled = YES;
    button.enabled = NO;
    _sexImageView.image = [UIImage imageNamed:@"gender_woman"];
    sexNum =1;
    
}

-(void)readdView{

    //贷款类型
    ZJCustomerTypeView *loanView = [[ZJCustomerTypeView alloc]initZJCustomerTypeViewWithTitle:@"贷款类型" viewType:ZJCustomerLoanTypeView];
    loanView.delegate = self;
    self.customerLoanView = loanView;
    [self.contentView addSubview:loanView];
    
    if (self.entingModel== ZJCustomerEntingEdit) {
        
        loanView.model = self.customerModel;
    }
    
//    sourceViewHeight = sourceView.customerItemsHeight;
    loanViewHeight = loanView.customerItemsHeight;
    
    //提醒设置
    _remindLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_remindLabel];
    [_remindLabel zj_labelText:@"提醒设置" textColor:ZJColor505050 textSize:PX2PT(45)];
    
    //跟进VIew
    ZJremindSetView *RSView = [[ZJremindSetView alloc]initWithType:ZJremindSetViewScan];
    [self.contentView addSubview:RSView];
    self.remindSetView  = RSView;
    RSView.delegate = self;
    
//    if(_birthDate!=nil){
//        
//        NSString *temp = [self.baseView.birthDayTF.text zj_dateStringFormatter:@"yyyy-MM-dd" toFromatter:@"yyyy年MM月dd日"];
//
//        
//        self.remindSetView.birthText = [_birthDate zj_getStringFromDatWithFormatter:@"yyyy-MM-dd"];
//    }
    
    if (_entingModel == ZJCustomerEntingEdit) {
        
//
        _firstS = self.customerModel.firstDate;
        
        _continueS = self.customerModel.continueLoanDate;
        
        _birthS = self.customerModel.cBirthDay;
        
        if (_birthS.length>0) {
            NSString *temp = [_birthS zj_dateStringFormatter:@"yyyy-MM-dd" toFromatter:@"yyyy年MM月dd日"];
            self.remindSetView.birthText = [NSString stringWithFormat:@"%@客户生日",temp];
            
        }
        
        if (_continueS.length>0) {
            NSString *temp = [_continueS zj_dateStringFormatter:@"yyyy-MM-dd" toFromatter:@"yyyy年MM月dd日"];
            self.remindSetView.continueText = [NSString stringWithFormat:@"%@之后可续贷",temp];
            
        }
        
        if (_firstS.length>0) {
            
            NSString*temp = [_firstS zj_dateStringFormatter:@"yyyy-MM-dd" toFromatter:@"yyyy年MM月dd日"];
            
            self.remindSetView.firstText = [NSString stringWithFormat:@"%@为首期还款日",temp];
            
        }
        

    }else{
        
        if (_loanDate!=nil) {
            
            
            _continueS = [_loanDate zj_getDateAfterMouths:_continueMonth];

            NSString *first = [_continueS zj_dateStringFormatter:@"yyyy-MM-dd" toFromatter:@"yyyy年MM月dd日"];
            
            self.remindSetView.continueText = [NSString stringWithFormat:@"%@之后可续贷",first];
            
            _firstS =[_loanDate zj_getDateAfterDays:_firstdays dateFormat:@"yyyy-MM-dd"];

            NSString *contin = [_firstS zj_dateStringFormatter:@"yyyy-MM-dd" toFromatter:@"yyyy年MM月dd日"];
            self.remindSetView.firstText = [NSString stringWithFormat:@"%@为首期还款日",contin];
        }
        
    }
    

 
    //资料照片
    _infoPhotoLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_infoPhotoLabel];
    [_infoPhotoLabel zj_labelText:@"资料照片" textColor:ZJColor505050 textSize:PX2PT(45)];
    //资料照片
    [self addPhotosView];//
    
    //底部录音视图
    ZJRecodeView *recode = [[ZJRecodeView alloc]init];
    [self.contentView addSubview:recode];
    self.recodeView = recode;
    recode.delegate = self;
    
    recodeViewHeight = PX2PT(1125);

    if (self.entingModel== ZJCustomerEntingEdit) {
        recode.GUID = self.customerModel.GUID;
        recode.recodeText = self.customerModel.cCustomerRemark_Text;
        recode.recodeArray = self.customerModel.recodePath;
        
        CGFloat height = [recode.recodeText zj_getStringRealHeightWithWidth:zjScreenWidth - 2*ZJmargin40 - 30 fountSize:ZJTextSize45PX]+2*PX2PT(40);
        CGFloat addHeight=recode.recodeArray.count*(36+ZJmargin40) +height;
        
        recodeViewHeight +=addHeight;
        
        contentVHeight += addHeight;
        
        self.scrollerView.contentSize = CGSizeMake(0, contentVHeight);
    }

    
    //贷款类型
    CGFloat loanViewY = CGRectGetMaxY(self.customerSourceView.frame)+ZJmargin40;
    self.customerLoanView.frame = CGRectMake(0, loanViewY, zjScreenWidth, loanViewHeight);
    
    //提醒设置Label
    CGFloat remindLabelY = CGRectGetMaxY(self.customerLoanView.frame)+ZJmargin40;
    _remindLabel.frame = CGRectMake(ZJmargin40, remindLabelY, zjScreenWidth, PX2PT(45));
    
    //提醒设置View  4个infoPLabelY
    CGFloat remindSetViewY = CGRectGetMaxY(_remindLabel.frame)+ZJmargin40;
    self.remindSetView.frame = CGRectMake(0, remindSetViewY, zjScreenWidth, PX2PT(600));
    //资料照片Label
    CGFloat infoPLabelY = CGRectGetMaxY(_remindSetView.frame)+ZJmargin40;
    _infoPhotoLabel.frame = CGRectMake(ZJmargin40, infoPLabelY, zjScreenWidth, PX2PT(45));
    //展示照片View
    CGFloat photosViewY = CGRectGetMaxY(_infoPhotoLabel.frame)+ZJmargin40;
    
    self.photosCollectionView.frame = CGRectMake(0, photosViewY, zjScreenWidth, photosViewHeight);
    
    //点击录音视图
    CGFloat recodevireY = CGRectGetMaxY( self.photosCollectionView.frame);
    
    self.recodeView.frame = CGRectMake(0, recodevireY,zjScreenWidth, recodeViewHeight);

}
#pragma mark   放照片的视图

-(void)addPhotosView{
    
    margin = 3;
    
    itemWidth = (self.view.width - 2*ZJmargin40 - 3*margin)/4;
    
    CGFloat itemHeight = itemWidth;
    photosViewHeight = itemWidth+PX2PT(52)+ZJmargin40;
    
    if (self.entingModel== ZJCustomerEntingEdit) {
        
        for (NSInteger i = 0; i<self.customerModel.photosPath.count; i++) {
            
            NSString*path= [ZJDirectorie getImagePathWithDirectoryName:self.customerModel.GUID];
            path = [path stringByAppendingPathComponent:self.customerModel.photosPath[i]];
            
            UIImage*image = [UIImage imageWithContentsOfFile:path];
            [self.photosArray addObject:image];
            [self.selectedAssets addObject:image];
        }
        
        if (self.photosArray.count>=4) {
            
            photosViewHeight = 2*itemWidth+PX2PT(52)+ZJmargin40;
        }else{
            photosViewHeight = itemWidth+PX2PT(52)+ZJmargin40;
            
        }
        
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    flowLayout.minimumLineSpacing = margin;
    flowLayout.minimumInteritemSpacing = margin;
    flowLayout.sectionInset = UIEdgeInsetsMake(PX2PT(52), ZJmargin40, PX2PT(52), ZJmargin40);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.scrollEnabled = NO;
    [self.contentView addSubview:collectionView];
    self.photosCollectionView = collectionView;
    collectionView.backgroundColor = ZJColorFFFFFF;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[ZJPhotoCollectionCell class] forCellWithReuseIdentifier:identifier];
}
#pragma mark  设置高度参数
-(void)typeViewHeight{
    
    contentVHeight = contentViewHeight;
    baseViewHeight = PX2PT(1024);
    
}
#pragma mark   布局视图
-(void)layoutUI{
    _contentView.height = contentVHeight;
    CGFloat width = self.scrollerView.width;
//    //基本信息
//    CGFloat baseY = CGRectGetMaxY(_sexImageView.frame)+ZJmargin40;
//    self.baseView.frame = CGRectMake(0, baseY, self.view.width, baseViewHeight);
    //客户状态
    CGFloat typeViewY = CGRectGetMaxY(self.baseView.frame) +ZJmargin40;
    self.customerStateView.frame = CGRectMake(0, typeViewY, width, stateViewHeight);
    
    //客户来源
    CGFloat sourceViewY = CGRectGetMaxY(self.customerStateView.frame)+ZJmargin40;
    self.customerSourceView.frame = CGRectMake(0, sourceViewY, width, sourceViewHeight);
    
    //贷款类型
    CGFloat loanViewY = CGRectGetMaxY(self.customerSourceView.frame)+ZJmargin40;
    self.customerLoanView.frame = CGRectMake(0, loanViewY, width, loanViewHeight);
    
    //提醒设置Label
    CGFloat remindLabelY = CGRectGetMaxY(self.customerLoanView.frame)+ZJmargin40;
    _remindLabel.frame = CGRectMake(ZJmargin40, remindLabelY, width, PX2PT(45));
    
    //提醒设置View  4个infoPLabelY
    CGFloat remindSetViewY = CGRectGetMaxY(_remindLabel.frame)+ZJmargin40;
    self.remindSetView.frame = CGRectMake(0, remindSetViewY, width, PX2PT(600));
    //资料照片Label
    CGFloat infoPLabelY = CGRectGetMaxY(_remindSetView.frame)+ZJmargin40;
    _infoPhotoLabel.frame = CGRectMake(ZJmargin40, infoPLabelY, width, PX2PT(45));
    //展示照片View
    CGFloat photosViewY = CGRectGetMaxY(_infoPhotoLabel.frame)+ZJmargin40;
    
    self.photosCollectionView.frame = CGRectMake(0, photosViewY, width, photosViewHeight);
    
    //点击录音视图
    CGFloat recodevireY = CGRectGetMaxY( self.photosCollectionView.frame);
    
    self.recodeView.frame = CGRectMake(0, recodevireY,width, recodeViewHeight);
    
    
}


#pragma mark   点击取消按钮
-(void)clickCancelButton{
    
    [self resignAndremove];

    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark   点击返回按钮
-(void)addBack{
    
    [self resignAndremove];

    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark   collectionView 的代理方法

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.photosArray.count + 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZJPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.row == self.photosArray.count) {
        
        UIImage *img = [UIImage imageNamed:@"CD_add"];
        cell.imageV.image = img;
    }else{
     
        cell.imageV.image = [self compressImage:self.photosArray[indexPath.row]];

    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.photosArray.count) {
        
        if (self.photosArray.count==8) return;
        
        [self clickAddPhotos];
        
    }else{
        
        CGRect frame = CGRectMake(0, 0, zjScreenWidth, zjScreenHeight);
        ZJPhotoScrollerView *PhotoScroll = [[ZJPhotoScrollerView alloc]initWithFrame:frame PhotosArray:self.photosArray viewType:EditType];
        
        PhotoScroll.delegate = self;
        self.bigPhotoScrollerView = PhotoScroll;

        [[UIApplication sharedApplication].keyWindow addSubview:PhotoScroll];
        
        [PhotoScroll clickItemIndex:indexPath.row];

    }
}

#pragma mark   ZJPhotoScrollerView代理方法

-(void)ZJPhotoScrollerView:(ZJPhotoScrollerView *)view{
    
    [self.bigPhotoScrollerView removeFromSuperview];
    
    self.bigPhotoScrollerView = nil;
    
    //判断高度
    if (self.photosArray.count>=4) {
        
        photosViewHeight = itemWidth*2+PX2PT(52)+ZJmargin40;
        
    }else{
        
        photosViewHeight = itemWidth+PX2PT(52)+ZJmargin40;

    }
    
    [self layoutUI];

    
    [self.photosCollectionView reloadData];
    
}
#pragma mark   点击添加照片按钮
-(void)clickAddPhotos{
    
    TZImagePickerController *tzpc = [[TZImagePickerController alloc] initWithMaxImagesCount:8 - self.photosArray.count delegate:self];
    tzpc.allowPickingOriginalPhoto = NO;
    tzpc.allowPickingVideo = NO;
    
    [tzpc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto){
        
        [self.photosArray addObjectsFromArray:photos];
//        [self.selectedAssets addObjectsFromArray:assets];
        
        //判断高度
        if (self.photosArray.count>=4) {
            
            photosViewHeight = itemWidth*2+PX2PT(52)+ZJmargin40;
            
            [self layoutUI];
        }
        [self.photosCollectionView reloadData];
        //
        
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
#pragma mark   ZJDatePickViewDelegate代理方法
-(void)ZJDatePickView:(ZJDatePickView *)view datePickView:(UIDatePicker *)datePick{
    
    if (buttonTag==1) {
        
        _birthDate = datePick.date;
        
        self.baseView.birthDayTF.text = [datePick.date zj_getStringFromDatWithFormatter:@"yyyy-MM-dd"];
        
        NSString *temp = [self.baseView.birthDayTF.text zj_dateStringFormatter:@"yyyy-MM-dd" toFromatter:@"yyyy年MM月dd日"];
            
        self.remindSetView.birthText = [NSString stringWithFormat:@"%@客户生日",temp];
  
    }else if(buttonTag ==2){
        _loanDate = datePick.date;
        
        self.baseView.loanDateTF.text = [datePick.date zj_getStringFromDatWithFormatter:@"yyyy-MM-dd"];

        _continueS = [_loanDate zj_getDateAfterMouths:_continueMonth];

        NSString *contin = [_continueS zj_dateStringFormatter:@"yyyy-MM-dd" toFromatter:@"yyyy年MM月dd日"];
        self.remindSetView.continueText = [NSString stringWithFormat:@"%@之后可续贷",contin];
            
        _firstS =[_loanDate zj_getDateAfterDays:_firstdays dateFormat:@"yyyy-MM-dd"];

        NSString *first = [_firstS zj_dateStringFormatter:@"yyyy-MM-dd" toFromatter:@"yyyy年MM月dd日"];
        self.remindSetView.firstText = [NSString stringWithFormat:@"%@为首期还款日",first];
        
    }
}
-(void)ZJDatePickView:(ZJDatePickView *)view isChoose:(BOOL)choose{
    
    [_dateView removeFromSuperview];
    _dateView = nil;
}
#pragma mark   ZJBaseMsgViewDelegate代理方法
-(void)ZJBaseMsgView:(ZJBaseMsgView *)view didClickButtonTag:(NSInteger)tag{

    buttonTag = tag;
    if (_dateView) return;
    
    self.scrollerView.contentOffset = CGPointMake(0, view.y);

    self.dateView.dateModel = ZJDatePickViewDateModel;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.dateView.frame = CGRectMake(0, zjScreenHeight-(40+zjScreenHeight/3.0), zjScreenWidth, 40+zjScreenHeight/3.0);
        
    }];
    if (tag ==2) {
        
        _loanDate = [ NSDate new];

//        if (_remindSetView) {
  
        _continueS = [_loanDate zj_getDateAfterMouths:_continueMonth];
        NSString *continu = [_continueS zj_dateStringFormatter:@"yyyy-MM-dd" toFromatter:@"yyyy年MM月dd日"];
            
        self.remindSetView.continueText = [NSString stringWithFormat:@"%@之后可续贷",continu];
    
        _firstS =[_loanDate zj_getDateAfterDays:_firstdays dateFormat:@"yyyy-MM-dd"];
        NSString *first = [_firstS zj_dateStringFormatter:@"yyyy-MM-dd" toFromatter:@"yyyy年MM月dd日"];
        self.remindSetView.firstText = [NSString stringWithFormat:@"%@为首期还款日",first];

//        }
        if (self.baseView.loanDateTF.text.length<1) {
            
            self.baseView.loanDateTF.text = [_loanDate zj_getStringFromDatWithFormatter:@"yyyy-MM-dd"];

        }

    }else if (tag ==1){
        
        _birthDate = [NSDate new];
//        if (_remindSetView) {
        
        NSString *temp = [_birthDate zj_getStringFromDatWithFormatter:@"yyyy年MM月dd日"];
            
        self.remindSetView.birthText = [NSString stringWithFormat:@"%@客户生日",temp];
//        }
        
        if (self.baseView.birthDayTF.text.length<1) {
            
            self.baseView.birthDayTF.text = [_birthDate zj_getStringFromDatWithFormatter:@"yyyy-MM-dd"];
        }
        
    }
}
////增加或减少高度
//-(void)ZJBaseMsgView:(ZJBaseMsgView *)view viewAddHight:(CGFloat)height{
//    [view.loanLimintTimeTF becomeFirstResponder];
//    baseViewHeight +=height;
//    [self layoutUI];
//}

-(void)ZJBaseMsgView:(ZJBaseMsgView *)view activeTextField:(UITextField *)textField{
    if (_dateView) {
        
        [_dateView removeFromSuperview];
        _dateView = nil;
        
    }
    if (textField == view.loanConutTF || textField ==view.interestTF || textField ==view.loanLimintTimeTF) {
        
        [UIView animateWithDuration:0.4 animations:^{
            
            self.scrollerView.contentOffset = CGPointMake(0, view.y);

        }];
        
    }
}
//获取系统手机号码或者联系人姓名
-(void)ZJBaseMsgView:(ZJBaseMsgView *)view{

    NSString *msg =[self CheckAddressBookAuthorizationandGetPeopleInfor:^(NSDictionary *data) {
        
        view.phoneTF.text = data[@"phone"];
    }];
    
    if (msg != nil) {
        
        [self alertViewWithTitle:@"提示" message:msg];
        
    }
}


#pragma mark   ZJRemindViewDelegate代理
-(void)ZJremindSetViewView:(ZJremindSetView *)view didClickButton:(NSInteger)tap{
    if (tap ==2){
        ZJCustomerBrithViewController *birth = [[ZJCustomerBrithViewController alloc]init];
        birth.delegate = self;
        birth.cName = self.baseView.nameTF.text;
        birth.iSex = sexNum;
        birth.cBirthDay = self.baseView.birthDayTF.text;
        birth.openRemind = _birthSwitch;
        [self.navigationController pushViewController:birth animated:YES];


    }else if (tap ==3){
        ZJCustomerContinueRViewController*continueVC = [[ZJCustomerContinueRViewController alloc]init];
        continueVC.delegate = self;
        continueVC.CTimeString = _continueS;
        continueVC.loanTimeString = [_loanDate zj_getStringFromDatWithFormatter:@"yyyy-MM-dd"];
        continueVC.openRemind = _continueSwitch;
        
        [self.navigationController pushViewController:continueVC animated:YES];
        
        
    }else{
        ZJFirstRefundViewController *firstVC = [[ZJFirstRefundViewController alloc]init];
        firstVC.delegate = self;
        firstVC.ReTimeString = _firstS;
        firstVC.loanTimeString = [_loanDate zj_getStringFromDatWithFormatter:@"yyyy-MM-dd"];
        firstVC.openRemind = _firstSwitch;
        [self.navigationController pushViewController:firstVC animated:YES];
    }

}
#pragma mark   ZJCustomerTypeViewDelegate代理
-(void)ZJCustomerTypeView:(ZJCustomerTypeView *)View ZJViewType:(ZJViewType)type viewHeight:(CGFloat)Height{
    
    if (type == ZJCustomerStateView) {
        
        stateViewHeight += Height;
    }else if (type == ZJCustomerSourceView){
        sourceViewHeight += Height;
        
    }else{
        
        loanViewHeight += Height;
    }
    
    contentVHeight += Height;
    
    self.scrollerView.contentSize = CGSizeMake(0, contentVHeight);
    
    
    [self layoutUI];
}

#pragma mark   ZJCustomerTypeView代理方法
-(void)ZJCustomerTypeView:(ZJCustomerTypeView *)view warnText:(NSString *)text{
    
    [self autorAlertViewWithMsg:text];
  
}

#pragma mark   ZJCustomerTypeView代理方法

-(void)ZJCustomerTypeView:(ZJCustomerTypeView *)view{
    
    NSString *msg = [self CheckAddressBookAuthorizationandGetPeopleInfor:^(NSDictionary *data) {
        
       view.introducerNameTField.text = data[@"name"];
        _phoneNumber = data[@"phone"];
        
    }];

    if (msg != nil) {
        
        [self alertViewWithTitle:@"提示" message:msg];
        
    }


}

#pragma mark   ZJCustomerTypeView代理方法
-(void)ZJCustomerTypeView:(ZJCustomerTypeView *)view actionTextField:(UITextField *)textField{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.scrollerView.contentOffset = CGPointMake(0, view.y);

    }];

}

#pragma mark   ZJCustomerBrithViewDelegate

-(void)ZJCustomerBrith:(ZJCustomerBrithViewController *)view switctButton:(NSInteger)isSelect{
    
    _birthSwitch = isSelect;
}
#pragma mark   ZJCustomerContinueDelegate

-(void)ZJCustomerContinue:(ZJCustomerContinueRViewController *)view switctButton:(NSInteger)isSelect date:(NSString *)date {
    _continueSwitch = isSelect;
    _continueS = date;
    
    NSString*temp = [_continueS zj_dateStringFormatter:@"yyyy-MM-dd" toFromatter:@"yyyy年MM月dd日"];

    self.remindSetView.continueText = [NSString stringWithFormat:@"%@之后可续贷",temp];


}

#pragma mark   ZJFirstRefundViewDelegate

-(void)ZJFirstView:(ZJFirstRefundViewController *)view switctButton:(NSInteger)isSelect date:(NSString *)date{
    
    _firstSwitch = isSelect;
    _firstS = date;
    NSString*temp = [_firstS zj_dateStringFormatter:@"yyyy-MM-dd" toFromatter:@"yyyy年MM月dd日"];

    self.remindSetView.firstText = [NSString stringWithFormat:@"%@为首期还款日",temp];

}

#pragma mark   ZJRecodeViewDelegate

-(void)ZJRecodeView:(ZJRecodeView*)view addHeight:(CGFloat)addHeight{
    
    
    recodeViewHeight += addHeight;
    contentVHeight += addHeight;
    
    [self layoutUI];
    
}

-(void)ZJRecodeView:(ZJRecodeView *)view activeTextView:(UITextView *)textView{
    
    self.scrollerView.contentOffset = CGPointMake(0, view.y-30);

    [view.tempTextView becomeFirstResponder];
}

-(void)ZJRecodeView:(ZJRecodeView *)view warnText:(NSString *)string{
    [self autorAlertViewWithMsg:string];
}
#pragma mark   获取用户头像
-(void)ZJIconViewController:(ZJIconViewController *)view iconImg:(UIImage *)iconImg{
    
    [_iconImgButton setImage: iconImg forState:UIControlStateNormal];

}
#pragma mark   点击获取客户头像
-(void)clickIconButton:(UIButton  *)button{
    [self getPictureFromeSystem];
    
}

#pragma mark   获取标记模式的照片

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    _isChangeIcon= YES;
    [_iconImgButton setImage:image forState:UIControlStateNormal];
    
}



#pragma mark---------获取系统相册
-(void)getPictureFromeSystem{
    
    if (_isChangeIcon) {
        
        ZJIconViewController *iconvc = [[ZJIconViewController alloc]init];
        iconvc.delegate = self;
        
        iconvc.iconImg = _iconImgButton.currentImage;
        
        [self.navigationController pushViewController:iconvc animated:YES];
        
    }else{
        
//        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        
//        UIAlertAction *picture = [UIAlertAction actionWithTitle:@"获取照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            TZImagePickerController *tzpc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
//            tzpc.allowPickingOriginalPhoto = NO;
//            tzpc.allowPickingVideo = NO;
//            [tzpc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto){
//                
//                [_iconImgButton setImage: photos[0] forState:UIControlStateNormal];
//                _isChangeIcon = YES;
//            }];
//            
//            [self presentViewController:tzpc animated:YES completion:nil];
//            
//        }];
//        
//        UIAlertAction *cancal = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//        
//        [alertC addAction:picture];
//        
//        [alertC addAction:cancal];
//        
//        [self presentViewController:alertC animated:YES completion:nil];
        
        [self getPictureForIcon];

        
    }
    
    
}

#pragma mark   点击完成  保存资料；

-(void)clickDoneButton{
    
    
    
    [self resignAndremove];

    //判断录音的状态
    if (self.recodeView.Recording == YES) {
        [self autorAlertViewWithMsg:@"正在录音，无法保存"];
        [self.recodeView.tempTextView becomeFirstResponder];
    }else {
    
    if (self.baseView.nameTF.text.length<1) {
        self.scrollerView.contentOffset = CGPointMake(0, 0);
        [self.baseView.nameTF becomeFirstResponder];
        [self autorAlertViewWithMsg:@"请输入客户姓名"];
        return;
    }
    
    if (self.baseView.nameTF.text.length>10) {
        self.scrollerView.contentOffset = CGPointMake(0, 0);
        [self.baseView.nameTF becomeFirstResponder];
        [self autorAlertViewWithMsg:@"客户名称最多10个字哦"];
        return;
    }
    
    if ((_baseView.codeIDTF.text.length!=0)&&(_baseView.codeIDTF.text.length!=18&&![_baseView.codeIDTF.text zj_isCodeID])) {
        self.scrollerView.contentOffset = CGPointMake(0, 0);

        [self.baseView.codeIDTF becomeFirstResponder];

        [self autorAlertViewWithMsg:@"身份证号码格式有误"];
        return;
    }
    
    if (self.baseView.phoneTF.text.length<1) {
        self.scrollerView.contentOffset = CGPointMake(0, 0);

        [self.baseView.phoneTF becomeFirstResponder];

        [self autorAlertViewWithMsg:@"请输入客户手机号码"];
        return;
    }
//    
//    if (self.baseView.phoneTF.text.length!=11) {
//        self.scrollerView.contentOffset = CGPointMake(0, 0);
//        
//        [self.baseView.phoneTF becomeFirstResponder];
//        
//        [self autorAlertViewWithMsg:@"手机号码格式有误"];
//        return;
//    }
    
    ZJcustomerTableInfo *customerModel = [[ZJcustomerTableInfo alloc]init];

    //标签
    customerModel.cCustomerState_Tags = [self.customerStateView ZJCustomerTypeViewWithSelectedItemsString];
    //标签个数必须大于1；
    
    if (customerModel.cCustomerState_Tags.length<1) {
        self.scrollerView.contentOffset = CGPointMake(0, _customerStateView.y);

        [self autorAlertViewWithMsg:@"请选择客户状态"];
        return;
    }
    customerModel.cCustomerSource_Tags = [self.customerSourceView ZJCustomerTypeViewWithSelectedItemsString];
    
    customerModel.cLoanType_Tags = [self.customerLoanView ZJCustomerTypeViewWithSelectedItemsString];
 
    //性别
    customerModel.iSex = sexNum;
    //基本信息
    
    //首字母
    char firstN =pinyinFirstLetter([self.baseView.nameTF.text characterAtIndex:0]);
    int acr = (int)firstN;
        
    if (acr>=66 && acr <=90) {
        
        customerModel.cFirstAlphabet = [NSString stringWithFormat:@"%c",firstN];
    }else if(acr>=97 && acr <=122) {
        
        customerModel.cFirstAlphabet =[NSString stringWithFormat:@"%c",firstN-32];
    }else{
        customerModel.cFirstAlphabet = @"#";
    }
    
    customerModel.cName = self.baseView.nameTF.text;
    customerModel.cBirthDay = self.baseView.birthDayTF.text;
        
        customerModel.cPhone = [self.baseView.phoneTF.text zj_disposePoneNumber];//处理手机号码
        
    customerModel.cCardID = self.baseView.codeIDTF.text;
    customerModel.fBorrowMoney = self.baseView.loanConutTF.text.doubleValue;
    customerModel.fMonthlyInterest = self.baseView.interestTF.text.doubleValue;
    customerModel.cLoanTimeLimit = self.baseView.loanLimintTimeTF.text;
    customerModel.cLoanDate = self.baseView.loanDateTF.text;
    customerModel.cCustomerState_Remark = self.customerStateView.remarkTextButton.titleLabel.text;
    //

    customerModel.cCustomerSource_IntroducerPhone = [_phoneNumber zj_disposePoneNumber] ;//介绍人电话
    
    NSString *temp = self.customerSourceView.introducerNameTField.text;
    
    if (temp.length>0) {
        
        temp = self.customerSourceView.introducerNameTField.text;
    }else{
        temp = @"";
    }
    
    
    customerModel.cCustomerSource_IntroducerName = temp;//介绍人姓名
    
    
    NSString *GUID = nil;
    
    if (self.entingModel == ZJCustomerEntingEdit){
        
        GUID = self.customerModel.GUID;
        
        
    }else{
        
        GUID = [ZJSaveTool zj_stringWithGUID];
        
        //创建文件夹
        [ZJDirectorie crecteCuetomerDirectoryName:GUID];

    }
    
    NSString *picturePath = [ZJDirectorie getImagePathWithDirectoryName:GUID];
    
        NSMutableArray *photosName = [ZJSaveTool zj_savePhotos:_photosArray
                                                      path:picturePath
                                                  UUIDName:[ZJSaveTool zj_stringWithGUID]];
    
    customerModel.cRelatedPhotos = [photosName zj_stringFromArrayString];
    //头像
    customerModel.cPhotoUrl = [ZJSaveTool zj_saveIconImg:_iconImgButton.currentImage
                                                    path:picturePath
                                               didChange:_isChangeIcon];
    
    //语音地址
    
    NSString *voicePath = [ZJDirectorie getVoicePathWithDirectoryName:GUID];
    
    [ZJSaveTool zj_moveFileFromPath:NSTemporaryDirectory()
                             toPath:voicePath
                           fileName:self.recodeView.recodeArray];
    
    customerModel.cCustomerRemark_Text = self.recodeView.textViewText;//备注
        
    
    customerModel.cCustomerRemark_VoiceUrl = [self.recodeView.recodeArray zj_stringFromArrayString];//语音信息地址
    
    customerModel.GUID = GUID;
    
    NSDate *creatDate = [NSDate new];
    customerModel.cCreateYear = [creatDate zj_getStringFromDatWithFormatter:@"yyyy"];
    
    customerModel.cCreateMonth = [creatDate zj_getStringFromDatWithFormatter:@"MM"];
//    customerModel.cCreateMonth = @"6";

    
    customerModel.cCreateDay = [creatDate zj_getStringFromDatWithFormatter:@"dd"];
    
    //判断客户录入类型
    if (self.entingModel ==ZJCustomerEntingFull) {//完整资料录入
        
        customerModel.iFrom = 1;

    }else if (self.entingModel ==ZJCustomerEntingScan ){//扫描录入
        
        customerModel.iFrom = 3;
        
    }else{//编辑情况下录入
        
        customerModel.iFrom = self.customerModel.iFrom;
    }
    //跟进资料存储
    NSInteger ID = 0;
    if (self.entingModel == ZJCustomerEntingEdit){
        
        ID = self.customerModel.iAutoID;
        
        customerModel.iAutoID = ID;
        
        //更新
        [ZJFMdb sqlUpdata:customerModel tableName:ZJCustomerTableName];
        
    }else{
        //插入
       ID =[ZJFMdb sqlInsertData:customerModel tableName:ZJCustomerTableName];

    }
    
    //跟进信息
    /* if (self.followModel !=nil) {
     
     ZJFollowUpTableInfo *follow = [[ZJFollowUpTableInfo alloc]init];
     
     
     follow.cText = self.followModel.cText;
     
     //照片名字
     NSMutableArray *followPhotosName = [ZJSaveTool zj_savePhotos:self.followModel.photosArray path:picturePath UUIDName:[ZJSaveTool zj_stringWithGUID]];
     follow.cPhotoUrl = [followPhotosName zj_stringFromArrayString];
     //录音名字
     [ZJSaveTool zj_moveFileFromPath:NSTemporaryDirectory()
     toPath:voicePath
     fileName:self.followModel.recodeNameArray];
     
     follow.cVoiceUrl = [self.followModel.recodeNameArray zj_stringFromArrayString];
     
     follow.iRemind = self.followModel.iRemind;
     
     follow.cRemindTime = self.followModel.cRemindTime;
     
     follow.cLogDate = self.followModel.cLogDate;
     
     follow.cLogTime = self.followModel.cLogTime;
     
     follow.cWeekDay = self.followModel.cWeekDay;
     follow.iCustomerID = ID;
     
     //判断是插入还是跟新
     
     if (self.entingModel == ZJCustomerEntingEdit){
     
     [ZJFMdb sqlUpdata:follow tableName:ZJFollowTableName];
     
     }else{
     
     [ZJFMdb sqlInsertData:follow tableName:ZJFollowTableName];
     
     }
     
     
     }*/

   
    //存储提醒数据
    ZJRemindTableInfo *remind = [[ZJRemindTableInfo alloc]init];
    
    if (!self.remindSetView.birthCoverButton) {
        remind.iCustomerID = ID;
        remind.iRemindType = 1;
        
        remind.iSwitch = _birthSwitch;
        
        remind.cRemindDate = [self.baseView.birthDayTF.text zj_dateStringFormatter:@"yyyy-MM-dd" toFromatter:@"MM-dd"];
        //判断是插入还是跟新
        
        if (self.entingModel == ZJCustomerEntingEdit){//更新
            
            NSString *selectCount = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE iCustomerID=%zd AND iRemindType = %zd",ZJRemindTableName,remind.iCustomerID,remind.iRemindType];
            NSInteger count = [ZJFMdb sqlSelecteCountWithString:selectCount];
            
             NSString *update = [NSString stringWithFormat:@"update %@ set cRemindDate='%@',cRemindTime='%@',iSwitch = %zd WHERE iCustomerID = %zd AND  iRemindType = %zd",ZJRemindTableName,remind.cRemindDate,remind.cRemindTime,remind.iSwitch,remind.iCustomerID,remind.iRemindType];
            
            if (count) {
                
                [ZJFMdb sqlUpdataWithString:update];//更新

            }else{//插入
                
                [ZJFMdb sqlInsertData:remind tableName:ZJRemindTableName];

                
            }
            
            
            
        }else{//插入
            
            [ZJFMdb sqlInsertData:remind tableName:ZJRemindTableName];
            
        }
        
    }
    
    if (!self.remindSetView.continueCoverButton) {
        
        remind.iCustomerID = ID;
        remind.iRemindType = 2;
        remind.cRemindDate = _continueS;
        remind.iSwitch = _continueSwitch;
        //判断是插入还是跟新
        
        if (self.entingModel == ZJCustomerEntingEdit){
            
            NSString *selectCount = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE iCustomerID=%zd AND iRemindType = %zd",ZJRemindTableName,remind.iCustomerID,remind.iRemindType];
            NSInteger count = [ZJFMdb sqlSelecteCountWithString:selectCount];


            NSString *update = [NSString stringWithFormat:@"update %@ set cRemindDate='%@',cRemindTime='%@',iSwitch = %zd WHERE iCustomerID = %zd AND  iRemindType = %zd",ZJRemindTableName,remind.cRemindDate,remind.cRemindTime,remind.iSwitch,remind.iCustomerID,remind.iRemindType];
            
            if (count) {
                
                [ZJFMdb sqlUpdataWithString:update];

                
            }else{
                
                [ZJFMdb sqlInsertData:remind tableName:ZJRemindTableName];

            }
            
            [ZJFMdb sqlUpdataWithString:update];
            
        }else{
            
            [ZJFMdb sqlInsertData:remind tableName:ZJRemindTableName];
            
        }
        

    }
    
    if (!self.remindSetView.firstCoverButton) {
        
        remind.iCustomerID = ID;
        remind.iRemindType = 3;
        remind.cRemindDate = _firstS;
        
        remind.iSwitch = _firstSwitch;
        //判断是插入还是跟新
        
        if (self.entingModel == ZJCustomerEntingEdit){
            
            NSString *selectCount = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE iCustomerID=%zd AND iRemindType = %zd",ZJRemindTableName,remind.iCustomerID,remind.iRemindType];
            NSInteger count = [ZJFMdb sqlSelecteCountWithString:selectCount];
            NSString *update = [NSString stringWithFormat:@"update %@ set cRemindDate='%@',cRemindTime='%@',iSwitch = %zd WHERE iCustomerID = %zd AND  iRemindType = %zd",ZJRemindTableName,remind.cRemindDate,remind.cRemindTime,remind.iSwitch,remind.iCustomerID,remind.iRemindType];
            if (count) {
                [ZJFMdb sqlUpdataWithString:update];

                
            }else{
                
                [ZJFMdb sqlInsertData:remind tableName:ZJRemindTableName];

                
            }
            
        }else{
            
            [ZJFMdb sqlInsertData:remind tableName:ZJRemindTableName];
            
        }
        

    }
    //通知
    NSString *nowString = [[NSDate new] zj_getStringFromDatWithFormatter:@"yyyy-MM-dd"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *bir = [self.baseView.birthDayTF.text zj_dateStringFormatter:@"yyyy-MM-dd" toFromatter:@"MM-dd"];
    
    NSString *birString = [[NSDate new] zj_getStringFromDatWithFormatter:@"MM-dd"];
        
        //是否发出生日通知
        
    if (![self.customerModel.cBirthDay isEqualToString:nowString]) {
            
            if ([bir isEqualToString:birString]) {
                
                dic[@"birth"] = @"1";
            }else{
                
                dic[@"birth"] = @"0";
                
            }
            
    }


        //是否发出生日通知
    if (![self.customerModel.continueLoanDate isEqualToString:nowString]) {
        
        if ([_continueS isEqualToString:nowString]) {
            
            dic[@"continu"] = @"1";
        }else{
            dic[@"continu"] = @"0";
            
        }
            
    }
        //是否发出生日通知
    if (![self.customerModel.firstDate isEqualToString:nowString]) {
            
        if ([_firstS isEqualToString:nowString]) {
            
            dic[@"first"] = @"1";
        }else{
            dic[@"first"] = @"0";
            
        }
    }
    
  
    
        
   
    
   
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"firstcount" object:nil userInfo:dic];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
    //判断退出模式
    if (self.entingModel == ZJCustomerEntingEdit){
        
        [self.delegate ZJCustomerInfoScanController:self customerInfo:customerModel];
        //
//        self.customerInfo(customerModel);
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
//        [self autorAlertViewWithMsg:@"保存成功"];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [alert dismissViewControllerAnimated:YES completion:nil];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            UITabBarController *vc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            
            vc.selectedIndex = 1;
            
        });

        

        
    }
    
    }
    
}
#pragma mark   扫描录入代理方法
-(void)sendIDCValue:(NSString *)name SEX:(NSString *)sex FOLK:(NSString *)folk BIRTHDAY:(NSString *)birthday ADDRESS:(NSString *)address NUM:(NSString *)num{
    
    self.baseView.nameTF.text = name;
    self.baseView.codeIDTF.text = num;
    if ([sex isEqualToString:@"男"]) {
        [self clickManButton:_manButton];
        
    }else{
        
        [self clickManButton:_womanButton];

    }
    
    NSDateFormatter *form = [[NSDateFormatter alloc]init];
    form.dateFormat = @"yyyy年MM月dd日";
    NSDate*date = [form dateFromString:birthday];
    
    form.dateFormat = @"yyyy-MM-dd";
    
    self.baseView.birthDayTF.text = [form stringFromDate:date];
    
    
}
-(void)sendCardFaceImage:(UIImage *)image{
    
    [_iconImgButton setImage:image forState:UIControlStateNormal];
    _isChangeIcon = YES;
}

#pragma mark   scrollView代理方法


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if (self.baseView.birthDayTF.text.length>0) {
        
        NSString *birth = [self.baseView.birthDayTF.text zj_dateStringFormatter:@"yyyy-MM-dd" toFromatter:@"yyyy年MM月dd日"];
        
        self.remindSetView.birthText = [NSString stringWithFormat:@"%@客户生日",birth];
    }
    
    if (_continueS) {
        
        NSString *continu = [_continueS zj_dateStringFormatter:@"yyyy-MM-dd" toFromatter:@"yyyy年MM月dd日"];
        
        self.remindSetView.continueText = [NSString stringWithFormat:@"%@之后可续贷",continu];
    }
    
    if (_firstS) {
        
        NSString *first = [_firstS zj_dateStringFormatter:@"yyyy-MM-dd" toFromatter:@"yyyy年MM月dd日"];
        self.remindSetView.firstText = [NSString stringWithFormat:@"%@为首期还款日",first];
        
    }
    
    [self resignAndremove];

}

#pragma mark   消除键盘
-(void) resignAndremove{
    
    if (_dateView) {
        
        [_dateView removeFromSuperview];
        _dateView = nil;
    }
    //消除键盘
    [self.baseView.actionTF resignFirstResponder];
    
    [self.customerStateView.actionField resignFirstResponder];
    [self.customerLoanView.actionField resignFirstResponder];
    [self.customerSourceView.actionField resignFirstResponder];
    
    if (self.recodeView.tempTextView) {
        
        [self.recodeView.tempTextView resignFirstResponder];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear: animated];
    
    if (self.recodeView.timer) {
        
        [self.recodeView.timer invalidate];
        
        self.recodeView.timer = nil;
        
    }

}

@end
