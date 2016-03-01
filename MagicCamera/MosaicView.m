//
//  MosaicView.m
//  MagicCamera
//
//  Created by xushuigen on 16/2/25.
//  Copyright © 2016年 SongWentong. All rights reserved.
//

#import "MosaicView.h"

@interface MosaicView()
{
    UIImageView *_backGroundImageView;//背景视图
    UIImageView *_frontImageView; //前面的视图
    
    UIImageView *_mosaicImageView;
    
    CAShapeLayer *_mosaicShapeLayer; //mask
    UIBezierPath *_mosaicPath; //
    UIBezierPath *_cleanPath;
    
    BOOL isOpterionChangeType;
    
    UIImage *_tailImage;
    
    CGSize resultSize;

}
@end

@implementation MosaicView

-(instancetype)init
{
    self = [super init];
    if(self){
       
    }
    return self;
}

-(instancetype)initWithMosaicImage:(UIImage *)mosaicImage andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        _cleanLineWidth = 20;
        resultSize = mosaicImage.size;
        isOpterionChangeType = NO;
        _backGroundImageView = [[UIImageView alloc]init];
        _frontImageView = [[UIImageView alloc]init];
        _mosaicImageView = [[UIImageView alloc]init];
        
        /*
        _backGroundImageView.contentMode = UIViewContentModeScaleAspectFit;
        _frontImageView.contentMode = UIViewContentModeScaleAspectFit;
        _mosaicImageView.contentMode = UIViewContentModeScaleAspectFit;
         */
        
        _frontImageView.backgroundColor = [UIColor clearColor];
        _mosaicImageView.backgroundColor = [UIColor clearColor];
        
        _backGroundImageView.userInteractionEnabled = YES;
        _frontImageView.userInteractionEnabled = YES;
        
        _backGroundImageView.frame = self.bounds;
        _frontImageView.frame = self.bounds;
        _mosaicImageView.frame = self.bounds;
        
        _tailImage = [self tailImage:mosaicImage];
        _backGroundImageView.image = _tailImage;
        
        _backGroundImageView.image = [self createCurrentImage];
        [self addSubview:_backGroundImageView];
        [self addSubview:_frontImageView];
        
        _mosaicPath = [UIBezierPath bezierPath];
        _cleanPath = [UIBezierPath bezierPath];
        
        _mosaicShapeLayer = [CAShapeLayer layer];
        _mosaicShapeLayer.frame = _mosaicImageView.bounds;
        _mosaicShapeLayer.path = _mosaicPath.CGPath;
        _mosaicShapeLayer.fillColor = [UIColor clearColor].CGColor;
        _mosaicShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        _mosaicShapeLayer.lineCap = kCALineCapRound;
        _mosaicShapeLayer.lineJoin = kCALineJoinRound;
        
        _mosaicImageView.layer.mask = _mosaicShapeLayer;
        self.mosaicLineWidth = 20;
       
        
        _mosaicImageView.image = [[self class] transToMosaicImage:[self createCurrentImage] blockLevel:20];
    }
    return self;
}

#pragma mark - 设置线宽
-(void)setMosaicLineWidth:(CGFloat)mosaicLineWidth
{
    _mosaicLineWidth = mosaicLineWidth;
    _mosaicShapeLayer.lineWidth = mosaicLineWidth;
}

-(void)setCleanLineWidth:(CGFloat)cleanLineWidth
{
    _cleanLineWidth = cleanLineWidth;
}


