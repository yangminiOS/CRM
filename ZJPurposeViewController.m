//
//  ZJPurposeViewController.m
//  CRM
//
//  Created by mini on 16/10/20.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJPurposeViewController.h"
#import "ZJRemindView.h"
#import "ZJRecodeView.h"
#import "ZJFolloweViewController.h"
#import "ZJFollowUpTableInfo.h"
#import "ZJcustomerTableInfo.h"
#import "ZJSaveTool.h"
#import "ZJDirectorie.h"
#import "ZJFMdb.h"
#import "UIViewController+getContactInfor.h"
#import "NSDate+Category.h"
#import "NSMutableArray+Category.h"

#import "CalenderObject.h"//添加到日历提醒事件

#import "Pinyin.h"

@interface ZJPurposeViewController ()<ZJRecodeViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    
    UITextField *_nameTF;//姓名
    UITextField *_phoneTF;//手机号码
    UIImageView *_sexImageView;//性别视图
    UIButton *_manButton;//男性BUtton
    UIButton *_womanButton;
    NSInteger _sexNum;//代表男女的数字
    
    CGFloat  _recodeViewHeight;//录音视图的高度
    
    CGFloat _contentVHeight;//内容视图的高度
    
    
}
//内容视图
@property (weak, nonatomic)  UIView *contentView;

//滚动视图
@property(nonatomic,weak) UIScrollView *scrollView;
//**基本信息视图**//
@property(nonatomic,weak) UIView *baseView;

//**跟进视图**//
//@property(nonatomic,strong)  ZJRemindView*follewView;//跟进视图

//**记录更多视图**//
@property(nonatomic,strong) ZJRecodeView *recodeView;

//**follow模型**//
@property(nonatomic,strong) ZJFollowUpTableInfo *followModel;

@end

@implementation ZJPurposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

-(void)setupUI{
    
    //导航
    [self setupNavi];
    //滚动视图
    [self setupScrollView];
    //基本信息
    [self setupBaseView];
    //性别设置
    [self setupSex];
    //跟进设置
//    [self setupFollow];
    //记录更多信息设置
    [self setupMoreInfo];
}
#pragma mark   设置导航
-(void)setupNavi{
    self.view.backgroundColor = ZJBackGroundColor;
    
    self.navigationItem.title = @"意向客户录入";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem zj_BarButtonItemWithTitle:@"取消"titleColor:[UIColor whiteColor]target:self action:@selector(clickCancelButton)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem zj_BarButtonItemWithTitle:@"保存"titleColor:[UIColor whiteColor]target:self action:@selector(clickDoneButton)];
}


