//
//  ChartVC.m
//  mammawenUser
//
//  Created by alex on 15/4/13.
//  Copyright (c) 2015年 alex. All rights reserved.
//

#import "ChartVC.h"
#import "Content.h"
#import "BackView.h"
#import "ChartCell.h"

#import "LineChartView.h"
#import "AFNetworking.h"


#import "EnteringVC.h"

#define kXheihgt 30
#define kx 4

@interface ChartVC ()<UITableViewDataSource,UITableViewDelegate>

{
    //---------------图表----
    UIScrollView *tubiaoScrollVC1;
    UIScrollView *tubiaoScrollVC2;
    UIScrollView *tubiaoScrollVC3;
}

//周的数据
@property(strong,nonatomic)NSMutableArray *xCoordinatePointWeek;
@property(strong,nonatomic)NSArray *yCoordinatePointWeek;
@property(strong,nonatomic)NSMutableArray *ybaobaosg;   //宝宝身高
@property(strong,nonatomic)NSMutableArray *ybaobaotz;    //体重
@property(strong,nonatomic)NSMutableArray *ybaobaotw; //头围

@property(strong,nonatomic)NSMutableArray *bzzValue;


@property(strong,nonatomic)UITableView *chartTableVC;

//----------病例
@property(strong,nonatomic)UIImageView *bingli_VC;
@property(strong,nonatomic)UIImageView *imageBili;
@property(strong,nonatomic)UILabel *biliLable;
@property(strong,nonatomic)UIImageView *minimage;

//-----------图表
@property(strong,nonatomic)LineChartView *lineView1;
@property(strong,nonatomic)LineChartView *lineView2;
@property(strong,nonatomic)LineChartView *lineView3;

//----------图表的背视图
@property(strong,nonatomic)UIImageView *backimageVC1;
@property(strong,nonatomic)UIImageView *backimageVC2;
@property(strong,nonatomic)UIImageView *backimageVC3;

@property(strong,nonatomic)UIView *yzuobiao1;
@property(strong,nonatomic)UIView *yzuobiao2;
@property(strong,nonatomic)UIView *yzuobiao3;

@end

@implementation ChartVC




-(void)viewWillAppear:(BOOL)animated{
   [self networkRequest];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"健康";
//    [self bingli];
    [self dataProcessing];

    [self addGR0:self.bingli_VC];
    
}

#pragma mark-- 杂乱数据
-(void)dataProcessing{
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-198)];
    backview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backview];
    
    self.xCoordinatePointWeek=[NSMutableArray array];
   // self.yCoordinatePointWeek=[NSMutableArray array];
    
    self.bzzValue=[NSMutableArray array];
    
    for(NSInteger i=0;i<36;i++){
        [self.xCoordinatePointWeek addObject:[NSString stringWithFormat:@"%i",i+1]];
        
        [self.bzzValue addObject:@"43"];
        
        
    }
    
    self.yCoordinatePointWeek=@[@"0",@"14",@"28",@"42",@"56",@"70",@"84"];
    
    self.ybaobaosg=[NSMutableArray array];
    self.ybaobaotz=[NSMutableArray array];
    self.ybaobaotw=[NSMutableArray array];
    
  //  self.bzzValue=@[@"80",@"120",@"120",@"160",@"175",@"240",@"30",@"30",@"240",@"30",@"30"];

    self.chartTableVC=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.chartTableVC.dataSource=self;
    self.chartTableVC.delegate=self;
    self.chartTableVC.backgroundColor=[UIColor clearColor];
    self.chartTableVC.showsVerticalScrollIndicator=NO;
    [self.view addSubview:self.chartTableVC];
    
}

#pragma mark----图表
-(void)tubiao{
    //------------------------图表视图-------------
    self.backimageVC1=[[UIImageView alloc]initWithFrame:CGRectMake(10, 80, kScreenWidth-20,60+(self.yCoordinatePointWeek.count-1)*kXheihgt)];
    self.backimageVC1.backgroundColor=[UIColor whiteColor];
    self.backimageVC1.alpha=0.1;
    self.backimageVC1.userInteractionEnabled=YES;
    self.backimageVC1.tag=1;
    
    //--------添加纵坐标
    self.yzuobiao1=[[UIView alloc]initWithFrame:CGRectMake(10, 80, 20,50+(self.yCoordinatePointWeek.count-1)*kXheihgt)];
    self.yzuobiao1.backgroundColor=[UIColor clearColor];
    
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 22)];
    titleLable.text=@"身高";
    titleLable.font=[UIFont systemFontOfSize:13.0f];
    titleLable.textColor=[UIColor whiteColor];
    [self.yzuobiao1 addSubview:titleLable];
    
    NSInteger cishu1=self.yCoordinatePointWeek.count;
