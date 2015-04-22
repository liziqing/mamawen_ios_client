//
//  EnteringVC.m
//  妈妈问
//
//  Created by kin on 15/4/13.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "EnteringVC.h"
#import "TRSDialScrollView.h"
#import "AFNetworking.h"
#define kBabyImageName  @"123_06"
#define kMomImageName   @"123_08"
#define kPicWitdh       (kScreenWidth / 4 - 10)
#define kPicHeight      kScreenHeight / 4 - 10
@interface EnteringVC () <UIPickerViewDelegate,UIPickerViewDataSource,UIScrollViewDelegate>
{
    NSDictionary *_para;
    TRSDialScrollView *_trsroll;
    UILabel      *_dataLable;
    
    
    UIPickerView *_picker1;
    UIPickerView *_picker2; // 日期选择器时   此为月选择
    
    NSMutableArray *_pickerDataArr1;
    NSMutableArray *_pickerDataArr2;
    
    CGFloat _picFrameY;
    
    NSInteger _years;
    NSInteger _months;
    NSInteger _days;
    
    NSString *_pickText1;
    NSString *_pickText2;

    
    //---------------xu--------
    NSString *nowTimeString;
    //-----------------------
}
@end

@implementation EnteringVC

- (void)prepareData {
    _pickerDataArr1 = [NSMutableArray array];
    _pickerDataArr2 = [NSMutableArray array];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
    
    _years= [components year];  //当前的年份
    _months = [components month];  //当前的月份
    _days = [components day];  // 当前的号数
    
    
    //-----------------xu--------
    NSDate *nowdate=[NSDate date];
    NSDateFormatter *nowformatter=[[NSDateFormatter alloc]init];
    [nowformatter setDateFormat:@"yyyy-MM-dd"];
    nowTimeString=[nowformatter stringFromDate:nowdate];
    //-----------------------
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self prepareData];
    [self uiConfig];
}
- (void)uiConfig {
    switch (_type) {
        case enteringTypeTemperature: // 体温
            [self prepareTemperature];
            break;
        case enteringTypeBabyHead:// 头围
            [self prepareBabyHead];
            break;
        case enteringTypeBabyBody:// 身长
            [self prepareBabyBody];
            break;
        case enteringTypeBabyEat:// 奶量
            [self prepareBabyEat];
            break;
        case enteringTypeBabyWeight:// 宝重
            [self prepareBabyWeight];
            break;
        case enteringTypeMomAbdomen:// 腹围
            [self prepareMomAbdomen];
            break;
        case enteringTypeBloodPressure:// 血压
            [self prepareBloodPressure];
            break;
        case enteringTypeMomWeight:// 体重
            [self prepareMomWeight];
            break;
            
            
        default:
            break;
    }

    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(30, kScreenHeight - 160, kScreenWidth - 60, 1)];
    lineV.backgroundColor = [UIColor colorWithRed:0.94 green:0.78 blue:0.83 alpha:1];
    [self.view addSubview:lineV];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.view.center.x - 80, CGRectGetMaxY(lineV.frame) + 30, 160, 40);
    btn.backgroundColor = [UIColor colorWithRed:0.94 green:0.78 blue:0.83 alpha:1];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"确   定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(upDateDatas) forControlEvents:64];
    [self.view addSubview:btn];
}

