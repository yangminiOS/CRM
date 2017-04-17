//
//  ZJBaseMsgView.m
//  CRM
//
//  Created by 杨敏 on 16/10/2.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//



#import "ZJBaseMsgView.h"
#import "NSDate+Category.h"
#import "ZJDatePickView.h"
#import "ZJcustomerTableInfo.h"

@interface ZJBaseMsgView ()<UITextFieldDelegate>

//**左边的label**//
@property(nonatomic,strong)NSMutableArray *leftLabeles;
//**生日Button**//
@property(nonatomic,strong)UIButton *birthButton;
//**手机Button**//
@property(nonatomic,strong)UIButton *phoneButton;
//**贷款日期Button**//
@property(nonatomic,strong)UIButton *loanDateButton;
////**贷款期限Button**//
//@property(nonatomic,strong)UIButton *loanLTButton;
//**贷款金额**//
@property(nonatomic,strong)UILabel *loanCountLabel;
//**月利息Label**//
@property(nonatomic,strong)UILabel *interestLabel;
//**月利息Label**//
@property(nonatomic,strong)UILabel *loanLimitTimeLabel;
//**slider底部视图**//
//@property(nonatomic,weak)UIView *sliderView;
//**滑动silder**//
//@property(nonatomic,strong)UISlider *slider;
//**items**//
//@property(nonatomic,strong)NSMutableArray *itemsMutable;



@end

@implementation ZJBaseMsgView


-(NSMutableArray *)leftLabeles{
    
    if (!_leftLabeles) {
        
        _leftLabeles = [NSMutableArray array];
    }
    
    return _leftLabeles;
}
//-(NSMutableArray *)itemsMutable{
//    
//    if (!_itemsMutable) {
//        
//        _itemsMutable = [NSMutableArray array];
//    }
//    return _itemsMutable;
//}
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame: frame]) {
        
        self.backgroundColor = ZJColorFFFFFF;
        
        
        [self setupUI];
        
    }
    
    return self;
}


-(void)setupUI{
    
    NSArray *titlesArray = @[@"*姓     名",@"生       日",@"身份证号",@"*手     机",@"贷款金额",@"利       息",@"贷款日期",@"贷款期限"];
    
    for (NSInteger i = 0; i<titlesArray.count; i++) {
        
        [self separatorViewWithFrame:CGRectMake(0, i*PX2PT(126), self.width, PX2PT(2))];
        UILabel *label = [[UILabel alloc]init];
        [label zj_labelText:titlesArray[i] textColor:ZJColorDCDCDC textSize:ZJTextSize45PX];
        [self addSubview:label];
        [self.leftLabeles addObject:label];
        if (i ==0||i==3) {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:titlesArray[i]];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
            label.attributedText = str;
        }
        
    };
    
    _nameTF = [self setTextFieldWithPlaceHolder:@"请输入姓名"];
    _birthDayTF = [self setTextFieldWithPlaceHolder:@"请选择出生日期" ];
    _codeIDTF = [self setTextFieldWithPlaceHolder:@"请输入身份证号" ];
    _codeIDTF.keyboardType = UIKeyboardTypeAlphabet;
    _phoneTF = [self setTextFieldWithPlaceHolder:@"请输入或选择手机号" ];
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    _loanConutTF = [self setTextFieldWithPlaceHolder:@"请输入贷款金额" ];
    _loanConutTF.keyboardType = UIKeyboardTypeDecimalPad;
    _interestTF = [self setTextFieldWithPlaceHolder:@"请输入每月利息" ];
    _interestTF.keyboardType = UIKeyboardTypeDecimalPad;

    _loanDateTF = [self setTextFieldWithPlaceHolder:@"请选择贷款日期" ];
    _loanLimintTimeTF = [self setTextFieldWithPlaceHolder:@"请输入贷款期限"];
    _loanLimintTimeTF.keyboardType = UIKeyboardTypeNumberPad;

    
    _birthDayTF.enabled = NO;
    _loanDateTF.enabled = NO;