//    for(NSInteger i=0;i<self.yCoordinatePointWeek.count;i++){
//        UILabel *ylable=[[UILabel alloc]initWithFrame:CGRectMake(0,22+i*15, 20, 15)];
//        ylable.textColor=[UIColor whiteColor];
//        ylable.text=self.yCoordinatePointWeek[cishu1-1];
//        cishu1--;
//        ylable.font=[UIFont systemFontOfSize:9];
//        [self.yzuobiao1 addSubview:ylable];
//    }
    
    tubiaoScrollVC1 = [[UIScrollView alloc]initWithFrame:CGRectMake(20, 110, kScreenWidth-40, 25+(self.yCoordinatePointWeek.count-1)*kXheihgt)];
    tubiaoScrollVC1.showsHorizontalScrollIndicator=NO;
    tubiaoScrollVC1.bounces=NO;
    tubiaoScrollVC1.backgroundColor=[UIColor clearColor];
    [tubiaoScrollVC1 addSubview:[self chart1]];
    
#pragma mark  ---图表2
    self.backimageVC2=[[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.backimageVC1.frame)+20, kScreenWidth-20,60+(self.yCoordinatePointWeek.count-1)*kXheihgt)];
    self.backimageVC2.backgroundColor=[UIColor whiteColor];
    self.backimageVC2.alpha=0.2;
    self.backimageVC2.userInteractionEnabled=YES;
    self.backimageVC2.tag=2;
    
    //--------添加纵坐标
    self.yzuobiao2=[[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.backimageVC1.frame)+20, 20, (self.yCoordinatePointWeek.count-1)*kXheihgt)];
    self.yzuobiao2.backgroundColor=[UIColor clearColor];
    
    UILabel *titleLable2=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 22)];
    titleLable2.text=@"体重";
    titleLable2.font=[UIFont systemFontOfSize:13.0f];
    titleLable2.textColor=[UIColor whiteColor];
    [self.yzuobiao2 addSubview:titleLable2];
    
    NSInteger cishu2=self.yCoordinatePointWeek.count;
//    for(NSInteger i=0;i<self.yCoordinatePointWeek.count;i++){
//        UILabel *ylable=[[UILabel alloc]initWithFrame:CGRectMake(0, 22+i*15, 20, 15)];
//        ylable.textColor=[UIColor whiteColor];
//        ylable.text=self.yCoordinatePointWeek[cishu2-1];
//        cishu2--;
//        ylable.font=[UIFont systemFontOfSize:9];
//        [self.yzuobiao2 addSubview:ylable];
//    }
    
    tubiaoScrollVC2 = [[UIScrollView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.backimageVC1.frame)+50, kScreenWidth-50,  25+(self.yCoordinatePointWeek.count-1)*kXheihgt)];
    tubiaoScrollVC2.showsHorizontalScrollIndicator=NO;
    tubiaoScrollVC2.bounces=NO;
    tubiaoScrollVC2.backgroundColor=[UIColor clearColor];
    [tubiaoScrollVC2 addSubview:[self chart2]];
    
    self.backimageVC3=[[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.backimageVC2.frame)+20, kScreenWidth-20, 60+(self.yCoordinatePointWeek.count-1)*kXheihgt)];
    self.backimageVC3.backgroundColor=[UIColor whiteColor];
    self.backimageVC3.alpha=0.2;
    self.backimageVC3.userInteractionEnabled=YES;
    self.backimageVC3.tag=3;
    
    //--------添加纵坐标
    self.yzuobiao3=[[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.backimageVC2.frame)+20, 20,(self.yCoordinatePointWeek.count-1)*kXheihgt)];
    self.yzuobiao2.backgroundColor=[UIColor clearColor];
    
    UILabel *titleLable3=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 22)];
    titleLable3.text=@"头围";
    titleLable3.font=[UIFont systemFontOfSize:13.0f];
    titleLable3.textColor=[UIColor whiteColor];
    [self.yzuobiao3 addSubview:titleLable3];
    
    NSInteger cishu3=self.yCoordinatePointWeek.count;
