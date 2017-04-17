//
//  ZJBaseViewController.m
//  CRM
//
//  Created by mini on 16/8/23.
//  Copyright © 2016年 武汉至简天成科技有限公司. All rights reserved.
//

#import "ZJBaseViewController.h"

@interface ZJBaseViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong) UIImagePickerController *imagePickerController;


@end

@implementation ZJBaseViewController


//懒加载   照片选择控制器

-(UIImagePickerController *)imagePickerController{
    
    if (!_imagePickerController) {
        
        _imagePickerController = [[UIImagePickerController alloc]init];
    }
    
    return _imagePickerController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//从系统中获取照片
-(void)getPictureFromeSystem{
    
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof (self)WeakSelf = self;

    UIAlertAction *picture = [UIAlertAction actionWithTitle:@"从照片获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        WeakSelf.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        WeakSelf.imagePickerController.delegate = self;
        
        WeakSelf.imagePickerController.allowsEditing = YES;
        
        [WeakSelf presentViewController:self.imagePickerController animated:YES completion:nil];
        
    }];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"从摄像头获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            [WeakSelf.imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            
            WeakSelf.imagePickerController.delegate = WeakSelf;
            
            WeakSelf.imagePickerController.allowsEditing = YES;
            
            [WeakSelf presentViewController:self.imagePickerController animated:YES completion:nil];
            
        }
        
    }];
    
    UIAlertAction *cancal = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertC addAction:picture];
    
    [alertC addAction:camera];
    
    [alertC addAction:cancal];
    
    [self presentViewController:alertC animated:YES completion:nil];
    

}


//封装弹框  自动
-(void)autorAlertViewWithMsg:(NSString *)title{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}


//手动
-(void)alertViewWithTitle:(NSString *)title  message:(NSString *)msg{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *down = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:down];
    
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


-(void)getPictureForIcon{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *picture = [UIAlertAction actionWithTitle:@"从照片获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        self.imagePickerController.delegate = self;
        
        self.imagePickerController.allowsEditing = YES;
        
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
        
    }];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"从摄像头获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            
            self.imagePickerController.delegate = self;
            
            self.imagePickerController.allowsEditing = YES;
            
            [self presentViewController:self.imagePickerController animated:YES completion:nil];
        }
        
    }];
    
    UIAlertAction *cancal = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertC addAction:picture];
    
    [alertC addAction:camera];
    
    [alertC addAction:cancal];
    
    [self presentViewController:alertC animated:YES completion:nil];

    
}

/**
 *  获取照片代理方法
 */

//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    
//    UIImage *image = info[UIImagePickerControllerEditedImage];
//    
//    self.iconImage = image;
//    
//}



@end
