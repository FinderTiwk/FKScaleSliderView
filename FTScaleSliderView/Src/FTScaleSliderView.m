//
//  FTScaleSliderView.m
//  FTScaleSliderView
//
//  Created by FinderTiwk on 14/12/2017.
//  Copyright © 2017 FinderTiwk. All rights reserved.
//

#import "FTScaleSliderView.h"

@interface FTScaleSliderView()
@property (nonatomic,strong,readwrite) UISlider *slider;
@end

@implementation FTScaleSliderView

#pragma mark - Construction
- (instancetype)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        [self prepare];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self prepare];
}

- (void)prepare{
    self.backgroundColor = [UIColor whiteColor];
    self.slider = [[UISlider alloc] init];
    self.slider.maximumValue = 1.0f;
    self.slider.minimumValue = 0.0f;
    [self.slider setMinimumTrackTintColor:[UIColor clearColor]];
    [self.slider setMaximumTrackTintColor:[UIColor clearColor]];
    
    self.scaleBarColor = [UIColor grayColor];
}

#pragma mark - OverRide
- (void)drawRect:(CGRect)rect {
    NSParameterAssert(self.scaleArray);
    if (self.titlesArray) {
        NSParameterAssert(self.scaleArray.count == self.titlesArray.count);
    }
    
    CGSize size = rect.size;
    BOOL hasTitle = (self.titlesArray.count > 0);
    CGFloat titleHeight = hasTitle?20.f:0.f;
    
    CGFloat titleY  = 0;
    CGFloat sliderY = hasTitle?titleHeight:0.f;
    if (self.titlePosition == FTScaleSliderTitlePosition_Bottom) {
        titleY = size.height - titleHeight;
        sliderY = 0;
    }
    
    CGFloat sliderAreaViewHeight = size.height - titleHeight;
    self.slider.frame = CGRectMake(0,sliderY, size.width, sliderAreaViewHeight);
    
    if (self.thumbImage) {
        [self.slider setThumbImage:self.thumbImage forState:UIControlStateNormal];
    }
    
    
    [self.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    
    if (self.enableTouch) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderWasTouch:)];
        [self.slider addGestureRecognizer:gesture];
    }
    [self addSubview:self.slider];
    
    CGRect trackRect = [self.slider trackRectForBounds:self.slider.bounds];
    CGRect thumbRect = [self.slider thumbRectForBounds:self.slider.bounds trackRect:trackRect value:0];
    CGSize thumbSize = thumbRect.size;
    
    CGSize trackSize = trackRect.size;
    CGPoint trackOrigin = trackRect.origin;
    
    CGFloat padding = trackOrigin.x + thumbSize.width/2;
    CGFloat sliderWidth = trackSize.width - thumbSize.width;
    
    CGFloat cursorHeigh = thumbSize.height * 0.4;
    CGFloat startX = padding;
    CGFloat startY = sliderY + thumbRect.origin.y + thumbSize.height/2 - cursorHeigh/2;
    if (self.style == FTScaleSliderStyle_Bottom) {
        startY =  sliderY + thumbRect.origin.y + thumbSize.height/2;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, self.scaleBarColor.CGColor);
    
    CGContextBeginPath(context);
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    NSUInteger scaleIndex = 0;
    
    NSUInteger count = self.scaleArray.count;
    for (NSUInteger index = 0; index < (2*count -1); index ++) {
        
        if (index % 2 == 0) {
            //如果有标题,则计算标题Label的位置并添加
            if (hasTitle) {
                NSMutableAttributedString *text = self.titlesArray[scaleIndex];
                CGFloat textWidth = [self widthForAttributedString:text
                                                         maxHeight:titleHeight];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(startX - textWidth/2, titleY, textWidth, titleHeight)];
                label.textAlignment = NSTextAlignmentCenter;
                label.attributedText = text;
                [self addSubview:label];
            }
            
            //画刻度
            [bezierPath moveToPoint:CGPointMake(startX, startY)];
            if (self.style == FTScaleSliderStyle_Full) {
                [bezierPath addLineToPoint:CGPointMake(startX, startY + cursorHeigh)];
            }else{
                [bezierPath addLineToPoint:CGPointMake(startX, startY + cursorHeigh/2)];
            }
        }else{
            CGFloat tmpStartY = startY + cursorHeigh/2;
            if (self.style == FTScaleSliderStyle_Bottom) {
                tmpStartY = startY;
            }
            //画连接线
            [bezierPath moveToPoint:CGPointMake(startX, tmpStartY)];
            NSNumber *number = self.scaleArray[++scaleIndex];
            CGFloat scale = [number floatValue];
            startX = padding + scale*sliderWidth;
            [bezierPath addLineToPoint:CGPointMake(startX, tmpStartY)];
        }
    }
    CGContextAddPath(context, bezierPath.CGPath);
    CGContextDrawPath(context, kCGPathStroke);
}


- (CGFloat)widthForAttributedString:(NSAttributedString *)text
                          maxHeight:(CGFloat)maxHeight {
    
    if ([text isKindOfClass:[NSString class]] && !text.length) {
        return 0;
    }
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize size = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,maxHeight)
                                     options:options
                                     context:nil].size;
    // add 1 point as padding
    CGFloat width = ceilf(size.height) + 1;
    return width;
}

#pragma mark - Slider Actions
- (void)sliderValueChange:(UISlider *)sender{
    CGFloat value = sender.value;
    [self.slider setValue:[self fixSliderValue:value] animated:YES];
}

- (void)sliderWasTouch:(UITapGestureRecognizer *)gesture{
    CGPoint touchPoint = [gesture locationInView:self.slider];
    CGFloat value = touchPoint.x/(self.bounds.size.width);
    [self.slider setValue:[self fixSliderValue:value] animated:YES];
}


- (CGFloat)fixSliderValue:(CGFloat)value{
    
    NSUInteger count = self.scaleArray.count;
    CGFloat fixValue = 0;
    for (NSUInteger index = 0; index < count-1; index ++) {
        CGFloat scale1 = [self.scaleArray[index] floatValue];
        CGFloat scale2 = [self.scaleArray[index+1] floatValue];
        if (value >= scale1 && value <= (scale1 + scale2)/2) {
            fixValue = scale1;
            break;
        }
        if (value > (scale1 + scale2)/2 && value <= scale2) {
            fixValue = scale2;
            break;
        }
    }
    self->_sliderValue = fixValue;
    return fixValue;
}

- (void)setSliderValue:(CGFloat)value animated:(BOOL)animated{
    CGFloat fixValue = [self fixSliderValue:value];
    [self.slider setValue:fixValue animated:animated];
}

@end
