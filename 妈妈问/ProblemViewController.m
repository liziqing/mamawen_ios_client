//
//  ProblemViewController.m
//  妈妈问
//
//  Created by lixuan on 15/3/4.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "ProblemViewController.h"
#import "HHTextView.h"
#import "ChatViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface ProblemViewController () <UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    HHTextView *_textView;
    UITextView    *_desclable;
    UIImageView *_audioPic;
    
    UILabel *_userInfoLable; // 顶部患者信息
    UIView  *_bottomView;    // 底部按钮背景
    
    CGRect _rect;
    
    UIView *_pictureBackView; // 显示图片背景
    NSMutableArray  *_picArr; // 单据图片数组
    NSMutableArray   *_picURLArr; // 单据图片urlStr数组
    NSMutableArray  *_picURL;
    NSString        *_drug;   // 添加用药
    UILabel         *_drugLable;
    
    UILabel *_picNotLable;
    UILabel *_drugNotLable;
    
    UIButton *_audioButton;
}
@end

@implementation ProblemViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightNavigationItemWithTitle:@"提交" isImage:NO];
    
    _picArr = [NSMutableArray array];
    _picURLArr = [NSMutableArray array];
    _picURL    = [NSMutableArray array];
    [self uiConfig];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

// ui设置
- (void)uiConfig {
//    _userInfoLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
//    _userInfoLable.textAlignment = NSTextAlignmentCenter;
//    _userInfoLable.font = [UIFont systemFontOfSize:16];
//    _userInfoLable.text = [NSString stringWithFormat:@"%@ %@ %@ %@",_model.name,_model.sex,_model.age,_model.category];
//    _userInfoLable.backgroundColor = [UIColor clearColor];
//    _userInfoLable.textColor = [UIColor whiteColor];
//    [self.view addSubview:_userInfoLable];
    
    _desclable = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, kScreenWidth - 40, kScreenHeight / 4)];
    _desclable.textColor = [UIColor whiteColor];
    _desclable.editable = NO;
    _desclable.font = [UIFont systemFontOfSize:16];
    _desclable.delegate = self;
    _desclable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_desclable];
    
    _audioPic = [[UIImageView alloc] initWithFrame:CGRectMake(40, 20, kScreenWidth / 3, 30)];
    _audioPic.backgroundColor = [UIColor lightGrayColor];
    _audioPic.hidden = YES;
    [self.view addSubview:_audioPic];
    
//    _textView = [[HHTextView alloc] initWithFrame:CGRectMake(20, 20, kScreenWidth - 40, kScreenHeight / 4)];
//    _textView.placeHolder = @"    宝宝哪里不舒服？有什么症状吗？吃了什么药？吃了多久？";
//    _textView.delegate = self;
//    _textView.backgroundColor = [UIColor clearColor];
//    _textView.textColor = [UIColor whiteColor];
//    
//    [self.view addSubview:_textView];
    
//    UIView *lineV1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(_textView.frame), kScreenWidth, 1)];
//    lineV1.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:lineV1];
//    
//    UIView *lineV2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_textView.frame), kScreenWidth, 1)];
//    lineV2.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:lineV2];
    
    _pictureBackView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_desclable.frame) + 15, kScreenWidth, 80)];
    _pictureBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_pictureBackView];
    
    _picNotLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_desclable.frame) + 1, kScreenWidth, 15)];
    _picNotLable.text = @"单据资料:";
    _picNotLable.backgroundColor = [UIColor whiteColor];
    _picNotLable.alpha = 0.2;
    _picNotLable.hidden = YES;
    [self.view addSubview:_picNotLable];
    
    _drugNotLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pictureBackView.frame) , kScreenWidth, 15)];
    _drugNotLable.text = @"用药情况:";
    _drugNotLable.backgroundColor = [UIColor whiteColor];
    _drugNotLable.alpha = 0.2;
    _drugNotLable.hidden = YES;
    [self.view addSubview:_drugNotLable];
    
    _drugLable = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_pictureBackView.frame) + 15, kScreenWidth - 40, 30)];
    _drugLable.numberOfLines = 2;
    _drugLable.font = [UIFont systemFontOfSize:14];
    _drugLable.textColor = [UIColor whiteColor];
    _drugLable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_drugLable];
    
    
   
    
    [self createBottomView];
    
}

