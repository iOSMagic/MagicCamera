//
//  PewviewView.m
//  MagicCamera
//
//  Created by SongWentong on 3/9/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

#import "PewviewView.h"
@import AVFoundation;
@implementation PewviewView

+ (Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session
{
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    return previewLayer.session;
}

- (void)setSession:(AVCaptureSession *)session
{
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    previewLayer.session = session;
}

@end
