//
//  Minion.h
//  Element Defense
//
//  Created by Julien Saad on 11/30/2013.
//  Copyright (c) 2013 Third Bridge. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "RouteStep.h"

@interface Minion : SKSpriteNode

@property CGPoint minionPosition;
@property int maxHp;
@property int currentHp;
@property (nonatomic)float walkingSpeed;
@property (nonatomic)float slowFactor;

@property float precisePositionX;
@property float precisePositionY;

@property CFTimeInterval lastSlowTime;

@property (nonatomic, strong) SKShapeNode* health;
@property (nonatomic, strong) SKShapeNode* missingHealth;

@property (nonatomic, strong) RouteStep* nextStep;
@property (nonatomic, strong) NSArray* path;
@property int currentDestination;
@property BOOL isReadyToDie;

-(void)updateMinionAtTime:(CFTimeInterval)currentTime;

-(void)slowMinion:(float)slowFactor atTime:(CFTimeInterval)currentTime;

-(void)initWithType:(int)type andPath:(NSArray*)path;

-(void)updateHPBar:(int)hp;

-(void)createHealthbar;

-(void)die;

@end
