//
//  Grid.h
//  Element Defense
//
//  Created by Julien Saad on 11/29/2013.
//  Copyright (c) 2013 Third Bridge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tower.h"

@interface Grid : NSObject

@property (nonatomic) int height;
@property (nonatomic) int width;

@property (nonatomic, strong) NSMutableArray* towers;


@end
