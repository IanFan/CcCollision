//
//  CollisionLayer.m
//  BasicCocos2D
//
//  Created by Fan Tsai Ming on 12/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CollisionLayer.h"
#import "AppDelegate.h"
#import "SpriteNode.h"

@implementation CollisionLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];	
	CollisionLayer *layer = [CollisionLayer node];
	[scene addChild: layer];
  
	return scene;
}

#pragma mark - Update

-(void)update:(ccTime)dt
{
  for (SpriteNode *spriteNode in spriteNodeMutableArray) {
    if (spriteNode.ready == NO) {
      [spriteNode.sprite setPosition:ccp(spriteNode.sprite.position.x + spriteNode.vx,
                                         spriteNode.sprite.position.y + spriteNode.vy)];
      
      if (spriteNode.sprite.position.y <= -spriteNode.sprite.boundingBox.size.height) {
        [spriteNode.sprite setPosition:ccp(-spriteNode.sprite.boundingBox.size.width, -spriteNode.sprite.boundingBox.size.height)];
        [spriteNode setReady:YES];
      }
    }
  }
  //
  CGPoint position = playerSprite.position;
  position.x += playerVelocity.x;
  position.y += playerVelocity.y;
  
  CGSize screenSize = [CCDirector sharedDirector].winSize;
  float imageWidthHalved = 0.5*playerSprite.texture.contentSize.width;
  float leftBorderLimit = imageWidthHalved;
  float rightBorderLimit = screenSize.width - imageWidthHalved;
  
  if (position.x < leftBorderLimit) {
    position.x = leftBorderLimit;
    playerVelocity.x = 0;
  }else if (position.x > rightBorderLimit){
    position.x = rightBorderLimit;
    playerVelocity.x = 0;
  }
  
  float imageHeightHalved = 0.5*playerSprite.texture.contentSize.height;
  float bottomBorderLimit = imageHeightHalved;
  float topBorderLimit = screenSize.height - imageHeightHalved;
  
  if (position.y < bottomBorderLimit) {
    position.y = bottomBorderLimit;
    playerVelocity.y = 0;
  }else if (position.y > topBorderLimit){
    position.y = topBorderLimit;
    playerVelocity.y = 0;
  }
  
  [playerSprite setPosition:position];
  
  [self checkCollision];
}

-(void)addSpriteNode:(ccTime)dt
{
  if (CCRANDOM_0_1() >= 0.3) {
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    for (SpriteNode *spriteNode in spriteNodeMutableArray) {
      if (spriteNode.ready) {
        [spriteNode.sprite setPosition:ccp(CCRANDOM_0_1() * screenSize.width, screenSize.height + spriteNode.sprite.boundingBox.size.height/2)];
        [spriteNode setVx:0];
        [spriteNode setVy:-CCRANDOM_0_1() * 8 - 2];
        [spriteNode setReady:NO];
        break;
      }
    }
  }
}

#pragma mark - Collision

-(void)checkCollision {
  BOOL isCollideAtLeastOnce = NO;
  
  for (SpriteNode *spriteNode in spriteNodeMutableArray) {
    if (spriteNode.ready == NO) {
      CGPoint circlePosition = spriteNode.sprite.position;
      float circleRadius = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 50:25;
      
      CGPoint rectPosition = playerSprite.position;
      float rectHalfWidth = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 50:25;
      float rectHalfHeight = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 50:25;

      
      BOOL isCollide;
      
      //check circle collide with rect
      isCollide = [self returnBoolWithCirclePoint:circlePosition circleRadius:circleRadius collideWithRectPoint:rectPosition rectHalfWidth:rectHalfWidth rectHalfHeight:rectHalfHeight];
      
      if (isCollide == YES) {
        isCollideAtLeastOnce = YES;
        
        if (wasChangedImage == NO) {
          [playerSprite setTexture:[[CCTextureCache sharedTextureCache] addImage:@"square_selected.png"]];
          wasChangedImage = YES;
        }
      }
    }
  }
  
  if (isCollideAtLeastOnce == NO && wasChangedImage == YES) {
    wasChangedImage = NO;
    [playerSprite setTexture:[[CCTextureCache sharedTextureCache] addImage:@"square.png"]];
  }
}

#pragma mark - CollisionMath with CircleAndRect

-(BOOL)returnBoolWithCircle1Point:(CGPoint)circle1Point radius:(float)circle1Radius collideWithCircle2Point:(CGPoint)circle2Point circle2Radius:(float)circle2Radius; {
  float distance = ccpDistance(circle1Point, circle2Point);
  float maxCollisionDistance = circle1Radius + circle2Radius;
  
  return (distance < maxCollisionDistance);
}

-(BOOL)returnBoolWithRect1Point:(CGPoint)rect1Point rect1Width:(float)rect1Width rect1Height:(float)rect1Height collideWithRect2Point:(CGPoint)rect2Point rect2Width:(float)rect2Width rect2Height:(float)rect2Height {
  CGRect rect1 = CGRectMake(rect1Point.x, rect1Point.y, rect1Width, rect1Height);
  CGRect rect2 = CGRectMake(rect2Point.x, rect2Point.y, rect2Width, rect2Height);
  
  return CGRectIntersectsRect(rect1, rect2);
}