//    _loanLimintTimeTF .enabled = NO;
    
    _birthButton = [[UIButton alloc]init];
    _birthButton.tag = 1;

    [self addSubview:_birthButton];
    [_birthButton setImage:[UIImage imageNamed:@"arrows"] forState:UIControlStateNormal];
    _birthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_birthButton addTarget:self action:@selector(clickBirthDayButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _phoneButton = [[UIButton alloc]init];
    [self addSubview:_phoneButton];
    [_phoneButton setImage:[UIImage imageNamed:@"arrows"] forState:UIControlStateNormal];
    _phoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_phoneButton addTarget:self action:@selector(clickPhoneButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _loanDateButton = [[UIButton alloc]init];
    _loanDateButton.tag = 2;

    [self addSubview:_loanDateButton];
    [_loanDateButton setImage:[UIImage imageNamed:@"arrows"] forState:UIControlStateNormal];
    _loanDateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_loanDateButton addTarget:self action:@selector(clickLoanDateButton:) forControlEvents:UIControlEventTouchUpInside];
    
//    _loanLTButton = [[UIButton alloc]init];
//    [self addSubview:_loanLTButton];
//    [_loanLTButton setImage:[UIImage imageNamed:@"remark"] forState:UIControlStateNormal];
//    _loanLTButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [_loanLTButton addTarget:self action:@selector(clickLoanLimintTimeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _loanCountLabel = [[UILabel alloc]init];
    [_loanCountLabel zj_labelText:@"(万元)" textColor:ZJColorDCDCDC textSize:ZJTextSize45PX];
    _loanCountLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_loanCountLabel];
    
    _interestLabel = [[UILabel alloc]init];
    [_interestLabel zj_labelText:@"(%)" textColor:ZJColorDCDCDC textSize:ZJTextSize45PX];
    _interestLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_interestLabel];
    
    _loanLimitTimeLabel = [[UILabel alloc]init];
    [_loanLimitTimeLabel zj_labelText:@"个月" textColor:ZJColorDCDCDC textSize:ZJTextSize45PX];
    [self addSubview:_loanLimitTimeLabel];
    _loanLimitTimeLabel.textAlignment = NSTextAlignmentRight;

    
//    UIView *sliderView = [[UIView alloc]init];
//    sliderView.backgroundColor = ZJColorFFFFFF;
//    [self addSubview:sliderView];
//    _sliderView = sliderView;
//    
//    UISlider *slider = [[UISlider  alloc]init];
//    slider.value = 0;
//    slider.minimumValue = 0;
//    slider.maximumValue = 48;
//    _slider = slider;
//    [_sliderView addSubview:_slider];
//    [_slider addTarget:self action:@selector(sliderView:) forControlEvents:UIControlEventValueChanged];
//    
//    NSArray *items = @[@"6个月",@"12个月",@"24个月",@"36个月",@"48个月"];
//    for (NSInteger i = 0; i<items.count; i++) {
//        
//        UILabel *itemsLabel = [[UILabel alloc]init];
//        [itemsLabel zj_labelText:items[i] textColor:ZJColor505050 textSize:ZJTextSize35PX];
//        [_sliderView addSubview:itemsLabel];
//        [self.itemsMutable addObject:itemsLabel];
//    }

}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    for (NSInteger i = 0; i<self.leftLabeles.count; i++) {
        
        UILabel *label = self.leftLabeles[i];
        
        label.frame = CGRectMake(ZJmargin40, 13+PX2PT(128)*i, 62, 16);

    }
    
    CGFloat textFx = 2*ZJmargin40+62;
    CGFloat textW =zjScreenWidth - textFx -62;
    
    _nameTF.frame = CGRectMake(textFx, 10,textW+62 , 22);
    _birthDayTF.frame = CGRectMake(textFx, 10+PX2PT(128)*1, textW, 22);
    _codeIDTF.frame =CGRectMake(textFx, 10+PX2PT(128)*2, textW+62, 22);
    _phoneTF.frame = CGRectMake(textFx, 10+PX2PT(128)*3, textW, 22);
    _loanConutTF.frame =CGRectMake(textFx, 10+PX2PT(128)*4, textW, 22);
    _interestTF.frame = CGRectMake(textFx, 10+PX2PT(128)*5, textW+20, 22);
    _loanDateTF.frame = CGRectMake(textFx, 10+PX2PT(128)*6, textW, 22);
    _loanLimintTimeTF.frame = CGRectMake(textFx, 10+PX2PT(128)*7, textW, 22);
    CGFloat maxX = CGRectGetMaxX(_birthDayTF.frame);
    CGFloat maxWidth = self.width - maxX - ZJmargin40;
    CGFloat maxHeight = PX2PT(128)-1;
    _birthButton.frame = CGRectMake(0, 1+PX2PT(128), zjScreenWidth-ZJmargin40, maxHeight);
    
    _phoneButton.frame = CGRectMake(maxX, 1+3*PX2PT(128), maxWidth, maxHeight);
