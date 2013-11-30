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
		/*self.physicsBody.dynamic = NO;
		self.physicsBody.affectedByGravity = NO;*/
		[self setColor:[UIColor whiteColor]];
		
		
	}else{
		/*self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
		self.physicsBody.dynamic = YES;
		self.physicsBody.affectedByGravity = NO;
		self.physicsBody.mass = 10000000;*/
		[self setColor:[UIColor redColor]];

	}
}
@end
