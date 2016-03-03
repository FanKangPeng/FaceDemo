//
//  FKPTextView.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/3/1.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FKPTextViewDelegate <NSObject>

- (void)deleteBackward;

@end

@interface FKPTextView : UITextView
@property (nonatomic ,assign) id<FKPTextViewDelegate>FkpDeleteDelegate;
@end
