//
//  BecomeVIPVC.m
//  妈妈问
//
//  Created by kin on 15/4/21.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "BecomeVIPVC.h"

@interface BecomeVIPVC ()

@end

@implementation BecomeVIPVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [self hiddenTabbar:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self hiddenTabbar:NO];
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
