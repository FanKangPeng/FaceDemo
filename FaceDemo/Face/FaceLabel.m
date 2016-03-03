//
//  FaceLabel.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/3/2.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "FaceLabel.h"

@implementation FaceLabel
- (void)setText:(NSString *)text
{
    NSLog(@"%@",text);
 
    NSArray * faceStringArr = [text componentsSeparatedByString:@"["];
    
    
    for (NSString * faceString in faceStringArr) {
        NSRange range = [faceString rangeOfString:@"]"];
        if (range.location != NSNotFound) {
            NSString * fece = [faceString substringWithRange:NSMakeRange(0,range.location)];
            fece = [NSString stringWithFormat:@"[%@]",fece];
            NSString * faceName =[self.faceDict objectForKey:fece];
            if (faceName.length > 0) {
                text =  [text stringByReplacingOccurrencesOfString:fece withString:faceName];
            }
        }
    }
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:7];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [attributedString1 length])];
    [self setAttributedText:attributedString1];
    [self sizeToFit];

}

-(void)getImageRange:(NSString*)message : (NSMutableArray*)array {
    NSRange range=[message rangeOfString: @"["];
    NSRange range1=[message rangeOfString: @"]"];
    //判断当前字符串是否还有表情的标志。
    if (range.length>0 && range1.length>0) {
        if (range.location > 0) {
            [array addObject:[message substringToIndex:range.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            NSString *str=[message substringFromIndex:range1.location+1];
            [self getImageRange:str :array];
        }else {
            NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            //排除文字是“”的
            if (![nextstr isEqualToString:@""]) {
                [array addObject:nextstr];
                NSString *str=[message substringFromIndex:range1.location+1];
                [self getImageRange:str :array];
            }else {
                return;
            }
        }
        
    } else if (message != nil) {
        [array addObject:message];
    }
}
#define KFacialSizeWidth  18
#define KFacialSizeHeight 18
#define MAX_WIDTH 150
-(UIView *)assembleMessageAtIndex : (NSString *) message from:(BOOL)fromself
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self getImageRange:message :array];
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    NSArray *data = array;
    UIFont *fon = [UIFont systemFontOfSize:13.0f];
    CGFloat upX = 0;
    CGFloat upY = 0;
    CGFloat X = 0;
    CGFloat Y = 0;
    if (data) {
        for (int i=0;i < [data count];i++) {
            NSString *str=[data objectAtIndex:i];
            NSLog(@"str--->%@",str);
            if ([str hasPrefix: @"["] && [str hasSuffix: @"]"])
            {
                if (upX >= MAX_WIDTH)
                {
                    upY = upY + KFacialSizeHeight;
                    upX = 0;
                    X = 150;
                    Y = upY;
                }
                NSLog(@"str(image)---->%@",str);
                NSString *imageName=[str substringWithRange:NSMakeRange(2, str.length - 3)];
                UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
                img.frame = CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight);
                [returnView addSubview:img];
              
                upX=KFacialSizeWidth+upX;
                if (X<150) X = upX;
                
                
            } else {
                for (int j = 0; j < [str length]; j++) {
                    NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                    if (upX >= MAX_WIDTH)
                    {
                        upY = upY + KFacialSizeHeight;
                        upX = 0;
                        X = 150;
                        Y =upY;
                    }
                    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,150,40)];
                    la.font = fon;
                    la.text = temp;
                    CGSize size = [la sizeThatFits:CGSizeMake(150, 40)];
                    la.frame = CGRectMake(upX,upY,size.width,size.height);
                    la.backgroundColor = [UIColor clearColor];
                    [returnView addSubview:la];
               
                    upX=upX+size.width;
                    if (X<150) {
                        X = upX;
                    }
                }
            }
        }
    }
    returnView.frame = CGRectMake(15.0f,1.0f, X, Y); //@ 需要将该view的尺寸记下，方便以后使用
    NSLog(@"%.1f %.1f", X, Y);
    return returnView;
}
- (NSDictionary *)faceDict
{
    if (!_faceDict) {
        _faceDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"FaceMap_Antitone" ofType:@"plist"]];
    }
    return _faceDict;
}
@end
