//
//  MyFilter.m
//  MagicCamera
//
//  Created by SongWentong on 2/29/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

#import "MyFilter.h"
/*

 */


NSString *const myfilter = SHADER_STRING
(
 attribute vec4 position;
 attribute vec4 inputTextureCoordinate;
 const int GAUSSIAN_SAMPLES = 9;
 uniform float texelWidthOffset;
 uniform float texelHeightOffset;
 varying vec2 textureCoordinate;
 varying vec2 blurCoordinates[GAUSSIAN_SAMPLES];
 void main() {
     gl_Position = position;
     textureCoordinate = inputTextureCoordinate.xy;
     int multiplier = 0;
     vec2 blurStep; vec2
     singleStepOffset = vec2(texelWidthOffset, texelHeightOffset);
     for (int i = 0; i < GAUSSIAN_SAMPLES; i++) { multiplier = (i - ((GAUSSIAN_SAMPLES - 1) / 2)); blurStep = float(multiplier) * singleStepOffset; blurCoordinates[i] = inputTextureCoordinate.xy + blurStep;
     }
 }
 uniform sampler2D inputImageTexture;
 const lowp int GAUSSIAN_SAMPLES = 9;
 varying highp vec2 textureCoordinate;
 varying highp vec2 blurCoordinates[GAUSSIAN_SAMPLES];
 void main() {
     lowp vec4 sum = vec4(0.0);
     sum += texture2D(inputImageTexture, blurCoordinates[0]) * 0.05;
     sum += texture2D(inputImageTexture, blurCoordinates[1]) * 0.09;
     sum += texture2D(inputImageTexture, blurCoordinates[2]) * 0.12;
     sum += texture2D(inputImageTexture, blurCoordinates[3]) * 0.15;
     sum += texture2D(inputImageTexture, blurCoordinates[4]) * 0.18;
     sum += texture2D(inputImageTexture, blurCoordinates[5]) * 0.15;
     sum += texture2D(inputImageTexture, blurCoordinates[6]) * 0.12;
     sum += texture2D(inputImageTexture, blurCoordinates[7]) * 0.09;
     sum += texture2D(inputImageTexture, blurCoordinates[8]) * 0.05;
     gl_FragColor = sum;
 }
 );
@implementation MyFilter
- (instancetype)init
{
    self = [super initWithFragmentShaderFromString:myfilter];
    if (self) {
        self.texelWidthOffset = 0;
        self.texelHeightOffset = 0;
    }
    return self;
}

-(void)setW:(CGFloat)w h:(CGFloat)h
{
    self.texelHeightOffset = h;
    self.texelWidthOffset = w;
    [self setSize:CGSizeMake(w, h) forUniform:myUniform program:filterProgram];
}
@end
