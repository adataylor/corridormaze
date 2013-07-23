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
@property NSMutableArray *grooves;
@end


@implementation MazeScene

static const uint32_t playerCategory = 0x1 << 0;
static const uint32_t wallCategory = 0x1 << 1;
static const uint32_t catCategory = 0x1 << 2;
static const uint32_t thingCategory = 0x1 << 3;

static const uint32_t NUM_ROW = 10;
static const uint32_t NUM_COL = 16;
static const uint32_t WALL_WIDTH = 10;


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
    self.backgroundColor = [SKColor grayColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    _player = [self newPlayer];
    _player.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
	[self addChild:_player];
    
    //[self makeGrooves];
    
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

- (void) makeGrooves
{
    SKSpriteNode *groove = nil;
    
    int colSize = self.size.width / NUM_COL;
    int rowSize = self.size.height / NUM_ROW;
    
    for (int i = 2; i < NUM_ROW - 1; i++) {
        for (int j = 2; j < NUM_COL - 1; j++) {
            groove = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(WALL_WIDTH,colSize)];
            groove.position = CGPointMake(j*rowSize, i*colSize);
            groove.name = @"groove";
            [self addChild:groove];
    

            groove = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(rowSize,WALL_WIDTH)];
            groove.position = CGPointMake(j*colSize, i*rowSize);
            groove.name = @"groove";
            [self addChild:groove];
        }
    }
    
    
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

    player.physicsBody.allowsRotation = NO;
    
    player.physicsBody.categoryBitMask = playerCategory;
    player.physicsBody.collisionBitMask = wallCategory | catCategory;
    player.physicsBody.contactTestBitMask = wallCategory | catCategory;
    
    return player;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self move:event withTouches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self move:event withTouches:touches];
}

-(void) move:(UIEvent*)event withTouches:(NSSet *)touches {
    CGPoint charPos = self.player.position;
    
    float speed = 800.0;
    
    UITouch* touch1 = [[event allTouches] anyObject];
    CGPoint clickPoint = [touch1 locationInNode:self.player];
    
    
//    NSLog(@"player X: %.02f", self.player.position.x);
//    NSLog(@"click X: %.02f", clickPoint.x);
//    
//    NSLog(@"player Y: %.02f", self.player.position.y);
//    NSLog(@"click Y: %.02f", clickPoint.y);


    CGFloat distance = sqrtf((clickPoint.x-charPos.x)*(clickPoint.x-charPos.x)+
                             (clickPoint.y-charPos.y)*(clickPoint.y-charPos.y));
    
//    SKAction *moveToClick = [SKAction moveByX:clickPoint.x y:clickPoint.y duration:.02];
//    [self.player runAction:moveToClick withKey:@"moveToClick"];
    
    
    CGFloat bearingRadians = atan2f(clickPoint.y, clickPoint.x);
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
    
    
    [_player.physicsBody applyForce:thrustVector];
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self];
    
    CGFloat xDirection = touchPoint.x - _player.position.x;
    CGFloat yDirection = touchPoint.y - _player.position.y;
    
    [_player.physicsBody applyForce: CGPointMake(xDirection, yDirection)];
    
    
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