//    for(NSInteger i=0;i<self.yCoordinatePointWeek.count;i++){
//        UILabel *ylable=[[UILabel alloc]initWithFrame:CGRectMake(0, 22+i*15, 20, 15)];
//        ylable.textColor=[UIColor whiteColor];
//        ylable.text=self.yCoordinatePointWeek[cishu3-1];
//        cishu3--;
//        ylable.font=[UIFont systemFontOfSize:9];
//        [self.yzuobiao3 addSubview:ylable];
//    }
    
    tubiaoScrollVC3 = [[UIScrollView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.backimageVC2.frame)+50, kScreenWidth-50,  25+(self.yCoordinatePointWeek.count-1)*kXheihgt)];
    tubiaoScrollVC3.showsHorizontalScrollIndicator=NO;
    tubiaoScrollVC3.bounces=NO;
    tubiaoScrollVC3.backgroundColor=[UIColor clearColor];
    [tubiaoScrollVC3 addSubview:[self chart3]];
}


#pragma mark --- 病例的imageview
-(void)bingli{
    self.bingli_VC=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    self.bingli_VC.backgroundColor=[UIColor whiteColor];
    self.bingli_VC.alpha=0.2;
    self.bingli_VC.userInteractionEnabled=YES;
    self.bingli_VC.tag=0;
    
    _imageBili=[[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 30, 30)];
    _imageBili.image=[UIImage imageNamed:@"123_05"];
    
    _biliLable=[[UILabel alloc]initWithFrame:CGRectMake(60, 15, kScreenWidth-80, 30)];
    _biliLable.text=@"查看病例";
    _biliLable.textColor=[UIColor whiteColor];
    _biliLable.font=[UIFont systemFontOfSize:18.0f];
    
    self.minimage=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-30, 23, 10, 15)];
    self.minimage.image=[UIImage imageNamed:@"123_04"];
    
}

#pragma mark -- 图表

-(LineChartView *)chart1{
    self.lineView1 = [[LineChartView alloc] initWithFrame:CGRectMake(0, 0,10+30*(self.xCoordinatePointWeek.count-1), (self.yCoordinatePointWeek.count-1)*kXheihgt)];
    self.lineView1.backgroundColor=[UIColor clearColor];
    self.lineView1.color=[UIColor whiteColor];
    self.lineView1.x=self.xCoordinatePointWeek;
    self.lineView1.y=self.yCoordinatePointWeek;
    self.lineView1.tag=0;
    self.lineView1.bzqjvalue=self.bzzValue;
    [self.lineView1 setChartData:self.ybaobaosg];
    
    [self addGR:self.lineView1];
    tubiaoScrollVC1.contentSize=CGSizeMake(self.lineView1.bounds.size.width, self.lineView1.bounds.size.height);
    [self.lineView1.layer setNeedsDisplay];
    return self.lineView1;
}

-(LineChartView *)chart2{
    self.lineView2 = [[LineChartView alloc] initWithFrame:CGRectMake(0, 0,10+30*(self.xCoordinatePointWeek.count-1), (self.yCoordinatePointWeek.count-1)*kXheihgt)];
    self.lineView2.backgroundColor=[UIColor clearColor];
    self.lineView2.color=[UIColor whiteColor];
    self.lineView2.x=self.xCoordinatePointWeek;
    self.lineView2.y=self.yCoordinatePointWeek;
    self.lineView2.bzqjvalue=self.bzzValue;
    [self.lineView2 setChartData:self.ybaobaotz];
    self.lineView2.tag=1;
    [self addGR:self.lineView2];
    
    tubiaoScrollVC2.contentSize=CGSizeMake(self.lineView2.bounds.size.width, self.lineView2.bounds.size.height);
    
    [self.lineView2.layer setNeedsDisplay];
    return self.lineView2;
}

-(LineChartView *)chart3{
    self.lineView3 = [[LineChartView alloc] initWithFrame:CGRectMake(0, 0,10+30*(self.xCoordinatePointWeek.count-1), (self.yCoordinatePointWeek.count-1)*kXheihgt)];
    self.lineView3.backgroundColor=[UIColor clearColor];
    self.lineView3.color=[UIColor whiteColor];
    self.lineView3.x=self.xCoordinatePointWeek;
    self.lineView3.y=self.yCoordinatePointWeek;
    self.lineView3.bzqjvalue=self.bzzValue;
    [self.lineView3 setChartData:self.ybaobaotw];
    
    self.lineView3.tag=2;
    [self addGR:self.lineView3];
    
    
    tubiaoScrollVC3.contentSize=CGSizeMake(self.lineView3.bounds.size.width, self.lineView3.bounds.size.height);
    [self.lineView3.layer setNeedsDisplay];
    return self.lineView3;
}




