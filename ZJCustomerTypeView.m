//
//  ZJCustomerTypeView.m
//  CRM
//
//  Created by mini on 16/9/21.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJCustomerTypeView.h"
#import "ZJAddRemindView.h"
#import "ZJCustomerItemsTableInfo.h"
#import "ZJFMdb.h"
#import "ZJcustomerTableInfo.h"

@interface ZJCustomerTypeView ()<ZJAddRemindViewDelegate,UITextFieldDelegate>
{
    ZJViewType _Viewtype;
    UILabel *_titleLabel;//标题
    UIButton *_remarkButton;//备注
    CGFloat ViewHeight;
    //_Viewtype
    UITextField *_RCTextField;//写入标签
    UIButton *_addItemButton;//添加标签按钮
    UIButton *_cancelButton;//取消按钮
    //介绍人
    UILabel *_introduceLabel;
    UIButton * _addIntroducerButton;
    //多少行
    NSInteger itemsLine;
    //remarkLabel高度
    CGFloat remarkLabelHeight;//备注信息的高度
    BOOL isPress;//开始长按
    //存储数据库是的Type
    NSString *_type;
    //对应items在表中储存的表头
    NSString *_tableHead;
    
}

//**标签Buttons**
@property(nonatomic,strong) NSMutableArray *itemsButton;

//**删除按钮**//
@property(nonatomic,strong)NSMutableArray *delecteButtons;

//添加备注
@property(nonatomic,strong)ZJAddRemindView *addRemind;

//**items模型**//
@property(nonatomic,strong) NSMutableArray *itemsModel;


@end

@implementation ZJCustomerTypeView

//-(ZJAddRemindView *)addRemind{
//    
//    if (!_addRemind) {
//        
//        _addRemind = [[ZJAddRemindView alloc]initWithFrame:CGRectMake(0, 0, zjScreenWidth, zjScreenHeight)];
//        
//        _addRemind.delegate = self;
//
//
//    }
//    
//    return _addRemind;
//}

-(NSMutableArray *)itemsModel{
    if (!_itemsModel) {
        
        _itemsModel = [NSMutableArray array];
    }
    return _itemsModel;
}

-(NSMutableArray *)itemsButton{
    
    if (!_itemsButton) {
        
        _itemsButton = [NSMutableArray array];
        
        ZJCustomerItemsTableInfo *model = [[ZJCustomerItemsTableInfo alloc]init];
        
        for (NSInteger i = 0; i<self.itemsModel.count; i++) {
            model = _itemsModel[i];
            [self addItemButtonWithModel:model selecte:NO];
            
        }
        
    }
    
    return _itemsButton;
}

-(NSMutableArray *)delecteButtons{
    
    if (!_delecteButtons) {
        _delecteButtons = [NSMutableArray array];
    }
    
    return _delecteButtons;
}

-(instancetype)initZJCustomerTypeViewWithTitle:(NSString *)title viewType:(ZJViewType)type{
    
    if (self = [super init]) {
        
        self.backgroundColor = ZJColorFFFFFF;
        //设置UI
        [self setupUIWithTitle:title viewType:type];
        
    }
    
    return self;
}

#pragma mark    数据库获取数据

