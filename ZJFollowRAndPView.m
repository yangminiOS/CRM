//
//  ZJFollowRAndPView.m
//  CRM
//
//  Created by mini on 16/11/3.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//


#import "ZJFollowRAndPView.h"
#import <AVFoundation/AVFoundation.h>

#import "ZJSaveTool.h"

@interface ZJFollowRAndPView ()<AVAudioPlayerDelegate,AVAudioRecorderDelegate>
{
    UIView *_contentView;//白色VIEW
    //显示录音时间Button
    UIButton *_showTimeButton;
    UIButton *_playrecodeButton;//录音Button
    UIButton *_cancelButton;//取消按钮
    UIButton *_DoneButton;//确定按钮
    
    UIImageView *_moveImgV;

    UIButton *_promptButton;//显示时间的Button
    UIButton *_recodeButton;//点击开始录音
    RecodeButtonState buttonState;//
    //**//录音**//
     AVAudioRecorder *_recorder;
    //**//播放**//
     AVAudioPlayer *_player;

    NSInteger _timeSecond;//录音的时间
    NSInteger _totilSecond;//

    NSString *_recodeName;
    NSString *_recodePath;//当前录音的路径

    BOOL _isRecode;//判断是否录音
    BOOL _isError;//判断扬声器是否已坏

    NSMutableArray *_moveRecode;

}
//**底部取消和确定**//
@property(nonatomic,weak) UIView *bottomView;
@end

@implementation ZJFollowRAndPView



-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame: frame]) {
        [self setupUI];
        
    }
    return self;
}

