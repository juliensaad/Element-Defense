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
        [self updatePath];
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
    
    // remove visual and modal path
    [_path removeAllObjects];
	
	for(SKSpriteNode* dot in _blueDots){
		[dot removeFromParent];
	}
	[_blueDots removeAllObjects];
    
    // boolean with elements blocking the way
    BOOL grid[NB_TOWER_X][NB_TOWER_Y];
    BOOL visited[NB_TOWER_X][NB_TOWER_Y];
    // distance between every grid position and end of grid
    float distance[NB_TOWER_X][NB_TOWER_Y];
    
    // fill grid
    for(Tower *t in _towerArray){
        visited[t.posX][t.posY] = NO;
        if (t.type==0) {
            grid[t.posX][t.posY] = NO;
        }else{
            grid[t.posX][t.posY] = YES;
        }
    }
    
    // initial and final positions
    int initX=0;
    int initY=3;
    int endX=NB_TOWER_X-1;
    int endY=3;
    
    // Set all distances to infinite
    for (int i=0; i<NB_TOWER_X; i++) {
        for(int j=0;j<NB_TOWER_Y;j++){
            distance[i][j]=9999;
        }
    }
    
    // set every distance to end position with djikstra
    [self setDistance:distance withGrid:grid withPosX:endX withPosY:endY withDist:0];
    
    // Distance outputs (practical)
    /*for (int i=0; i<NB_TOWER_X; i++) {
        for(int j=0;j<NB_TOWER_Y;j++){
            NSLog(@"(%d,%d) : %f",i,j,distance[i][j]);
        }
    }*/
    
    // if path is blocked
    if (distance[initX][initY]==9999 || grid[initX][initY] || grid[endX][endY]) {
        NSLog(@"path broken");
        return;
    }
    
    // current position to initial
    int currentX=initX;
    int currentY=initY;
    
    // draw path of initial position
    SKSpriteNode *pathElement = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(4, 4)];
    [pathElement setPosition:CGPointMake(currentX*TOWER_SIZE, currentY*TOWER_SIZE)];
    [_grid addChild:pathElement];
    [_blueDots addObject:pathElement];
	
    // draw and memorize quickest path
    while (currentX!=endX || currentY!=endY) {
        
        visited[currentX][currentY]=YES;
        
        // array of neighbors distance to end of maze
        float neighborDist[8];
        float minDist=9999;
        int next=-1;
        
        // Every distance is set to infinite
        for(int i=0;i<8;i++){
            neighborDist[i]=9999;
        }
        
        // find every neighbor's distance to end
        
        //left
        if(currentX-1>=0 && !visited[currentX-1][currentY])
            neighborDist[7]=distance[currentX-1][currentY];
        //left-bot
        if(currentX-1>=0 && currentY-1>=0 && !grid[currentX-1][currentY] && !grid[currentX][currentY-1] && !visited[currentX-1][currentY-1])
            neighborDist[6]=distance[currentX-1][currentY-1];
        //bot
        if(currentY-1>=0 && !visited[currentX][currentY-1])
            neighborDist[4]=distance[currentX][currentY-1];
        //right-bot
        if(currentX+1<NB_TOWER_X && currentY-1>=0 && !grid[currentX+1][currentY] && !grid[currentX][currentY-1] && !visited[currentX+1][currentY-1])
            neighborDist[1]=distance[currentX+1][currentY-1];
        //right
        if(currentX+1<NB_TOWER_X && !visited[currentX+1][currentY])
            neighborDist[0]=distance[currentX+1][currentY];
        //right-top
        if(currentX+1<NB_TOWER_X && currentY+1<NB_TOWER_Y && !grid[currentX+1][currentY] && !grid[currentX][currentY+1] && !visited[currentX+1][currentY+1])
            neighborDist[2]=distance[currentX+1][currentY+1];
        //top
        if(currentY+1<NB_TOWER_Y && !visited[currentX][currentY+1])
            neighborDist[3]=distance[currentX][currentY+1];
        //left-top
        if(currentX-1>=0 && currentY+1<NB_TOWER_Y && !grid[currentX-1][currentY] && !grid[currentX][currentY+1] && !visited[currentX-1][currentY+1])
            neighborDist[5]=distance[currentX-1][currentY+1];
        
        // find closest neighbor to the end
        for (int i=0; i<8; i++) {
            if (neighborDist[i]>=0 && neighborDist[i]<=((NB_TOWER_X-1)*(NB_TOWER_Y-1)) && neighborDist[i]<minDist) {
                minDist=neighborDist[i];
                next=i;
            }
        }
        NSLog(@"%d", next);
        // move trajectory to closest neighbor
        switch (next) {
            case 2:
                currentX++;
                currentY++;
                break;
            case 1:
                currentX++;
                currentY--;
                break;
            case 0:
                currentX++;
                break;
            case 3:
                currentY++;
                break;
            case 4:
                currentY--;
                break;
            case 5:
                currentX--;
                currentY++;
                break;
            case 6:
                currentX--;
                currentY--;
                break;
            case 7:
                currentX--;
                break;
            default:
                NSLog(@"path broken");
                return;
                break;
        }
        
        // Draw trajectory
        SKSpriteNode *pathElement = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(4, 4)];
        [pathElement setPosition:CGPointMake(currentX*TOWER_SIZE, currentY*TOWER_SIZE)];
        [_grid addChild:pathElement];
		[_blueDots addObject:pathElement];
        
        // add to path
        RouteStep* s =[[RouteStep alloc] init];
        s.posX=currentX*TOWER_SIZE+TOWER_SIZE/2;
        s.posY=currentY*TOWER_SIZE+TOWER_SIZE/2;
        [_path addObject:s];
        
    }
}

