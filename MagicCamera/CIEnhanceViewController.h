//
//  CIEnhanceViewController.h
//  MagicCamera
//
//  Created by SongWentong on 3/4/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditImageViewController.h"

//Core Image 使用的增强效果
@interface CIEnhanceViewController : EditImageViewController
{
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *typeCollection;

@end