-(void)addDateFromFMdbWith:(ZJCustomerItemsTableInfo *)model{
    
    NSString *select = [NSString stringWithFormat:@"select * from %@ where type='%@'",ZJCustomerItemsTableName,_type];
    
    [ZJFMdb sqlSelecteData:model selecteString:select success:^(NSMutableArray *successMsg) {
        [self.itemsModel addObjectsFromArray:successMsg];
        
    }];
    
}
-(void)setupUIWithTitle:(NSString *)title viewType:(ZJViewType)type{
    _Viewtype = type;
    remarkLabelHeight = 0;
    
    ZJCustomerItemsTableInfo *Model = [[ZJCustomerItemsTableInfo alloc]init];
    
    if (type ==ZJCustomerStateView) {
        _type = @"customerState";
        _tableHead = @"cCustomerState_Tags";
        [self addDateFromFMdbWith:Model];
        
    }else if (type ==ZJCustomerSourceView){
        _type = @"customerSource";
        _tableHead = @"cCustomerSource_Tags";

        [self addDateFromFMdbWith:Model];

        
    }else{
        _type = @"customerType";
        _tableHead = @"cLoanType_Tags";

        [self addDateFromFMdbWith:Model];

    }
    itemsLine = (self.itemsModel.count - 1)/itemsCount_line +1;
    
    self.customerItemsHeight = 4*ZJmargin40 +61+36+(itemsLine -1)*(36+PX2PT(25));

    //标题
    _titleLabel = [[UILabel alloc]init];
    [self addSubview:_titleLabel];
    _titleLabel.text = title;
    _titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    _titleLabel.textColor = ZJColor505050;
    
    if (type == ZJCustomerStateView) {
        
        _titleLabel.text = [NSString stringWithFormat:@"*%@",title];

        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:_titleLabel.text];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
        _titleLabel.attributedText = str;
    }
    //取消按钮
    _cancelButton = [[UIButton alloc]init];
    
    [self addSubview:_cancelButton];
    [_cancelButton setBackgroundImage:[UIImage imageNamed:@"deselect"] forState:UIControlStateNormal];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:ZJColorFFFFFF forState:UIControlStateNormal];
    _cancelButton.hidden = YES;
    
    [_cancelButton addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    //添加按钮和输入items 的textfield
    
    _addItemButton = [[UIButton alloc]init];
    [self addSubview:_addItemButton];
    [_addItemButton setTitle:@"添加" forState:UIControlStateNormal];
    _addItemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_addItemButton setTitleColor:ZJColor00D3A3 forState:UIControlStateNormal];
    _addItemButton.titleLabel.font = [UIFont systemFontOfSize:PX2PT(45)];
    [_addItemButton addTarget:self action:@selector(clickAddItemButton) forControlEvents:UIControlEventTouchUpInside];
    //items 的textfield
    _RCTextField = [[UITextField alloc]init];
    _RCTextField.backgroundColor = ZJBackGroundColor;
    _RCTextField.layer.cornerRadius = 3.0;
    [_RCTextField clipsToBounds];
    [self addSubview:_RCTextField];
    _RCTextField.delegate = self;
    _RCTextField.placeholder = @"在此输入标签内容，最多6个字";
    _RCTextField.font = [UIFont systemFontOfSize:PX2PT(35)];
    _RCTextField.textColor = ZJColor505050;
    _RCTextField.textAlignment = NSTextAlignmentCenter;
    
        //判断类型
    if (type == ZJCustomerStateView) {
        //备注button
        _remarkButton = [[UIButton alloc]init];
        _remarkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self addSubview:_remarkButton];
        [_remarkButton setImage:[UIImage imageNamed:@"remark"] forState:UIControlStateNormal];
        [_remarkButton setTitle:@"备注" forState:UIControlStateNormal];
        _remarkButton.contentMode = UIViewContentModeRight;
        [_remarkButton setTitleColor:ZJColor00D3A3 forState:UIControlStateNormal];
        [_remarkButton addTarget:self action:@selector(clickRemarkButton:) forControlEvents:UIControlEventTouchUpInside];
        
        self.remarkTextButton = [[UIButton alloc]init];
        [self addSubview:self.remarkTextButton];
        [self.remarkTextButton setTitleColor:ZJColor505050 forState:UIControlStateNormal];
        self.remarkTextButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
        self.remarkTextButton.backgroundColor = ZJBackGroundColor;
        self.remarkTextButton.titleLabel.numberOfLines = 0;
        self.remarkTextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.remarkTextButton.layer.cornerRadius = 3;
        self.remarkTextButton.clipsToBounds = YES;
        self.remarkTextButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        self.remarkTextButton.hidden = YES;
        
        [self.remarkTextButton addTarget:self action:@selector(clickRemarkButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (type == ZJCustomerSourceView){
        
        self.customerItemsHeight +=31+ZJmargin40;
        _introduceLabel = [[UILabel alloc]init];
        [self addSubview:_introduceLabel];
        [_introduceLabel zj_labelText:@"介绍人" textColor:ZJColor505050 textSize:ZJTextSize45PX];
        _introduceLabel.textAlignment = NSTextAlignmentLeft;
        
        _introducerNameTField = [[UITextField alloc]init];
        _introducerNameTField.enabled = NO;
        [self addSubview:_introducerNameTField];
        _introducerNameTField.textColor = ZJColor505050;
        _introducerNameTField.font = [UIFont systemFontOfSize:ZJTextSize45PX];
        
        _addIntroducerButton =[[UIButton alloc]init];
        [self addSubview:_addIntroducerButton];
        _addIntroducerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_addIntroducerButton setImage:[UIImage imageNamed:@"arrows"] forState:UIControlStateNormal];
        [_addIntroducerButton addTarget:self action:@selector(clickAddIntroducderButton) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

#pragma mark   布局itemsButton
-(void)layoutItemsButton{
    
    CGFloat width = (self.width -ZJmargin40 *2 - PX2PT(25)*3)/4;
    CGFloat height = 36;
    CGFloat Y = CGRectGetMaxY(_addItemButton.frame)+ ZJmargin40;
    for (NSInteger i = 0; i<self.itemsButton.count; i++) {
        UIButton *button = self.itemsButton[i];
        [self addSubview:button];
        button.frame = CGRectMake(ZJmargin40+i%itemsCount_line*(width +PX2PT(25)),  i/itemsCount_line*(height + PX2PT(30))+ Y, width, height);
        if (i == self.itemsButton.count - 1) {
            
            CGFloat yes = CGRectGetMaxY(button.frame) +PX2PT(30);
            
            CGFloat no = button.y;
            
            CGFloat cancelY = self.itemsButton.count%itemsCount_line == 0?yes:no;
            
            _cancelButton.frame = CGRectMake(self.width-ZJmargin40-63, cancelY, 63, 36);
            
            ViewHeight = CGRectGetMaxY(button.frame) +ZJmargin40;
            
        }
        NSInteger delectIndex = self.itemsModel.count - self.delecteButtons.count;
        if (i>=(delectIndex)) {
            
            UIButton *deleButton = self.delecteButtons[i -delectIndex];
            deleButton.size = deleButton.currentImage.size;
            deleButton.x = width - deleButton.width +1;
            deleButton.y = -1;
        }
        
    }
    
}
#pragma mark   布局子视图
-(void)layoutSubviews{
    
    [super layoutSubviews];
    //标题
    _titleLabel.frame = CGRectMake(ZJmargin40, ZJmargin40, 70, 31);
    //添加标签
    CGFloat addItemButtonY = CGRectGetMaxY(_titleLabel.frame)+ZJmargin40;
    _addItemButton.frame = CGRectMake(self.width - ZJmargin40 - 30, addItemButtonY, 32, 30);
    _RCTextField.frame = CGRectMake(ZJmargin40, addItemButtonY, self.width - 32 -3*ZJmargin40, 30);
    //标签
    [self layoutItemsButton];

    if (_Viewtype == ZJCustomerStateView){
        
        _remarkButton.frame = CGRectMake(self.width - 100, ZJmargin40, 100-ZJmargin40, 31);
        self.remarkTextButton.frame = CGRectMake(ZJmargin40, self.height-remarkLabelHeight, self.width - 2*ZJmargin40, remarkLabelHeight-ZJmargin40);

    }else if (_Viewtype == ZJCustomerSourceView){
        CGFloat Y=0;
        
        if (_cancelButton.hidden) {
            
            UIButton *button = self.itemsButton.lastObject;
             Y = CGRectGetMaxY(button.frame)+ZJmargin40 ;
            
        }else{
            
             Y = CGRectGetMaxY(_cancelButton.frame)+ZJmargin40 ;
            
        }
        
        _introduceLabel.frame = CGRectMake(ZJmargin40, Y, 50, 31);
        
        CGFloat introducerNX =2*ZJmargin40 +50;
        _introducerNameTField.frame = CGRectMake(introducerNX, Y, self.width - introducerNX, 31);
        _addIntroducerButton.frame = CGRectMake(0, Y, self.width - ZJmargin40, 31);
        
    }
    
}

#pragma mark   点击备注按钮

-( void)clickRemarkButton:(UIButton *)button{
    
    CGRect frame = CGRectMake(0, 0, zjScreenWidth, zjScreenHeight);
    
    _addRemind = [[ZJAddRemindView alloc]initWithFrame:frame andTitle:self.remarkTextButton.titleLabel.text];
    
    _addRemind.delegate = self;
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.addRemind];
    if (_addRemind) {
        
        [_addRemind.textView becomeFirstResponder];
    }
}
#pragma mark   增加标签
-(void)addItemButtonWithModel:(ZJCustomerItemsTableInfo *)model selecte:(BOOL)select {
    
    UIButton *itemButton = [[UIButton alloc]init];
    itemButton.selected = select;
    [itemButton setTitle:model.itemString forState:UIControlStateNormal];
    [itemButton setTitleColor:ZJColorFFFFFF forState:UIControlStateNormal];
    [itemButton setTitleColor:ZJColor505050 forState:UIControlStateSelected];
    itemButton.titleLabel.font = [UIFont systemFontOfSize:PX2PT(35)];
    [itemButton setBackgroundImage:[UIImage imageNamed:@"Uncheck--label"] forState:UIControlStateNormal];
    [itemButton setBackgroundImage:[UIImage imageNamed:@"Select--label"] forState:UIControlStateSelected];
    [itemButton addTarget:self action:@selector(clickItemButton:) forControlEvents:UIControlEventTouchUpInside];
    if (model.delect == 0) {
        //设置删除按钮
        UIButton *deleButton = [[UIButton alloc]init];
        [itemButton addSubview:deleButton];
        [deleButton setImage:[UIImage imageNamed:@"delete-audition--After-clicking"] forState:UIControlStateNormal];
        deleButton.hidden = YES;
        [self.delecteButtons addObject:deleButton];
        [deleButton addTarget:self action:@selector(clickUPDelecteButton:) forControlEvents:UIControlEventTouchUpInside];
        //添加手势  长按
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressItemButton:)];
        longPress.minimumPressDuration = 1.0;
        
        [itemButton addGestureRecognizer:longPress];
        
    }
    [self.itemsButton addObject:itemButton];
    
}
#pragma mark   长按itemsButton
-(void)longPressItemButton:(UILongPressGestureRecognizer *)recognize{
    
    if (!isPress&& recognize.state == UIGestureRecognizerStateBegan){
        isPress = YES;
        for (UIButton *button in self.delecteButtons) {
            button.hidden = NO;
        }
        _cancelButton.hidden = NO;
        //判断是否要加上取消按钮的高度
        CGFloat height =(36+PX2PT(30));
        
        [self returenViewHeight:height];
        
    }else if (recognize.state == UIGestureRecognizerStateEnded)
 
        isPress = NO;
    
}
#pragma mark   //点击itemsButton
-(void)clickItemButton:(UIButton *)button{
    
    if (!_cancelButton.hidden) {
        NSInteger index = [self.itemsButton indexOfObject:button];
        
        
        if (_Viewtype == ZJCustomerStateView) {
        
            if (index<=defaultItemsMaxIndex) return;

        }
        
        NSInteger diffIndex = self.itemsModel.count - self.delecteButtons.count;

        
        ZJCustomerItemsTableInfo *model = self.itemsModel[index];

        NSString *select = [NSString stringWithFormat:@"SELECT COUNT (*) FROM %@ WHERE (%@ LIKE '%zd;%%' OR %@ LIKE '%%;%zd;%%' OR %@ LIKE '%%;%zd;')",ZJCustomerTableName,_tableHead,model.iAutoID,_tableHead,model.iAutoID,_tableHead,model.iAutoID];
        //SELECT * FROM crm_CustomerInfo WHERE  cCustomerState_Tags IN ('23')
        NSInteger num = [ZJFMdb sqlSelecteCountWithString:select];

        if (num>0) {
            [self.delegate ZJCustomerTypeView:self warnText:@"该标签已被客户使用，不能删除"];
            return;
        }
        //select	__NSCFString *	@"SELECT * FROM crm_CustomerInfo WHERE (cCustomerState_Tags LIKE '23;%' OR cCustomerState_Tags LIKE '%;23;%' OR cCustomerState_Tags LIKE '%;23')"
        [self.itemsButton removeObjectAtIndex:index];
        [self.delecteButtons removeObjectAtIndex:index-diffIndex];
        [ZJFMdb sqlDelecteData:model tableName:ZJCustomerItemsTableName headString:model.iAutoID];
        [self.itemsModel removeObjectAtIndex:index];
        [button removeFromSuperview];
        button = nil;
        if ((self.itemsButton.count+1)%itemsCount_line == 0) {
            
            CGFloat height = -( 36+PX2PT(30));
            
            [self.delegate ZJCustomerTypeView:self ZJViewType:_Viewtype viewHeight:height];
            
        }
        itemsLine =(self.itemsButton.count - 1)/itemsCount_line +1;

        return;
    }else{
        
        button.selected = !button.selected;
    }
    
}
#pragma mark   //添加标签按钮
-(void)clickAddItemButton{
    //退回键盘
    [_RCTextField resignFirstResponder];
    if (!_cancelButton.hidden) return;
    
    //判断是否超出20个
    if (self.itemsButton.count >=20) {
        [self.delegate ZJCustomerTypeView:self warnText:@"最多只能添加20个标签"];
        return;
    }
    //判断输入是否为空
    
    if(_RCTextField.text.length ==0){
        //判断输入是否超过6个字符
        [self.delegate ZJCustomerTypeView:self warnText:@"标签内容不可为空"];
        return;
        
    }
    
    //判断文字输入的长度
    if(_RCTextField.text.length > 6){
        //判断输入是否超过6个字符
        [self.delegate ZJCustomerTypeView:self warnText:@"在此输入标签内容，最多6个字"];
        return;
        
    }
    //判断标签内容是否存在
    
    ZJCustomerItemsTableInfo * model = [[ZJCustomerItemsTableInfo alloc]init];
    for (model in self.itemsModel) {
        
        NSString *string = model.itemString;
        if ([_RCTextField.text isEqualToString:string]) {
            [self.delegate ZJCustomerTypeView:self warnText:@"标签内容已存在"];
            return;
        }
    }

    //正常录入
    if (_RCTextField.text.length <= 6 &&_RCTextField.text.length >0) {
        
        ZJCustomerItemsTableInfo * model = [[ZJCustomerItemsTableInfo alloc]init];
        model.itemString = _RCTextField.text;
        model.delect = 0;
        model.type = _type;
        [self addItemButtonWithModel:model selecte:YES];
        NSInteger ID =[ZJFMdb sqlInsertData:model tableName:ZJCustomerItemsTableName];
        model.iAutoID = ID;
        [self.itemsModel addObject:model];
        
        _RCTextField.text = nil;

    }
    
    if (((self.itemsButton.count - 1)/itemsCount_line +1) ==itemsLine) {
        
        [self layoutSubviews];//没有超过原有行数的情况
        
    }else{//超过原有行数的情况
        
        itemsLine =(self.itemsButton.count - 1)/itemsCount_line +1;
        
        CGFloat height = 36+PX2PT(30);
        
        [self.delegate ZJCustomerTypeView:self ZJViewType:_Viewtype viewHeight:height];

    }
    //
    

    
}
#pragma mark   //点击删除按钮
-(void)clickUPDelecteButton:(UIButton *)button{
    
    NSInteger index = [self.delecteButtons indexOfObject:button];
    
    
    NSInteger diffIndex = self.itemsModel.count - self.delecteButtons.count;

    ZJCustomerItemsTableInfo *model = self.itemsModel[index+diffIndex];

    NSString *select = [NSString stringWithFormat:@"SELECT COUNT (*) FROM %@ WHERE (%@ LIKE '%zd;%%' OR %@ LIKE '%%;%zd;%%' OR %@ LIKE '%%;%zd;')",ZJCustomerTableName,_tableHead,model.iAutoID,_tableHead,model.iAutoID,_tableHead,model.iAutoID];
    
    NSInteger num = [ZJFMdb sqlSelecteCountWithString:select];

    if (num>0) {
        [self.delegate ZJCustomerTypeView:self warnText:@"该标签已被客户使用，不能删除"];
        return;
    }
    
    UIButton *itemB = (UIButton *)button.superview;
    
    [itemB removeFromSuperview];
    
    [self.delecteButtons removeObjectAtIndex:index];
    
    [self.itemsButton removeObjectAtIndex:index+diffIndex];
    
    [ZJFMdb sqlDelecteData:model tableName:ZJCustomerItemsTableName headString:model.iAutoID];
    [self.itemsModel removeObjectAtIndex:index+diffIndex];
    
    itemB = nil;
    
    if ((self.itemsButton.count+1)%itemsCount_line == 0) {
        
        CGFloat height = -( 36+PX2PT(30));
        
        [self.delegate ZJCustomerTypeView:self ZJViewType:_Viewtype viewHeight:height];
        
    }
    
    itemsLine =(self.itemsButton.count - 1)/itemsCount_line +1;

    
}
#pragma mark   //点击取消按钮
-(void)clickCancelButton:(UIButton *)button{
    
    button.hidden = YES;
    
    for (UIButton *button in self.delecteButtons) {
        button.hidden = YES;
    }
    //判断是否要减去取消按钮的高度
    CGFloat height = -(36+PX2PT(30));
    
    [self returenViewHeight:height];

}

