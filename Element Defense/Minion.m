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
    actualDuration = 1.0;
    // Determine direction of the walker
	
	// Create the actions
    SKAction * actionMoveDone = [SKAction removeFromParent];
    SKAction * walk;

	self.position =CGPointMake(self.frame.size.width + self.size.width/2, 100);
    walk = [SKAction moveTo:CGPointMake(eScreenWidth, 100) duration:actualDuration];

	
    //This is our general runAction method to make our walker walk
    [self runAction:[SKAction sequence:@[walk, actionMoveDone]]];

}
@end
