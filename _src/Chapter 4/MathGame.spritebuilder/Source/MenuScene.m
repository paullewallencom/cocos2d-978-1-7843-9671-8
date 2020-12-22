//
//  MenuScene.m
//  MathGame
//
//  Created by Alex Ogorek on 12/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "MenuScene.h"
#import "MainScene.h"

@implementation MenuScene
+(CCScene*)scene
{
	return [[self alloc] init];
}

-(id)init
{
	if ((self=[super init]))
	{
		
		
		//these values range 0 to 1.0, so use float to get ratio
		CCNode *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:58/255.f green:138/255.f blue:88/255.f]];
		[self addChild:background];
		
		winSize = [CCDirector sharedDirector].viewSize;
		CCButton *btnPlay = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"btnPlay.png"]];
		btnPlay.position = ccp(winSize.width/2, winSize.height/2);
		[btnPlay setTarget:self selector:@selector(goToGame)];
		[self addChild:btnPlay];
	}
	return self;
}

-(void)goToGame
{
	[[CCDirector sharedDirector] replaceScene:[MainScene scene]];
}
@end
