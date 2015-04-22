//
//  userInfoHasBabyVC.m
//  妈妈问
//
//  Created by lixuan on 15/3/2.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "UserInfoOfRegisterVC.h"
#import "CustomDropDownTextField.h"


@interface UserInfoOfRegisterVC () <UITextFieldDelegate>
{
    NSArray *_infosArr;
    CGFloat _bottonLableH;
    
    NSString *_selectedSex;
    
    UIDatePicker *_datePicker;
    UITextField *_selectTF;
}
@end

@implementation UserInfoOfRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden = NO;
    [self uiConfig];
}
- (void)uiConfig {
    switch (_index) {
        case 0:
            self.title = @"备孕期";
            _infosArr = @[@"最后一次月经",@"月经周期"];
            break;
        case 1:
           self.title = @"怀孕期";
            _infosArr = @[@"预产期",@"身高",@"孕前体重"];

            break;
        case 2:
            self.title = @"育儿期";
            _infosArr = @[@"宝宝昵称",@"性别",@"宝宝生日"];

            break;
        default:
            break;
    }
    [self createLablesAndTextField];
}
// 选择框
- (void)createLablesAndTextField {
    CGFloat topH = 80;
    CGFloat spaceW = 15;
    CGFloat leadH = 30;
    CGFloat H = iphone6? 50 : 40;
    
    NSArray *pics = @[@"03_06",@"03_03"];
    for (int i = 0; i < _infosArr.count; i ++) {
        
        CustomDropDownTextField *textField = [[CustomDropDownTextField alloc] initWithFrame:CGRectMake(leadH, topH + (H +spaceW) * i, self.view.frame.size.width - leadH * 2, H)];
       
        
       
        if (2 == _index && (0 == i || 1 == i)) {
            textField.isHiddenRightBtn = YES;
        } else if (1 == _index && (1 == i || 2 == i)) {
            textField.isHiddenRightBtn = YES;
        } else if (0 == _index && 1 == i) {
            textField.isHiddenRightBtn = YES;
        }
        
        if (2 == _index && 1 == i) {
            CGRect rect = textField.frame;
            CGFloat width = (rect.size.width - 8) /2;
            textField.hidden = YES;
            for (int j = 0; j < 2; j++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(CGRectGetMinX(rect) + (width + 8)  * j , CGRectGetMinY(rect), width, CGRectGetHeight(rect));
                btn.tag = 11 + j;
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn setTitle:0 == j?@"男宝宝":@"女宝宝" forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:pics[j]] forState:UIControlStateNormal];
                btn.titleEdgeInsets = UIEdgeInsetsMake(0, width / 2 - 30, 0, 0);
                btn.titleLabel.textAlignment = NSTextAlignmentLeft;
                btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0,btn.titleLabel.bounds.size.width);
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                
                btn.titleLabel.font = [UIFont systemFontOfSize:iphone6?16:14];
                [btn addTarget:self action:@selector(sexSelected:) forControlEvents:64];
                [btn setBackgroundColor:[UIColor clearColor]];
                btn.layer.borderColor = [UIColor whiteColor].CGColor;
                btn.layer.borderWidth = 0.8;
                [self.view addSubview:btn];
                
            }
        }
        
        textField.tag = 100 + i;
        textField.delegate = self;
        textField.backgroundColor = [UIColor clearColor];
        textField.textColor = [UIColor whiteColor];
        textField.font = [UIFont systemFontOfSize:iphone6? 16 : 14];
        textField.placeholder = [NSString stringWithFormat:@"   %@", _infosArr[i] ];
        [self.view addSubview:textField];
        
         __block CustomDropDownTextField *tf = textField;
        [textField setButtonClick:^{
            [self showTableWhenClick:tf];
        }];
      
        
        _bottonLableH = CGRectGetMaxY(textField.frame);
    }
    [self createGoinBtn];
}
- (void)showTableWhenClick:(UITextField *)tf { //
    NSInteger index = tf.tag - 100;
    NSLog(@"%ld",index);
}
// 性别选择
- (void)sexSelected:(UIButton *)sender {
    for (UIView *vv in self.view.subviews) {
        if (vv.tag == 11 || vv.tag == 12) {
            [(UIButton *)vv setBackgroundColor:[UIColor clearColor]];
        }
    }
    sender.backgroundColor = [UIColor colorWithRed:0.31 green:0.83 blue:0.68 alpha:1];
    _selectedSex = sender.titleLabel.text;
    NSLog(@"%@",_selectedSex);
}