-(void)setupUI{
    
    //录音动态图片
    NSArray *recodeImgs = @[@"recode1",@"recode2",@"recode3",@"recode4",@"recode5"];
    _moveRecode = [NSMutableArray array];
    
    for (NSInteger i = 0; i<recodeImgs.count; i++) {
        
        UIImage *img = [UIImage imageNamed:recodeImgs[i]];
        
        [_moveRecode addObject:img];
    }
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [self addGestureRecognizer:tap];
    //底部白色视图
    self.backgroundColor = ZJRGBColor(220, 220, 220, 0.6 );
    UIView *content= [[UIView alloc]init];
    [self addSubview:content];
    _contentView = content;
    content.backgroundColor = ZJColorFFFFFF;
    content.frame = CGRectMake(0, zjScreenHeight -PX2PT(964), zjScreenWidth, PX2PT(964));
    //分割线
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = ZJColorDCDCDC;
    [content addSubview:line];
    line.frame = CGRectMake(0, 0, zjScreenWidth, 1);
    //设置录音和图片Button
    [self setRecodeAndPhotoButton];
    //
    [self setupPlayButton];
}
-(void)setRecodeAndPhotoButton{
    
    CGFloat buttonW = (zjScreenWidth -1)/2.0;
    CGFloat buttonH = PX2PT(126)-1;
    _recodeButton = [[UIButton alloc]init];
    [_contentView addSubview:_recodeButton];
    [_recodeButton setImage:[UIImage imageNamed:@"follow-record"] forState:UIControlStateNormal];
    _recodeButton.frame = CGRectMake(0, 1, buttonW, buttonH);


    _photoButton = [[UIButton alloc]init];
    [_contentView addSubview:_photoButton];
    [_photoButton setImage:[UIImage imageNamed:@"UN-photo"] forState:UIControlStateNormal];
    [_photoButton setImage:[UIImage imageNamed:@"follow-photo"] forState:UIControlStateHighlighted];
    _photoButton.frame = CGRectMake(buttonW+1, 1, buttonW, buttonH);
    [_photoButton addTarget: self action:@selector(clickChoosePhotoButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //水平分割线
    UIView *Hline = [[UIView alloc]init];
    [_contentView addSubview:Hline];
    Hline.backgroundColor = ZJColorDCDCDC;
    Hline.frame = CGRectMake(0, buttonH, zjScreenWidth, 1);
    //垂直分割线
    UIView *Vline = [[UIView alloc]init];
    [_contentView addSubview:Vline];
    Vline.backgroundColor = ZJColorDCDCDC;
    Vline.frame = CGRectMake(buttonW, 0, 1, PX2PT(126));
}
#pragma mark   时间记录和开始  暂停 播放BUtton
-(void)setupPlayButton{
    
    _moveImgV = [[UIImageView alloc]init];
    [_contentView addSubview:_moveImgV];
    
    UIButton *promptButton = [[UIButton alloc]init];
    [_contentView addSubview:promptButton];
    _promptButton = promptButton;
    [_promptButton setTitleColor:ZJColor00D3A3 forState:UIControlStateNormal];
    [_promptButton setTitle:@"点击录音" forState:UIControlStateNormal];
    _promptButton.titleLabel.font = [UIFont systemFontOfSize:ZJTextSize45PX];
    _promptButton.width = 145;
    _promptButton.height=16;
    _promptButton.y = PX2PT(226);
    _promptButton.centerX = _contentView.centerX;
    
    _moveImgV.frame = _promptButton.frame;

    _recodeButton = [[UIButton alloc]init];
    [_contentView addSubview:_recodeButton];
    [_recodeButton setBackgroundImage:[UIImage imageNamed:@"record_voice"] forState:UIControlStateNormal];
    [_recodeButton setBackgroundImage:[UIImage imageNamed:@"record--After-clicking"] forState:UIControlStateHighlighted];
    [_recodeButton addTarget:self action:@selector(clickRecodeButton:) forControlEvents:UIControlEventTouchUpInside];
    _recodeButton.width = PX2PT(320);
    _recodeButton.height = PX2PT(320);
    _recodeButton.centerX = _contentView.centerX;
    _recodeButton.y = PX2PT(296)+16;
    //底部取消和确定
    CGFloat buttonW = (zjScreenWidth -1)/2.0;
    CGFloat buttonH = PX2PT(126)-1;
    UIView *bottomView = [[UIView alloc]init];
    self.bottomView = bottomView;
    [_contentView addSubview:bottomView];
    bottomView.backgroundColor = ZJColorDCDCDC;
    bottomView.x = 0;
    bottomView.y = _contentView.height - PX2PT(126);
    bottomView.width = zjScreenWidth;
    bottomView.height = PX2PT(126);
    
    _cancelButton = [[UIButton alloc]init];
    _cancelButton.backgroundColor = ZJColorFFFFFF;
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:ZJColor00D3A3 forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton.frame = CGRectMake(0, 1, buttonW, buttonH);
    [bottomView addSubview:_cancelButton];
    //确定按钮
    _DoneButton = [[UIButton alloc]init];
    _DoneButton.backgroundColor = ZJColorFFFFFF;
    [_DoneButton setTitle:@"保存" forState:UIControlStateNormal];
    [_DoneButton setTitleColor:ZJColor00D3A3 forState:UIControlStateNormal];
    [_DoneButton addTarget:self action:@selector(clickDoneButton) forControlEvents:UIControlEventTouchUpInside];
    _DoneButton.frame = CGRectMake(buttonW+1, 1, buttonW, buttonH);
    [bottomView addSubview:_DoneButton];
    bottomView.hidden = YES;

}

#pragma mark   点击开始录音按钮
-(void)clickRecodeButton:(UIButton *)button{
    if (buttonState == RecodeStarState) {
        buttonState =RecodeRecodeingState;
        //改变图片
        [button setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"stop--After-clicking"] forState:UIControlStateHighlighted];
        //去掉文字  图片
        //改变图片
        [_moveImgV setAnimationImages:_moveRecode];
        
        [_moveImgV setAnimationRepeatCount:180];
        [_moveImgV setAnimationDuration:5*0.1];
        [_moveImgV startAnimating];
        [_promptButton setTitle:@"00:00" forState:UIControlStateNormal];
//        [_promptButton setBackgroundImage:[UIImage imageNamed:@"frequency"] forState:UIControlStateNormal];
        //添加定时器
        [self addTimer];
        //配置文件
        [self setupRecoder];
        //开始录音
        [_recorder record];
        self.active = YES;
        _bottomView.hidden = YES;

    }else if (buttonState == RecodeRecodeingState){
        buttonState =RecodeListenState;
        if (_recorder.recording == YES) {//录音状态  点击后录音停止
            [_recorder stop];//体质录音的计时器在代理方法中移除
            _totilSecond = _timeSecond;
            [_moveImgV stopAnimating];

            
        }else{//播放状态点击后暂停播放
            [button setBackgroundImage:[UIImage imageNamed:@"audition"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"audition--After-clicking"] forState:UIControlStateHighlighted];
            [_player pause];
            [_moveImgV stopAnimating];

            //移除计时器
            [self removeTimer];
            //底部视图出现
            _bottomView.hidden = NO;
        }

    }else{
        buttonState =RecodeRecodeingState;
        [button setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"stop--After-clicking"] forState:UIControlStateHighlighted];
        //播放录音
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSURL alloc]initFileURLWithPath:_recodePath isDirectory:YES] error:nil];
        _player.delegate = self;
        [_player play];
        //添加计时器
        [self addTimer];
    }

}
#pragma mark   点击图片Button
-(void)clickChoosePhotoButton:(UIButton *)button{
    //播放状态
    if (_player&&_player.isPlaying) {
        [_moveImgV stopAnimating];

        [_player stop];
    }
    
    if (self.active) {
        //录音状态
        [self.delegate ZJFollowRAndPView:self isActive:self.active];
        return;
        
    }
    
    [self.delegate ZJFollowRAndPView:self clickButton:button];
}
#pragma mark   //点击取消按钮
-(void)clickCancelButton{
    
    if ([_moveImgV isAnimating]) {
        [_moveImgV stopAnimating];
        
    }
    //判断是否在播放
    if (_player&&_player.isPlaying) {
        [self removeTimer];

        [_player stop];
    }
    //还原照片 和状态
    buttonState = RecodeStarState;
    [_recodeButton setBackgroundImage:[UIImage imageNamed:@"record_voice"] forState:UIControlStateNormal];
    [_recodeButton setBackgroundImage:[UIImage imageNamed:@"record--After-clicking"] forState:UIControlStateHighlighted];
    [_promptButton setTitle:@"点击录音" forState:UIControlStateNormal];
    [_promptButton setBackgroundImage:nil forState:UIControlStateNormal];

    
    //隐藏底部视图
    _bottomView.hidden = YES;
    //删除文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:_recodePath error:nil];
}
#pragma mark   //点击保存按钮
-(void)clickDoneButton{
    
    if ([_moveImgV isAnimating]) {
        [_moveImgV stopAnimating];
        
    }
    //当前录音的地址  当前录音的名字
    //在录音
    if (self.active) {//在录音
        [self.delegate ZJFollowRAndPView:self isActive:self.active];
        return;
    }else if (_player&&_player.playing){//在播放
        [_player stop];
        [self removeTimer];
        
        buttonState = RecodeStarState;
        [_promptButton setTitle:@"点击录音" forState:UIControlStateNormal];
        
        [self.delegate ZJFollowRAndPView:self recodePath:_recodePath recodeFileName:_recodeName recodeTime:_totilSecond];
    }else{
        
        buttonState = RecodeStarState;
        [_promptButton setTitle:@"点击录音" forState:UIControlStateNormal];

        [self.delegate ZJFollowRAndPView:self recodePath:_recodePath recodeFileName:_recodeName recodeTime:_totilSecond];
    }
}

