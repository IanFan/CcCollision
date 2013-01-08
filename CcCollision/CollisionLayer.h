//
//  CollisionLayer.h
//  BasicCocos2D
//
//  Created by Fan Tsai Ming on 12/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface CollisionLayer : CCLayer
{
  CCSprite *playerSprite;
  CGPoint playerVelocity;
  BOOL wasChangedImage;
  NSMutableArray *spriteNodeMutableArray;
}

+(CCScene *) scene;

-(void)update:(ccTime)dt;
-(void)addSpriteNode:(ccTime)dt;

-(void)checkCollision;
-(BOOL)returnBoolWithCircle1Point:(CGPoint)circle1Point radius:(float)circle1Radius collideWithCircle2Point:(CGPoint)circle2Point circle2Radius:(float)circle2Radius;
-(BOOL)returnBoolWithCirclePoint:(CGPoint)circlePoint circleRadius:(float)circleRadius collideWithRectPoint:(CGPoint)rectPoint rectHalfWidth:(float)rectHalfWidth rectHalfHeight:(float)rectHalfHeight;
-(BOOL)returnBoolWithRect1Point:(CGPoint)rect1Point rect1Width:(float)rect1Width rect1Height:(float)rect1Height collideWithRect2Point:(CGPoint)rect2Point rect2Width:(float)rect2Width rect2Height:(float)rect2Height;

@end