// 底部tap
- (void)createBottomView {
    
    
//    NSArray *arr = @[@"拍摄单据",@"添加用药"];
//    CGFloat W = kScreenWidth / 2 - 0.5;
//    for (int i = 0; i < arr.count; i ++) {
//        UIImageView *backImgV = [[UIImageView alloc] initWithFrame:CGRectMake((W+1) * i, 0, W, CGRectGetHeight(_bottomView.frame))];
//        backImgV.backgroundColor = [UIColor colorWithRed:0.92 green:0.64 blue:0.73 alpha:1];
//        backImgV.userInteractionEnabled = YES;
//        backImgV.tag = 100 + i;
//        [backImgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgvTaped:)]];
//        [_bottomView addSubview:backImgV];
//        
//        
//        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, W / 2,CGRectGetHeight(backImgV.frame) / 2)];
//        lable.center = CGPointMake(backImgV.frame.size.width / 2, backImgV.frame.size.height / 2);
////        lable.backgroundColor = [UIColor redColor];
//        lable.text = arr[i];
//        lable.font = [UIFont systemFontOfSize:18];
//        lable.textColor = [UIColor whiteColor];
//        [backImgV addSubview:lable];
//        
//        CGFloat lableH = CGRectGetHeight(lable.frame);
//        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(lable.frame) - lableH * 1.5, CGRectGetMinY(lable.frame), lableH, lableH)];
//        imgV.backgroundColor = [UIColor whiteColor];
//        imgV.layer.cornerRadius = lableH / 2;
//        imgV.layer.masksToBounds = YES;
//        [backImgV addSubview:imgV];
//    }
    NSArray *arr = @[@"7_09",@"7_11"];
    CGFloat w = kScreenWidth / 5;
    for (int i = 0; i < arr.count; i++) {
        UIImageView *tapV = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x - w * 5 / 4  + (w * 3 / 2)*i, CGRectGetMaxY(_drugLable.frame) + 25, w, w)];
        tapV.layer.cornerRadius = w / 2;
        tapV.layer.masksToBounds = YES;
        tapV.userInteractionEnabled = YES;
//        tapV.layer.borderColor = [UIColor whiteColor].CGColor;
//        tapV.layer.borderWidth = 1;
        tapV.tag = 100 + i;
        tapV.image = [UIImage imageNamed:arr[i]];
        [tapV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgvTaped:)]];
        [self.view addSubview:tapV];
    }
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 60 - kNavigationBarMaxY, kScreenWidth, 60)];
    _bottomView.backgroundColor = [UIColor colorWithRed:0.91 green:0.7 blue:0.74 alpha:1];
    [self.view addSubview:_bottomView];
    _rect = _bottomView.frame;
    
    _textView = [[HHTextView alloc] initWithFrame:CGRectMake(15, 10, _bottomView.frame.size.width * 2 / 3, _bottomView.frame.size.height * 2 / 3)];
        _textView.placeHolder = @"    输入问题";
        _textView.delegate = self;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.textColor = [UIColor lightGrayColor];
    _textView.layer.cornerRadius = 5;
    _textView.layer.masksToBounds = YES;
    [_bottomView addSubview:_textView];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_textView.frame) + 20, CGRectGetMinY(_textView.frame), 1, CGRectGetHeight(_textView.frame))];
    lineV.backgroundColor = [UIColor whiteColor];
    [_bottomView addSubview:lineV];
    
    UIButton *sure = [UIButton buttonWithType:UIButtonTypeCustom];
    sure.frame = CGRectMake(CGRectGetMaxX(lineV.frame) + 10, CGRectGetMinY(lineV.frame), _bottomView.frame.size.width - CGRectGetMaxX(lineV.frame) - 20, CGRectGetHeight(lineV.frame));
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [sure addTarget:self action:@selector(sureBtnClick) forControlEvents:64];
    [_bottomView addSubview:sure];
    
    
    _audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _audioButton.frame = CGRectMake(0, kScreenHeight  - kNavigationBarMaxY, kScreenWidth, 60);
    _audioButton.backgroundColor = [UIColor colorWithRed:0.18 green:1 blue:1 alpha:1];
    [_audioButton setTitle:@"按住说话" forState:UIControlStateNormal];
    [_audioButton setTitle:@"松开完成录音" forState:UIControlStateHighlighted];
    [_audioButton addTarget:self action:@selector(recorderBegin) forControlEvents:UIControlEventTouchDown];
    [_audioButton addTarget:self action:@selector(recorderEnd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_audioButton];
}
- (void)sureBtnClick {
    [_textView resignFirstResponder];
    _audioPic.hidden = YES;
    _desclable.hidden = NO;
    _desclable.text = _textView.text;
    _textView.text = nil;
}
- (void)recorderBegin {
    NSLog(@"recore");
}

