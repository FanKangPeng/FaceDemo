//
//  FaceBoard.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/3/1.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "FaceBoard.h"
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height //主屏幕的高度
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width  //主屏幕的宽度
@implementation FaceBoard
@synthesize inputTextField = _inputTextField;
@synthesize inputTextView = _inputTextView;


- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, 216)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1];
        
      
        
        _faceMap = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Expression_Antitone" ofType:@"plist"]];
        
        
        //表情盘
        faceView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 190)];
        faceView.pagingEnabled = YES;
        faceView.contentSize = CGSizeMake((100/28+1)*kScreenWidth, 190);
        faceView.showsHorizontalScrollIndicator = NO;
        faceView.showsVerticalScrollIndicator = NO;
        faceView.delegate = self;
        
        for (int i = 1; i<=100; i++) {
       
            FaceButton *faceButton = [FaceButton buttonWithType:UIButtonTypeCustom];
            faceButton.buttonIndex = i;
            
            [faceButton addTarget:self
                           action:@selector(faceButton:)
                 forControlEvents:UIControlEventTouchUpInside];
            
            //计算每一个表情按钮的坐标和在哪一屏
            CGFloat xxx = kScreenWidth/7;
            faceButton.frame = CGRectMake((((i-1)%28)%7)*xxx+6+((i-1)/28*kScreenWidth), (((i-1)%28)/7)*44+8, xxx, 44);
            
            [faceButton setImage:[UIImage imageWithContentsOfFile:self.imgArr[i-1]] forState:UIControlStateNormal];
            [faceView addSubview:faceButton];
        }
        
        //添加PageControl
        facePageControl = [[GrayPageControl alloc]initWithFrame:CGRectMake(kScreenWidth/2-50, 190, 100, 20)];
        
        [facePageControl addTarget:self
                            action:@selector(pageChange:)
                  forControlEvents:UIControlEventValueChanged];
        
        facePageControl.numberOfPages = 100/28+1;
        facePageControl.currentPage = 0;
        [self addSubview:facePageControl];
        
        //添加键盘View
        [self addSubview:faceView];
        
        //删除键
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        [back setTitle:@"删除" forState:UIControlStateNormal];
        [back setImage:[UIImage imageNamed:@"backFace"] forState:UIControlStateNormal];
        [back setImage:[UIImage imageNamed:@"backFaceSelect"] forState:UIControlStateSelected];
        [back addTarget:self action:@selector(backFace) forControlEvents:UIControlEventTouchUpInside];
        back.frame = CGRectMake(kScreenWidth-40, 185, 38, 27);
        [self addSubview:back];
        
    }
    return self;
}

//停止滚动的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [facePageControl setCurrentPage:faceView.contentOffset.x/kScreenWidth];
    [facePageControl updateCurrentPageDisplay];
}

- (void)pageChange:(id)sender {
    [faceView setContentOffset:CGPointMake(facePageControl.currentPage*kScreenWidth, 0) animated:YES];
    [facePageControl setCurrentPage:facePageControl.currentPage];
}

- (void)faceButton:(id)sender {
    int i = (int)((FaceButton*)sender).buttonIndex;
    if (self.inputTextField) {
        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextField.text];
        [faceString appendString:[_faceMap objectForKey:[NSString stringWithFormat:@"Expression_%d",i]]];
        self.inputTextField.text = faceString;
     
    }
    if (self.inputTextView) {
        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextView.text];
        [faceString appendString:[_faceMap objectForKey:[NSString stringWithFormat:@"Expression_%d",i]]];
        self.inputTextView.text = faceString;
    }
}

- (void)backFace{
    NSString *inputString;
    inputString = self.inputTextField.text;
    if (self.inputTextView) {
        inputString = self.inputTextView.text;
    }
    
    NSString *string = nil;
    NSInteger stringLength = inputString.length;
    if (stringLength > 0) {
        if ([@"]" isEqualToString:[inputString substringFromIndex:stringLength-1]]) {
            if ([inputString rangeOfString:@"["].location == NSNotFound){
                string = [inputString substringToIndex:stringLength - 1];
            } else {
                string = [inputString substringToIndex:[inputString rangeOfString:@"[" options:NSBackwardsSearch].location];
            }
        } else {
            string = [inputString substringToIndex:stringLength - 1];
        }
    }
    self.inputTextField.text = string;
    self.inputTextView.text = string;
}
- (NSArray *)imgArr
{
    if (!_imgArr) {
        NSString  *bundlePath = [[ NSBundle   mainBundle ]. resourcePath stringByAppendingPathComponent : @"ClippedExpression.bundle" ];
        
        NSBundle  *bundle = [ NSBundle   bundleWithPath :bundlePath];
        
        _imgArr = [bundle pathsForResourcesOfType:@".png" inDirectory:nil];
        
        
        NSArray * arrr = [_imgArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return  [obj1 compare:obj2 options:NSNumericSearch];
        }];
    
        
        _imgArr = [NSArray arrayWithArray:arrr];
        
    }
    return _imgArr;
}
@end
