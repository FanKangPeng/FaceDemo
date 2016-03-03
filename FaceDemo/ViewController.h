//
//  ViewController.h
//  FaceDemo
//
//  Created by 樊康鹏 on 16/3/3.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceBoard.h"
#import "FKPTextView.h"
#import <MJExtension.h>
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,FKPTextViewDelegate>

@property (nonatomic ,strong) NSMutableArray * commentArr;
@property (nonatomic ,strong) UITableView *estimateListView;




@property (nonatomic ,strong) FaceBoard *faceBoard;
@property (nonatomic ,strong) UIButton *faceButton;

@property (nonatomic ,strong) UIView *tabView;
@property (nonatomic ,strong) FKPTextView *commeunityTextView;
@property (nonatomic ,strong) UIButton *sendButton;
@property (nonatomic ,assign) BOOL isShowKeyBoard;
@property (nonatomic ,assign) BOOL isButtonClicked;
@property (nonatomic ,assign) BOOL isSystemBoardShow;
@end

