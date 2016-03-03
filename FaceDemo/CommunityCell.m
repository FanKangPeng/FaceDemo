//
//  CommunityCell.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/24.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "CommunityCell.h"

#define KLeft 10
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height //主屏幕的高度
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width  //主屏幕的宽度
#define kScreenBounds [UIScreen mainScreen].bounds               //主屏幕bounds
#define kBottomBarHeight   (49.f)
#define kNavigationHeight  (64.f)
@implementation CommunityCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self initView];
    return  self;
}
- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KLeft*2,KLeft,40,40)];
        [_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
        [_portraitImageView.layer setMasksToBounds:YES];
        [_portraitImageView setContentMode:UIViewContentModeScaleToFill];
        [_portraitImageView setClipsToBounds:YES];
        _portraitImageView .image = [UIImage imageNamed:@"Expression_31.png"];
        _portraitImageView.layer.shadowColor = [UIColor whiteColor].CGColor;
        _portraitImageView.layer.shadowOffset = CGSizeMake(0, 0);
        _portraitImageView.layer.shadowOpacity = 0;
        _portraitImageView.layer.shadowRadius = 0;
        _portraitImageView.layer.borderColor =[UIColor whiteColor].CGColor;
        _portraitImageView.layer.borderWidth = 1;
        _portraitImageView.userInteractionEnabled = YES;
        _portraitImageView.backgroundColor =  [UIColor whiteColor];
    }
    return _portraitImageView;
}
-(void)initView
{
    [self.contentView addSubview:self.portraitImageView];
    _portraitImageView.sd_layout
    .leftSpaceToView(self.contentView,KLeft)
    .topSpaceToView(self.contentView,KLeft)
    .heightIs(40)
    .widthIs(40);
    
    _nameLabel =[[UILabel alloc] init];
    _nameLabel.font =[UIFont systemFontOfSize:13];
   
    _nameLabel.textColor =[UIColor grayColor];

    [self.contentView addSubview:_nameLabel];
    _nameLabel.sd_layout
    .leftSpaceToView(_portraitImageView,KLeft)
    .topSpaceToView(self.contentView,KLeft+3)
    .heightIs(15)
    .widthIs(200);
    
    
 
    
    [self.contentView addSubview:self.concentLabel];
    _concentLabel.sd_layout
    .leftSpaceToView(_portraitImageView,KLeft)
    .topSpaceToView(_portraitImageView,KLeft)
    .rightSpaceToView(self.contentView,KLeft);
    

    
      [self setupAutoHeightWithBottomView:_concentLabel bottomMargin:8];

}


- (void)setCommentModel:(CommentModel *)commentModel
{
    _commentModel = commentModel;
    _nameLabel.text = commentModel.name;

    _concentLabel.attributedText = [commentModel.content expressionAttributedStringWithExpression:self.exp];
    CGSize size = [_concentLabel sizeThatFits:CGSizeMake(kScreenWidth- _portraitImageView.right -KLeft, MAXFLOAT)];
    _concentLabel.sd_layout
    .leftSpaceToView(_portraitImageView,KLeft)
    .heightIs(size.height)
    .rightSpaceToView(self.contentView,KLeft);
    
}
- (MLLabel *)concentLabel
{
    if (!_concentLabel) {
        _concentLabel = [MLLabel new];
        _concentLabel.textColor =  [UIColor blackColor];
        _concentLabel.font = [UIFont systemFontOfSize:13];
        _concentLabel.numberOfLines = 0;
        _concentLabel.lineBreakMode=  NSLineBreakByTruncatingTail;
    }
    return _concentLabel;
}
- (MLExpression *)exp
{
    if (!_exp) {
        _exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"Expression" bundleName:@"ClippedExpression"];
    }
    return _exp;
}


- (NSDictionary *)faceDict
{
    if (!_faceDict) {
        _faceDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"FaceMap_Antitone" ofType:@"plist"]];
    }
    return _faceDict;
}

@end