//    _loanLTButton.frame = CGRectMake(maxX, 1+7*PX2PT(128), maxWidth, maxHeight);
    _loanDateButton.frame = CGRectMake(0, 6*PX2PT(128), zjScreenWidth-ZJmargin40, maxHeight);
    _loanCountLabel.frame = CGRectMake(maxX, 10+PX2PT(128)*4, maxWidth, 22);
    _interestLabel.frame = CGRectMake(maxX, 10+PX2PT(128)*5, maxWidth, 22);
    
    _loanLimitTimeLabel.frame = CGRectMake(maxX, 10+PX2PT(128)*7, maxWidth, 22);
//    _sliderView.frame = CGRectMake(0, 8*PX2PT(128)+1, self.width, PX2PT(280));
//    _slider.frame = CGRectMake(ZJmargin40, ZJmargin40 , self.width - 2*ZJmargin40, 30);
//    CGFloat  margin = (self.width - 40*5-2*ZJmargin40)/4.0;
//    CGFloat itemsY = CGRectGetMaxY(self.slider.frame)+PX2PT(20);
//    for (NSInteger i = 0; i<self.itemsMutable.count; i++) {
//        
//        UILabel * label = self.itemsMutable[i];
//        
//        label.frame = CGRectMake(ZJmargin40 +(40+margin)*i, itemsY, 40, 15);
//    }
    
    
}
//textfield设置

-(UITextField *)setTextFieldWithPlaceHolder:(NSString *)text{
    
    UITextField *textField = [[UITextField alloc]init];
    textField.delegate = self;
    textField.placeholder = text;
    textField.textColor = ZJColor505050;
    textField.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    textField.borderStyle = UITextBorderStyleNone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:textField];
    return textField;
}
//分割线
-(void)separatorViewWithFrame:(CGRect)frame{

    UIView *view = [[UIView alloc]init];
    [self addSubview:view];
    view.frame = frame;
    view.backgroundColor = ZJColorDCDCDC;
    
}

#pragma mark---------点击生日Button

-(void)clickBirthDayButton:(UIButton *)button{
    [_actionTF resignFirstResponder];

    [self.delegate ZJBaseMsgView:self didClickButtonTag:button.tag];
}

#pragma mark---------点击手机Button

-(void)clickPhoneButton:(UIButton *)button{
    
    [self.delegate ZJBaseMsgView:self];
    
}

#pragma mark---------点击贷款日期Button

-(void)clickLoanDateButton:(UIButton *)button{
    
    [_actionTF resignFirstResponder];
    
    [self.delegate ZJBaseMsgView:self didClickButtonTag:button.tag];
    
}

