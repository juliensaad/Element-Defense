//
//  EDMyScene.m
//  Element Defense
//
//  Created by Julien Saad on 11/29/2013.
//  Copyright (c) 2013 Third Bridge. All rights reserved.
//

#import "EDMyScene.h"
#import "Tower.h"
#import <QuartzCore/QuartzCore.h>



@implementation EDMyScene


-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
		
		 NSLog(@"Size: %@", NSStringFromCGSize(size));
	
        self.backgroundColor = [SKColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.0];

		_towerArray = [[NSMutableArray alloc] init];
		_minions = [[NSMutableArray alloc] init];
		
		[self createGrid];
    }
    return self;
}

-(void)createGrid{
	_grid = [[SKNode alloc] init];

	for(int i = 0;i<NB_TOWER_X;i++){
		for(int j = 0; j<NB_TOWER_Y;j++){
			Tower *tower = [Tower spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(TOWER_SIZE-1, TOWER_SIZE-1)];
			
			// Pas de tour, type vide
			[tower setType:0];
			
			[tower setPosX:i];
			[tower setPosY:j];
			
			
			[tower setPosition:CGPointMake(i*TOWER_SIZE, j*TOWER_SIZE)];
    
			[_grid addChild:tower];
			[_towerArray addObject:tower];
		}
	}
	[_grid setPosition:CGPointMake(TOWER_SIZE/2, TOWER_SIZE/2)];
	[self addChild:_grid];

	
}


// Redraw walking path
-(void)drawWalkingPath{
    BOOL grid[NB_TOWER_X][NB_TOWER_Y];
    for(Tower *t in _towerArray){
        if (t.type==0) {
            grid[t.posX][t.posY] = NO;
        }else{
            grid[t.posX][t.posY] = YES;
        }
    }
   /* for(int i=0;i<NB_TOWER_X;i++){
        for (int j=0; j<NB_TOWER_Y; j++) {
             NSLog(@"(%d,%d) %d",i,j, grid[i][j]);
        }
    }*/
    
    int currentX=0;
    int currentY=0;
    int endX=NB_TOWER_X-1;
    int endY=NB_TOWER_Y-1;
    
    SKSpriteNode *pathElement = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(4, 4)];
    [pathElement setPosition:CGPointMake(currentX*TOWER_SIZE, currentY*TOWER_SIZE)];
    [_grid addChild:pathElement];
    
    while (currentX<endX || currentY<endY) {
        // not arrived in x and in y
        if (currentX<endX && currentY<endY) {
            // if diagonal is free
            if (!grid[currentX+1][currentY+1] && !grid[currentX+1][currentY] && !grid[currentX][currentY+1]) {
                currentX++;
                currentY++;
            }
            else if(!grid[currentX+1][currentY]){
                currentX++;
            }
            else if(!grid[currentX][currentY+1]){
                currentY++;
            }
        }
        // arrived in y not in x
        else if(currentX<endX && currentY>=endY){
            currentX++;
        }
        // arrived in x not in y
        else if(currentX>=endX && currentY<endY){
            currentY++;
        }
        
        NSLog(@"path");
        
        SKSpriteNode *pathElement = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(4, 4)];
        [pathElement setPosition:CGPointMake(currentX*TOWER_SIZE, currentY*TOWER_SIZE)];
        [_grid addChild:pathElement];
    }
    
    NSLog(@"(%d,%d)", currentX,currentY);
}

-(void)addTowerAtLocation:(CGPoint)location{
	float maxX = location.x + TOWER_SIZE/2;
	float minX = location.x - TOWER_SIZE/2;
	float maxY = location.y + TOWER_SIZE/2;
	float minY = location.y - TOWER_SIZE/2;
	
	for(Tower *tower in _towerArray){
		if(tower.position.x < maxX && tower.position.x > minX
		   && tower.position.y < maxY && tower.position.y > minY){
			if(tower.type ==0){
				
				[tower setType:1];
				
			}else{
				
				[tower setType:0];
			}
		}
	}
	
	[self drawWalkingPath];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
		
		// Decaler en fonction de la position de la grid
		location.x -= self.grid.position.x;
		location.y -= self.grid.position.y;
		[self addTowerAtLocation:location];
		
	
    }
}

-(void)createMinion{
	// [Minion spriteNodeWithImageNamed:@"docteur"];//
	Minion *sn = [Minion spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(MINION_SIZE, MINION_SIZE)];
	[sn setWalkingSpeed:0.01];
	[sn setMaxHp:1536];
	
	sn.position = CGPointMake(0, 100);
	sn.name = @"Minion";
	
	[sn createHealthbar];
    
    [_minions addObject:sn];
	
	[sn updateHPBar:1450];
	
	//[sn addChild:healthBar];

	
	NSMutableArray *path = [[NSMutableArray alloc] init];
	
	RouteStep *s1 = [[RouteStep alloc] init];
	s1.posX = 50;
	s1.posY = 50;
	
	RouteStep *s2 = [[RouteStep alloc] init];
	s2.posX = 100;
	s2.posY = 50;
	
	RouteStep *s3 = [[RouteStep alloc] init];
	s3.posX = 100;
	s3.posY = 100;
	
	[path addObject:s1];
	[path addObject:s2];
	[path addObject:s3];
	
	[sn walkPath:path atIndex:0];
	[self addChild:sn];

}

-(void)update:(CFTimeInterval)currentTime {
	// spawning delay calculation
    CFTimeInterval timeSinceLastWalker = currentTime - self.lastSpawnTime;
    
    // spawn walker every tw0 seconds
    if (timeSinceLastWalker>2) {
        [self createMinion];
        _lastSpawnTime = currentTime;
    }}

@end