#pragma mark -
-(void)setOpertionType:(ImageOpertionType)opertionType
{
    if(_opertionType !=  opertionType)
    {
        isOpterionChangeType = YES;
    }
    _opertionType = opertionType;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = (UITouch *)[[touches allObjects] lastObject];
    CGPoint point = [touch locationInView:_frontImageView];
    if(_opertionType == ImageOpertionType_Mosaic)
    {
       if(isOpterionChangeType)
       {
           isOpterionChangeType = NO;
           [_mosaicPath removeAllPoints];
           _mosaicImageView.image = [self createMosaicImage];
           isOpterionChangeType = NO;
       }
        [_mosaicPath moveToPoint:point];
    }else{
        if(isOpterionChangeType)
        {
            isOpterionChangeType = NO;
            [_cleanPath removeAllPoints];
        }
        [_cleanPath moveToPoint:point];
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = (UITouch *)[[touches allObjects] lastObject];
    CGPoint point = [touch locationInView:_frontImageView];
    if(_opertionType == ImageOpertionType_Mosaic)
    {
        [self mosaicShowPoint:point];
    }else{
        [self mosaicCleanPoint:point];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = (UITouch *)[[touches allObjects] lastObject];
    CGPoint point = [touch locationInView:_frontImageView];
    if(_opertionType == ImageOpertionType_Mosaic)
    {
        
    }else{
        
    }
}

-(void)mosaicShowPoint:(CGPoint)point
{
    [_mosaicPath addLineToPoint:point];
    _mosaicShapeLayer.path = _mosaicPath.CGPath;
    [_mosaicPath moveToPoint:point];
    
    UIGraphicsBeginImageContextWithOptions(_frontImageView.bounds.size,NO, 0);
    // 3.获取当前上下文
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 4.截图:实际是把layer上面的东西绘制到上下文中
    
    [_frontImageView.layer renderInContext:ctx];
    [_mosaicImageView.layer renderInContext:ctx];
    
    
    // 5.获取截图
    
    UIImage *imageTemp = UIGraphicsGetImageFromCurrentImageContext();
    _frontImageView.image = imageTemp;
    // 2.关闭图片上下文
    
    UIGraphicsEndImageContext();
    

}

-(void)mosaicCleanPoint:(CGPoint)point
{
    [_cleanPath addLineToPoint:point];
    
    UIGraphicsBeginImageContextWithOptions(_frontImageView.bounds.size,NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginTransparencyLayer(context, NULL);
    [_frontImageView.image drawAtPoint:CGPointZero];
    
    CGContextAddPath(context, _cleanPath.CGPath);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, _cleanLineWidth);
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextSetStrokeColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextStrokePath(context);
    CGContextEndTransparencyLayer(context);
    
    UIImage *imageTemp = UIGraphicsGetImageFromCurrentImageContext();
    _frontImageView.image = imageTemp;
    UIGraphicsEndImageContext();

}

-(UIImage *)createMosaicImage
{
    UIGraphicsBeginImageContextWithOptions(_backGroundImageView.bounds.size,NO, 0);
    // 3.获取当前上下文
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 4.截图:实际是把layer上面的东西绘制到上下文中
    
    
    [_backGroundImageView.layer renderInContext:ctx];
    [_frontImageView.layer renderInContext:ctx];
    
    
    // 5.获取截图
    
    UIImage *imageTemp = UIGraphicsGetImageFromCurrentImageContext();
    // 2.关闭图片上下文
    UIGraphicsEndImageContext();
    
    
    UIGraphicsBeginImageContext(CGSizeMake(_backGroundImageView.image.size.width , _backGroundImageView.image.size.height  ));
    [imageTemp drawInRect:CGRectMake(0, 0, _backGroundImageView.image.size.width ,_backGroundImageView.image.size.height )];
    UIImage *imageTemp1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [[self class] transToMosaicImage:imageTemp blockLevel: 20];

}

-(UIImage *)createCurrentImage
{
    UIGraphicsBeginImageContextWithOptions(_backGroundImageView.bounds.size,NO, 0);
    // 3.获取当前上下文
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 4.截图:实际是把layer上面的东西绘制到上下文中
    
    
    [_backGroundImageView.layer renderInContext:ctx];
    
    
    // 5.获取截图
    
    UIImage *imageTemp = UIGraphicsGetImageFromCurrentImageContext();
    // 2.关闭图片上下文
    UIGraphicsEndImageContext();
    
    
    return imageTemp;
}

-(UIImage *)tailImage:(UIImage *)image
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width , image.size.height ));
    [image drawInRect:CGRectMake(0, 0, image.size.width ,image.size.height )];
    UIImage *imageTemp = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    /*
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width, image.size.height ));
    [imageTemp drawInRect:CGRectMake(0, 0, image.size.width,image.size.height )];
    UIImage *imageTemp1 = UIGraphicsGetImageFromCurrentImageContext();
    NSData * data12 = UIImageJPEGRepresentation(imageTemp1, 1.0);
    UIGraphicsEndImageContext();
     */
    return imageTemp;
    
    /*
    UIGraphicsBeginImageContext(_backGroundImageView.bounds.size);
    [image drawInRect:CGRectMake(0, 0, _backGroundImageView.bounds.size.width,_backGroundImageView.bounds.size.height)];
    UIImage *imageTemp = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageTemp;
     */
}

