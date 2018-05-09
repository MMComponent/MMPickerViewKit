//
//  MMPickerView.h
//  MyMoney
//
//  Created by boxytt on 2018/4/15.
//  Copyright © 2018年 boxytt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMPickerViewDelegate <NSObject>

- (void)didPickedResult:(NSString *)result;

@end

@interface MMPickerView : UIView

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isIcon;
@property (nonatomic, assign) BOOL isSecond; /** 是否二级。 数组[字典{key:[values]}] */
@property (nonatomic, weak) id<MMPickerViewDelegate>delegate;

+ (instancetype)pickerView;

- (void)show;


@end