#pragma mark   设置scrollerView和内容视图
-(void)setupScrollView{
    
    CGFloat height = self.view.height-ZJTNHeight;
    
    _contentVHeight = height;
    
    UIScrollView *scroll = [[UIScrollView alloc]init];
    [self.view addSubview:scroll];
    self.scrollView = scroll;
    scroll.delegate = self;
    scroll.frame = CGRectMake(0, 0, self.view.width, height);
    scroll.contentSize = CGSizeMake(0, _contentVHeight+100);
    //内容视图
    UIView *contentV = [[UIView alloc]init];
    [scroll addSubview:contentV];
    contentV.frame = CGRectMake(0, 0, self.view.width, _contentVHeight+100);
    self.contentView = contentV;
    contentV.backgroundColor = ZJBackGroundColor;
    
    
    _recodeViewHeight = PX2PT(955)+2*ZJmargin40+30;
    
    
}
#pragma mark   设置基本信息
-(void)setupBaseView{
    
    //分割线
    UIView *line = [[UIView alloc]init];
    [self.contentView addSubview:line];
    line.backgroundColor = ZJColorDCDCDC;
    line.frame = CGRectMake(0, ZJmargin40, zjScreenWidth, 1);
    
    UIView *baseView = [[UIView alloc]init];
    baseView.backgroundColor = ZJColorFFFFFF;
    [self.contentView addSubview:baseView];
    self.baseView = baseView;
    baseView.frame = CGRectMake(0, ZJmargin40+1, self.view.width, 87);
    
    //姓名
    UILabel *name = [[UILabel alloc]init];
    [baseView addSubview:name];
    [name zj_labelText:@"*姓      名" textColor:ZJColorDCDCDC textSize:ZJTextSize45PX];
    [name zj_adjustWithMin];
    name.x = ZJmargin40;
    name.y = 17;
    
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:name.text];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
    name.attributedText = str1;
    
    UITextField *nameTF = [[UITextField alloc]init];
    [baseView addSubview:nameTF];
    _nameTF = nameTF;
    nameTF.delegate = self;
    nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTF.placeholder = @"请输入姓名";
    nameTF.textColor = ZJColor505050;
    nameTF.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    CGFloat nameTFX = CGRectGetMaxX(name.frame)+PX2PT(60);
    nameTF.frame = CGRectMake(nameTFX, 17, self.view.width - nameTFX, 20);
    
    //分割性
    UIView *spView = [[UIView alloc]init];
    [baseView addSubview:spView];
    spView.backgroundColor = ZJColorDCDCDC;
    spView.frame = CGRectMake(0, 44, self.view.width, 1);
    
    //手机
    //姓名
    UILabel *phone = [[UILabel alloc]init];
    [baseView addSubview:phone];
    [phone zj_labelText:@"*手      机" textColor:ZJColorDCDCDC textSize:ZJTextSize45PX];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:phone.text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
    phone.attributedText = str;
    
    [phone zj_adjustWithMin];
    phone.x = ZJmargin40;
    phone.y = 61;
    
    UITextField *phoneTF = [[UITextField alloc]init];
    [baseView addSubview:phoneTF];
    phoneTF.delegate = self;
    _phoneTF = phoneTF;
    phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTF.placeholder = @"请输入手机号";
    phoneTF.textColor = ZJColor505050;
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;

    phoneTF.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    CGFloat phoneTFX = CGRectGetMaxX(name.frame)+PX2PT(60);
    phoneTF.frame = CGRectMake(phoneTFX, 61, self.view.width - nameTFX-45, 20);
    
    //获取手机号码Button
    UIButton *phoneButton = [[UIButton alloc]init];
    [self.baseView addSubview:phoneButton];
    [phoneButton setImage:[UIImage imageNamed:@"arrows"] forState:UIControlStateNormal];
    phoneButton.frame = CGRectMake(self.view.width - ZJmargin40 - 31, 45, 31, 42);
    [phoneButton addTarget:self action:@selector(clickPhoneButton:) forControlEvents:UIControlEventTouchUpInside];
    //分割线
    UIView *line2 = [[UIView alloc]init];
    [self.contentView addSubview:line2];
    line2.backgroundColor = ZJColorDCDCDC;
    
    CGFloat line2Y = CGRectGetMaxY(baseView.frame);
    line2.frame = CGRectMake(0, line2Y, zjScreenWidth, 1);
}

#pragma mark   性别设置
-(void)setupSex{
    //默认是男性
    _sexNum = 0;
    
    UIImageView *sexMsgView = [[UIImageView alloc]init];
    [self.contentView addSubview:sexMsgView];
    _sexImageView = sexMsgView;
    sexMsgView.image = [UIImage imageNamed:@"gender_man"];
    CGFloat sexY = CGRectGetMaxY(_baseView.frame)+ZJmargin40;
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
    
    [manButton addTarget:self action:@selector(clickPManButton:) forControlEvents:UIControlEventTouchUpInside];
    
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
    [womanButton addTarget:self action:@selector(clickPWoManButton:) forControlEvents:UIControlEventTouchUpInside];

    
}

-(void)clickPManButton:(UIButton *)button{
    _womanButton.enabled = YES;
    button.enabled = NO;
    _sexImageView.image = [UIImage imageNamed:@"gender_man"];
    _sexNum = 0;
    
}

-(void)clickPWoManButton:(UIButton *)button{
    
    _manButton.enabled = YES;
    button.enabled = NO;
    _sexImageView.image = [UIImage imageNamed:@"gender_woman"];
    _sexNum =1;
    
}

