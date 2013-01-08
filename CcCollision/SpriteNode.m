//
//  SpriteNode.m
//  BasicCocos2D
//
//  Created by Fan Tsai Ming on 12/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpriteNode.h"

@implementation SpriteNode

@synthesize sprite;
@synthesize ready;
@synthesize vx;
@synthesize vy;

- (id)initWithImageFile: (NSString *)imageFile{
  if (self = [super init]) {
    sprite = [[CCSprite alloc] initWithFile:imageFile];
    ready = YES;
    vx = 0.0f;
    vy = 0.0f;
  }
  return self;
}

- (void)dealloc {
  [sprite release];
  [super dealloc];
}

@end