//#pragma mark---------点击贷款期限Button
//
//-(void)clickLoanLimintTimeButton:(UIButton *)button{
//
//    button.selected = !button.selected;
//    
//    _loanLimintTimeTF.enabled = button.selected;
//    _sliderView.hidden = button.selected;
//    
//    CGFloat addHeight = 0;
//    if (!button.selected) {
//        _loanLimintTimeTF.placeholder = @"请选择贷款期限";
//        addHeight = PX2PT(280);
//    }else{
//        addHeight = -PX2PT(280);
//        _loanLimintTimeTF.placeholder = @"请输入贷款期限";
//    }
//    [self.delegate  ZJBaseMsgView:self viewAddHight:addHeight];
//}
//
//#pragma mark---------滑动silder
//
//-(void)sliderView:(UISlider *)slider{
//    
//    if (slider.value < 6) {
//        
//        _loanLimintTimeTF.text = @"6";
//    }else if (slider.value > 6 &&slider.value <=18){
//        
//        _loanLimintTimeTF.text = @"12";
//    }else if (slider.value > 18 &&slider.value <=30){
//        
//        _loanLimintTimeTF.text = @"24";
//        
//    }else if (slider.value > 30 &&slider.value <=42){
//        
//        _loanLimintTimeTF.text = @"36";
//        
//    }else if (slider.value > 42 &&slider.value <=48){
//        
//        _loanLimintTimeTF.text = @"48";
//        
//    }
//    
//}
/*
 //姓名
 @property(nonatomic,strong) UITextField *nameTF;
@property(nonatomic,strong)UITextField *birthDayTF;
@property(nonatomic,strong)UITextField *codeIDTF;
@property(nonatomic,strong)UITextField *phoneTF;
@property(nonatomic,strong)UITextField *loanConutTF;
@property(nonatomic,strong)UITextField *interestTF;
@property(nonatomic,strong)UITextField *loanDateTF;
@property(nonatomic,strong)UITextField *loanLimintTimeTF;
 */
#pragma mark   编辑模式下赋值

-(void)setModel:(ZJcustomerTableInfo *)model{
    _model  = model;
    
    _nameTF.text = model.cName;
    _birthDayTF.text = model.cBirthDay;
    _codeIDTF.text = model.cCardID ;
    _phoneTF.text = model.cPhone;
    _loanConutTF.text = [NSString stringWithFormat:@"%.2f",model.fBorrowMoney];
    _interestTF.text = [NSString stringWithFormat:@"%.3f",model.fMonthlyInterest];;
    _loanDateTF.text = model.cLoanDate;
    _loanLimintTimeTF.text = model.cLoanTimeLimit;
}
#pragma mark   textField代理方法
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.actionTF = textField;
    [self.delegate ZJBaseMsgView:self activeTextField:self.actionTF];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    //手机号码判断
//    else if (textField == _phoneTF&&[temp zj_isStringAccordWith:@"^1[0-9]{0,10}?$"]){//手机号码
//        return YES;//^1[0-9]\\d{9}$
    
//    }
    NSString * temp = [textField.text stringByAppendingString:string];
    
    if (textField == _nameTF) {//名字
        return YES;

    }else if (textField == _phoneTF){//手机号码
        return YES;//^1[0-9]\\d{9}$
        
    }else if (textField == _codeIDTF&&[temp zj_isStringAccordWith:@"^[1-9][0-9]{0,16}([0-9]|[xX])?$"]){//身份证
        return YES;
        
    }else if (textField == _loanConutTF&&([temp zj_isStringAccordWith:@"^[0-9]{1,4}+(\\.[0-9]{0,2})?$"])){//贷款金额
        return YES;
    }else if (textField == _interestTF &&([temp zj_isStringAccordWith:@"^[0-9]{1,2}+(\\.[0-9]{0,3})?$"])){//贷款利息
        return YES;
    }else if (textField == _loanLimintTimeTF&&([temp zj_isStringAccordWith:@"^[1-9]\\d{0,2}$"])){
        
        return YES;
    }
    return NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == _codeIDTF&&textField.text.length==18) {
        
        NSString *year = [_codeIDTF.text substringWithRange:NSMakeRange(6, 4)];
        
        NSString *month = [_codeIDTF.text substringWithRange:NSMakeRange(10, 2)];
        NSString *day = [_codeIDTF.text substringWithRange:NSMakeRange(12, 2)];
        
        _birthDayTF.text =[NSString stringWithFormat:@"%@-%@-%@",year,month,day];
        
    }
}
@end










