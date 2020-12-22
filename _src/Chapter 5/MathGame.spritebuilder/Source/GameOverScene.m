//
//  GameOverScene.m
//  MathGame
//
//  Created by Alex Ogorek on 12/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameOverScene.h"
#import "MainScene.h"
#import "MenuScene.h"

@implementation GameOverScene

+(CCScene*)scene
{
	return [[self alloc] initWithScoreData:@{DictTotalScore : @0,
											 DictTurnsSurvived : @0,
											 DictUnitsKilled : @0,
											 DictHighScoreIndex : @(-1)}];
}

+(CCScene*)sceneWithScoreData:(NSDictionary *)dict
{
	return [[self alloc] initWithScoreData:dict];
}

-(id)initWithScoreData:(NSDictionary*)dict
{
	if ((self=[super init]))
	{
		winSize = [[CCDirector sharedDirector] viewSize];
		highScoreIndex = [dict[DictHighScoreIndex] integerValue];
		
		//these values range 0 to 1.0, so use float to get ratio
		CCNode *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:128/255.f green:128/255.f blue:128/255.f]];
		[self addChild:background];
		
		[[OALSimpleAudio sharedInstance] playEffect:@"gameOver.mp3"];
		
		CCButton *btnRestart = [CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"btnRestart.png"]];
		[btnRestart setTarget:self selector:@selector(restartGame)];
		CCButton *btnMenu = [CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"btnMenu.png"]];
		[btnMenu setTarget:self selector:@selector(goToMenu)];
		
		CCLayoutBox *buttonLayout = [CCLayoutBox node];
		[buttonLayout addChild:btnRestart];
		[buttonLayout addChild:btnMenu];
		[buttonLayout setDirection:CCLayoutBoxDirectionHorizontal];
		[buttonLayout setSpacing:winSize.width/2];
		buttonLayout.position = ccp(winSize.width/2, winSize.height * 0.1);
		buttonLayout.anchorPoint = ccp(0.5,0.5);
		[self addChild:buttonLayout];
		
		//left-side stuff (aka, current game)
		CCLabelBMFont *lblTurnsSurvivedDesc = [CCLabelBMFont labelWithString:@"Turns Survived:" fntFile:@"bmFont.fnt"];
		lblTurnsSurvivedDesc.position = ccp(winSize.width * 0.125, winSize.height * 0.8);
		[self addChild:lblTurnsSurvivedDesc];
		
		CCLabelBMFont *lblTurnsSurvived = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", [dict[DictTurnsSurvived] integerValue]] fntFile:@"bmFont.fnt"];
		lblTurnsSurvived.position = ccp(winSize.width * 0.125, winSize.height * 0.75);
		[self addChild:lblTurnsSurvived];
		
		CCLabelBMFont *lblUnitsKilledDesc = [CCLabelBMFont labelWithString:@"Units Killed:" fntFile:@"bmFont.fnt"];
		lblUnitsKilledDesc.position = ccp(winSize.width * 0.125, winSize.height * 0.6);
		[self addChild:lblUnitsKilledDesc];
		
		CCLabelBMFont *lblUnitsKilled = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", [dict[DictUnitsKilled] integerValue]] fntFile:@"bmFont.fnt"];
		lblUnitsKilled.position = ccp(winSize.width * 0.125, winSize.height * 0.55);
		[self addChild:lblUnitsKilled];
		
		CCLabelBMFont *lblTotalScoreDesc = [CCLabelBMFont labelWithString:@"Total Score:" fntFile:@"bmFont.fnt"];
		lblTotalScoreDesc.position = ccp(winSize.width * 0.125, winSize.height * 0.4);
		[self addChild:lblTotalScoreDesc];
		
		CCLabelBMFont *lblTotalScore = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", [dict[DictTotalScore] integerValue]] fntFile:@"bmFont.fnt"];
		lblTotalScore.position = ccp(winSize.width * 0.125, winSize.height * 0.35);
		[self addChild:lblTotalScore];
	}
	return self;
}

-(void)goToMenu
{
	//to be filled in later
	[[CCDirector sharedDirector] replaceScene:[MenuScene scene]];
}

-(void)restartGame
{
	//to be filled in later
	[[CCDirector sharedDirector] replaceScene:[MainScene scene]];
}
@end
