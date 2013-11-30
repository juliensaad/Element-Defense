//
//  EDMyScene.h
//  Element Defense
//

//  Copyright (c) 2013 Third Bridge. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Minion.h"

@interface EDMyScene : SKScene

@property (nonatomic) NSMutableArray *towerArray;
@property (nonatomic, strong) SKNode *grid;


@property (nonatomic) NSMutableArray* graphNodes;

@property (nonatomic) NSTimeInterval lastSpawnTime;
@property (nonatomic) NSMutableArray * minions;
@end
