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
	
	self.precisePositionX = self.position.x;
	self.precisePositionY = self.position.y;
	
	self.position = CGPointMake([(RouteStep*)[_path objectAtIndex:0] posX], [(RouteStep*)[_path objectAtIndex:0] posY]);
	if(type==0){
		[self setMaxHp:1500];
		[self setCurrentHp:_maxHp];
		[self setWalkingSpeed:10.0];
		[self setSlowFactor:1.0];

	}
}
-(void)walk{
	
	if(((self.position.x >= _nextStep.posX-0.5) && (self.position.x <= _nextStep.posX+0.5)
		&&
		(self.position.y >= _nextStep.posY-0.5) && (self.position.y <= _nextStep.posY+0.5))){
		_currentDestination++;
		if(_currentDestination==[_path count]){
			// PERDRE UNE VIE
			[self setIsReadyToDie:YES];
		}else{
			_nextStep = [_path objectAtIndex:_currentDestination];
		}
	}
	
	
	float nextX = 0.0;
	float nextY = 0.0;
	
	if(self.precisePositionX < _nextStep.posX){
		nextX += _walkingSpeed*_slowFactor/10.0;
	}else if(self.precisePositionX > _nextStep.posX){
		nextX -= _walkingSpeed*_slowFactor/10.0;
	}
	
	if(self.precisePositionY < _nextStep.posY){
		nextY += _walkingSpeed*_slowFactor/10.0;
	}else if(self.precisePositionY > _nextStep.posY){
		nextY -= _walkingSpeed*_slowFactor/10.0;
	}
	
	
	[self setPosition:CGPointMake(self.precisePositionX + nextX, self.precisePositionY + nextY)];
	self.precisePositionX += nextX;
	self.precisePositionY += nextY;
}



-(void)slowMinion:(float)slowFactor atTime:(CFTimeInterval)currentTime{
	// If there is in fact a slow
	if(slowFactor!=1.0){
		_slowFactor = slowFactor;
		_lastSlowTime = currentTime;
	}
}


-(void)updateMinionAtTime:(CFTimeInterval)currentTime{
	
	CFTimeInterval timeSinceLastSlow = currentTime - self.lastSlowTime;
	
	if(timeSinceLastSlow>0.5){
		_slowFactor = 1.0; // Remettre a la vitesse normale
	}
	
	[self walk];
	
}


#define HPBAR_Y self.size.height/2
#define HPBAR_WIDTH self.size.width

-(void)updateHPBar:(int)hp{
	[self removeAllActions];

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
