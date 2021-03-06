//
//  FKScaleSliderView.h
//  FKScaleSliderView
//
//  Created by FinderTiwk on 14/12/2017.
//  Copyright © 2017 FinderTiwk. All rights reserved.
//

#import <UIKit/UIKit.h>

//刻度标题位置
typedef NS_ENUM(NSUInteger,FKScaleSliderTitlePosition) {
    /*! 位于滑杆上面,default*/
    FKScaleSliderTitlePositionTop,
    /*! 位于滑杆下面*/
    FKScaleSliderTitlePositionBottom
};

//刻度样式
typedef NS_ENUM(NSUInteger,FKScaleSliderStyle) {
    //刻度穿透,default
    FKScaleSliderStyleFull,
    //刻度只在上半部分
    FKScaleSliderStyleTop,
    //刻度只在下半部分
    FKScaleSliderStyleBottom
};

@interface FKScaleSliderView : UIView

@property (nonatomic,readonly) CGFloat sliderValue;
- (void)setSliderValue:(CGFloat)value animated:(BOOL)animated;

//Require: 刻度比例 eg: @[@(0),@(0.5),@(1)]
@property (nonatomic,strong) NSArray<NSNumber *> *scaleArray;
//Option: 刻度标题 (支持富文本)
@property (nonatomic,strong) NSArray<NSMutableAttributedString *> *titlesArray;

#pragma mark - Preferences

//刻度样式,default FTScaleSliderTitlePosition_Top
@property (nonatomic,assign) FKScaleSliderTitlePosition titlePosition;

//刻度标题位置,default FTScaleSliderStyle_Full
@property (nonatomic,assign) FKScaleSliderStyle style;

//游标颜色,deflut [UIColor grayColor]
@property (nonatomic,strong) UIColor *scaleBarColor;

//滑块图片,default nil, 系统默认的滑块样式
@property (nonatomic,strong) UIImage *thumbImage;

//是否允许点击滑动游标,default NO
@property (nonatomic,assign) BOOL enableTouch;


@end
