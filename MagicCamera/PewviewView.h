//
//  PewviewView.h
//  MagicCamera
//
//  Created by SongWentong on 3/9/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVCaptureSession;
@interface PewviewView : UIView
@property (nonatomic) AVCaptureSession *session;
@end
