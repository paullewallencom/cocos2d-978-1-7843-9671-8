//
//  GameScene.m
//  Depth
//
//  Created by Alex Ogorek on 1/19/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene
+(CCScene*)scene
{
	return [[self alloc] init];
}

-(id)init
{
	if ((self=[super init]))
	{
		winSize = [[CCDirector sharedDirector] viewSize];
	}
	return self;
}

@end
