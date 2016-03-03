//
//  CommunityCell.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/24.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MLLabel/MLLabel.h>
#import <MLLabel/MLLinkLabel.h>
#import <MLLabel/NSString+MLExpression.h>
#import <MLLabel/NSAttributedString+MLExpression.h>
#import <UIView+SDAutoLayout.h>
#import <UITableView+SDAutoTableViewCellHeight.h>
#import <MLTextAttachment.h>
#import "CommentModel.h"
@interface CommunityCell : UITableViewCell

@property (nonatomic,strong) UIImageView*portraitImageView;

@property (nonatomic,strong) UILabel * nameLabel;

@property (nonatomic,strong) MLLabel * concentLabel;


@property (nonatomic ,strong) NSDictionary *faceDict;

@property (nonatomic ,strong)  MLExpression *exp;

@property (nonatomic ,strong) CommentModel *commentModel;
@end
