//
//  CustomMoreSeletoerButton.m
//  chatdemo
//
//  Created by lixuan on 15/3/2.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "CustomMoreSeletoerButton.h"

@implementation CustomMoreSeletoerButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        

        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        //        boundingRect=[self.titleLabel.text boundingRectWithSize:CGSizeMake(320,14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    }
    return self;
}


- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    return CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height *2/3-2);
    
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    
    
    return CGRectMake(5, self.frame.size.height *2/3+2, self.frame.size.width - 10, self.frame.size.height /3);
    
}

@end
