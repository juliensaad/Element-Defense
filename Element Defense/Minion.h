//
//  Minion.h
//  Element Defense
//
//  Created by Julien Saad on 11/30/2013.
//  Copyright (c) 2013 Third Bridge. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Minion : SKSpriteNode

@property CGPoint minionPosition;
@property int maxHp;
@property int currentHp;
@property float walkingSpeed;

@property (nonatomic, strong) SKShapeNode* health;
@property (nonatomic, strong) SKShapeNode* missingHealth;

-(void)walk;

-(void)updateHPBar:(int)hp;

-(void)createHealthbar;

-(void)walkPath:(NSArray*)path atIndex:(int)index;

-(void)die;

@end
