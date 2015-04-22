//
//  BaseViewController.m
//  妈妈问
//
//  Created by lixuan on 15/3/3.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "BaseViewController.h"
#import "RootTabbarController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"背景.jpg"]];
    UIImageView *imgV= [[UIImageView alloc] initWithFrame:self.view.bounds];
    imgV.image = [UIImage imageNamed:@"背景.jpg"];
    [self.view addSubview:imgV];
    [self setLeftNavigationItemWithTitle:nil isImage:NO];
}

- (void)setRightNavigationItemWithTitle:(NSString *)rightTitle isImage:(BOOL)isImage {
    if (isImage) {
        UIImage *image = [UIImage imageNamed:rightTitle];
        UIImage *img   = [self OriginImage:image scaleToSize:CGSizeMake(image.size.width / 2, image.size.height / 2)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemclick)];
        return;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:rightTitle style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemclick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
}
- (void)setLeftNavigationItemWithTitle:(NSString *)leftTitle isImage:(BOOL)isImage {
    if (nil == leftTitle && NO == isImage) {
        UIImage *image = [UIImage imageNamed:@"backBtn"];
        UIImage *img   = [self OriginImage:image scaleToSize:CGSizeMake(image.size.width / 2, image.size.height / 2)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
        return;
    }
    
    if (isImage) {
        UIImage *image = [UIImage imageNamed:leftTitle];
        UIImage *img   = [self OriginImage:image scaleToSize:CGSizeMake(image.size.width / 2, image.size.height / 2)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
        return;
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:leftTitle style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
      [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
}
- (void)rightBarButtonItemclick {

}
- (void)leftBarButtonItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)hiddenTabbar:(BOOL)hidden {
    [(RootTabbarController *)self.tabBarController hiddenMyTabbar:hidden];
}
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
//- (void)viewWillAppear:(BOOL)animated {
//    [self hiddenTabbar:NO];
//}
//- (void)viewWillDisappear:(BOOL)animated {
//    [self hiddenTabbar:YES];
//}
@end
