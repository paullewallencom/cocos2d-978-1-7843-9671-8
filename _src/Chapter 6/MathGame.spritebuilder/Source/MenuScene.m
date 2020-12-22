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
		//ALBuffer *buffer = [[OALSimpleAudio sharedInstance] preloadEffect:@"soundEffect.mp3"];
		//[[OALSimpleAudio sharedInstance] unloadEffect:@"soundEffect.mp3"];
		//[[OALSimpleAudio sharedInstance] unloadAllEffects];
		
		//volume range: 0.0 to 1.0
		//pitch range:  1.0 to inf (1.0 is normal)
		//pan range:   -1.0 to 1.0 (far left to far right)
		//loop:			If YES, will play until stop is called on the sound
		id<ALSoundSource> effect;
		
		effect = [[OALSimpleAudio sharedInstance] playEffect:@"soundEffect.mp3" volume:1 pitch:1 pan:1 loop:NO];
		[effect stop];
		
		__block ALBuffer *soundBuffer;
		[[OALSimpleAudio sharedInstance] preloadEffect:@"sound.caf"
										  reduceToMono:NO
									   completionBlock:^(ALBuffer* buffer)
		{
			soundBuffer = buffer;
		}];
		
		
		
		//these values range 0 to 1.0, so use float to get ratio
		CCNode *background = [CCNodeColor nodeWithColor:[CCColor whiteColor]];
		[self addChild:background];
		
		winSize = [CCDirector sharedDirector].viewSize;
		CCButton *btnPlay = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"btnPlay.png"]];
		btnPlay.position = ccp(winSize.width/2, winSize.height * 0.5);
		[btnPlay setTarget:self selector:@selector(goToGame)];
		[self addChild:btnPlay];
	}
	return self;
}

-(void)goToGame
{
	[[OALSimpleAudio sharedInstance] playEffect:@"buttonClick.mp3"];
	[[CCDirector sharedDirector] replaceScene:[MainScene scene]];
}
@end
