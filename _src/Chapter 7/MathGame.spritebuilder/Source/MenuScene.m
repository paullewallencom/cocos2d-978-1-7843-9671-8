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
		winSize = [CCDirector sharedDirector].viewSize;
		
		//these values range 0 to 1.0, so use float to get ratio
		CCNode *background = [CCNodeColor nodeWithColor:[CCColor whiteColor] width:winSize.width*5 height:winSize.height*5];
		background.anchorPoint = ccp(0.5,0.5);
		background.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:background z:-2];
		
		CCLabelBMFont *lblTitle = [CCLabelBMFont labelWithString:@"Cubic!" fntFile:@"bmTitleFont.fnt"];
		lblTitle.position = ccp(winSize.width/2, winSize.height * 0.8);
		lblTitle.color = [CCColor colorWithRed:52/255.f green:73/255.f blue:94/255.f];
		[self addChild:lblTitle];
		
		CCButton *btnPlay = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"btnPlay.png"]];
		btnPlay.position = ccp(winSize.width/2, winSize.height * 0.5);
		[btnPlay setTarget:self selector:@selector(goToGame)];
		[self addChild:btnPlay];
		
		//add the sound and music buttons:
		
		CCButton *btnSound = [CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"btnSoundOn.png"]];
		[btnSound setBackgroundSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"btnSoundOff.png"] forState:CCControlStateSelected];
		btnSound.position = ccp(winSize.width * 0.35, winSize.height * 0.2);
		[btnSound setTogglesSelectedState:YES];
		[btnSound setTarget:self selector:@selector(soundToggle)];
		[self addChild:btnSound];
		
		CCButton *btnMusic = [CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"btnMusicOn.png"]];
		[btnMusic setBackgroundSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"btnMusicOff.png"] forState:CCControlStateSelected];
		btnMusic.position = ccp(winSize.width * 0.65, winSize.height * 0.2);
		[btnMusic setTogglesSelectedState:YES];
		[btnMusic setTarget:self selector:@selector(musicToggle)];
		[self addChild:btnMusic];
		
		isSoundOn = [[NSUserDefaults standardUserDefaults] boolForKey:KeySound];
		isMusicOn = [[NSUserDefaults standardUserDefaults] boolForKey:KeyMusic];
		
		btnSound.selected = !isSoundOn;
		btnMusic.selected = !isMusicOn;		
	}
	return self;
}

-(void)goToGame
{
	if (isSoundOn)
		[[OALSimpleAudio sharedInstance] playEffect:@"buttonClick.mp3"];
	
	[MainScene rubberBandToScene:[MainScene scene] fromParent:self withDuration:0.5f withDirection:kMoveDirectionUp];
}

-(void)soundToggle
{
	isSoundOn = !isSoundOn;
	[[NSUserDefaults standardUserDefaults] setBool:isSoundOn forKey:KeySound];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	if (isSoundOn)
		[[OALSimpleAudio sharedInstance] playEffect:@"buttonClick.mp3"];
}

-(void)musicToggle
{
	isMusicOn = !isMusicOn;
	[[NSUserDefaults standardUserDefaults] setBool:isMusicOn forKey:KeyMusic];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	isMusicOn ? [[OALSimpleAudio sharedInstance] playBg] : [[OALSimpleAudio sharedInstance] bgPaused];
	
	if (isSoundOn)
		[[OALSimpleAudio sharedInstance] playEffect:@"buttonClick.mp3"];
}

@end