// 继续添加和确认按钮
- (void)createGoinBtn {
    if (2 == _index) {
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat bw = iphone6?50:40;
        addBtn.frame = CGRectMake(self.view.center.x - bw / 2, _bottonLableH + 20, bw, bw);
        addBtn.layer.cornerRadius = bw / 2;
        addBtn.layer.masksToBounds = YES;
        [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [addBtn setTitle:@"➕" forState:UIControlStateNormal];
        [addBtn setImage:[UIImage imageNamed:@"03_11"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addmore) forControlEvents:64];
        addBtn.backgroundColor = [UIColor colorWithRed:0.92 green:0.68 blue:0.74 alpha:1];
        [self.view addSubview:addBtn];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(addBtn.frame), CGRectGetMaxY(addBtn.frame) + 5, bw, bw / 3)];
        lable.text = @"继续添加";
        lable.textColor = [UIColor whiteColor];
        lable.backgroundColor = [UIColor clearColor];
        lable.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:lable];
        
        _bottonLableH = CGRectGetMaxY(lable.frame) - 20;
    }
   
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(30, _bottonLableH + 40, self.view.frame.size.width - 30 * 2, iphone6? 50 : 40);
    [btn setTitle:@"加入妈妈帮" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithRed:0.31 green:0.83 blue:0.68 alpha:1]];
    [btn addTarget:self action:@selector(goinBtnClick) forControlEvents:64];
    btn.layer.cornerRadius = 8;
    btn.layer.masksToBounds = YES;
    [self.view addSubview:btn];
    
    [self createDatePicker];
}
- (void)createDatePicker {
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.backgroundColor = [UIColor colorWithRed:0.31 green:0.83 blue:0.68 alpha:1];
    [_datePicker addTarget:self action:@selector(getTimeStr:) forControlEvents:UIControlEventValueChanged];
}
- (void)getTimeStr:(UIDatePicker *)sender {
    NSDate *selectedDate = sender.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:selectedDate];
    _selectTF.text = dateString;
}
//添加更多
- (void)addmore {

}
- (void)goinBtnClick {
   // 上传注册数据 进入首页   刷新个人信息
#warning 标记已注册或登录   首页显示个人信息  退出登录时记得修改状态
    [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:kHasLoginOrRegister];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _selectTF = textField;
    BOOL s;
    if ((0 == _index && 100 == textField.tag) || (1 == _index && 100 == textField.tag) || (2 == _index && 102 == textField.tag)) { // 时间选择器
        if (_datePicker.superview == nil) {
            [self.view endEditing:YES];
            
            _datePicker.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216);
            [self.view addSubview:_datePicker];
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect = _datePicker.frame;
                rect.origin.y -= rect.size.height;
                _datePicker.frame = rect;
            } completion:nil];
            s = NO;;
        }
    } else {
    
        if (_datePicker.superview) {
            [_datePicker removeFromSuperview];
        }
        s = YES;
    }
    return s;
}
- (void)viewWillAppear:(BOOL)animated {
    [self hiddenTabbar:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self hiddenTabbar:NO];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (_datePicker.superview) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = _datePicker.frame;
            rect.origin.y += rect.size.height;
            _datePicker.frame = rect;
        }
         completion:^(BOOL finished) {
             [_datePicker removeFromSuperview];
         }];
            }

}
#warning 定位
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