- (void)upDateDatas {
#warning para填充回调数据
//    NSLog(@"t1:%@ t2:%@",_pickText1,_pickText2);  //如果为null  说明是默认值
//_para =
    //----------------------xu------------
    if(self.type == enteringTypeBabyWeight){
        [_para setValue:_dataLable.text forKey:@"enteringTypeBabyWeight"]; //体重
        
    }else if(self.type == enteringTypeBabyBody){
        [_para setValue:_dataLable.text forKey:@"enteringTypeBabyBody"]; //身高
        
    }else if(self.type == enteringTypeBabyHead){
        [_para setValue:_dataLable.text forKey:@"enteringTypeBabyHead"]; //头围
    }
    [ self networkData];
    //----------------------xu------------
    
    if (_endEnteringCB) _endEnteringCB(_para);
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)prepareTemperature { // 备孕体温
    self.title = @"备孕体温";
    
    [self createDataLableWithTitle:@"体温" unit:@"℃" startPoint:CGPointMake(self.view.center.x - 100, 80)];
    
    
    
    for (int i = 1; i < 13; i++) {
        [_pickerDataArr2 addObject:@(i)];// 返回12行即可    这个数组课不用
    }
    for (int j = 1; j <=[self getCurrentMounthsDaysFromyear:_years mounth:_months]; j ++) {
        [_pickerDataArr1 addObject:@(j)];
    }
    [self createTempretureWithTopY:CGRectGetMaxY(_dataLable.frame) + 15];
    

}
- (void)prepareBabyHead { // 宝宝头围
    self.title = @"宝宝头围";
    
    for (int i = 1; i <=40; i++) {
        [_pickerDataArr1 addObject:@(i)];
    }
    
    [self createDataLableWithTitle:@"头围" unit:@"cm" startPoint:CGPointMake(self.view.center.x - 80, 15)];
    _dataLable.text = @"25.3";
    _trsroll = [[TRSDialScrollView alloc] initWithFrame:CGRectMake(60, CGRectGetMaxY(_dataLable.frame) + 10, kScreenWidth - 120, 50)];
    [_trsroll setDialRangeFrom:10 to:40];
    _trsroll.layer.cornerRadius = 5;
    _trsroll.layer.masksToBounds = YES;
    [self.view addSubview:_trsroll];
    [self setTSRDWithMinorTicksPerMajorTick:10 MinorTickDistance:6 lableColor:nil lableWidth:1 lableFillColor:nil font:12 minorTickColor:nil minorTickLength:12 minorTickWidth:0.4 majorTickColor:nil majorTickLength:20 majorTickWidth:1.2];
    [self createMomOrBabyPicWithFrame:CGRectMake(self.view.center.x - kPicWitdh / 2, CGRectGetMaxY(_trsroll.frame) + 25, kPicWitdh, kPicHeight) imageName:kBabyImageName];
    [self createPickerWithNum:1 startPoint:CGPointMake(self.view.center.x - 80, _picFrameY + 30) placeHolderOne:3 placeHolderTwo:0 beforeText:@"第" afterText:@"月"];
    
}
- (void)prepareBabyBody { // 宝宝身长
    self.title = @"宝宝身长";
    for (int i = 1; i <=40; i++) {
        [_pickerDataArr1 addObject:@(i)];
    }
    [self createDataLableWithTitle:@"身长" unit:@"cm" startPoint:CGPointMake(self.view.center.x - 20, 40)];
    _dataLable.text = @"44.3";
    _trsroll = [[TRSDialScrollView alloc] initWithFrame:CGRectMake(0, 120, kScreenHeight / 3, 50)];
    _trsroll.transform = CGAffineTransformMakeRotation(M_PI_2);
    [_trsroll setDialRangeFrom:30 to:60];
    _trsroll.layer.cornerRadius = 5;
    _trsroll.layer.masksToBounds = YES;
    [self.view addSubview:_trsroll];
    [self setTSRDWithMinorTicksPerMajorTick:10 MinorTickDistance:6 lableColor:nil lableWidth:1 lableFillColor:nil font:12 minorTickColor:nil minorTickLength:12 minorTickWidth:0.4 majorTickColor:nil majorTickLength:20 majorTickWidth:1.2];
    [self createMomOrBabyPicWithFrame:CGRectMake(self.view.center.x, CGRectGetMaxY(_dataLable.frame) + 20, kPicWitdh + 10, kPicHeight) imageName:kBabyImageName];
    [self createPickerWithNum:1 startPoint:CGPointMake(self.view.center.x - 80, _picFrameY + 60) placeHolderOne:1 placeHolderTwo:1 beforeText:@"第" afterText:@"月"];
}
- (void)prepareBabyEat { // 宝宝奶量
    self.title = @"宝宝奶量";
    
    [self createDataLableWithTitle:@"奶量" unit:@"ml" startPoint:CGPointMake(self.view.center.x, 100)];
    _dataLable.text = @"280";
    [self createMomOrBabyPicWithFrame:CGRectMake(self.view.center.x, CGRectGetMaxY(_dataLable.frame) + 30, kPicWitdh + 10, kPicHeight) imageName:kBabyImageName];
    
    UIImageView *feeder  = [[UIImageView alloc] initWithFrame:CGRectMake(40, 120, kPicWitdh + 10, kPicHeight * 3 / 2)];
    feeder.image = [UIImage imageNamed:@"123_07"];
    [self.view addSubview:feeder];
    
}
- (void)prepareBabyWeight {// 宝宝体重
    self.title = @"宝宝体重";
    for (int i = 3; i <=10; i++) {
        [_pickerDataArr1 addObject:@(i)];
    }
    [self createDataLableWithTitle:@"体重" unit:@"kg" startPoint:CGPointMake(self.view.center.x - 60, 20)];
    _dataLable.text = @"6.0";
    
    [self createMomOrBabyPicWithFrame:CGRectMake(self.view.center.x - (kPicWitdh + 10) / 2, CGRectGetMaxY(_dataLable.frame) + 10, kPicWitdh + 10, kPicHeight) imageName:kBabyImageName];
    _trsroll = [[TRSDialScrollView alloc] initWithFrame:CGRectMake(self.view.center.x - kScreenWidth / 6, _picFrameY + 10, kScreenWidth / 3, 50)];
    [_trsroll setDialRangeFrom:3 to:10];
    [self.view addSubview:_trsroll];
    _trsroll.layer.cornerRadius = 5;
    _trsroll.layer.masksToBounds = YES;
    [self setTSRDWithMinorTicksPerMajorTick:10 MinorTickDistance:6 lableColor:nil lableWidth:1 lableFillColor:nil font:12 minorTickColor:nil minorTickLength:12 minorTickWidth:0.4 majorTickColor:nil majorTickLength:20 majorTickWidth:1.2];
    
    [self createPickerWithNum:1 startPoint:CGPointMake(self.view.center.x - 80,  CGRectGetMaxY(_trsroll.frame) + 40) placeHolderOne:1 placeHolderTwo:1 beforeText:@"第" afterText:@"月"];
    
}
- (void)prepareMomAbdomen { // 孕期腹围
    self.title = @"孕期腹围";
    for (int i = 1; i <=40; i++) {
        [_pickerDataArr1 addObject:@(i)];
    }
    [self createDataLableWithTitle:@"腹围" unit:@"cm" startPoint:CGPointMake(self.view.center.x - 60, 20)];
    _dataLable.text = @"6.0";
    
    [self createMomOrBabyPicWithFrame:CGRectMake(self.view.center.x - (kPicWitdh + 10) / 2, CGRectGetMaxY(_dataLable.frame) + 10, kPicWitdh + 10, kPicHeight) imageName:kMomImageName];
    _trsroll = [[TRSDialScrollView alloc] initWithFrame:CGRectMake( kScreenWidth / 8, _picFrameY + 10, kScreenWidth  * 3 / 4, 50)];
    [_trsroll setDialRangeFrom:10 to:40];
    _trsroll.layer.cornerRadius = 5;
    _trsroll.layer.masksToBounds = YES;
    [self.view addSubview:_trsroll];
    [self setTSRDWithMinorTicksPerMajorTick:10 MinorTickDistance:6 lableColor:nil lableWidth:1 lableFillColor:nil font:12 minorTickColor:nil minorTickLength:12 minorTickWidth:0.4 majorTickColor:nil majorTickLength:20 majorTickWidth:1.2];
    
    [self createPickerWithNum:1 startPoint:CGPointMake(self.view.center.x - 80,  CGRectGetMaxY(_trsroll.frame) + 40) placeHolderOne:1 placeHolderTwo:1 beforeText:@"孕" afterText:@"周"];
}
- (void)prepareBloodPressure {// 孕期血压
    self.title = @"孕期血压";
}
- (void)prepareMomWeight {// 孕期体重
    self.title = @"孕期体重";
    for (int i = 40; i <=100; i++) {
        [_pickerDataArr1 addObject:@(i)];
    }
    [self createDataLableWithTitle:@"体重" unit:@"kg" startPoint:CGPointMake(self.view.center.x - 60, 20)];
    _dataLable.text = @"60.0";
    
    [self createMomOrBabyPicWithFrame:CGRectMake(self.view.center.x - (kPicWitdh + 10) / 2, CGRectGetMaxY(_dataLable.frame) + 10, kPicWitdh , kPicHeight) imageName:kMomImageName];
    _trsroll = [[TRSDialScrollView alloc] initWithFrame:CGRectMake( kScreenWidth / 8, _picFrameY + 10, kScreenWidth  * 3 / 4, 50)];
    [_trsroll setDialRangeFrom:40 to:100];
    _trsroll.layer.cornerRadius = 5;
    _trsroll.layer.masksToBounds = YES;
    [self.view addSubview:_trsroll];
    [self setTSRDWithMinorTicksPerMajorTick:10 MinorTickDistance:6 lableColor:nil lableWidth:1 lableFillColor:nil font:12 minorTickColor:nil minorTickLength:12 minorTickWidth:0.4 majorTickColor:nil majorTickLength:20 majorTickWidth:1.2];
    
    [self createPickerWithNum:1 startPoint:CGPointMake(self.view.center.x - 80,  CGRectGetMaxY(_trsroll.frame) + 50) placeHolderOne:1 placeHolderTwo:1 beforeText:@"孕" afterText:@"周"];
    
}
// 温度计
- (void)createTempretureWithTopY:(CGFloat)frameY {
    UIImageView *temp = [[UIImageView alloc] initWithFrame:CGRectMake(-30, frameY, kScreenWidth, 50)];
    temp.image = [UIImage imageNamed:@"123_02"];
    [self.view addSubview:temp];
    
// 温度标尺
    
    
    [self createPickerWithNum:2 startPoint:CGPointMake(self.view.center.x - 100, CGRectGetMaxY(temp.frame) + 60) placeHolderOne:_months - 1 placeHolderTwo:_days - 1 beforeText:@"月" afterText:@"日"];
}