#pragma mark------//返回View的高度 点击取消和长按键
-(void)returenViewHeight:(CGFloat)height{
    
    if (self.itemsButton.count%itemsCount_line == 0) {
        //代理方法
        [self.delegate ZJCustomerTypeView:self ZJViewType:_Viewtype viewHeight:height];
    }

}


#pragma mark-----//返回选中Items文字的方法
-(NSString *)ZJCustomerTypeViewWithSelectedItemsString{
    NSString *string = @" ";
    for (NSInteger i = 0; i<self.itemsButton.count;i++) {
        UIButton *button  = self.itemsButton[i];
        ZJCustomerItemsTableInfo *model = [[ZJCustomerItemsTableInfo alloc]init];
        if (button.selected) {
            model = self.itemsModel[i];
            
            string = [NSString stringWithFormat:@"%@%zd;",string,model.iAutoID];
            
        }
        
    }
    NSString *itemsString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    return itemsString;
}

-(void)clickAddIntroducderButton{
    
    [self.delegate ZJCustomerTypeView:self];
    
}

#pragma mark---------模型赋值

-(void)setModel:(ZJcustomerTableInfo *)model{
    
    _model = model;

    if (_Viewtype == ZJCustomerStateView) {
        
        [self buttonSelectedFromArray:model.stateArray];
        
        CGFloat height = 0;
        if (model.cCustomerState_Remark.length>0) {
            
            _remarkTextButton.hidden = NO;
            
            height = [model.cCustomerState_Remark zj_getStringRealHeightWithWidth:self.width - 2*ZJmargin40 - 10 fountSize:ZJTextSize45PX]+10+ZJmargin40;
            self.customerItemsHeight +=height;
            
            [self.remarkTextButton setTitle:model.cCustomerState_Remark forState:UIControlStateNormal];
            remarkLabelHeight = height;
            //_remarkTextButton.height = height;
            //_remarkTextButton.y = self.height - height-ZJmargin40;

            

        }else{
            
            _remarkTextButton.hidden = YES;
        }
        
        
    }else if (_Viewtype ==ZJCustomerSourceView){
        
        [self buttonSelectedFromArray:model.sourceArray];

        _introducerNameTField.text = model.cCustomerSource_IntroducerName;
        
    }else{
        [self buttonSelectedFromArray:model.typeArray];

    }
    
}
//编辑转态下  那些button是选中的
-(void)buttonSelectedFromArray:(NSMutableArray *)array{
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSInteger ID = [obj integerValue];
        
        [self.itemsModel enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            ZJCustomerItemsTableInfo *itemModel = obj;

            
            if (ID == itemModel.iAutoID) {
                
                UIButton *button = self.itemsButton[idx];
                
                button.selected = YES;
            }
            
        }];
        
    }];
}

#pragma mark   textField代理方法
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    self.actionField = textField;
    
    [self.delegate ZJCustomerTypeView:self actionTextField:textField];
    
    return YES;
}
#pragma mark---------ZJAddRemindViewDelegate

-(void)ZJAddRemindView:(ZJAddRemindView *)view text:(NSString *)text clickButton:(UIButton *)button{
    
    if (button.tag ==2) {
        
        CGFloat height = 0;
        if (text.length>0) {
            
            _remarkTextButton.hidden = NO;
            
            height = [text zj_getStringRealHeightWithWidth:self.width - 2*ZJmargin40 - 10 fountSize:ZJTextSize45PX]+10+ZJmargin40;
        }else{
            _remarkTextButton.hidden = YES;
        }
        
        [_remarkTextButton setTitle:text forState:UIControlStateNormal];
        
        if (height ==remarkLabelHeight){
            
            [view removeFromSuperview];
            
            view = nil;
            return;
            
        }
        
        CGFloat addHeight = height - remarkLabelHeight;
        
        remarkLabelHeight = height;
        
        
        [self.delegate ZJCustomerTypeView:self ZJViewType:_Viewtype viewHeight:addHeight];

    }
    [view removeFromSuperview];
    
    view = nil;
    
}

@end
