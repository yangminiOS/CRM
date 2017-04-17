//
//  ZJRecodeView.m
//  CRM
//
//  Created by mini on 16/9/23.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJRecodeView.h"
#import <Masonry.h>
#import <AVFoundation/AVFoundation.h>
#import "ZJDirectorie.h"
#import "ZJSaveTool.h"
#import "ZJRecodeAndPlayer.h"
@interface ZJRecodeView ()<UITextViewDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate>

{
    RecodeButtonState buttonState;//

    UIView * _colorView;//间隔View
    UILabel *_titleLabel;//记录更多信息
    UIButton *_changeButton;//右边Button
    UIView *_contentView;//资料录音视图
    UIImageView *_AnimatImageView;//播放动画视图
    UIButton *_promptButton;//点击录音
    UIButton *_recodeButton;//录音Button
    UILabel *_detailTextLabel;//描述文字
    UIView *_downView;//放buttond的view
    UIButton *_cancelButton;//取消按钮
    UIButton *_DoneButton;//确定按钮
    AVAudioRecorder *_recorder;
    AVAudioPlayer *_player;
    NSString *_recodePath;//当前录音的路径
    NSString *_recodeName;
    NSInteger recodeButtonCount;//记录录音的次数
    CGFloat remainLabelHeight;//记录信息的高度
    CGFloat preRemainTextHeight;//上一次文字的高度
    CGFloat contentViewHeight;//资料录音视图高
    BOOL _isError;//判断扬声器是否已坏
    BOOL _isRecode;//判断是否录音
    BOOL _isEdit;//判断是否开始编辑
    NSInteger timeSecond;//时间
    NSInteger totilSecond;//
    UIButton *_tempButton;
    UIView *_HView;//水平分割线
    UIView *_Vview;//垂直分割线
    UIView *_line;//
    BOOL _isClick;//判断点击按钮
}
//**录音路径数组**//
@property(nonatomic,strong) NSMutableArray *recodeAllPathArray;
//**录音Button数组**//
@property(nonatomic,strong) NSMutableArray *buttonsArray;
//**录音的删除按钮**//
@property(nonatomic,strong) NSMutableArray *delectsBtttonArray;
//**TextView**//
@property(nonatomic,strong)UITextView *textView;

//动画数组

@property(nonatomic,strong) NSMutableArray *moveRecode;


@end

static  NSString *Title = @"在此记录一下客户情况吧：\n年龄、已婚还是未婚？\n上班还是做生意？\n有无公积金或人寿保险？\n是否有房，全款还是按揭？\n是否有车，全款还是按揭？";

@implementation ZJRecodeView

//textView
-(UITextView *)textView{
    
    if (!_textView) {
        
        //textView
        _textView = [[UITextView alloc]init];
        self.tempTextView = _textView;
        _textView.delegate = self;
        if (self.textViewText.length>0) {
            _textView.text = self.textViewText;
        }else{
             _textView.text = Title;
        }
       
        _textView.textColor = ZJRGBColor(180, 180, 180, 1.0);
        _textView.font = [UIFont systemFontOfSize:ZJTextSize45PX];
        
        _textView.height =  self.height - _titleLabel.height;
        
    }
    return _textView;
}
//录音文件数组
-(NSMutableArray *)recodeAllPathArray{
    if (!_recodeAllPathArray) {
        
        _recodeAllPathArray = [NSMutableArray array];
    }
    return _recodeAllPathArray;
}
//录音Button
-(NSMutableArray *)buttonsArray{
    if (!_buttonsArray) {
        
        _buttonsArray = [NSMutableArray array];
        
    }
    return _buttonsArray;
}
//**录音的删除按钮**//
-(NSMutableArray *)delectsBtttonArray{
    if (!_delectsBtttonArray) {
        _delectsBtttonArray = [NSMutableArray array];
    }
    return _delectsBtttonArray;
}
-(instancetype)init{
    
    if (self = [super init ]) {
        
        [self setupUI];


    }
    return self;
}