// 宝宝或者妈妈图片
- (void)createMomOrBabyPicWithFrame:(CGRect)rect imageName:(NSString *)name{
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:rect];
    imgV.image = [UIImage imageNamed:name];
    [self.view addSubview:imgV];
    _picFrameY = CGRectGetMaxY(imgV.frame);
}
// 上方数据Lable
- (void)createDataLableWithTitle:(NSString *)title unit:(NSString *)unit startPoint:(CGPoint)pt {

    UILabel *temp = [[UILabel alloc] initWithFrame:CGRectMake(pt.x, pt.y, 50, 40)];
    temp.text = title;
    temp.font = [UIFont systemFontOfSize:iphone6?20 : 18];
    temp.textColor = [UIColor whiteColor];
    [self.view addSubview:temp];
    
    
    _dataLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(temp.frame), CGRectGetMinY(temp.frame) - 10, 60, 50)];
    _dataLable.font = [UIFont systemFontOfSize:30];
    _dataLable.textColor = [UIColor whiteColor];
    _dataLable.text = @"37.8";
    _dataLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_dataLable];
    
    UILabel *units = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_dataLable.frame) + 10, CGRectGetMinY(temp.frame), 50, 40)];
    units.text = unit;
    units.textColor = [UIColor whiteColor];
    units.font = [UIFont systemFontOfSize:iphone6?20 : 18];
    [self.view addSubview:units];

}
// pickerView和lables
- (void)createPickerWithNum:(NSInteger)num  // 只能为1、2、3
               startPoint:(CGPoint)pt
           placeHolderOne:(NSInteger)one
           placeHolderTwo:(NSInteger)two
               beforeText:(NSString *)before
                afterText:(NSString *)after {
    CGPoint startPt = CGPointZero;
    if (num == 2) {
        UIView *backV1 = [[UIView alloc] initWithFrame:CGRectMake(pt.x, pt.y, 50, 80)];
        backV1.backgroundColor = [UIColor colorWithRed:0.9 green:0.62 blue:0.68 alpha:1];
        [self.view addSubview:backV1];
        backV1.layer.masksToBounds = YES;
        backV1.layer.cornerRadius = 3;
        backV1.layer.masksToBounds = YES;
        _picker2 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, -40, 50, 80)];
        _picker2.delegate = self;
        _picker2.dataSource = self;
        _picker2.backgroundColor = [UIColor clearColor];
        [_picker2 selectRow:one inComponent:0 animated:NO];
        [backV1 addSubview:_picker2];
        startPt = CGPointMake(CGRectGetMaxX(backV1.frame), backV1.center.y - 20);
    }
    else if (num == 1)  startPt = pt;
        UILabel *bfl = [[UILabel alloc] initWithFrame:CGRectMake(startPt.x, startPt.y, 50, 40)];
        bfl.text = before;
        bfl.textColor = [UIColor whiteColor];
        bfl.font = [UIFont systemFontOfSize:32];
    bfl.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:bfl];
    
    
    UIView *backV2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bfl.frame), CGRectGetMinY(bfl.frame) - 20, 50, 80)];
    backV2.backgroundColor = [UIColor colorWithRed:0.9 green:0.62 blue:0.68 alpha:1];
    [self.view addSubview:backV2];
    backV2.layer.masksToBounds = YES;
    backV2.layer.cornerRadius = 3;
    backV2.layer.masksToBounds = YES;
    
        _picker1 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, -40, 50, 80)];
        _picker1.delegate = self;
        _picker1.dataSource = self;
    _picker1.backgroundColor = [UIColor clearColor];
    [_picker1 selectRow:two inComponent:0 animated:YES];
        [backV2 addSubview:_picker1];
        
        UILabel *aftl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(backV2.frame), CGRectGetMinY(bfl.frame), CGRectGetWidth(bfl.frame), CGRectGetHeight(bfl.frame))];
    aftl.text = after;
    aftl.textColor = [UIColor whiteColor];
    aftl.font = [UIFont systemFontOfSize:32];
    [self.view addSubview:aftl];
}
- (void)setTSRDWithMinorTicksPerMajorTick:(NSInteger)majorTick
                        MinorTickDistance:(NSInteger)distance
                               lableColor:(UIColor *)color
                               lableWidth:(CGFloat)width
                           lableFillColor:(UIColor *)fillColor
                                     font:(CGFloat)font
                           minorTickColor:(UIColor*)tickColor
                          minorTickLength:(CGFloat)minorTickLength
                           minorTickWidth:(CGFloat)minorTickWidth
                           majorTickColor:(UIColor *)majorTickColor
                          majorTickLength:(CGFloat)majorTickLength
                           majorTickWidth:(CGFloat)majorTickWidth {
    [[TRSDialScrollView appearance] setMinorTicksPerMajorTick:majorTick];
    [[TRSDialScrollView appearance] setMinorTickDistance:distance];
    
    [[TRSDialScrollView appearance] setBackgroundColor:[UIColor colorWithRed:0.91 green:0.63 blue:0.71 alpha:1]];
    [[TRSDialScrollView appearance] setOverlayColor:[UIColor clearColor]];
    
    [[TRSDialScrollView appearance] setLabelStrokeColor:[UIColor lightGrayColor]];
    [[TRSDialScrollView appearance] setLabelStrokeWidth:0.1f];
    [[TRSDialScrollView appearance] setLabelFillColor:[UIColor blackColor]];
    
    [[TRSDialScrollView appearance] setLabelFont:[UIFont systemFontOfSize:font]];
    
    [[TRSDialScrollView appearance] setMinorTickColor:[UIColor lightGrayColor]];
    [[TRSDialScrollView appearance] setMinorTickLength:minorTickLength];
    [[TRSDialScrollView appearance] setMinorTickWidth:minorTickWidth];
    
    [[TRSDialScrollView appearance] setMajorTickColor:[UIColor grayColor]];
    [[TRSDialScrollView appearance] setMajorTickLength:majorTickLength];
    [[TRSDialScrollView appearance] setMajorTickWidth:majorTickWidth];
    
    [[TRSDialScrollView appearance] setShadowColor:[UIColor colorWithRed:0.593 green:0.619 blue:0.643 alpha:1.000]];
    [[TRSDialScrollView appearance] setShadowOffset:CGSizeMake(0, 1)];
    [[TRSDialScrollView appearance] setShadowBlur:0.9f];
    
  
    
    _trsroll.delegate = self;

}
// 指定月份天数
- (NSInteger)getCurrentMounthsDaysFromyear:(NSInteger)year mounth:(NSInteger)mounth {
    NSInteger days = 0;
    switch (mounth) {
        case 4:
            case 6:
            case 9:
        case 11: days = 30;
            break;
           case 2:
            if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
                days = 29;
            } else days = 28;
            break;
        default: days = 31;
            break;
    }
    return days;
}
#pragma mark -
#pragma mark picker delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == _picker2) return _pickerDataArr2.count;
    else return _pickerDataArr1.count;

}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *labe = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 35)];
    labe.font = [UIFont systemFontOfSize:12];
    labe.textColor = [UIColor whiteColor];
    labe.textAlignment = NSTextAlignmentCenter;
    labe.text = [NSString stringWithFormat:@"%@", _pickerDataArr1[row] ];
    return labe;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    UIView *view = [pickerView viewForRow:row forComponent:component];
    UILabel *lable;
    NSString *rowText;
    if ([view isKindOfClass:[UILabel class]]) {
        lable = (UILabel *)view;
        rowText = lable.text;
        [lable setFont:[UIFont systemFontOfSize:30]];
    }
    
    if (pickerView == _picker2) {// 这里有月份改变   须刷新天数数组
        [_pickerDataArr1 removeAllObjects];
        for (int i = 1; i <= [self getCurrentMounthsDaysFromyear:_years mounth:rowText.integerValue]; i ++) {
            [_pickerDataArr1 addObject:@(i)];
        }
        
        [_picker1 reloadAllComponents];
    }
    
    if (_picker2 == pickerView) {
        _pickText2 = rowText;
    } else _pickText1 = rowText;
    
        NSLog(@"选中row：%@",rowText);
    
    
    
}