- (void)recorderEnd {
    NSLog(@"record end");

}
- (void)showRecordButton {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = _audioButton.frame;
        if (rect.origin.y < kScreenHeight - kNavigationBarMaxY - 10) {
            return ;
        }
        _bottomView.hidden = YES;
        rect.origin.y -= 60;
        _audioButton.frame = rect;
    }];


}
// 底部tap点击事件
- (void)imgvTaped:(UIGestureRecognizer *)ges {
    NSInteger index = ges.view.tag - 100;
    
     UIActionSheet *actionSheet;
     UIAlertView   *alert;
    
    switch (index) {
//            case 0: // 语音
//            _desclable.hidden = YES;
//            
//            [self showRecordButton];
            
            // 录音完成显示audioPic
            
//            break;
        case 0:   // 拍摄单据
            _picNotLable.hidden = NO;
            if (_picArr.count >= 4) {
                [ShowAlertView showAlertViewWithTitle:@"Tips:" message:@"您一次最多只能添加4张图面资料！" leftbtn:@"sure" rightBtn:nil];
                return;
            }
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Images", nil];
            [actionSheet showInView:self.view.window];
            break;
        case 1:  // 添加用药
            _drugNotLable.hidden = NO;
            alert = [[UIAlertView alloc] initWithTitle:@"添加用药:多个药物间请用空格隔开" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert show];
            break;
        default:
            break;
    }
}

#pragma  mark -
#pragma  mark alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (1 == buttonIndex) {
        _drug = [alertView textFieldAtIndex:0].text;
        _drugLable.text = _drug;
    }
}

