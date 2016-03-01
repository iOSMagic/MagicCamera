//
//  MosaicView.h
//  MagicCamera
//
//  Created by xushuigen on 16/2/25.
//  Copyright © 2016年 SongWentong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ImageOpertionType)
{
    ImageOpertionType_Mosaic,
    ImageOpertionType_Clean,
};

@interface MosaicView : UIView

@property(nonatomic) ImageOpertionType opertionType;
@property(nonatomic) CGFloat mosaicLineWidth; //马赛克线宽
@property(nonatomic) CGFloat cleanLineWidth;  //清除线宽

-(instancetype)initWithMosaicImage:(UIImage *)mosaicImage andFrame:(CGRect)frame;

-(void)savePhoto;

@end
