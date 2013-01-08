//
//  SpriteNode.h
//  BasicCocos2D
//
//  Created by Fan Tsai Ming on 12/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface SpriteNode : CCNode {
  CCSprite *sprite;
  float vx, vy;
  bool ready;
  
}

-(id)initWithImageFile: (NSString *)imageFile;

@property(nonatomic, retain) CCSprite *sprite;
@property(readwrite) bool ready;
@property(readwrite) float vx;
@property(readwrite) float vy;

@end
