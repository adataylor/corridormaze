//
//  MazeViewController.m
//  MazeWorld
//
//  Created by Ada Taylor on 7/22/13.
//  Copyright (c) 2013 Ada Taylor. All rights reserved.
//

#import "MazeViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "WelcomeScene.h"

@interface MazeViewController ()

@end

@implementation MazeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SKView *spriteView = (SKView*)self.view;
    spriteView.showsDrawCount = YES;
    spriteView.showsNodeCount = YES;
    spriteView.showsFPS = YES;
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {

    WelcomeScene* hello = [[WelcomeScene alloc] initWithSize:CGSizeMake(768, 1024)];
    SKView *spriteView = (SKView*) self.view;
    [spriteView presentScene:hello];
}




@end
