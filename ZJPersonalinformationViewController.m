//
//  ZJPersonalinformationViewController.m
//  CRM
//
//  Created by 蒙建东 on 16/12/3.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJPersonalinformationViewController.h"
#import "CartoonUtils.h"
#import "ZJUser.h"
#import "AESCrypt.h"
#import "ZJIconViewController.h"
#import "TFFileUploadManager.h"
#import "AFNetworking.h"

#import "ZJUUID.h"
@interface ZJPersonalinformationViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,ZJIconViewDelegate>
{
    //性别按钮
     UIButton *_womenButton;
     UIButton *_menButton;
    
    //切换性别的背景图片
     UIImageView *_sexImageView;
    
     //头像按钮
     UIButton *_HeadButton;
    
}

//**//判断头像是否改变**//
@property(nonatomic,assign)BOOL isChangeIcon ;

@property (nonatomic,strong)NSString *Error;

@property (nonatomic,strong)NSString *HeadString;

@property (nonatomic,assign)NSInteger Sex;

@property (nonatomic,weak)UITextField *NameTextField;

@property (nonatomic,weak)UIImage *HeadImage;
@end

@implementation ZJPersonalinformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置个人信息";
    self.view.backgroundColor = ZJBackGroundColor;
    
    
    [self LoadSyte];
    
    // 删除导航栏左侧按钮
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]init];
    barBtn.title=@"";
    self.navigationItem.leftBarButtonItem = barBtn;
  
}




- (void)LoadSyte{
    
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, PX2PT(40), zjScreenWidth, PX2PT(256));
    view.backgroundColor = ZJColorFFFFFF;
    [self.view addSubview:view];
    
    UILabel *HeadLabel = [[UILabel alloc]init];
    HeadLabel.textAlignment = NSTextAlignmentLeft;
    [HeadLabel zj_labelText:@"头像" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    HeadLabel.x = PX2PT(40);
    HeadLabel.centerY = PX2PT(256)/3;
    [HeadLabel zj_adjustWithMin];
    [view addSubview:HeadLabel];
    
    
    UIButton *HeadButton =  [[UIButton alloc]initWithFrame:CGRectMake(zjScreenWidth - PX2PT(40) - 8 - PX2PT(40) - PX2PT(360)/2 , PX2PT(80), PX2PT(360)/2, PX2PT(360)/2)];
    _HeadButton = HeadButton;
    HeadButton.layer.masksToBounds = YES;
    HeadButton.layer.cornerRadius = PX2PT(20);
    [HeadButton setImage:[UIImage imageNamed:@"KHCD-head-portrait"] forState:UIControlStateNormal];
    [HeadButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:HeadButton];
    
    UIButton *button = [[UIButton alloc]init];
    button.width = 31;
    button.height = 31;
    button.x = self.view.width - ZJmargin40  - 20;
    button.y = PX2PT(256)  / 2 ;
    [button setImage:[UIImage imageNamed:@"arrows"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    

    self.Sex = 1;
    //性别
    UIImageView *sexMsgView = [[UIImageView alloc]initWithFrame:CGRectMake(PX2PT(60), PX2PT(40 + 40 + 256),self.view.width -4*ZJmargin40, 39)];
    _sexImageView = sexMsgView;
    sexMsgView.image = [UIImage imageNamed:@"gender_man"];
    sexMsgView.userInteractionEnabled = YES;
    [self.view addSubview:sexMsgView];
    UIButton *manButton = [[UIButton alloc]init];
    manButton.enabled = NO;
    [sexMsgView addSubview:manButton];
    _menButton = manButton;
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
    _womenButton = womanButton;
    [womanButton setImage:[UIImage imageNamed:@"WOMAN_icon"] forState:UIControlStateNormal];
    [womanButton setImage:[UIImage imageNamed:@"WOMAN-USER"] forState:UIControlStateDisabled];
    [womanButton setTitle:@"女" forState:UIControlStateNormal];
    [womanButton setTitleColor:ZJRGBColor(255, 171, 195, 1.0) forState:UIControlStateNormal];
    [womanButton setTitleColor:ZJColorFFFFFF forState:UIControlStateDisabled];
    womanButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize35PX];
    womanButton.frame = CGRectMake(sexMsgView.width/2.0, 0, sexMsgView.width/2.0, 37);
    [womanButton addTarget:self action:@selector(clickWoManButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *NameView = [[UIView alloc]initWithFrame:CGRectMake(0,PX2PT(184 + 256 + 60), zjScreenWidth, PX2PT(128))];
    NameView.backgroundColor = ZJColorFFFFFF;
    [self.view addSubview:NameView];
    
    UILabel *NameLabel = [[UILabel alloc]init];
    NameLabel.textAlignment = NSTextAlignmentLeft;
    [NameLabel zj_labelText:@"姓名" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    NameLabel.x = PX2PT(40);
    NameLabel.centerY = PX2PT(128)/3;
    [NameLabel zj_adjustWithMin];
    [NameView addSubview:NameLabel];
    
    
    UITextField *textField = [[UITextField alloc]init];
    self.NameTextField = textField;
    [textField becomeFirstResponder];
    textField.delegate = self;
    textField.frame = CGRectMake(PX2PT(40 + 60) + NameLabel.width, 0, zjScreenWidth - 80, PX2PT(128));
    textField.clearButtonMode= UITextFieldViewModeWhileEditing;
    [NameView addSubview:textField];
    
    
    UIView *UPView = [[UIView alloc]initWithFrame:CGRectMake(0,PX2PT(184 + 256 + 40 + 60) + NameView.height, zjScreenWidth, zjScreenHeight)];
    UPView.backgroundColor = ZJColorFFFFFF;
    [self.view addSubview:UPView];
    
    UILabel *YouLabel = [[UILabel alloc]init];
    YouLabel.textAlignment = NSTextAlignmentCenter;
    [YouLabel zj_labelText:@"填写真实姓名，让更多同行认识你~" textColor:ZJColor505050 textSize:ZJTextSize35PX];
    YouLabel.x = zjScreenWidth/3.5;
    YouLabel.centerY = PX2PT(400)/3;
    [YouLabel zj_adjustWithMin];
    [UPView addSubview:YouLabel];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(SaveClick)];
    rightItem.tintColor = ZJColorFFFFFF;
    self.navigationItem.rightBarButtonItem = rightItem;
}


-(void)clickManButton:(UIButton *)button{
    _womenButton.enabled = YES;
    button.enabled = NO;
    _sexImageView.image = [UIImage imageNamed:@"gender_man"];
    self.Sex = 1;
    
}

-(void)clickWoManButton:(UIButton *)button{
    
    _menButton.enabled = YES;
    button.enabled = NO;
    _sexImageView.image = [UIImage imageNamed:@"gender_woman"];
    self.Sex = 0;
    
}

- (void)clickButton:(UIButton *)sender{
    [self getPictureFromeSystem];
}


#pragma mark---------获取系统相册
-(void)getPictureFromeSystem{
    
    if (_isChangeIcon) {
        ZJIconViewController *iconvc = [[ZJIconViewController alloc]init];
        iconvc.delegate = self;
        iconvc.iconImg =  _HeadButton.currentImage;
        [self.navigationController pushViewController:iconvc animated:YES];
    }else{
        [self getPictureForIcon];
        
    }
    
    
}

#pragma mark   获取标记模式的照片

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.HeadImage = image;
    UIImage *HeadImage = [self OriginImage:image scaleToSize:CGSizeMake(PX2PT(1024), PX2PT(1024))];

    //沙盒临时文件夹
    NSString *path_document = NSTemporaryDirectory();
    NSString *imagePath = [path_document stringByAppendingString:@"/ZJHead.jpg"];
    [UIImagePNGRepresentation(HeadImage) writeToFile:imagePath atomically:YES];
    self.HeadString = imagePath;
    
    _isChangeIcon= YES;
    
    [_HeadButton setImage:image forState:UIControlStateNormal];
}



#pragma mark   获取用户头像
-(void)ZJIconViewController:(ZJIconViewController *)view iconImg:(UIImage *)iconImg{
    
    [_HeadButton setImage:iconImg forState:UIControlStateNormal];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - 限制手机号码输入格式
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    if (textField == _NameTextField && _NameTextField.text.length < 10 ){
        return YES;
    }
    return NO;
    
}


-(void)SaveClick{
    
    if (_NameTextField.text.length < 1) {
        
        [self autorAlertViewWithMsg:@"请输入姓名"];
        return;
    }
    
    //检测网络状态
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    __weak __typeof(self) weakself=self;
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
       
        if (status ==AFNetworkReachabilityStatusNotReachable) {
            [weakself autorAlertViewWithMsg:@"亲，您的网络开小差了~"];
        }else{
             [weakself Sendnetwork];
        }
    }];
    //开始检测
    [manager startMonitoring];
    
}


