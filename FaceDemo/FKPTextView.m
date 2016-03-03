//
//  FKPTextView.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/3/1.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "FKPTextView.h"

@implementation FKPTextView
- (void)deleteBackward
{
    if (_FkpDeleteDelegate && [_FkpDeleteDelegate respondsToSelector:@selector(deleteBackward)]) {
        [_FkpDeleteDelegate deleteBackward];
    }
}
@end
