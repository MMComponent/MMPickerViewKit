//
//  IconPickerView.m
//  MyMoney
//
//  Created by boxytt on 2018/4/15.
//  Copyright © 2018年 boxytt. All rights reserved.
//

#import "MMPickerView.h"

#define YLSRect(x, y, w, h)  CGRectMake([UIScreen mainScreen].bounds.size.width * x, [UIScreen mainScreen].bounds.size.height * y, [UIScreen mainScreen].bounds.size.width * w,  [UIScreen mainScreen].bounds.size.height * h)
#define YLSFont(f) [UIFont systemFontOfSize:[UIScreen mainScreen].bounds.size.width * f]
#define YLSColorAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define YLSMainBackColor [UIColor colorWithRed:240/255.0 green:239/255.0 blue:245/255.0 alpha:1]
#define BlueColor [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1]
#define ClearColor [UIColor clearColor]


@interface MMPickerView() <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSString *result;

@property(nonatomic,assign) NSInteger firstIndex; /** 记录一级 */


@end


@implementation MMPickerView

//快速创建
+ (instancetype)pickerView {
    return [[self alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:YLSRect(0, 0, 1, 917/667)]) {
        self.backgroundColor = YLSColorAlpha(0, 0, 0, 0.4);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.topView = [[UIView alloc]initWithFrame:YLSRect(0, 667/667, 1, 250/667)];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topView];
    
    //为view上面的两个角做成圆角。不喜欢的可以注掉
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.topView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.topView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.topView.layer.mask = maskLayer;
    
    self.doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.doneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.doneBtn setFrame:YLSRect(320/375, 5/667, 50/375, 40/667)];
    [self.doneBtn addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.doneBtn];
    
    UILabel *titlelb = [[UILabel alloc]initWithFrame:YLSRect(100/375, 0, 175/375, 50/667)];
    titlelb.backgroundColor = ClearColor;
    titlelb.textAlignment = NSTextAlignmentCenter;
    titlelb.text = self.title;
    titlelb.font = YLSFont(20/375);
    [self.topView addSubview:titlelb];
    
    self.pickerView = [[UIPickerView alloc]init];
    [self.pickerView setFrame:YLSRect(0, 50/667, 1, 200/667)];
    [self.pickerView setBackgroundColor:YLSMainBackColor];
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    [self.topView addSubview:self.pickerView];
    
}

// 返回选择器有几列.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.isSecond) {
        return 2;
    } else {
        return 1;
    }
}

// 返回每组有几行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.isSecond) {
        if (component == 0) {
            return self.array.count;
        } else{
            return [[self.array[self.firstIndex] allValues][0] count];
        }

    } else {
        return self.array.count;
    }
}

#pragma mark - 代理

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 60;
}

// 返回第component列第row行的内容（标题）
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.isSecond) {
        if (component == 0) {
            return [self.array[row] allKeys][0];
        } else{
            return [self.array[self.firstIndex] allValues][0][row];
        }
        
    } else {
        return self.array[row];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    if (self.isIcon) {
        UIImageView* pickerImageView = (UIImageView *)view;
        if (!pickerImageView) {
            pickerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 40, 40)];
        }
        pickerImageView.image = [UIImage imageNamed:[self pickerView:pickerView titleForRow:row forComponent:component]];
        
        return pickerImageView;
    } else {
        UILabel* pickerLabel = (UILabel *)view;
        if (!pickerLabel) {
            pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 150, 40)];
            pickerLabel.textAlignment = NSTextAlignmentCenter;
        }
        pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
        
        return pickerLabel;
        
    }

}

// 选中第component第row的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.isSecond) {
        
        NSString *key;
        NSString *value;
        
        if (component == 0) {
            self.firstIndex = [pickerView selectedRowInComponent:0];
            [pickerView reloadComponent:1];
        }
        key = [self.array[self.firstIndex] allKeys][0];
        value = (component == 1) ? [self.array[self.firstIndex] allValues][0][row] : [self.array[self.firstIndex] allValues][0][0];
        self.result = [NSString stringWithFormat:@"%@ > %@", key, value];
        
    } else {
        self.result = self.array[row];
    }
}

//弹出
- (void)show {
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

//添加弹出移除的动画效果
- (void)showInView:(UIView *)view {
    // 浮现
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint point = self.center;
        point.y -= 250;
        self.center = point;
    } completion:^(BOOL finished) {
    }];
    [view addSubview:self];
}

- (void)quit {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        CGPoint point = self.center;
        point.y += 250;
        self.center = point;
    } completion:^(BOOL finished) {
        if (!self.result && !self.isSecond) {
            self.result = self.array[0];
        }
        if (!self.result && self.isSecond) {
            self.result = [NSString stringWithFormat:@"%@ > %@", [self.array[0] allKeys][0],  [self.array[0] allValues][0][0]];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPickedResult:)]) {
            [self.delegate didPickedResult:self.result];
        }
        [self removeFromSuperview];
    }];
}



@end
