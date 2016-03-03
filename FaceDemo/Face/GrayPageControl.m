//
//  GrayPageControl.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/3/1.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "GrayPageControl.h"

@implementation GrayPageControl
-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self setCurrentPage:1];
    return self;
}

- (id)initWithFrame:(CGRect)aFrame {
    
    if (self = [super initWithFrame:aFrame]) {
        [self setCurrentPage:1];
    }
    
    return self;
}

-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++) {
        UIView* dotView = [self.subviews objectAtIndex:i];
        
        if (i == self.currentPage)
            [dotView setBackgroundColor:[UIColor redColor]];
        else
            [dotView setBackgroundColor:[UIColor lightGrayColor]];
    }
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

@end
