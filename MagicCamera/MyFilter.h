//
//  MyFilter.h
//  MagicCamera
//
//  Created by SongWentong on 2/29/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

#import "GPUImageFilter.h"

@interface MyFilter : GPUImageFilter
{
    GLint myUniform;
}
@property(nonatomic) CGFloat texelWidthOffset;
@property(nonatomic) CGFloat texelHeightOffset; 
@end