//设置UI
-(void)setupUI{
    //录音动态图片
    NSArray *recodeImgs = @[@"recode1",@"recode2",@"recode3",@"recode4",@"recode5"];
    _moveRecode = [NSMutableArray array];
    
    for (NSInteger i = 0; i<recodeImgs.count; i++) {
        
        UIImage *img = [UIImage imageNamed:recodeImgs[i]];
        
        [_moveRecode addObject:img];
    }
    
    self.recodeArray = [NSMutableArray array];

    recodeButtonCount = 0;
    contentViewHeight = PX2PT(1);
    self.backgroundColor = ZJColorFFFFFF;
    buttonState = RecodeStarState;

    

    _colorView = [[UIView alloc]init];
    _colorView.backgroundColor = ZJBackGroundColor;
    [self addSubview:_colorView];
    
    //分割线
    _line = [[UIView alloc]init];
    
    [self addSubview:_line];
    _line.backgroundColor = ZJColorDCDCDC;
    //记录更多信息
    _titleLabel = [[UILabel alloc]init];
    [_titleLabel zj_labelText:@"记录更多信息" textColor:ZJColor505050 textSize:ZJTextSize45PX];
    [_colorView addSubview:_titleLabel];
    //改变输入信息Button
    _changeButton = [[UIButton alloc]init];
    [_changeButton setImage:[UIImage imageNamed:@"Voice"] forState:UIControlStateNormal];
    [_changeButton setImage:[UIImage imageNamed:@"text-input"] forState:UIControlStateSelected];
    [_colorView addSubview:_changeButton];
    [_changeButton addTarget:self action:@selector(clickChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    //contentView
    _contentView = [[UIView alloc]init];
    [self addSubview:_contentView];

    //
    _AnimatImageView = [[UIImageView alloc]init];
    [self addSubview:_AnimatImageView];
    //
    //点击录音Button
    _promptButton = [[UIButton alloc]init];
    [self addSubview:_promptButton];
    [_promptButton setTitle:@"点击录音" forState:UIControlStateNormal];
    [_promptButton setTitleColor:ZJColor00D3A3 forState:UIControlStateNormal];
    _promptButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    _promptButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //录音按钮
    _recodeButton = [[UIButton alloc]init];
    [self addSubview:_recodeButton];
    [_recodeButton setBackgroundImage:[UIImage imageNamed:@"record_voice"] forState:UIControlStateNormal];
    [_recodeButton setBackgroundImage:[UIImage imageNamed:@"record--After-clicking"] forState:UIControlStateHighlighted];
    [_recodeButton addTarget:self action:@selector(clickRecodeButton:) forControlEvents:UIControlEventTouchUpInside];
    //详细描述
    

    _detailTextLabel = [[UILabel alloc]init];
    [self addSubview:_detailTextLabel];
    [_detailTextLabel zj_labelText:Title textColor:ZJRGBColor(180, 180, 180, 1.0) textSize:ZJTextSize45PX];
    _detailTextLabel.textAlignment = NSTextAlignmentCenter;
    _detailTextLabel.numberOfLines = 0;
    
    //底部view
    UIView *downView = [[UIView alloc]init];
    [self addSubview:downView];
    downView.backgroundColor = ZJColorFFFFFF;
    _downView = downView;
    //取消按钮
    _cancelButton = [[UIButton alloc]init];
    [downView addSubview:_cancelButton];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:ZJColor00D3A3 forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    //确定按钮
    _DoneButton = [[UIButton alloc]init];
    [downView addSubview:_DoneButton];
    [_DoneButton setTitle:@"保存" forState:UIControlStateNormal];
    [_DoneButton setTitleColor:ZJColor00D3A3 forState:UIControlStateNormal];
    [_DoneButton addTarget:self action:@selector(clickDoneButton) forControlEvents:UIControlEventTouchUpInside];
    
    //水平分割线
    _HView = [[UIView alloc]init];
    _HView.backgroundColor = ZJColorDCDCDC;
    [downView addSubview:_HView];
    //垂直分割线
    _Vview = [[UIView alloc]init];
    _Vview.backgroundColor = ZJColorDCDCDC;
    [downView addSubview:_Vview];

    [self addSubview:self.textView];
    
    //
    downView.hidden = YES;
    
}
#pragma mark---------布局
-(void)layoutSubviews{
    [super layoutSubviews];
    _colorView.frame = CGRectMake(0, 0, self.width, PX2PT(125));
    _line.frame = CGRectMake(0, PX2PT(125), zjScreenWidth, 1);
    //记录更多信息  和Button
    _titleLabel.frame = CGRectMake(ZJmargin40, ZJmargin40, 100, 17);
    
    _changeButton.frame = CGRectMake(self.width - ZJmargin40 - 31, 4, 31, 31);
    //内容
    CGFloat contentViewY = CGRectGetMaxY(_titleLabel.frame)+ZJmargin40;

    _contentView.frame = CGRectMake(0, contentViewY, self.width, contentViewHeight);
    //提示
    CGFloat promptLabelY = CGRectGetMaxY(_contentView.frame)+ZJmargin40;

    _promptButton.frame = CGRectMake((zjScreenWidth - 145)/2.0,promptLabelY , 145, PX2PT(50));
    
    _AnimatImageView.frame = _promptButton.frame;
    //录音按钮
    CGFloat recodeButtonY = CGRectGetMaxY(_promptButton.frame)+ZJmargin40;
    _recodeButton.frame = CGRectMake((zjScreenWidth - PX2PT(320))/2, recodeButtonY, PX2PT(320), PX2PT(320));
    
    //描述
    CGFloat detailTextLabelY = CGRectGetMaxY(_recodeButton.frame)+PX2PT(30);

    _detailTextLabel.frame = CGRectMake(0, detailTextLabelY, zjScreenWidth, PX2PT(360));
    
    //取消和确定
    
    CGFloat downViewY = CGRectGetMaxY(_detailTextLabel.frame);
    _downView.frame = CGRectMake(0, downViewY, self.width, PX2PT(150));
    _cancelButton.frame = CGRectMake(0, PX2PT(2), self.width/2.0-1, PX2PT(148));

    _DoneButton.frame = CGRectMake(self.width/2.0, PX2PT(2), self.width/2.0, PX2PT(148));
    _HView.frame = CGRectMake(0, 0, zjScreenWidth, PX2PT(2));
    
    _Vview.frame = CGRectMake(self.width/2.0, 0, PX2PT(2), PX2PT(150));
    
    if (_textView ) {
        
        _textView .frame = CGRectMake(0, promptLabelY, self.width, self.height - promptLabelY);
 
    }
}

#pragma mark   点击开始录音还是播放 暂停
-(void)clickRecodeButton:(UIButton *)button{
    
    //判断录音的条数
    if (recodeButtonCount ==3){
        
        [self.delegate ZJRecodeView:self warnText:@"最多可以录制三条语音"];
        return;
    }
    
    if (buttonState == RecodeStarState) {
        buttonState =RecodeRecodeingState;
        
        //配置文件
        _recorder = [ZJRecodeAndPlayer disposeRecoder:^(NSString *error) {
            
            [self.delegate ZJRecodeView:self warnText:error];
            return ;
       }];
        _recorder.delegate = self;
        
        //设置录音状态时button的图片和开启动画  计时器
        [_promptButton setTitle:nil forState:UIControlStateNormal];

        [self starRecodeOrPlayType];
        
        //开始录音
        _isRecode = YES;
        
        self.Recording = YES;
        
    }else if (buttonState == RecodeRecodeingState){
        buttonState =RecodeListenState;
        //底部视图出现
        _downView.hidden = NO;
 
        if (_recorder.recording) {//停止录音
            
            [_recorder stop];
            totilSecond = timeSecond;

        }else{
            
            [_player stop];
            
            [self stopRecodeOrPlayRestoryType];
        }
        
    }else{
        
        buttonState =RecodeRecodeingState;
        
        [self starRecodeOrPlayType];
        
        _recodePath= [ZJRecodeAndPlayer tempRecodePath];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSURL alloc]initFileURLWithPath:_recodePath isDirectory:YES] error:nil];
        _player.delegate = self;
        [_player play];
        self.Recording = YES;
        
    }
    
}
#pragma mark---------改变录入信息button
-(void)clickChangeButton:(UIButton *)button{
    
    //判断是否在录音  如果录音必须先停止
    if (_recorder.recording) {
        
        [self.delegate ZJRecodeView:self warnText:@"请结束录音"];
        return;
    }
    
    //判断是否在播放  如果播放会停止  改变button状态
    
    
    if (_player.isPlaying) {
        
        [_player stop];
        
        [self stopRecodeOrPlayRestoryType];
        
    }
    
    button.selected = !button.selected;
    
    if (button.selected) {
        
        [_textView removeFromSuperview];
        _textView = nil;
        
    }else{
   
        _isEdit = NO;
        [self addSubview:self.textView];
        
//        _downView.hidden = YES;

    }
    
}

