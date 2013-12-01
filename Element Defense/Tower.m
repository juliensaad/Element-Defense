//
//  Tower.m
//  Element Defense
//
//  Created by Julien Saad on 11/30/2013.
//  Copyright (c) 2013 Third Bridge. All rights reserved.
//

#import "Tower.h"

@implementation Tower

-(void) setType:(int)type{
	_type = type;
	

	if(type==0){
		//self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(0,0)];
		self.physicsBody.dynamic = NO;
		[self setColor:[UIColor whiteColor]];
		
		
	}else if(type==1){
		
		[self setColor:[UIColor redColor]];
		_fireRate = 1.0;
		_attackDamage = 20.0;
		_range = 80;

	}else if(type==2){
		
	}
}

-(void)updateTower:(CFTimeInterval)currentTime withMinions:(NSArray*)minions{

	if(self.type !=0){
		CFTimeInterval timeSinceLastAttack = currentTime - self.lastAttackTime;
		if(timeSinceLastAttack>_fireRate){
			if([minions count]>0){
				Minion* minionToAttack = [self findClosestMinion:minions];
				if(minionToAttack!= NULL){
					[self attackMinion:minionToAttack];
					_lastAttackTime = currentTime;
				}
			}
		}
	}
}

-(Minion*)findClosestMinion:(NSArray*)minions{

	for(Minion *m in minions){
		double a,b;
		a = abs(self.position.x-m.position.x);
		b = abs(self.position.y-m.position.y);
		
		double distance = sqrt(a*a+b*b);
		
		if(distance<_range){
			return m;
		}
		
	}
	
	return NULL;
}

-(void)attackMinion:(Minion*)minion{
	SKSpriteNode *missile = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(3, 3)];
	[[self parent] addChild:missile];
	

	float actualDuration = _fireRate/2.0;
	 // Determine direction of the walker
	 
	 // Create the actions
	SKAction * actionMoveDone = [SKAction removeFromParent];
	SKAction * shoot;
	 
	missile.position =CGPointMake(self.frame.origin.x, self.frame.origin.y);
	shoot = [SKAction moveTo:CGPointMake(minion.position.x, minion.position.y) duration:actualDuration];
	 
	 
	//This is our general runAction method to make our walker walk

	[missile runAction:[SKAction sequence:@[shoot, actionMoveDone]] completion:^{
		[minion updateHPBar:minion.currentHp-self.attackDamage];
	}];

	
}
@end