-(void)savePhoto
{
    UIGraphicsBeginImageContextWithOptions(_backGroundImageView.bounds.size,NO, 0);
    // 3.获取当前上下文
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 4.截图:实际是把layer上面的东西绘制到上下文中
    
    
    [_backGroundImageView.layer renderInContext:ctx];
    [_frontImageView.layer renderInContext:ctx];
    
    
    // 5.获取截图
    
    UIImage *imageTemp = UIGraphicsGetImageFromCurrentImageContext();
    // 2.关闭图片上下文
    UIGraphicsEndImageContext();
    
    
    UIGraphicsBeginImageContext(resultSize);
    [imageTemp drawInRect:CGRectMake(0, 0, resultSize.width ,resultSize.height )];
    UIImage *imageTemp1 = UIGraphicsGetImageFromCurrentImageContext();
    NSData * data12 = UIImageJPEGRepresentation(imageTemp1, 1.0);
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(imageTemp1, nil, nil, nil);

}

#define kBitsPerComponent (8)
#define kBitsPerPixel (32)
#define kPixelChannelCount (4)

/*
 *转换成马赛克,level代表一个点转为多少level*level的正方形
 */
+ (UIImage *)transToMosaicImage:(UIImage*)orginImage blockLevel:(NSUInteger)level
{
    //获取BitmapData
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef imgRef = orginImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  kBitsPerComponent,        //每个颜色值8bit
                                                  width*kPixelChannelCount, //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit
                                                  colorSpace,
                                                  kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
    unsigned char *bitmapData = CGBitmapContextGetData (context);
    
    //这里把BitmapData进行马赛克转换,就是用一个点的颜色填充一个level*level的正方形
    unsigned char pixel[kPixelChannelCount] = {0};
    NSUInteger index,preIndex;
    for (NSUInteger i = 0; i < height - 1 ; i++) {
        for (NSUInteger j = 0; j < width - 1; j++) {
            index = i * width + j;
            if (i % level == 0) {
                if (j % level == 0) {
                    memcpy(pixel, bitmapData + kPixelChannelCount*index, kPixelChannelCount);
                }else{
                    memcpy(bitmapData + kPixelChannelCount*index, pixel, kPixelChannelCount);
                }
            } else {
                preIndex = (i-1)*width +j;
                memcpy(bitmapData + kPixelChannelCount*index, bitmapData + kPixelChannelCount*preIndex, kPixelChannelCount);
            }
        }
    }
    
    NSInteger dataLength = width*height* kPixelChannelCount;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bitmapData, dataLength, NULL);
    //创建要输出的图像
    CGImageRef mosaicImageRef = CGImageCreate(width, height,
                                              kBitsPerComponent,
                                              kBitsPerPixel,
                                              width*kPixelChannelCount ,
                                              colorSpace,
                                              kCGImageAlphaPremultipliedLast,
                                              provider,
                                              NULL, NO,
                                              kCGRenderingIntentDefault);
    CGContextRef outputContext = CGBitmapContextCreate(nil,
                                                       width,
                                                       height,
                                                       kBitsPerComponent,
                                                       width*kPixelChannelCount,
                                                       colorSpace,
                                                       kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(outputContext, CGRectMake(0.0f, 0.0f, width, height), mosaicImageRef);
    CGImageRef resultImageRef = CGBitmapContextCreateImage(outputContext);
    UIImage *resultImage = nil;
    if([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
        float scale = [[UIScreen mainScreen] scale];
        resultImage = [UIImage imageWithCGImage:resultImageRef scale:scale orientation:orginImage.imageOrientation];
    } else {
        resultImage = [UIImage imageWithCGImage:resultImageRef];
    }
    //释放
    if(resultImageRef){
        CFRelease(resultImageRef);
    }
    if(mosaicImageRef){
        CFRelease(mosaicImageRef);
    }
    if(colorSpace){
        CGColorSpaceRelease(colorSpace);
    }
    if(provider){
        CGDataProviderRelease(provider);
    }
    if(context){
        CGContextRelease(context);
    }
    if(outputContext){
        CGContextRelease(outputContext);
    }
    return resultImage ;
    
}

#pragma mark - 合并两张图片
-(UIImage *)mergeImage:(UIImage *)firstImage andSecondImage:(UIImage *)secondImage
{
    UIGraphicsBeginImageContext(firstImage.size);
    [firstImage drawInRect:CGRectMake(0, 0, firstImage.size.width, firstImage.size.height)];
    [secondImage drawInRect:CGRectMake(0, 0, firstImage.size.width, firstImage.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}


@end
