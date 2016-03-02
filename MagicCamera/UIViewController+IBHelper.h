//
//  UIViewController+IBHelper.h
//  MagicCamera
//
//  Created by SongWentong on 3/2/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (IBHelper)
+(instancetype)instanceFromIB;
+(instancetype)instanceFromStoryBoard:(UIStoryboard*)sb name:(NSString*)name;
@end
