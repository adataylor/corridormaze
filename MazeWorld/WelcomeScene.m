//
//  WelcomeScene.m
//  MazeWorld
//
//  Created by Ada Taylor on 7/22/13.
//  Copyright (c) 2013 Ada Taylor. All rights reserved.
//

#import "WelcomeScene.h"

@implementation WelcomeScene

- (void)didMoveToView:(SKView *)view {
    if(!self.contentCreated) {
        
        [self createSceneContents];
        self.contentCreated = YES;
    }
    
}

- (void)createSceneContents {

    self.backgroundColor = [SKColor blueColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    [self addChild:[self newHelloNode]];
    
}

- (SKLabelNode*)newHelloNode {
    
    SKLabelNode *helloNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    helloNode.text = @"Hello, World";
    helloNode.fontSize = 42;
    helloNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    helloNode.name = @"helloNode";
    
    return helloNode;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    SKNode *helloNode = [self childNodeWithName:@"helloNode"];
    
    if (helloNode != nil)
    {
        helloNode.name = nil;
        SKAction *moveUp = [SKAction moveByX: 0 y: 100.0 duration: 0.5];
        SKAction *zoom = [SKAction scaleTo: 2.0 duration: 0.25];
        SKAction *pause = [SKAction waitForDuration: 0.5];
        SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.25];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *moveSequence = [SKAction sequence:@[moveUp, zoom,
                                                      pause, fadeAway, remove]];
        [helloNode runAction: moveSequence];
    }
    
}

@end