//#pragma mark   跟进设置
//-(void)setupFollow{
//    
//    _follewView = [[ZJRemindView alloc]initWithViewType:RemindFollowType ONImgName:@"follow-up" OFFImgName:nil title:@"跟进提醒"];
//    _follewView.detailText =@"客户不跟踪，销售一场空";
//    [self.contentView addSubview:_follewView];
//    [_follewView.clickButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
//    
//    CGFloat follY = CGRectGetMaxY(_sexImageView.frame)+ZJmargin40;
//    _follewView.frame = CGRectMake(0, follY, self.view.width,PX2PT(200));
//}

-(void)clickButton:(UIButton *)button{
    
    ZJFolloweViewController *follow = [[ZJFolloweViewController alloc]init];
    follow.FollowEnterModel = AddEnterModel;
    
//    follow.model = ^(ZJFollowUpTableInfo *followModel){
//        self.followModel = followModel;
//    };
    
    [self.navigationController pushViewController:follow animated:YES];
    
}


#pragma mark   记录更多资料设置
-(void)setupMoreInfo{
    
    //底部录音视图
    ZJRecodeView *recode = [[ZJRecodeView alloc]init];
    [self.contentView addSubview:recode];
    self.recodeView = recode;
    recode.delegate = self;
    CGFloat recodeY = CGRectGetMaxY(_sexImageView.frame);
    recode.frame = CGRectMake(0, recodeY, self.view.width, _recodeViewHeight);
    
}

#pragma mark   ZJRecodeViewDelegate代理方法
-(void)ZJRecodeView:(ZJRecodeView*)view addHeight:(CGFloat)addHeight{
    
    _recodeViewHeight +=addHeight;
    
    _contentVHeight += addHeight;
    

    [self layoutUI];
}

-(void)ZJRecodeView:(ZJRecodeView *)view warnText:(NSString *)string{
    [self autorAlertViewWithMsg:string];
}
-(void)ZJRecodeView:(ZJRecodeView *)view activeTextView:(UITextView *)textView{
   
    
    CGFloat offsetY = CGRectGetMaxY(self.baseView.frame);
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.scrollView.contentOffset = CGPointMake(0, offsetY);

    }];
    
}

#pragma mark   textField代理方法
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    

    if (textField == _nameTF) {
        
        return YES;
        
    }else if(textField == _phoneTF){
        
        //&&[temp zj_isStringAccordWith:@"^1[0-9]{0,10}?$"]
        return YES;
        
    }
    
    return NO;
}

//点击获取手机号码
- (void)clickPhoneButton:(UIButton *)button {
    
    NSString *msg =[self CheckAddressBookAuthorizationandGetPeopleInfor:^(NSDictionary *data) {
        
        _phoneTF.text = data[@"phone"];
    }];
    
    if (msg != nil) {
        
        [self alertViewWithTitle:@"提示" message:msg];
        
    }
}


-(void)layoutUI{
    
    self.scrollView.contentSize = CGSizeMake(0, _contentVHeight);
    
    self.contentView.height = _contentVHeight;
    
    self.recodeView.height = _recodeViewHeight;

}

#pragma mark   点击导航取消