#pragma mark   --tableview代理
//-------行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

#pragma mark --- cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *chartInfo=@"chartInfo";
    ChartCell *chartCell=[tableView dequeueReusableCellWithIdentifier:chartInfo];
    if(chartCell == nil){
        chartCell = [ChartCell ChartCell];
    }
    chartCell.backgroundColor=[UIColor clearColor];
    chartCell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    [chartCell.contentView addSubview:self.bingli_VC];
    [chartCell.contentView addSubview:self.imageBili];
    [chartCell.contentView addSubview:self.biliLable];
    [chartCell.contentView addSubview:self.minimage];

//----------------改  -xu--------------------
    [chartCell.contentView addSubview:self.backimageVC1];
    [chartCell.contentView addSubview:self.yzuobiao1];
    [chartCell.contentView addSubview:tubiaoScrollVC1];
  
    [chartCell.contentView addSubview:self.backimageVC2];
    [chartCell.contentView addSubview:self.yzuobiao2];
    [chartCell.contentView addSubview:tubiaoScrollVC2];
    
    [chartCell.contentView addSubview:self.backimageVC3];
    [chartCell.contentView addSubview:self.yzuobiao3];
    [chartCell.contentView addSubview:tubiaoScrollVC3];
 //--------------------------------
    return chartCell;
}

#pragma mark 行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGRectGetMaxY(self.backimageVC3.frame)+120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



#pragma mark  -----病例
#pragma mark --添加图表imageview手势
-(void)addGR0:(UIImageView *)imageview1{
    UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapshoushi1:)];
    [imageview1 addGestureRecognizer:tapGR];
}

#pragma mark 手势的跳转
-(void)tapshoushi1:(UITapGestureRecognizer *)pam{
    UIImageView *imageview1=(UIImageView *)[pam view];
    if(imageview1.tag == 0){
        
    }
}


#pragma mark --添加图表imageview手势
-(void)addGR:(UIView *)imageview1{
    UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapshoushi:)];
    [imageview1 addGestureRecognizer:tapGR];
}

