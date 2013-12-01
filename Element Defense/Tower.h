//
//  Tower.h
//  Element Defense
//
//  Created by Julien Saad on 11/30/2013.
//  Copyright (c) 2013 Third Bridge. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Minion.h"
@interface Tower : SKSpriteNode

@property int posX;
@property int posY;

@property int fireRate;
@property int attackDamage;
@property int range;

@property (nonatomic) NSTimeInterval lastAttackTime;
@property (nonatomic, setter=setType:) int type;

-(void)attackMinion:(Minion*)minion;

-(void)updateTower:(CFTimeInterval)currentTime withMinions:(NSArray*)minions;
@end