#pragma mark   初始化录音按钮的状态
-(void)stopRecodeRestoryType{
    //还原图片
    buttonState = RecodeStarState;
    [_recodeButton setBackgroundImage:[UIImage imageNamed:@"record_voice"] forState:UIControlStateNormal];
    [_recodeButton setBackgroundImage:[UIImage imageNamed:@"record--After-clicking"] forState:UIControlStateHighlighted];
    
    [_promptButton setBackgroundImage:nil forState:UIControlStateNormal];
    [_promptButton setTitle:@"点击录音" forState:UIControlStateNormal];
}

#pragma mark-        停止播放时 停止录音 还原到暂停和停止动画和计时器
-(void)stopRecodeOrPlayRestoryType{
    
    buttonState =RecodeListenState;
    
    [_recodeButton setBackgroundImage:[UIImage imageNamed:@"audition"] forState:UIControlStateNormal];
    
    [_recodeButton setBackgroundImage:[UIImage imageNamed:@"audition--After-clicking"] forState:UIControlStateHighlighted];
    
    [self removeTimerAndStopAnimating];
}


#pragma mark    开启录音或者试听时状态

-(void)starRecodeOrPlayType{
    
    [_promptButton setTitle:@"00:00" forState:UIControlStateNormal];

    [_recodeButton setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    [_recodeButton setBackgroundImage:[UIImage imageNamed:@"stop--After-clicking"] forState:UIControlStateHighlighted];
    
    [self addTimerAndStarAnimating];
    
}

#pragma mark   //点击取消按钮
-(void)clickCancelButton{
    
    if ([_player isPlaying]) {
        
        [_player stop];
        [self removeTimerAndStopAnimating];

        
    }
    //隐藏底部Button
    _downView.hidden = YES;
    
    //删除录音
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:_recodePath error:nil];
    [self.recodeArray removeObject:_recodeName];
    
    [self stopRecodeRestoryType];
    self.Recording = NO;
}