#pragma mark 手势的跳转
-(void)tapshoushi:(UITapGestureRecognizer *)pam{
   UIView *imageview1=(UIView *)[pam view];
    
    EnteringVC *vc = [[EnteringVC alloc] init];
    
//    [vc setEndEnteringCB:^(NSDictionary *para) {
//        if([[para allKeys][0] isEqualToString:@"enteringTypeBabyWeight"]){
//            [self.ybaobaosg addObject:[para objectForKey:@"enteringTypeBabyWeight"]];
//            
//        }
//   
//    }];
    
    if(imageview1.tag == 0){
        vc.type = enteringTypeBabyBody;
        
    }else if(imageview1.tag == 1 ){
         vc.type = enteringTypeBabyWeight;
        
    }else if(imageview1.tag == 2){
         vc.type = enteringTypeBabyHead;
        
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark --网络请求
-(void)networkRequest{
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    
    NSString *url=[kBaseURL stringByAppendingFormat:@"/user/health/record/get?uid=%@&sessionkey=%@",[[NSUserDefaults standardUserDefaults] objectForKey:kUserID],@"12"];
    
    NSDictionary *dict=@{@"category":@"宝宝",@"subCategory":@"身高"};
    
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
        NSDictionary *dict1=(NSDictionary *)responseObject;
        NSLog(@"身高%@",responseObject);
        if([[dict1 objectForKey:@"message"]isEqualToString:@"success"]){
            NSArray *myarray=[dict1 objectForKey:@"records"];
            if(myarray.count != 0){
                [self.ybaobaosg removeAllObjects];
                NSMutableArray *cycleArray=[NSMutableArray array];
                [cycleArray removeAllObjects];
                NSMutableArray *valueArray=[NSMutableArray array];
                [valueArray removeAllObjects];
                NSString *temp;
                NSString *tempvalue;
                for(NSInteger j=0 ;j<myarray.count;j++){
                    
                    [cycleArray addObject:[myarray[j] objectForKey:@"cycle"]];
                    [valueArray addObject:[myarray[j] objectForKey:@"value"]];
                }
                
                for(NSInteger a=0;a<cycleArray.count;a++){
                    for(NSInteger b=a;b<cycleArray.count;b++){
                        if([cycleArray[a] integerValue]>[cycleArray[b] integerValue]){
                            temp=cycleArray[a];
                            cycleArray[a]=cycleArray[b];
                            cycleArray[b]=temp;
                            
                            tempvalue=valueArray[a];
                            valueArray[a]=valueArray[b];
                            valueArray[b]=tempvalue;
                            
                        }
                    }
                    
                }
                if([cycleArray[0] integerValue] ==0){
                    [cycleArray removeObjectAtIndex:0];
                    [valueArray removeObjectAtIndex:0];
                }
                
                for(NSInteger i=1;i<=[[cycleArray lastObject]integerValue];i++){
                    if(i<=cycleArray.count){
                        for(NSInteger j=0;j<cycleArray.count;j++){
                            if(i == [cycleArray[j]integerValue] ){
                                [self.ybaobaosg addObject:valueArray[j]];
                                
                            }
                            
                        }
                        
                        for(NSInteger l=0;l<cycleArray.count;l++){
                            if(i == [cycleArray[i-1]integerValue] ){
                                break;
                            }else if([cycleArray[i-1]integerValue]>cycleArray.count){
                                [self.ybaobaosg addObject:@"0"];
                                break;
                            }else if(i !=[cycleArray[l]integerValue] ){
                                [self.ybaobaosg addObject:@"0"];
                            }
                        }
                        
                    }else if(i>cycleArray.count){
                        
                        for(NSInteger k=0;k<cycleArray.count;k++){
                            if(i ==[cycleArray[k]integerValue]){
                                [self.ybaobaosg addObject:valueArray[k]];
                                
                            }
                        }
                        for(NSInteger l=0;l<cycleArray.count;l++){
                            if([[cycleArray lastObject]integerValue] == i){
                                break;
                            }else if(i !=[cycleArray[l]integerValue] ){
                                [self.ybaobaosg addObject:@"0"];
                                break;
                            }
                        }
                        
                    }
                    
                }
                
            }
        }
     

        [self tubiao];
        
        [self.chartTableVC reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"_erreo__%@",error);
    }];
    
    NSDictionary *dict1=@{@"category":@"宝宝",@"subCategory":@"体重"};
    [manager POST:url parameters:dict1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict1=(NSDictionary *)responseObject;
        NSLog(@"身高%@",responseObject);
        if([[dict1 objectForKey:@"message"]isEqualToString:@"success"]){
            NSArray *myarray=[dict1 objectForKey:@"records"];
            if(myarray.count != 0){
                [self.ybaobaotz removeAllObjects];
                NSMutableArray *cycleArray=[NSMutableArray array];
                [cycleArray removeAllObjects];
                NSMutableArray *valueArray=[NSMutableArray array];
                [valueArray removeAllObjects];
                NSString *temp;
                NSString *tempvalue;
                for(NSInteger j=0 ;j<myarray.count;j++){
                    
                    [cycleArray addObject:[myarray[j] objectForKey:@"cycle"]];
                    [valueArray addObject:[myarray[j] objectForKey:@"value"]];
                }
                
                for(NSInteger a=0;a<cycleArray.count;a++){
                    for(NSInteger b=a;b<cycleArray.count;b++){
                        if([cycleArray[a] integerValue]>[cycleArray[b] integerValue]){
                            temp=cycleArray[a];
                            cycleArray[a]=cycleArray[b];
                            cycleArray[b]=temp;
                            
                            tempvalue=valueArray[a];
                            valueArray[a]=valueArray[b];
                            valueArray[b]=tempvalue;
                            
                        }
                    }
                    
                }
                if([cycleArray[0] integerValue] ==0){
                    [cycleArray removeObjectAtIndex:0];
                    [valueArray removeObjectAtIndex:0];
                }
                
                for(NSInteger i=1;i<=[[cycleArray lastObject]integerValue];i++){
                    if(i<=cycleArray.count){
                        for(NSInteger j=0;j<cycleArray.count;j++){
                            if(i == [cycleArray[j]integerValue] ){
                                [self.ybaobaotz addObject:valueArray[j]];
                                
                            }
                            
                        }
                        
                        for(NSInteger l=0;l<cycleArray.count;l++){
                            if(i == [cycleArray[i-1]integerValue] ){
                                break;
                            }else if([cycleArray[i-1]integerValue]>cycleArray.count){
                                [self.ybaobaotz addObject:@"0"];
                                break;
                            }else if(i !=[cycleArray[l]integerValue] ){
                                [self.ybaobaotz addObject:@"0"];
                            }
                        }
                        
                    }else if(i>cycleArray.count){
                        
                        for(NSInteger k=0;k<cycleArray.count;k++){
                            if(i ==[cycleArray[k]integerValue]){
                                [self.ybaobaotz addObject:valueArray[k]];
                                
                            }
                        }
                        for(NSInteger l=0;l<cycleArray.count;l++){
                            if([[cycleArray lastObject]integerValue] == i){
                                break;
                            }else if(i !=[cycleArray[l]integerValue] ){
                                [self.ybaobaotz addObject:@"0"];
                                break;
                            }
                        }
                        
                    }
                    
                }
                
            }
        }
        [self tubiao];
        
        [self.chartTableVC reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"_erreo__%@",error);
    }];
    
    NSDictionary *dict2=@{@"category":@"宝宝",@"subCategory":@"头围"};
    [manager POST:url parameters:dict2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict1=(NSDictionary *)responseObject;
        NSLog(@"身高%@",responseObject);
        if([[dict1 objectForKey:@"message"]isEqualToString:@"success"]){
            NSArray *myarray=[dict1 objectForKey:@"records"];
            if(myarray.count != 0){
                [self.ybaobaotw removeAllObjects];
                NSMutableArray *cycleArray=[NSMutableArray array];
                [cycleArray removeAllObjects];
                NSMutableArray *valueArray=[NSMutableArray array];
                [valueArray removeAllObjects];
                NSString *temp;
                NSString *tempvalue;
                for(NSInteger j=0 ;j<myarray.count;j++){
                    
                    [cycleArray addObject:[myarray[j] objectForKey:@"cycle"]];
                    [valueArray addObject:[myarray[j] objectForKey:@"value"]];
                }
                
                for(NSInteger a=0;a<cycleArray.count;a++){
                    for(NSInteger b=a;b<cycleArray.count;b++){
                        if([cycleArray[a] integerValue]>[cycleArray[b] integerValue]){
                            temp=cycleArray[a];
                            cycleArray[a]=cycleArray[b];
                            cycleArray[b]=temp;
                            
                            tempvalue=valueArray[a];
                            valueArray[a]=valueArray[b];
                            valueArray[b]=tempvalue;
                            
                        }
                    }
                    
                }
                if([cycleArray[0] integerValue] ==0){
                    [cycleArray removeObjectAtIndex:0];
                    [valueArray removeObjectAtIndex:0];
                }
                
                for(NSInteger i=1;i<=[[cycleArray lastObject]integerValue];i++){
                    if(i<=cycleArray.count){
                        for(NSInteger j=0;j<cycleArray.count;j++){
                            if(i == [cycleArray[j]integerValue] ){
                                [self.ybaobaotw addObject:valueArray[j]];
                                
                            }
                            
                        }
                        
                        for(NSInteger l=0;l<cycleArray.count;l++){
                            if(i == [cycleArray[i-1]integerValue] ){
                                break;
                            }else if([cycleArray[i-1]integerValue]>cycleArray.count){
                                [self.ybaobaotw addObject:@"0"];
                                break;
                            }else if(i !=[cycleArray[l]integerValue] ){
                                [self.ybaobaotw addObject:@"0"];
                            }
                        }
                        
                    }else if(i>cycleArray.count){
                        
                        for(NSInteger k=0;k<cycleArray.count;k++){
                            if(i ==[cycleArray[k]integerValue]){
                                [self.ybaobaotw addObject:valueArray[k]];
                                
                            }
                        }
                        for(NSInteger l=0;l<cycleArray.count;l++){
                            if([[cycleArray lastObject]integerValue] == i){
                                break;
                            }else if(i !=[cycleArray[l]integerValue] ){
                                [self.ybaobaotw addObject:@"0"];
                                break;
                            }
                        }
                        
                    }
                    
                }
                
            }
        }
        [self tubiao];
        
        [self.chartTableVC reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"_erreo__%@",error);
    }];
    
    [self tubiao];
    
    [self.chartTableVC reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
 
}


@end
