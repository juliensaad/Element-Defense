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

        _path = [[NSMutableArray alloc] init];
		_towerArray = [[NSMutableArray alloc] init];
		_minions = [[NSMutableArray alloc] init];
		
		_blueDots = [[NSMutableArray alloc] init];
		
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
-(void)updatePath{
    
    [_path removeAllObjects];
	
	for(SKSpriteNode* dot in _blueDots){
		[dot removeFromParent];
	}
	[_blueDots removeAllObjects];
    
    BOOL grid[NB_TOWER_X][NB_TOWER_Y];
    BOOL visited[NB_TOWER_X][NB_TOWER_Y];
    int distance[NB_TOWER_X][NB_TOWER_Y];
    
    for(Tower *t in _towerArray){
        visited[t.posX][t.posY] = NO;
        if (t.type==0) {
            grid[t.posX][t.posY] = NO;
        }else{
            grid[t.posX][t.posY] = YES;
        }
    }
    
    int initX=0;
    int initY=0;
    int endX=NB_TOWER_X-1;
    int endY=NB_TOWER_Y-1;
    
    for (int i=0; i<NB_TOWER_X; i++) {
        for(int j=0;j<NB_TOWER_Y;j++){
            distance[i][j]=9999;
        }
    }

    [self setDistance:distance withGrid:grid withPosX:initX withPosY:initY withDist:0];
   /* for (int i=0; i<NB_TOWER_X; i++) {
        for(int j=0;j<NB_TOWER_Y;j++){
            if (!grid[i][j]) {
                // left
                if (distance[i-1][j]+1<distance[i][j] && i-1>=0) {
                    distance[i][j]=distance[i-1][j]+1;
                }
                // dig bot-left
                if (distance[i-1][j-1]+1<distance[i][j] && i-1>=0 && j-1>=0) {
                    distance[i][j]=distance[i-1][j-1]+1;
                }
                // bot
                if (distance[i][j-1]+1<distance[i][j] && distance[i][j-1]>=0 && j-1>=0) {
                    distance[i][j]=distance[i][j-1]+1;
                }
                // dig bot-right
                if (distance[i+1][j-1]+1<distance[i][j] && distance[i+1][j-1]>=0 && j-1>=0 && i+1<NB_TOWER_X) {
                    distance[i][j]=distance[i+1][j-1]+1;
                }
                // right
                if (distance[i+1][j]+1<distance[i][j] && distance[i+1][j]>=0 && i+1<NB_TOWER_X) {
                    distance[i][j]=distance[i+1][j]+1;
                }
                // dig top-right
                if (distance[i+1][j+1]+1<distance[i][j] && distance[i+1][j+1]>=0 && i+1<NB_TOWER_X && j+1<NB_TOWER_Y) {
                    distance[i][j]=distance[i+1][j+1]+1;
                }
                // top
                if (distance[i][j+1]+1<distance[i][j] && distance[i][j+1]>=0 && j+1<NB_TOWER_Y) {
                    distance[i][j]=distance[i][j+1]+1;
                }
                // dig top-left
                if (distance[i-1][j+1]+1<distance[i][j] && distance[i-1][j+1]>=0 && i-1>=0 && j+1<NB_TOWER_Y) {
                    distance[i][j]=distance[i-1][j+1]+1;
                }
            }
        }
    }*/
    for (int i=0; i<NB_TOWER_X; i++) {
        for(int j=0;j<NB_TOWER_Y;j++){
            NSLog(@"(%d,%d) : %d",i,j,distance[i][j]);
        }
    }
    
    /*SKSpriteNode *pathElement = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(4, 4)];
    [pathElement setPosition:CGPointMake(currentX*TOWER_SIZE, currentY*TOWER_SIZE)];
    [_grid addChild:pathElement];
    
    while (currentX!=endX || currentY!=endY) {
      
        NSLog(@"path");
        
        SKSpriteNode *pathElement = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(4, 4)];
        [pathElement setPosition:CGPointMake(currentX*TOWER_SIZE, currentY*TOWER_SIZE)];
        [_grid addChild:pathElement];
		[_blueDots addObject:pathElement];
        
        RouteStep* s =[[RouteStep alloc] init];
        s.posX=currentX*TOWER_SIZE+TOWER_SIZE/2;
        s.posY=currentY*TOWER_SIZE+TOWER_SIZE/2;
        [_path addObject:s];
        
    }*/
}