/*
 
 
 定位和反查位置信息要加载两个动态库 CoreLocation.framework 和 MapKit.framework 一个获取坐标一个提供反查
 

 // appDelgate.h
 #import <UIKit/UIKit.h>
 #import <CoreLocation/CoreLocation.h>
 #import <MapKit/MapKit.h>
 
 @interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,MKReverseGeocoderDelegate>
 
 @property (strong, nonatomic) UIWindow *window;
 
 @end
 
 
 //
 //  AppDelegate.m
 //  location
 //
 //  Copyright (c) 2013年 TestApp. All rights reserved.
 //
 
 #import "AppDelegate.h"
 
 
 @implementation AppDelegate
 
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 {
 self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
 // Override point for customization after application launch.
 self.window.backgroundColor = [UIColor whiteColor];
 [self.window makeKeyAndVisible];
 UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
 button.frame = CGRectMake(0, 100, 100, 30);
 [button setTitle:@"定位" forState:UIControlStateNormal];
 [button addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
 
 UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 320, 30)];
 label.tag = 101;
 label.text = @"等待定位中....";
 [self.window addSubview:label];
 [label release];
 [self.window addSubview:button];
 return YES;
 
 }
 
 -(void) test {
 
 CLLocationManager *locationManager = [[CLLocationManager alloc] init];
 // 设置定位精度，十米，百米，最好
 [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
 locationManager.delegate = self;
 
 // 开始时时定位
 [locationManager startUpdatingLocation];
 }
 
 // 错误信息
 -(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
 NSLog(@"error");
 }
 
 // 6.0 以上调用这个函数
 -(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
 
 NSLog(@"%d", [locations count]);
 
 CLLocation *newLocation = locations[0];
 CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
 NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
 
 //    CLLocation *newLocation = locations[1];
 //    CLLocationCoordinate2D newCoordinate = newLocation.coordinate;
 //    NSLog(@"经度：%f,纬度：%f",newCoordinate.longitude,newCoordinate.latitude);
 
 // 计算两个坐标距离
 //    float distance = [newLocation distanceFromLocation:oldLocation];
 //    NSLog(@"%f",distance);
 
 [manager stopUpdatingLocation];
 
 //------------------位置反编码---5.0之后使用-----------------
 CLGeocoder *geocoder = [[CLGeocoder alloc] init];
 [geocoder reverseGeocodeLocation:newLocation
 completionHandler:^(NSArray *placemarks, NSError *error){
 
 for (CLPlacemark *place in placemarks) {
 UILabel *label = (UILabel *)[self.window viewWithTag:101];
 label.text = place.name;
 NSLog(@"name,%@",place.name);                       // 位置名
 //                           NSLog(@"thoroughfare,%@",place.thoroughfare);       // 街道
 //                           NSLog(@"subThoroughfare,%@",place.subThoroughfare); // 子街道
 //                           NSLog(@"locality,%@",place.locality);               // 市
 //                           NSLog(@"subLocality,%@",place.subLocality);         // 区
 //                           NSLog(@"country,%@",place.country);                 // 国家
 }
 
 }];
 
 }
 
 // 6.0 调用此函数
 -(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
 NSLog(@"%@", @"ok");
 }
 
 
 @end
 
 */


#pragma mark -
#pragma mark 详细：