-(void)clickCancelButton{
    
    [self viewResignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark   点击导航保存
-(void)clickDoneButton{
    [self viewResignFirstResponder];

    
    //判断录音的状态
    if (self.recodeView.Recording == YES) {
        [self autorAlertViewWithMsg:@"正在录音，无法保存"];
        [self.recodeView.tempTextView becomeFirstResponder];
    }else {
    //刻苦姓名为空
    if (_nameTF.text.length==0) {
        
        self.scrollView.contentOffset = CGPointMake(0, 0);

        [_nameTF becomeFirstResponder];
        [self autorAlertViewWithMsg:@"请输入客户姓名"];

        return;
    }
    
    //刻苦姓名为空
    if (_nameTF.text.length>10) {
        
        self.scrollView.contentOffset = CGPointMake(0, 0);
        
        [_nameTF becomeFirstResponder];
        [self autorAlertViewWithMsg:@"客户名称最多10个字哦"];
        
        return;
    }
    //手机号码空
    if (_phoneTF.text.length==0){
        self.scrollView.contentOffset = CGPointMake(0, 0);

        [_phoneTF becomeFirstResponder];
        [self autorAlertViewWithMsg:@"请输入客户手机号码"];


        return;
    }
    
//    //手机号码格式
//    if (_phoneTF.text.length !=11) {
//        
//        self.scrollView.contentOffset = CGPointMake(0, 0);
//
//        [_phoneTF becomeFirstResponder];
//        [self autorAlertViewWithMsg:@"手机号码格式有误"];
//        return;
//        
//    }
    
    ZJcustomerTableInfo *customerModel = [[ZJcustomerTableInfo alloc]init];
    
    customerModel.cName = _nameTF.text;
    
    customerModel.cPhone = [_phoneTF.text zj_disposePoneNumber];
    
    customerModel.iSex = _sexNum;
    customerModel.cCustomerRemark_Text = self.recodeView.textViewText;
    customerModel.cCustomerSource_IntroducerName = @"";
    customerModel.cCustomerState_Tags = @"1;";
    //获取文件夹名字
    NSString *GUID = [ZJSaveTool zj_stringWithGUID];
    //创建文件夹
    [ZJDirectorie crecteCuetomerDirectoryName:GUID];
    
    //需要判断是否登录
    NSString *voicePath = [ZJDirectorie getVoicePathWithDirectoryName:GUID];
    NSString *picturePath = [ZJDirectorie getImagePathWithDirectoryName:GUID];


    [ZJSaveTool zj_moveFileFromPath:NSTemporaryDirectory()
                             toPath:voicePath
                           fileName:self.recodeView.recodeArray];
    
    customerModel.cCustomerRemark_VoiceUrl = [self.recodeView.recodeArray zj_stringFromArrayString];//语音信息地址
    
    //头像
    customerModel.cPhotoUrl = [ZJSaveTool zj_saveIconImg:nil
                                                    path:picturePath
                                               didChange:NO];
    
    customerModel.GUID = GUID;
    
    NSDate *creatDate = [NSDate new];
    customerModel.cCreateYear = [creatDate zj_getStringFromDatWithFormatter:@"yyyy"];
    
    customerModel.cCreateMonth = [creatDate zj_getStringFromDatWithFormatter:@"MM"];
    
    customerModel.cCreateDay = [creatDate zj_getStringFromDatWithFormatter:@"dd"];

    customerModel.iFrom = 2;
    
    //首字母
    char firstN =pinyinFirstLetter([_nameTF.text characterAtIndex:0]);
    int acr = (int)firstN;
    
    if (acr>=66 && acr <=90) {
        
        customerModel.cFirstAlphabet = [NSString stringWithFormat:@"%c",firstN];
    }else if(acr>=97 && acr <=122) {
        
        customerModel.cFirstAlphabet =[NSString stringWithFormat:@"%c",firstN-32];
    }else{
        customerModel.cFirstAlphabet = @"#";
    }
    //跟进资料存储
    NSInteger ID =[ZJFMdb sqlInsertData:customerModel tableName:ZJCustomerTableName];
    //跟进视图资料
    /*    if (self.followModel !=nil) {
     
     ZJFollowUpTableInfo *follow = [[ZJFollowUpTableInfo alloc]init];
     
     follow.iCustomerID = ID;
     
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
     
     
     [ZJFMdb sqlInsertData:follow tableName:ZJFollowTableName];
     
     if (follow.iRemind) {
     
     NSString *starTime = self.followModel.dateString;
     
     
     NSString *idefitier = [NSString stringWithFormat:@"%zd",ID];
     
     NSString *title = [NSString stringWithFormat:@"客户%@有跟进提醒，快来看看吧",_nameTF.text];
     
     [CalenderObject initWithTitle:title andIdetifider:idefitier WithStartTime:starTime andEndTime:starTime Location:nil andNoticeFirTime:0 withNoticeEndTime:0];
     
     
     }
     
     
     */
    
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

#pragma mark   退出键盘

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self viewResignFirstResponder];

}

-(void)viewResignFirstResponder{
    [_nameTF resignFirstResponder];
    [_phoneTF resignFirstResponder];
    [self.recodeView.tempTextView resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    //判断计时器是否是开启
    
    if (self.recodeView.timer) {
        
        [self.recodeView.timer invalidate];
        
        self.recodeView.timer = nil;
        
    }
    
    
    
}

@end
