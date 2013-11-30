//
//  EDViewController.m
//  Element Defense
//
//  Created by Julien Saad on 11/29/2013.
//  Copyright (c) 2013 Third Bridge. All rights reserved.
//

#import "EDViewController.h"
#import "EDMyScene.h"

@implementation EDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    // Configure the view after it has been sized for the correct orientation.
    SKView *skView = (SKView *)self.view;
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
		
        // Create and configure the scene.
        EDMyScene *theScene = [EDMyScene sceneWithSize:skView.bounds.size];
        theScene.scaleMode = SKSceneScaleModeAspectFill;
		
        // Present the scene.
        [skView presentScene:theScene];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