-(BOOL)returnBoolWithCirclePoint:(CGPoint)circlePoint circleRadius:(float)circleRadius collideWithRectPoint:(CGPoint)rectPoint rectHalfWidth:(float)rectHalfWidth rectHalfHeight:(float)rectHalfHeight {
  float distanceX = abs(circlePoint.x - rectPoint.x);
  float distanceY = abs(circlePoint.y - rectPoint.y);
  
  //check must No Collision situation: 
  if (distanceX > (rectHalfWidth + circleRadius)) return NO;
  if (distanceY > (rectHalfHeight + circleRadius)) return NO;
  
  //check must Collision situation:
  if (distanceX <= rectHalfWidth) return YES;
  if (distanceY <= rectHalfHeight) return YES;
  
  //check detail Collision situtation:
  float distance = (distanceX - rectHalfWidth)*(distanceX - rectHalfWidth) + (distanceY-rectHalfHeight)*(distanceY-rectHalfHeight);
  float maxCollisionDistance = circleRadius * circleRadius;
  return (distance <= maxCollisionDistance);
}

#pragma mark - Accelerometer

-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
  float deceleration = 0.1f;
  float sensitivity = 30.0f;
  float maxVelocity = 600.0f;
  float adjustForUserExp = 0;//recommand 6.0
  
  AppController *app = (AppController*)[[UIApplication sharedApplication] delegate];
  UIInterfaceOrientation interfaceOrientation =  app.navController.interfaceOrientation;
  
  switch (interfaceOrientation) {
    case UIInterfaceOrientationPortrait:
      playerVelocity.x = playerVelocity.x*deceleration + acceleration.x*sensitivity;
      playerVelocity.y = playerVelocity.y*deceleration + acceleration.y*sensitivity + adjustForUserExp;
      break;
    case UIInterfaceOrientationPortraitUpsideDown:
      playerVelocity.x = playerVelocity.x*deceleration - acceleration.x*sensitivity;
      playerVelocity.y = playerVelocity.y*deceleration - acceleration.y*sensitivity + adjustForUserExp;
      break;
    case UIInterfaceOrientationLandscapeLeft:
      playerVelocity.x = playerVelocity.x*deceleration + acceleration.y*sensitivity;
      playerVelocity.y = playerVelocity.y*deceleration - acceleration.x*sensitivity + adjustForUserExp;
      break;
    case UIInterfaceOrientationLandscapeRight:
      playerVelocity.x = playerVelocity.x*deceleration - acceleration.y*sensitivity;
      playerVelocity.y = playerVelocity.y*deceleration + acceleration.x*sensitivity + adjustForUserExp;
      break;
      
    default:
      break;
  }
  
  if (playerVelocity.x > maxVelocity) playerVelocity.x = maxVelocity;
  else if (playerVelocity.x < -maxVelocity) playerVelocity.x = -maxVelocity;
  
  if (playerVelocity.y > maxVelocity) playerVelocity.y = maxVelocity;
  else if (playerVelocity.y < -maxVelocity) playerVelocity.y = -maxVelocity;
}

#pragma mark - Set

-(void)setPlayer {
  CGSize screenSize = [CCDirector sharedDirector].winSize;
  playerSprite = [CCSprite spriteWithFile:@"square.png"];
  [playerSprite setPosition:ccp(screenSize.width/2, 100)];
  playerSprite.scale = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 1.0: 0.5;
  
  [self addChild:playerSprite];
}

-(void)setMultipleSprite {
  spriteNodeMutableArray = [[NSMutableArray alloc]init];
  
  for (int i=0; i<20; i++) {
    SpriteNode *spriteNode = [[SpriteNode alloc]initWithImageFile:@"ball.png"];
    [spriteNode.sprite setPosition:ccp(-spriteNode.sprite.boundingBox.size.width, -spriteNode.sprite.boundingBox.size.height)];
    [spriteNodeMutableArray addObject:spriteNode];
    spriteNode.sprite.scale = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 1.0: 0.5;
    
    [self addChild:spriteNode.sprite];
    [spriteNode release];
  }
}

/*
 Target: Learn how to detect when a circle collide with a rect.
 
 1. set a rect to be the player effected by accelerometer
 2. set multiple sprite
 3. update the sprites, and detect the collision.
 */

#pragma mark - Init

-(id) init {
	if( (self=[super init])) {
    [self setPlayer];
    
    [self setMultipleSprite];
    
    [self schedule:@selector(addSpriteNode:) interval:0.5f];
    [self schedule:@selector(update:) interval:1.0f/60.0f];
    
    self.isAccelerometerEnabled = YES;
	}
	return self;
}

- (void) dealloc {
  [spriteNodeMutableArray release], spriteNodeMutableArray=nil;
  
	[super dealloc];
}

@end
