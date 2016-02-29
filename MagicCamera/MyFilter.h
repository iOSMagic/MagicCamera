//
//  MyFilter.h
//  MagicCamera
//
//  Created by SongWentong on 2/29/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

#import "GPUImageTwoInputFilter.h"

@interface MyFilter : GPUImageTwoInputFilter
{
    GLint mixUniform;
}
@property(nonatomic) CGFloat texelWidthOffset;
@property(nonatomic) CGFloat texelHeightOffset;
@property(readwrite, nonatomic) CGFloat mix;

@end