//------------xu--------网络存记录
-(void)networkData{
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    NSString *url=[kBaseURL stringByAppendingFormat:@"/user/health/record/add?uid=%@&sessionkey=%@",[[NSUserDefaults standardUserDefaults] objectForKey:kUserID],@"a123"];
    NSDictionary *dict;
    
    if(self.type == enteringTypeBabyWeight){
        
        dict =@{@"value":@([_dataLable.text floatValue]),@"cycle":@([_pickText1 integerValue]),@"category":@"宝宝",@"subCategory":@"体重",@"recordDate":nowTimeString};
        
    }else if(self.type == enteringTypeBabyBody){
        dict =@{@"cycle":@([_pickText1 integerValue]),@"category":@"宝宝",@"subCategory":@"身高",@"recordDate":nowTimeString,@"value":@([_dataLable.text floatValue])};
        
    }else if(self.type == enteringTypeBabyHead){
        dict =@{@"cycle":@([_pickText1 integerValue]),@"category":@"宝宝",@"subCategory":@"头围",@"recordDate":nowTimeString,@"value":@([_dataLable.text floatValue])};
    }
    
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败---%@",error);
    }];
    
}

//----------------------------------xu-------------------

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _dataLable.text = [NSString stringWithFormat:@"%.1f", _trsroll.currentValue * 0.1 ];
}
- (void)viewWillAppear:(BOOL)animated {
    [self hiddenTabbar:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self hiddenTabbar:NO];
}

@end