-(void)setDistance:(int[NB_TOWER_X][NB_TOWER_Y]) distArray withGrid:(BOOL[NB_TOWER_X][NB_TOWER_Y]) grid withPosX:(int) posX withPosY:(int) posY withDist:(int) dist{
    
    // out of bound
    if (posX<0 || posY<0 || posX>=NB_TOWER_X || posY>=NB_TOWER_Y) {
        return;
    }
    // if there is a tower at this position
    if(grid[posX][posY]){
        return;
    }
    // if actual distance is lower or equal to new dist
    if (dist>=distArray[posX][posY]) {
        return;
    }
    
    // Update distance
    distArray[posX][posY]=dist;
    
    //*** Recursively check for neighbors ***//
    
    //left
    [self setDistance:distArray withGrid:grid withPosX:posX-1 withPosY:posY withDist:dist+1];
    //left-bot
    [self setDistance:distArray withGrid:grid withPosX:posX-1 withPosY:posY-1 withDist:dist+1];
    //bot
    [self setDistance:distArray withGrid:grid withPosX:posX withPosY:posY-1 withDist:dist+1];
    //right-bot
    [self setDistance:distArray withGrid:grid withPosX:posX+1 withPosY:posY-1 withDist:dist+1];
    //right
    [self setDistance:distArray withGrid:grid withPosX:posX+1 withPosY:posY withDist:dist+1];
    //right-top
    [self setDistance:distArray withGrid:grid withPosX:posX+1 withPosY:posY+1 withDist:dist+1];
    //top
    [self setDistance:distArray withGrid:grid withPosX:posX withPosY:posY+1 withDist:dist+1];
    //left-top
    [self setDistance:distArray withGrid:grid withPosX:posX-1 withPosY:posY+1 withDist:dist+1];
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
	
	[self updatePath];
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
	
	// //
	Minion *sn = [Minion spriteNodeWithImageNamed:@"tree"];
	[sn setScale:1.0];//[Minion spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(MINION_SIZE, MINION_SIZE)];
	[sn setWalkingSpeed:5.0];
	[sn setMaxHp:100];
	[sn setCurrentHp:100];
	
	
	sn.position = CGPointMake(0, 0);
	sn.name = @"Minion";
	
	[sn createHealthbar];
    
    [_minions addObject:sn];
	
	[sn updateHPBar:1450];
	
	//[sn addChild:healthBar];
	
	RouteStep *s1 = [[RouteStep alloc] init];
	s1.posX = 50;
	s1.posY = 50;
	
	RouteStep *s2 = [[RouteStep alloc] init];
	s2.posX = 100;
	s2.posY = 50;
	
	RouteStep *s3 = [[RouteStep alloc] init];
	s3.posX = 100;
	s3.posY = 100;
	
	[_path addObject:s1];
	[_path addObject:s2];
	[_path addObject:s3];
	
	[sn walkPath:_path atIndex:0];
	[self addChild:sn];

}

-(void)update:(CFTimeInterval)currentTime {
	// spawning delay calculation
    CFTimeInterval timeSinceLastWalker = currentTime - self.lastSpawnTime;
    
	
	for(Minion* m in _minions){
		[m walk];
	}
	
	
	BOOL deadMinionFound = YES;
	while(deadMinionFound){
		for(Minion* m in _minions){
			if(m.currentHp<=0){
				[_minions removeObject:m];
				deadMinionFound = YES;
				break;
			}
		}
		deadMinionFound = NO;
	}
	

	
	for(Tower* t in _towerArray){
		[t updateTower:currentTime withMinions:_minions];
	}
	
    // spawn a new minion evrytim
    if (timeSinceLastWalker>2) {
				
        [self createMinion];
        _lastSpawnTime = currentTime;
		
    }}

@end