//把个人信息发送到网络
- (void)Sendnetwork{
    
    [self.navigationItem.rightBarButtonItem.customView setAlpha:0.0];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *identifierForVendor = [ZJUUID getUUID];
    NSString *Token = [ud stringForKey:@"TOKEN"];
    NSString *URL = [NSString stringWithFormat:@"%@/crm/interface/user_SetUserInfo.php",THEURL];
   
    NSString *message = [NSString stringWithFormat:@"name=%@&sex=%zd&token=%@&meid=%@",self.NameTextField.text,self.Sex,Token,identifierForVendor];
    NSString *password = CIPHER;
    NSString *encryptedData = [AESCrypt encrypt:message password:password];
    NSString *Ecode = [encryptedData encodeString];
    NSDictionary* param = @{@"params":Ecode};
    
     __weak __typeof(self) weakself=self;
    
    TFFileUploadManager *tr = [TFFileUploadManager shareInstance];
    
    [[TFFileUploadManager shareInstance] uploadFileWithURL:URL params:param fileKey:@"file" filePath:weakself.HeadString completeHander:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];
    tr.username = ^(NSString *error){
        if ([error isEqualToString:@"网络异常，请稍后重试"]) {
            [weakself autorAlertViewWithMsg:error];
             [self.navigationItem.rightBarButtonItem.customView setAlpha:1.0];
            return ;
        }
        if ([error isEqualToString:@"1111111"]) {
          
            //更新归档对象
            NSString *documentsPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/ZJHAOKE"];
            NSData *data = [NSData dataWithContentsOfFile:documentsPath];
            ZJUser * User = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            User.Image = weakself.HeadImage;
            User.Sex = [NSString stringWithFormat:@"%zd",weakself.Sex];
            User.Name = weakself.NameTextField.text;
            User.Phone = weakself.Phone;
            NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:User];
            [data1 writeToFile:documentsPath atomically:YES];
            
            [weakself.navigationController popToRootViewControllerAnimated:YES];
        }else{
            NSString *urldecode = [weakself.Error zj_urlDecode];
            [weakself autorAlertViewWithMsg:urldecode];
            [self.navigationItem.rightBarButtonItem.customView setAlpha:1.0];
        }
    };

    

}

//压缩图片大小
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