#pragma mark   //点击保存按钮
-(void)clickDoneButton{

    //判断是否在播放   如果在播放就先结束播放  测试
    if ([_player isPlaying]) {
        
        [_player stop];
        
        [self removeTimerAndStopAnimating];
    }
        //隐藏底部Button
        _downView.hidden = YES;
        
        recodeButtonCount++;
        //还原button 信息
        [self stopRecodeRestoryType];

        //添加播放按钮
        [self addPlayRecodeButton];
    
        [self layoutButtons];
        
        [self.delegate ZJRecodeView:self addHeight:PX2PT(118)];
        _isRecode = NO;
        //录音地址
        [self.recodeAllPathArray addObject:_recodePath];
        _recorder = nil;
    //}
    self.Recording = NO;
}

#pragma mark   //录音后添加Button
-(void)addPlayRecodeButton{
    UIButton *button = [[UIButton alloc]init];
    button.width = 3*ZJmargin40 +31+(zjScreenWidth - 6*ZJmargin40 - 61)*totilSecond/180;
    //边框
    [button.layer setMasksToBounds:YES];
    [button.layer setBorderWidth:1.0];
    button.layer.cornerRadius = 4.0;
    button.clipsToBounds = YES;
    button.layer.borderColor = ZJColor505050.CGColor;
    
    button.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, ZJmargin40, 0, 0);

    button.contentEdgeInsets = UIEdgeInsetsMake(0, ZJmargin40, 0,0);
    [button setTitleColor:ZJColorDCDCDC forState:UIControlStateNormal];
    button.tag  = recodeButtonCount;
    
    [button setImage:[UIImage imageNamed:@"trumpet"] forState:UIControlStateNormal];
    [button setTitle:[NSString stringWithFormat:@"%zd\"",totilSecond] forState:UIControlStateNormal];
    
    [_contentView addSubview:button];

    [button addTarget:self action:@selector(playRecode:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *deleteButton = [[UIButton alloc]init];
    deleteButton.tag = recodeButtonCount+10;
    [_contentView addSubview:deleteButton];
    [deleteButton setImage:[UIImage imageNamed:@"delete-audition--After-clicking"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(clickRecodeDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonsArray addObject:button];
    [self.delectsBtttonArray addObject:deleteButton];
    
    contentViewHeight += PX2PT(118);
    _contentView.height +=contentViewHeight;
}
#pragma mark   //布局Button
-(void)layoutButtons{
    
    for (NSInteger i = 0; i<self.buttonsArray.count; i++) {
        UIButton *button = self.buttonsArray[i];
        button.x = ZJmargin40;
        button.y =ZJmargin40+PX2PT(118)*i;
        button.height = PX2PT(78);
        UIButton *delect = self.delectsBtttonArray[i];
        delect.width = 26+ZJmargin40;
        delect.height = PX2PT(78);
        delect.x = zjScreenWidth - 26 - ZJmargin40;
        delect.centerY = button.centerY;
    }
}
#pragma mark   点击button播放{
-(void)playRecode:(UIButton *)button{
    button.selected  = !button.selected;
    _isClick = YES;
    if (button.selected) {
        _tempButton = button;
        NSInteger index = [self.buttonsArray indexOfObject:button];
        NSString *path = self.recodeAllPathArray[index];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSURL alloc]initFileURLWithPath:path isDirectory:YES] error:nil];
        _player.delegate = self;
        [_player play];
        
    }else{
        
        [_player stop];
        
    }

    
}

