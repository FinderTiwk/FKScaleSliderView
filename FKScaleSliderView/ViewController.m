//
//  ViewController.m
//  FKScaleSliderView
//
//  Created by FinderTiwk on 14/12/2017.
//  Copyright © 2017 FinderTiwk. All rights reserved.
//

#import "ViewController.h"
#import "FKScaleSliderView.h"

@interface ViewController ()
//xib初始化
@property (weak, nonatomic) IBOutlet FKScaleSliderView *xibXcaleSlider;

//code初始化
@property (strong, nonatomic) FKScaleSliderView *codeScaleSlider;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.codeScaleSlider = [[FKScaleSliderView alloc] initWithFrame:CGRectMake(30, 200, 300, 70)];
    self.codeScaleSlider.titlePosition = FKScaleSliderTitlePositionBottom;
    self.codeScaleSlider.style = FKScaleSliderStyleFull;
    self.codeScaleSlider.thumbImage = [UIImage imageNamed:@"font_slider_thumb"];
    [self setupScaleSlider:self.codeScaleSlider];
    [self.view addSubview:self.codeScaleSlider];
    
    
    self.xibXcaleSlider.scaleBarColor = [UIColor greenColor];
    self.xibXcaleSlider.titlePosition = FKScaleSliderTitlePositionTop;
    self.xibXcaleSlider.style = FKScaleSliderStyleTop;
    [self setupScaleSlider:self.xibXcaleSlider];
}

- (void)setupScaleSlider:(FKScaleSliderView *)sliderView{
    
    
    sliderView.enableTouch = YES;
    sliderView.scaleArray = @[@(0),@(0.25),@(0.5),@(0.75),@(1.0)];
    
    UIColor *fontColor = [UIColor colorWithRed:67/255.0
                                         green:74/255.0
                                          blue:84/255.0
                                         alpha:1/1.0];
    
    NSMutableArray *attributedStrings = [NSMutableArray arrayWithCapacity:3];
    {
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        NSMutableAttributedString *aString = [self buildAttributedString:@"A"
                                                                    font:font
                                                                   color:fontColor];
        [attributedStrings addObject:aString];
    }
    
    {
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        NSMutableAttributedString *aString = [self buildAttributedString:@"A"
                                                                    font:font
                                                                   color:fontColor];
        [attributedStrings addObject:aString];
    }
    
    {
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:24];
        NSMutableAttributedString *aString = [self buildAttributedString:@"B"
                                                                    font:font
                                                                   color:fontColor];
        [attributedStrings addObject:aString];
    }
    
    {
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:24];
        NSMutableAttributedString *aString = [self buildAttributedString:@"C"
                                                                    font:font
                                                                   color:fontColor];
        [attributedStrings addObject:aString];
    }
    
    {
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:24];
        NSMutableAttributedString *aString = [self buildAttributedString:@"A"
                                                                    font:font
                                                                   color:fontColor];
        [attributedStrings addObject:aString];
    }
    sliderView.titlesArray = attributedStrings;
    [sliderView setSliderValue:0.8 animated:NO];
}

- (NSMutableAttributedString *)buildAttributedString:(NSString *)aString
                                                font:(UIFont *)font
                                               color:(UIColor *)fontColor{
    
    NSRange renderRange = NSMakeRange(0, aString.length);
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:aString];
    [attributedStr addAttribute:NSFontAttributeName
                          value:font
                          range:renderRange];
    
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:fontColor
                          range:renderRange];
    
    return attributedStr;
}

@end
