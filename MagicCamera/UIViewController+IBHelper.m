//
//  UIViewController+IBHelper.m
//  MagicCamera
//
//  Created by SongWentong on 3/2/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

#import "UIViewController+IBHelper.h"

@implementation UIViewController (IBHelper)

+(instancetype)instanceFromIB
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSString *name = NSStringFromClass(self);
    return [self instanceFromStoryBoard:sb name:name];
}

+(instancetype)instanceFromStoryBoardName:(NSString*)storyBoardName
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    NSString *name = NSStringFromClass(self);
    return [self instanceFromStoryBoard:sb name:name];
}

+(instancetype)instanceFromStoryBoard:(UIStoryboard*)sb
{
    NSString *name = NSStringFromClass(self);
    return [self instanceFromStoryBoard:sb name:name];
}

+(instancetype)instanceFromStoryBoard:(UIStoryboard*)sb name:(NSString*)name
{
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:name];
    if (!vc) {
        //如果未找到就尝试直接创建
        vc = [[self alloc] init];
    }
    return vc;
}
@end
