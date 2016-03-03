//
//  FaceBoard.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/3/1.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrayPageControl.h"
#import "FaceButton.h"
@interface FaceBoard : UIView<UIScrollViewDelegate>
{
    UIScrollView *faceView;
    GrayPageControl *facePageControl;
    NSDictionary *_faceMap;
}
@property (nonatomic, retain) UITextField *inputTextField;
@property (nonatomic, retain) UITextView *inputTextView;
@property (nonatomic ,strong) NSArray * imgArr;
@end