/*
 
 1.CLLocationManager
 
 CLLocationManager的常用操作和属性
 
 开始用户定位- (void)startUpdatingLocation;
 
 停止用户定位- (void) stopUpdatingLocation;
 
 说明：当调用了startUpdatingLocation方法后，就开始不断地定位用户的位置，中途会频繁地调用代理的下面方法
 
 　　- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;
 
 每隔多少米定位一次
 
 　　@property(assign, nonatomic) CLLocationDistance distanceFilter;
 
 定位精确度（越精确就越耗电）
 
 　　@property(assign, nonatomic) CLLocationAccuracy desiredAccuracy;
 
 
 
 2.CLLocation
 
 CLLocation用来表示某个位置的地理信息，比如经纬度、海拔等等
 
 （1）经纬度
 
 　　@property(readonly, nonatomic) CLLocationCoordinate2D coordinate;
 
 （2）海拔
 
 　　@property(readonly, nonatomic) CLLocationDistance altitude;
 
 （3）路线，航向（取值范围是0.0° ~ 359.9°，0.0°代表真北方向）
 
 　　@property(readonly, nonatomic) CLLocationDirection course;
 
 （4）行走速度（单位是m/s）
 
 　　 @property(readonly, nonatomic) CLLocationSpeed speed;
 
 （5）计算2个位置之间的距离
 
 　　- (CLLocationDistance)distanceFromLocation:(const CLLocation *)location方法
 
 
 
 3.CLLocationCoordinate2D
 
 CLLocationCoordinate2D是一个用来表示经纬度的结构体，定义如下
 
 typedef struct {
 
 CLLocationDegrees latitude; // 纬度
 
 CLLocationDegrees longitude; // 经度
 
 } CLLocationCoordinate2D;
 
 一般用CLLocationCoordinate2DMake函数来创建CLLocationCoordinate2D
 
 
 
 二、代码示例
 
 复制代码
 1 //
 2 //  YYViewController.m
 3 //  18-定位服务
 4 //
 5 //  Created by apple on 14-8-9.
 6 //  Copyright (c) 2014年 yangyong. All rights reserved.
 7 //
 8
 9 #import "YYViewController.h"
 10 #import <CoreLocation/CoreLocation.h>
 11
 12 //需要遵守CLLocationManagerDelegate协议
 13 @interface YYViewController ()<CLLocationManagerDelegate>
 14 @property(nonatomic,strong)CLLocationManager *locMgr;
 15 @end
 16
 17 @implementation YYViewController
 18 #pragma mark-懒加载
 19 -(CLLocationManager *)locMgr
 20 {
 21     if (_locMgr==nil) {
 22         //1.创建位置管理器（定位用户的位置）
 23         self.locMgr=[[CLLocationManager alloc]init];
 24         //2.设置代理
 25         self.locMgr.delegate=self;
 26     }
 27     return _locMgr;
 28 }
 29 - (void)viewDidLoad
 30 {
 31     [super viewDidLoad];
 32
 33     //判断用户定位服务是否开启
 34     if ([CLLocationManager locationServicesEnabled]) {
 35         //开始定位用户的位置
 36         [self.locMgr startUpdatingLocation];
 37         //每隔多少米定位一次（这里的设置为任何的移动）
 38         self.locMgr.distanceFilter=kCLDistanceFilterNone;
 39         //设置定位的精准度，一般精准度越高，越耗电（这里设置为精准度最高的，适用于导航应用）
 40         self.locMgr.desiredAccuracy=kCLLocationAccuracyBestForNavigation;
 41     }else
 42     {//不能定位用户的位置
 43         //1.提醒用户检查当前的网络状况
 44         //2.提醒用户打开定位开关
 45     }
 46
 47     //测试方法，计算两个位置之间的距离
 48     [self countDistance];
 49 }
 50
 51 #pragma mark-CLLocationManagerDelegate
 52 /
   **
 53  *  当定位到用户的位置时，就会调用（调用的频率比较频繁）
 54  *
      /
55 -(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
56 {
    57     //locations数组里边存放的是CLLocation对象，一个CLLocation对象就代表着一个位置
    58    CLLocation *loc = [locations firstObject];
    59
    60     //维度：loc.coordinate.latitude
    61     //经度：loc.coordinate.longitude
    62     NSLog(@"纬度=%f，经度=%f",loc.coordinate.latitude,loc.coordinate.longitude);
    63     NSLog(@"%d",locations.count);
    64
    65     //停止更新位置（如果定位服务不需要实时更新的话，那么应该停止位置的更新）
    66 //    [self.locMgr stopUpdatingLocation];
    67
    68 }
69
70 //计算两个位置之间的距离
71 -(void)countDistance
72 {
    73     //根据经纬度创建两个位置对象
    74     CLLocation *loc1=[[CLLocation alloc]initWithLatitude:40 longitude:116];
    75     CLLocation *loc2=[[CLLocation alloc]initWithLatitude:41 longitude:116];
    76     //计算两个位置之间的距离
    77     CLLocationDistance distance=[loc1 distanceFromLocation:loc2];
    78     NSLog(@"(%@)和(%@)的距离=%fM",loc1,loc2,distance);
    79 }
80
81 @end
复制代码
打印查看：

　　

代码说明：

1.关于代理方法

　　需要设置代理，通过代理告诉用户当前的位置，有两个代理方法：

　　locations参数里面装着CLLocation对象



其中后者是一个过期的方法，在新的方法（第一个）中使用了一个数组来替代。
说明：该方法在当定位到用户的位置时就会调用，调用比较频繁
注意：不要使用局部变量（创建位置管理器），因为局部变量的方法结束它就被销毁了。建议使用一个全局的变量，且只创建一次就可以了（使用懒加载）。

2.定位的精度
　　
3.如果发现自己的定位服务没有打开，那么应该提醒用户打开定位服务功能。
4.定位服务是比较耗电的，如果是做定位服务（没必要实时更新的话），那么定位了用户位置后，应该停止更新位置。

三、用户隐私的保护
1.权限设置说明

从iOS 6开始，苹果在保护用户隐私方面做了很大的加强，以下操作都必须经过用户批准授权

（1）要想获得用户的位置

（2）想访问用户的通讯录、日历、相机、相册等

当想访问用户的隐私信息时，系统会自动弹出一个对话框让用户授权



注意：一旦用户选择了“Don’t Allow”，意味着你的应用以后就无法使用定位功能，且当用户第一次选择了之后，以后就再也不会提醒进行设置。

因此在程序中应该进行判断，如果发现自己的定位服务没有打开，那么应该提醒用户打开定位服务功能。

CLLocationManager有个类方法可以判断当前应用的定位功能是否可用+ (BOOL)locationServicesEnabled;

　　常用的方法：截图告诉用户，应该怎么打开授权
　　
2.开发者可以在Info.plist中设置NSLocationUsageDescription说明定位的目的(Privacy - Location Usage Description)

　　

说明：这里的定位服务是基于网络的。通常定位服务可以是基于GPS、基站或者是网络的。
 */
@end
