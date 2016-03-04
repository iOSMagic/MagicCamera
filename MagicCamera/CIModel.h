//
//  CIModel.h
//  MagicCamera
//
//  Created by SongWentong on 3/4/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CIModel : NSObject
@property (nonatomic,strong) NSString *filterName;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSMutableDictionary *inputs;
@end
