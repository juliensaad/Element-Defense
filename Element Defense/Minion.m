//
//  Minion.m
//  Element Defense
//
//  Created by Julien Saad on 11/30/2013.
//  Copyright (c) 2013 Third Bridge. All rights reserved.
//

#import "Minion.h"

@implementation Minion

-(void)initWithType:(int)type andPath:(NSArray*)path{
	[self setIsReadyToDie:NO];
	[self createHealthbar];
	[self setCurrentDestination:0];
	[self setPath:path];
	[self setNextStep:[_path objectAtIndex:0]];
	
	self.position = CGPointMake([(RouteStep*)[_path objectAtIndex:0] posX], [(RouteStep*)[_path objectAtIndex:0] posY]);
	if(type==0){
		[self setMaxHp:1500];
		[self setCurrentHp:_maxHp];
		[self setWalkingSpeed:20.0];
	}
}
-(void)walk{
	
	if(self.position.x == _nextStep.posX && self.position.y == _nextStep.posY){
		_currentDestination++;
		
		if(_currentDestination==[_path count]){
			// PERDRE UNE VIE
			[self setIsReadyToDie:YES];
		}else{
			_nextStep = [_path objectAtIndex:_currentDestination];
		}
	}
	
	
	int nextX = 0;
	int nextY = 0;
	
	if(self.position.x < _nextStep.posX){
		nextX += _walkingSpeed/20;
	}else if(self.position.x > _nextStep.posX){
		nextX -= _walkingSpeed/20;
	}
	
	if(self.position.y < _nextStep.posY){
		nextY += _walkingSpeed/20;
	}else if(self.position.y > _nextStep.posY){
		nextY -= _walkingSpeed/20;
	}
	
	
	[self setPosition:CGPointMake(self.position.x + nextX, self.position.y + nextY )];


}

-(void)walkPath:(NSArray*)path atIndex:(int)index{
	
	[self setPosition:CGPointMake(50,50)];
	/*if(index<[path count]){
		RouteStep* pt = [path objectAtIndex:index];
		
		SKAction * walk = [SKAction moveTo:CGPointMake(pt.posX, pt.posY) duration:10.0/_walkingSpeed];
		[self runAction:walk completion:^{
				[self walkPath:path atIndex:index+1];
		}];
	}else{
		[self runAction:[SKAction removeFromParent]];
		return;
	}*/

}
#define HPBAR_Y self.size.height/2
#define HPBAR_WIDTH self.size.width

-(void)updateHPBar:(int)hp{
	[self removeAllActions];
	NSLog(@"%d OUCH", hp);
	if(hp<=0){
		[self setCurrentHp:0];
		[self setIsReadyToDie:YES];
	}else{
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

}

-(void)die{
	[self runAction:[SKAction removeFromParent]];
}


#define HEALTHBAR_HEIGHT 3.0
-(void)createHealthbar{
	
	_health = [SKShapeNode node];
	UIBezierPath* barpath = [[UIBezierPath alloc] init];
	[barpath moveToPoint:CGPointMake(-self.size.width/2, HPBAR_Y)];
	[barpath addLineToPoint:CGPointMake(-self.size.width/2 + HPBAR_WIDTH,HPBAR_Y)];
	_health.path = barpath.CGPath;
	_health.lineWidth = HEALTHBAR_HEIGHT;
	_health.strokeColor = [UIColor greenColor];
	_health.antialiased = NO;
	
	_missingHealth = [SKShapeNode node];
	_missingHealth.lineWidth = HEALTHBAR_HEIGHT;
	_missingHealth.strokeColor = [UIColor redColor];
	_missingHealth.antialiased = NO;
	 
	[self addChild:_health];
	[self addChild:_missingHealth];
	
}
@end
