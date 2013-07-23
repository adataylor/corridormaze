//
//  MazeScene.m
//  MazeWorld
//
//  Created by Ada Taylor on 7/22/13.
//  Copyright (c) 2013 Ada Taylor. All rights reserved.
//

//WHAT IF MAKE MOVES DUE TO TILT CONTROL


#import "MazeScene.h"


@interface MazeScene ()
@property BOOL contentCreated;
@property SKSpriteNode *player;
@end


@implementation MazeScene

static const uint32_t playerCategory = 0x1 << 0;
static const uint32_t wallCategory = 0x1 << 1;
static const uint32_t catCategory = 0x1 << 2;
static const uint32_t thingCategory = 0x1 << 3;


- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        
        self.physicsWorld.gravity = CGPointMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor brownColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    _player = [self newPlayer];
    _player.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
	[self addChild:_player];
    
    
    [self makeObstacles];
    
}

- (void) makeObstacles {
    SKAction *makeRocks = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(addHorizWall) onTarget:self],
                                                //[SKAction waitForDuration:0.10 withRange:0.15]
                                                ]];
    [self runAction: [SKAction repeatAction:makeRocks count:60]];
    
    
    makeRocks = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(addVertWall) onTarget:self],
                                                //[SKAction waitForDuration:0.10 withRange:0.15]
                                                ]];
    [self runAction: [SKAction repeatAction:makeRocks count:60]];

}


static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}
static inline CGFloat skRand(CGFloat low, CGFloat high) {
    float num = (skRandf() * (high - low) + low);
    return num - fmodf(num, 50);
}

- (void) addVertWall
{
    SKSpriteNode *rock = [[SKSpriteNode alloc] initWithColor:[SKColor
                                                                blackColor] size:CGSizeMake(15,50)];
    rock.position = CGPointMake(skRand(0, self.size.width),
                                skRand(0, self.size.height));
    rock.name = @"rock";
    rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
    rock.physicsBody.usesPreciseCollisionDetection = YES;
//    rock.physicsBody.dynamic = YES;
    rock.physicsBody.affectedByGravity = NO;
    rock.physicsBody.mass = 1;
    rock.physicsBody.friction = 0;
    
    rock.physicsBody.allowsRotation = NO;
    
    [self addChild:rock];
}

- (void) addHorizWall
{
    SKSpriteNode *rock = [[SKSpriteNode alloc] initWithColor:[SKColor
                                                              blackColor] size:CGSizeMake(50,15)];
    rock.position = CGPointMake(skRand(0, self.size.width),
                                skRand(0, self.size.height));
    rock.name = @"rock";
    rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
    rock.physicsBody.usesPreciseCollisionDetection = YES;
//    rock.physicsBody.dynamic = YES;
    rock.physicsBody.affectedByGravity = NO;
    //rock.physicsBody.mass = 1;
    rock.physicsBody.friction = 0;
    rock.physicsBody.categoryBitMask = wallCategory;
    rock.physicsBody.collisionBitMask = playerCategory;
    rock.physicsBody.contactTestBitMask = playerCategory;
    
    
    [self addChild:rock];
}


- (SKSpriteNode *) newPlayer{
    SKSpriteNode *player = [[SKSpriteNode alloc] initWithColor:[SKColor whiteColor] size:CGSizeMake(20, 20)];
    player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.size];

    player.physicsBody.dynamic = YES;
    player.physicsBody.affectedByGravity = NO;
    //player.physicsBody.mass = 2000000000000;
    
    player.physicsBody.categoryBitMask = playerCategory;
    
    player.physicsBody.collisionBitMask = wallCategory | catCategory;
    
    player.physicsBody.contactTestBitMask = wallCategory | catCategory;
    
    return player;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self move:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self move:event];
}

-(void) move:(UIEvent*)event {
    CGPoint charPos = self.player.position;
    
    float speed = 800.0;
    
    UITouch* touch = [[event allTouches] anyObject];
    CGPoint clickPoint = [touch locationInNode:self.player];
    
    
//    NSLog(@"player X: %.02f", self.player.position.x);
//    NSLog(@"click X: %.02f", clickPoint.x);
//    
//    NSLog(@"player Y: %.02f", self.player.position.y);
//    NSLog(@"click Y: %.02f", clickPoint.y);


    CGFloat distance = sqrtf((clickPoint.x-charPos.x)*(clickPoint.x-charPos.x)+
                             (clickPoint.y-charPos.y)*(clickPoint.y-charPos.y));
    
//    SKAction *moveToClick = [SKAction moveByX:clickPoint.x y:clickPoint.y duration:.02];
//    [self.player runAction:moveToClick withKey:@"moveToClick"];
    
    
    CGFloat bearingRadians = atan2f(charPos.y - clickPoint.y, charPos.x - clickPoint.x);
    CGFloat myDirection = bearingRadians * (180. / M_PI);
    
    static const CGFloat thrust = 60.12;
    
    CGPoint thrustVector = CGPointMake(thrust*cosf(myDirection),
                                       thrust*sinf(myDirection));
    
    
    NSLog(@"direction Radians: %.02f", bearingRadians);
    NSLog(@"direction Degrees: %.02f", myDirection);
    NSLog(@"Thrust X: %.02f", thrustVector.x);
    NSLog(@"Thrust Y: %.02f", thrustVector.y);
    NSLog(@"diffX: %.02f", clickPoint.x-charPos.x);
    NSLog(@"diffY: %.02f", clickPoint.y-charPos.y);
    
    
    //[_player.physicsBody applyForce:thrustVector];
    
    
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [_player.physicsBody setVelocity:CGPointMake(0, 0)];
    
    //SKAction *moveToClick = [SKAction moveByX:0 y:0 duration:.01];
    //[self.player runAction:moveToClick withKey:@"moveToClick"];
}

- (void)didBeginContact:(SKPhysicsContact *)contact {

    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if(firstBody.categoryBitMask == playerCategory) {
        NSLog(@"Ouch");
    }
    
    
    
}


@end