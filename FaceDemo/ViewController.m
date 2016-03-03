//
//  ViewController.m
//  FaceDemo
//
//  Created by 樊康鹏 on 16/3/3.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "ViewController.h"
#import <UIView+SDAutoLayout.h>
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "UIViewExt.h"
#import "CommunityCell.h"
#import "CommentModel.h"
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height //主屏幕的高度
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width  //主屏幕的宽度

#define kBottomBarHeight   (49.f)
#define kNavigationHeight  (64.f)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"faceDemo";
    [self AddObserverForKeyboard];
    [self.view addSubview:self.tabView];
    [self.view bringSubviewToFront:self.tabView];
    [self.view addSubview:self.estimateListView];
    [self.view sendSubviewToBack:self.estimateListView];
    
    
    _commentArr = [NSMutableArray array];
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - private methods
- (void)faceButtonClick:(UIButton*)button
{
    _isButtonClicked = YES;
    _faceButton.selected=NO;
    
    if ([_commeunityTextView.inputView isEqual:self.faceBoard]) {
        [_commeunityTextView resignFirstResponder];
    }
    else
    {
        
        if (!_isShowKeyBoard) {
            self.faceBoard.inputTextView = _commeunityTextView;
            _commeunityTextView.inputView = self.faceBoard;
            _faceButton.selected = YES;
            [_commeunityTextView becomeFirstResponder];
        }
        else
        {
            [_commeunityTextView resignFirstResponder];
        }
    }
}
#pragma mark --- NSNotification keyboard
-(void)AddObserverForKeyboard
{
    UITapGestureRecognizer * dismissKeyBoardtap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoardtapClick:)];
    [self.view addGestureRecognizer:dismissKeyBoardtap];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
    NSValue *animationDurationValue = [[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    [UIView animateWithDuration:animationDuration animations:^{
        NSLog(@"%f",keyboardRect.size.height);
        self.tabView.top = kScreenHeight - kBottomBarHeight -keyboardRect.size.height;
    }];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSValue *animationDurationValue = [[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.tabView.top = kScreenHeight-kBottomBarHeight;
    }];
    
    
}
- (void)keyboardDidHide:(NSNotification *)notification {
    _faceButton.selected = NO;
    if (_isButtonClicked) {
        _isButtonClicked = NO;
        if (![_commeunityTextView.inputView isEqual:_faceBoard]) {
            self.faceBoard.inputTextView = _commeunityTextView;
            _commeunityTextView.inputView = self.faceBoard;
            _faceButton.selected = YES;
        }
        else
        {
            _commeunityTextView.inputView = nil;
        }
        [_commeunityTextView becomeFirstResponder];
        _isShowKeyBoard = YES;
    }
    else
        _isShowKeyBoard = NO;
}
-(void)dismissKeyBoardtapClick:(UITapGestureRecognizer*)tap
{
    _isButtonClicked = NO;
    _commeunityTextView.inputView = nil;
    [self.commeunityTextView resignFirstResponder];
    
}
- (void)sendComment
{
    _isButtonClicked = NO;
    _commeunityTextView.inputView = nil;
    [self.commeunityTextView resignFirstResponder];
    if (self.commeunityTextView.text.length>0) {
        NSDictionary * dict =@{@"name":@"阿狸",@"content": self.commeunityTextView.text};
        [_commentArr addObject:dict];
        [self.estimateListView reloadData];
        _commeunityTextView.text = @"";
    }
}
#pragma mark - UITableView delegate and dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
    return _commentArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height =[self.estimateListView  cellHeightForIndexPath:indexPath model:[CommentModel mj_objectWithKeyValues:_commentArr[indexPath.section]] keyPath:@"commentModel" cellClass:[CommunityCell class] contentViewWidth:kScreenWidth];
    
    return height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"Cell";
    CommunityCell * cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[CommunityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    CommentModel * model = [CommentModel mj_objectWithKeyValues:_commentArr[indexPath.section]];
    cell.commentModel = model;
    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
#pragma mark - UITextView delegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _isShowKeyBoard  = YES;
    if ([textView.textColor isEqual:[UIColor grayColor]]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    
    if (textView.text.length == 0) {
        _commeunityTextView.textColor = [UIColor grayColor];
        _commeunityTextView .text = @"发表一下您的评论";
    }
}
#pragma mark - FKPTextView
- (void)deleteBackward
{
    NSString *string = nil;
    NSString * inputString = _commeunityTextView.text;
    NSInteger stringLength = _commeunityTextView.text.length;
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
    _commeunityTextView.text =  string;
    
}
#pragma mark - setter and getter
-(UIView *)tabView
{
    if(!_tabView)
        
    {
        _tabView  =[[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kBottomBarHeight, kScreenWidth, kBottomBarHeight)];
        [_tabView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel * line  =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,  (1/[UIScreen mainScreen].scale) )];
        [line setBackgroundColor:[UIColor lightGrayColor]];
        [_tabView addSubview:line];
        [_tabView addSubview:self.faceButton];
        [_tabView addSubview:self.sendButton];
        [_tabView addSubview:self.commeunityTextView];
        
    }
    return _tabView;
}
-(UIButton *)sendButton
{
    if(!_sendButton)
    {
        _sendButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setFrame:CGRectMake(kScreenWidth-50, 0, 50, kBottomBarHeight)];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_sendButton addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchDown];
    }
    return _sendButton;
}
- (FKPTextView *)commeunityTextView
{
    if(!_commeunityTextView)
    {
        _commeunityTextView =[[FKPTextView alloc] initWithFrame:CGRectMake(50,7, kScreenWidth-100, 35)];
        _commeunityTextView.layer.borderColor = [UIColor grayColor].CGColor;
        _commeunityTextView.layer.borderWidth =  (1/[UIScreen mainScreen].scale) ;
        _commeunityTextView.layer.cornerRadius = 3;
        _commeunityTextView.layer.masksToBounds = YES;
        _commeunityTextView.delegate = self;
        _commeunityTextView.FkpDeleteDelegate=self;
        _commeunityTextView.text =@"发表一下您的评论";
        _commeunityTextView.delegate =self;
        _commeunityTextView.font = [UIFont systemFontOfSize:14];
        _commeunityTextView.textColor = [UIColor grayColor];
        _commeunityTextView.returnKeyType = UIReturnKeySend;
        _isSystemBoardShow = NO;
    }
    return _commeunityTextView;
}
-(UITableView *)estimateListView
{
    if (!_estimateListView) {
        _estimateListView =[[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight-kBottomBarHeight) style:UITableViewStylePlain];
        _estimateListView.delegate =self;
        _estimateListView.dataSource =self;
        if([_estimateListView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_estimateListView setSeparatorInset:UIEdgeInsetsZero];
        }
        if([_estimateListView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [_estimateListView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        UIView * view =[UIView new];
        [view setBackgroundColor:[UIColor clearColor]];
        _estimateListView.tableFooterView =view;

    }
    return _estimateListView;
}
- (FaceBoard *)faceBoard
{
    if (!_faceBoard) {
        _faceBoard = [[FaceBoard alloc] init];
    }
    return _faceBoard;
}
- (UIButton *)faceButton
{
    if (!_faceButton) {
        _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_faceButton setFrame:CGRectMake(0, 5, 50, 40)];
        [_faceButton setImage:[UIImage imageNamed:@"icon_keyboard_face"] forState:UIControlStateNormal];
        [_faceButton setImage:[UIImage imageNamed:@"icon_send_keyboard"] forState:UIControlStateSelected];
        [_faceButton addTarget:self action:@selector(faceButtonClick:) forControlEvents:UIControlEventTouchDown];
    }
    return _faceButton;
}
#pragma mark - 内存警告

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
