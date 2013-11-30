//
//  Minion.m
//  Element Defense
//
//  Created by Julien Saad on 11/30/2013.
//  Copyright (c) 2013 Third Bridge. All rights reserved.
//

#import "Minion.h"

@implementation Minion
-(void)walk{
	// Determine speed of the walker
    int minDuration = 3.0;
    int maxDuration = 6.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    actualDuration = 8.0;
    // Determine direction of the walker
	
	// Create the actions
    SKAction * actionMoveDone = [SKAction removeFromParent];
    SKAction * walk;

	self.position =CGPointMake(self.frame.size.width + self.size.width/2, 100);
    walk = [SKAction moveTo:CGPointMake(eScreenWidth, 100) duration:actualDuration];

	
    //This is our general runAction method to make our walker walk
    [self runAction:[SKAction sequence:@[walk, actionMoveDone]]];

}

-(void)walkPath:(NSArray*)path atIndex:(int)index{
	
	if(index<[path count]){
		RouteStep* pt = [path objectAtIndex:index];
		
		SKAction * walk = [SKAction moveTo:CGPointMake(pt.posX, pt.posY) duration:10.0*_walkingSpeed];
		[self runAction:walk completion:^{
				[self walkPath:path atIndex:index+1];
		}];
	}else{
		[self runAction:[SKAction removeFromParent]];
		return;
	}

}
#define HPBAR_Y self.size.height/2
#define HPBAR_WIDTH self.size.width

-(void)updateHPBar:(int)hp{
	double hpPercentage = (double)hp/_maxHp;
	[self setCurrentHp:hp];
	
	UIBezierPath* barpath = [[UIBezierPath alloc] init];
	[barpath moveToPoint:CGPointMake(-self.size.width/2, HPBAR_Y)];
	[barpath addLineToPoint:CGPointMake(-self.size.width/2 + HPBAR_WIDTH*hpPercentage,HPBAR_Y)];
	_health.path = barpath.CGPath;
	
	float hpWidth =HPBAR_WIDTH*hpPercentage;

	UIBezierPath* missingPath = [[UIBezierPath alloc] init];
	[missingPath moveToPoint:CGPointMake(hpWidth-self.size.width/2, HPBAR_Y)];
	[missingPath addLineToPoint:CGPointMake(hpWidth-self.size.width/2+(HPBAR_WIDTH-hpWidth), HPBAR_Y)];
	_missingHealth.path = missingPath.CGPath;

}


-(void)createHealthbar{
	
	_health = [SKShapeNode node];
	UIBezierPath* barpath = [[UIBezierPath alloc] init];
	[barpath moveToPoint:CGPointMake(-self.size.width/2, HPBAR_Y)];
	[barpath addLineToPoint:CGPointMake(-self.size.width/2 + HPBAR_WIDTH,HPBAR_Y)];
	_health.path = barpath.CGPath;
	_health.lineWidth = 10.0;
	_health.strokeColor = [UIColor greenColor];
	_health.antialiased = NO;
	
	
	
	 _missingHealth = [SKShapeNode node];
	 _missingHealth.lineWidth = 10.0;
	 _missingHealth.strokeColor = [UIColor redColor];
	 _missingHealth.antialiased = NO;
	 
	[self addChild:_health];
	[self addChild:_missingHealth];
	
}
@end