#pragma mark   删除录音
-(void)clickRecodeDeleteButton:(UIButton *)button{
    recodeButtonCount --;

    NSInteger index = [self.delectsBtttonArray indexOfObject:button];
    UIButton *recodeButton = self.buttonsArray[index];
    [recodeButton removeFromSuperview];
    [button removeFromSuperview];
    [self.delectsBtttonArray removeObjectAtIndex:index];
    [self.buttonsArray removeObjectAtIndex:index];
    [self.recodeAllPathArray removeObjectAtIndex:index];
    button = nil;
    recodeButton = nil;
    contentViewHeight -=PX2PT(118);
    _contentView.height -=PX2PT(118);
    [self.delegate ZJRecodeView:self addHeight:-PX2PT(118)];
    [self.recodeArray removeObjectAtIndex:index];
    [self layoutButtons];
}

#pragma mark   添加计时器和开启动画
-(void)addTimerAndStarAnimating{
    
    timeSecond = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setTitleForButton) userInfo:nil repeats:YES];
    //开启动画
    
    [_AnimatImageView setAnimationImages:_moveRecode];
    [_AnimatImageView setAnimationRepeatCount:360];
    [_AnimatImageView setAnimationDuration:5*0.1];
    [_AnimatImageView startAnimating];
}

#pragma mark   删除计时器和关闭动画
-(void)removeTimerAndStopAnimating{
    [_timer invalidate];
    _timer = nil;
    //删除动画
    [_AnimatImageView stopAnimating];
}
-(void)setTitleForButton{

    timeSecond++;
    NSString *string = [NSString stringWithFormat:@"%02zd:%02zd",(timeSecond/60)%60,timeSecond%60];
    [_promptButton setTitle:string forState:UIControlStateNormal];

    
}


#pragma mark   AVAudioPlayerDelegate

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    if (_isClick == NO) {
        _tempButton.selected = NO;
        buttonState =RecodeListenState;
        
        [self stopRecodeOrPlayRestoryType];
        
    }
    _isClick = NO;

}



#pragma mark   AVAudioRecorderDelegate
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if (recordDuration>=timeSecond) {
        
        _downView.hidden = NO;
        
    }
    
    [self stopRecodeOrPlayRestoryType];
    totilSecond = timeSecond;
    
    self.Recording = NO;
   
}

//***************************************************************************

-(void)setRecodeText:(NSString *)recodeText{
    
    _recodeText = recodeText;
    if (recodeText.length>0) {
        self.textViewText = recodeText;
        self.textView.text = recodeText;
        
    }
    
    
}

-(void)setRecodeArray:(NSMutableArray *)recodeArray{
    _recodeArray = recodeArray;
    
    recodeButtonCount = recodeArray.count;
    
    for (NSInteger i = 0;  i<self.recodeArray.count; i++) {
        
        NSString *path = [ZJDirectorie getVoicePathWithDirectoryName:self.GUID];
        path = [path stringByAppendingPathComponent:recodeArray[i]];
        
        totilSecond = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSURL alloc]initFileURLWithPath:path isDirectory:YES] error:nil].duration;
        
        [self.recodeAllPathArray addObject:path];
        
        [self addPlayRecodeButton];
    }
    
    if (recodeArray.count>0) {
                
        [self layoutButtons];
        
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    [self.delegate ZJRecodeView:self activeTextView:textView];
    if ([textView.text isEqualToString:Title]) {
    
        textView.text = @"";
    }
    _isEdit = YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString *temp = [textView.text stringByAppendingString:text];

    if (temp.length<=300) {
        
       // self.textViewText = temp;
        
        return YES;
    }
    [self.delegate ZJRecodeView:self warnText:@"您最多可以输入300个字符"];

    return NO;
    
}

//内容发生改变
- (void)textViewDidChange:(UITextView *)textView{
    self.textViewText = textView.text;
}
@end