#pragma mark   添加计时器
-(void)addTimer{
    _timeSecond = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setTitleForButton) userInfo:nil repeats:YES];
}

-(void)setTitleForButton{
    
    _timeSecond++;
    NSString *string = [NSString stringWithFormat:@"%02zd:%02zd",_timeSecond/60,_timeSecond%60];
    [_promptButton setTitle:string forState:UIControlStateNormal];
    
}

#pragma mark   删除计时器
-(void)removeTimer{
    [_timer invalidate];
    _timer = nil;
}
#pragma mark   //配置录音文件
-(void)setupRecoder{
    //开始录音
    NSError *error = nil;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error !=nil) {
        //扬声器已坏
        _isError = YES;
    }else{
        [session setActive:YES error:nil];
        [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    }
    
    NSString*path = NSTemporaryDirectory();
    _recodeName =[NSString stringWithFormat:@"Recode%@.caf",[ZJSaveTool zj_stringWithGUID]];
//    [self.recodeArray addObject:_recodeName];
    _recodePath = [path stringByAppendingPathComponent:_recodeName];
    //配置录音器
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:AVAudioQualityLow],AVEncoderAudioQualityKey,[NSNumber numberWithInt:16],AVEncoderBitRateKey,[NSNumber numberWithInt:2],AVNumberOfChannelsKey,[NSNumber numberWithFloat:44100.0],AVSampleRateKey,nil];
    _recorder = [[AVAudioRecorder alloc]initWithURL:[[NSURL alloc]initFileURLWithPath:_recodePath isDirectory:YES] settings:dic error:nil];
    _recorder.delegate = self;
    [_recorder recordForDuration:recordDuration];
}
//添加手势
-(void)tapView:(UITapGestureRecognizer *)tap{
    
    if (_player.isPlaying) {
        
        [_player stop];
    }
    if (!self.active &&buttonState == RecodeStarState) {
        
        return;
    }
    [self.delegate ZJFollowRAndPView:self isActive:self.active];
}
#pragma mark   AVAudioRecorderDelegate
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    [self removeTimer];
    buttonState =RecodeListenState;

    self.active = NO;
    _bottomView.hidden = NO;
    [_recodeButton setBackgroundImage:[UIImage imageNamed:@"audition"] forState:UIControlStateNormal];
    [_recodeButton setBackgroundImage:[UIImage imageNamed:@"audition--After-clicking"] forState:UIControlStateHighlighted];
    _totilSecond = _timeSecond;
    
    [_moveImgV stopAnimating];



}

#pragma mark   AVAudioPlayerDelegate

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    buttonState =RecodeListenState;
    
    [_recodeButton setBackgroundImage:[UIImage imageNamed:@"audition"] forState:UIControlStateNormal];
    [_recodeButton setBackgroundImage:[UIImage imageNamed:@"audition--After-clicking"] forState:UIControlStateHighlighted];
    
    
    [self removeTimer];
}
@end












