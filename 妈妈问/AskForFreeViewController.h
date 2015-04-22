//
//  AskForFreeViewController.h
//  妈妈问
//
//  Created by lixuan on 15/3/4.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "BaseViewController.h"

@interface AskForFreeViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, assign) BOOL isFindDr;
@property (nonatomic, copy)   NSString *doctorID;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;




@end