// Recursive algo that sets distance with end of path to every grid element (djikstra modified)
-(void)setDistance:(float[NB_TOWER_X][NB_TOWER_Y]) distArray withGrid:(BOOL[NB_TOWER_X][NB_TOWER_Y]) grid withPosX:(int) posX withPosY:(int) posY withDist:(float) dist{
    
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
    [self setDistance:distArray withGrid:grid withPosX:posX-1 withPosY:posY-1 withDist:dist+1.4];
    //bot
    [self setDistance:distArray withGrid:grid withPosX:posX withPosY:posY-1 withDist:dist+1];
    //right-bot
    [self setDistance:distArray withGrid:grid withPosX:posX+1 withPosY:posY-1 withDist:dist+1.4];
    //right
    [self setDistance:distArray withGrid:grid withPosX:posX+1 withPosY:posY withDist:dist+1];
    //right-top
    [self setDistance:distArray withGrid:grid withPosX:posX+1 withPosY:posY+1 withDist:dist+1.4];
    //top
    [self setDistance:distArray withGrid:grid withPosX:posX withPosY:posY+1 withDist:dist+1];
    //left-top
    [self setDistance:distArray withGrid:grid withPosX:posX-1 withPosY:posY+1 withDist:dist+1.4];
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
	
	[sn initWithType:0 andPath:_path];	
	
	sn.name = @"Minion";
    
    [_minions addObject:sn];
		
	
	//[sn addChild:healthBar];
	
	/*RouteStep *s1 = [[RouteStep alloc] init];
	s1.posX = 50;
	s1.posY = 50;
	
	RouteStep *s2 = [[RouteStep alloc] init];
	s2.posX = 100;
	s2.posY = 50;
	
	RouteStep *s3 = [[RouteStep alloc] init];
	s3.posX = 100;
	s3.posY = 100;*/
	
	//[_path addObject:s1];
	//[_path addObject:s2];
	//[_path addObject:s3];
	
	//	[sn walkPath:_path atIndex:0];
	[self addChild:sn];

}

-(void)update:(CFTimeInterval)currentTime {
	// spawning delay calculation
    CFTimeInterval timeSinceLastWalker = currentTime - self.lastSpawnTime;
	CFTimeInterval timeSinceLastUpdate = currentTime - self.lastUpdateTime;
	
	if(timeSinceLastUpdate>0.1){
		
		BOOL deadMinionFound = YES;
		while(deadMinionFound){
			for(Minion* m in _minions){
				if(m.isReadyToDie){
					[_minions removeObject:m];
					[m die];
					deadMinionFound = YES;
					break;
				}
			}
			deadMinionFound = NO;
		}

		
		
		for(Minion* m in _minions){
				[m walk];
		}
		
		
		

		
		for(Tower* t in _towerArray){
			[t updateTower:currentTime withMinions:_minions];
		}
		
		// spawn a new minion evrytim
		if (timeSinceLastWalker>2) {
					
			[self createMinion];
			_lastSpawnTime = currentTime;
			
		}
		
	}
	
}

@end