#pragma  mark -
#pragma  mark ActionSheet delegate  && 相机 && 图库
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self addCamera];
    } else if (buttonIndex == 1) {
        [self openPicLibrary];
    }
    
}
- (void)addCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Your device don't have camera" delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil];
        [alert show];
    }
}
- (void)openPicLibrary {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *editImage = info[UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:^{
     // 选中图片
        [_picArr addObject:editImage];
//        ALAssetsLibraryWriteImageCompletionBlock completeBlock = ^(NSURL *assetURL, NSError *error){
//            if (!error) {
//                NSLog(@"%@",assetURL);
//            }
//        };
//        
//        if (editImage) {
//            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//            [library writeImageToSavedPhotosAlbum:[editImage CGImage]
//                                      orientation:(ALAssetOrientation)[editImage imageOrientation]
//                                  completionBlock:completeBlock];
//        }
        NSDateFormatter *dfm = [[NSDateFormatter alloc] init];
        [dfm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingFormat:@"%@imageSave.png",[dfm stringFromDate:[NSDate date] ]];
        NSData *data = [NSData data];
        data = UIImageJPEGRepresentation(editImage, 1);
        if ([data writeToFile:path atomically:YES]) {
            [_picURLArr addObject:path];
        }
        [self refreshPicView];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 选中图片后更新到页面
- (void)refreshPicView {
    for (id obj in _pictureBackView.subviews) {
        [obj removeFromSuperview];
    }
    CGFloat imgW = 60;
    for (int i = 0; i < _picArr.count; i++) {
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(imgW / 2 + (imgW + 10) * i, 10, imgW, imgW)];
        imgV.image = _picArr[i];
        imgV.layer.cornerRadius = 5;
        imgV.layer.masksToBounds = YES;
        [_pictureBackView addSubview:imgV];
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    _audioPic.hidden = YES;
    _desclable.hidden = NO;
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
    }
    return YES;
}
#pragma mark -
#pragma mark 键盘高度变化
- (void)keyboardFrameChange:(NSNotification *)note {
    CGRect rect = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self changeBottomViewFrame:CGRectMake(0, CGRectGetMinY(rect) - _rect.size.height * 2.2 + 10, CGRectGetWidth(_rect), CGRectGetHeight(_rect))];
}


// 改变bottomViewframe
- (void)changeBottomViewFrame:(CGRect)rect {
    [UIView animateWithDuration:0.2 animations:^{
        _bottomView.frame = rect;
    }];
}


// 提交
- (void)rightBarButtonItemclick {
    if (_desclable.text.length < 6) {
        [ShowAlertView showAlertViewWithTitle:@"Tips:" message:@"您输入的信息过少，请详细描述xxx" leftbtn:@"好的" rightBtn:nil];
        return;
    }
    
    // 发送数据到http服务器  并跳转下一级页面
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer  = [AFJSONResponseSerializer serializer];
    manager.requestSerializer   = [AFJSONRequestSerializer  serializer];
   
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@[@"胃痛",@"腹泻"] forKey:@"keyWords"];
    [dic setObject:_model.category forKey:@"department"];
    [dic setObject:_desclable.text forKey:@"textContent"];
    [dic setObject:(_drug == nil)?@"":_drug forKey:@"drug"];
    if (_isFindDr) [dic setObject:[NSString stringWithFormat:@"exp_%@",_doctorID] forKey:@"questionTo"];
    NSLog(@"%@",_doctorID);
    
    if (_picURLArr.count != 0) {
        for (NSString *path in _picURLArr) {
            [_picURL addObject:[NSURL fileURLWithPath:path]];
        }
    }
    
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.userInteractionEnabled = NO;
    view.backgroundColor = [UIColor lightGrayColor];
    view.alpha = 0.7;
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    lable.center = view.center;
    lable.font = [UIFont systemFontOfSize:18];
    lable.textColor = [UIColor blackColor];
    lable.text = @"玩命上传中，请稍等...";
    lable.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lable];
    [self.view addSubview:view];
    
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:kUserID];
    
    // 上传数据
    
        [manager            POST:
                                   [kBaseURL stringByAppendingString:[NSString stringWithFormat:@"/inquiry/post?uid=%@&sessionkey=1",uid]]
                      parameters: nil
        constructingBodyWithBlock:
                                   ^(id<AFMultipartFormData> formData) {
                                       if (_picURL.count != 0) {
                                           for (int i = 0; i < _picURL.count; i++) {
                                               [formData appendPartWithFileURL:_picURL[i] name:[NSString stringWithFormat:@"photo_%d",i + 1] error:nil];
                                           }
                                       }
//                                   [formData appendPartWithFileURL:url name:@"photo_1" error:nil];
                                       [formData appendPartWithFormData:[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil] name:@"inquiry"];NSLog(@"%@",dic);
                                    }
                         success:
                                  ^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSLog(@"%@",responseObject);
                                      [view removeFromSuperview];
                                      
                                      NSInteger inquiryID = [[(NSDictionary *)responseObject objectForKey:@"inquiryID"] integerValue];
//                                      NSLog(@"inquiryID:%@",inquiryID);
                                      
                                      // 跳转
                                     
                                      ChatViewController *chatVC = [[ChatViewController alloc] init];
                                      if (_doctorID) {
                                          chatVC.doctorID = _doctorID.integerValue;
                                      }
                                      chatVC.inquiryID   = inquiryID;
                                      chatVC.firstStr = _desclable.text;
                                      if (_picURL.count > 0) {
                                          chatVC.isHasPic = YES;
                                          chatVC.picArr   = _picArr;
                                      }  else chatVC.isHasPic = NO;
                                      [self.navigationController pushViewController:chatVC animated:YES];
                                    }
                         failure:
                                ^(AFHTTPRequestOperation *operation, NSError *error) {
                                    
                                    [view removeFromSuperview];
                                    
                                    NSLog(@"%@",error.description);
                                    [ShowAlertView showAlertViewWithTitle:@"Tips:" message:@"发送失败，请检查网络" leftbtn:@"back" rightBtn:@"yes"];
    }];
    }


#pragma mark -
#pragma mark 隐藏tabbar
- (void)viewWillAppear:(BOOL)animated {
//    [_textView becomeFirstResponder];
    [self hiddenTabbar:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self hiddenTabbar:NO];
}

@end
