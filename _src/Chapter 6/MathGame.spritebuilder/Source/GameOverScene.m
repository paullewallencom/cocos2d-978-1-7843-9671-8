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
		CCNode *background = [CCNodeColor nodeWithColor:[CCColor whiteColor]];
		[self addChild:background];
		
		[[OALSimpleAudio sharedInstance] playEffect:@"gameOver.mp3"];
		
		CCButton *btnRestart = [CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"btnRestart.png"]];
		[btnRestart setTarget:self selector:@selector(restartGame)];
		CCButton *btnMenu = [CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"btnMenu.png"]];
		[btnMenu setTarget:self selector:@selector(goToMenu)];
		
		CCLayoutBox *layoutButtons = [[CCLayoutBox alloc] init];
		[layoutButtons addChild:btnRestart];
		[layoutButtons addChild:btnMenu];
		layoutButtons.spacing = 10.f;
		layoutButtons.anchorPoint = ccp(0.5f, 0.5f);
		layoutButtons.direction = CCLayoutBoxDirectionVertical;
		[layoutButtons layout];
		layoutButtons.position = ccp(winSize.width * 0.125, winSize.height * 0.15);
		[self addChild:layoutButtons];
		
		//left-side stuff (aka, current game)
		CCLabelBMFont *lblTurnsSurvivedDesc = [CCLabelBMFont labelWithString:@"Turns Survived:" fntFile:@"bmFont.fnt"];
		lblTurnsSurvivedDesc.position = ccp(winSize.width * 0.125, winSize.height * 0.9);
		[self addChild:lblTurnsSurvivedDesc];
		
		CCLabelBMFont *lblTurnsSurvived = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%ld", (long)[dict[DictTurnsSurvived] integerValue]] fntFile:@"bmScoreFont.fnt"];
		lblTurnsSurvived.position = ccp(winSize.width * 0.125, winSize.height * 0.82);
		[self addChild:lblTurnsSurvived];
		
		CCLabelBMFont *lblUnitsKilledDesc = [CCLabelBMFont labelWithString:@"Units Killed:" fntFile:@"bmFont.fnt"];
		lblUnitsKilledDesc.position = ccp(winSize.width * 0.125, winSize.height * 0.7);
		[self addChild:lblUnitsKilledDesc];
		
		CCLabelBMFont *lblUnitsKilled = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%ld", (long)[dict[DictUnitsKilled] integerValue]] fntFile:@"bmScoreFont.fnt"];
		lblUnitsKilled.position = ccp(winSize.width * 0.125, winSize.height * 0.62);
		[self addChild:lblUnitsKilled];
		
		CCLabelBMFont *lblTotalScoreDesc = [CCLabelBMFont labelWithString:@"Total Score:" fntFile:@"bmFont.fnt"];
		lblTotalScoreDesc.position = ccp(winSize.width * 0.125, winSize.height * 0.5);
		[self addChild:lblTotalScoreDesc];
		
		CCLabelBMFont *lblTotalScore = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%ld", (long)[dict[DictTotalScore] integerValue]] fntFile:@"bmScoreFont.fnt"];
		lblTotalScore.position = ccp(winSize.width * 0.125, winSize.height * 0.42);
		[self addChild:lblTotalScore];
		
		//table stuff
		arrScores = [[NSUserDefaults standardUserDefaults] arrayForKey:DataHighScores];
		
		CCLabelBMFont *lblTableTotalScore = [CCLabelBMFont labelWithString:@"Total Score:" fntFile:@"bmFont.fnt"];
		CCLabelBMFont *lblTableUnitsKilled = [CCLabelBMFont labelWithString:@"Units Killed:" fntFile:@"bmFont.fnt"];
		CCLabelBMFont *lblTableTurnsSurvived = [CCLabelBMFont labelWithString:@"Turns Survived:" fntFile:@"bmFont.fnt"];
		
		lblTableTurnsSurvived.scale =
		lblTableTotalScore.scale =
		lblTableUnitsKilled.scale = 0.8f;
		
		lblTableTotalScore.position = ccp(winSize.width * 0.475, winSize.height * 0.85);
		lblTableUnitsKilled.position = ccp(winSize.width * 0.65, winSize.height * 0.85);
		lblTableTurnsSurvived.position = ccp(winSize.width * 0.85, winSize.height * 0.85);
		
		lblTurnsSurvivedDesc.color =
		lblTurnsSurvived.color =
		lblTotalScoreDesc.color =
		lblTotalScore.color =
		lblUnitsKilledDesc.color =
		lblUnitsKilled.color =
		lblTableUnitsKilled.color =
		lblTableTotalScore.color =
		lblTableTurnsSurvived.color = [CCColor colorWithRed:52/255.f green:73/255.f blue:94/255.f];
		
		[self addChild:lblTableTurnsSurvived];
		[self addChild:lblTableTotalScore];
		[self addChild:lblTableUnitsKilled];
		
		CCTableView *tblScores = [CCTableView node];
		tblScores.contentSize = CGSizeMake(0.7, 0.4);
		CGFloat ratioX = (1.0 - tblScores.contentSize.width) * 0.8;
		CGFloat ratioY = (1.0 - tblScores.contentSize.height) / 2;
		tblScores.position = ccp(winSize.width * ratioX, winSize.height * ratioY);
		tblScores.dataSource = self;
		tblScores.block = ^(CCTableView *table){
			//if the press a cell, do something here.
			//NSLog(@"Cell %ld", (long)table.selectedRow);
		};
		[self addChild:tblScores];
	}
	return self;
}

-(CCTableViewCell*)tableView:(CCTableView *)tableView nodeForRowAtIndex:(NSUInteger)index
{
	CCTableViewCell* cell = [CCTableViewCell node];
	
	cell.contentSizeType = CCSizeTypeMake(CCSizeUnitNormalized, CCSizeUnitPoints);
	cell.contentSize = CGSizeMake(1, 40);
	
	// Color every other row differently
	CCNodeColor* bg;
	if (index == highScoreIndex) bg = [CCNodeColor nodeWithColor:[CCColor colorWithRed:52/255.f green:73/255.f blue:94/255.f]];
	else if	(index % 2 != 0) bg = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
	else bg = [CCNodeColor nodeWithColor: [CCColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
	
	bg.userInteractionEnabled = NO;
	bg.contentSizeType = CCSizeTypeNormalized;
	bg.contentSize = CGSizeMake(1, 1);
	[cell addChild:bg];
	
	CCLabelBMFont *lblScoreNumber = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d)", index+1] fntFile:@"bmScoreFont.fnt"];
	lblScoreNumber.anchorPoint = ccp(1,0.5);
	
	CCLabelBMFont *lblTotalScore = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%ld", (long)[arrScores[index][DictTotalScore] integerValue]] fntFile:@"bmScoreFont.fnt"];
	CCLabelBMFont *lblUnitsKilled = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%ld", (long)[arrScores[index][DictUnitsKilled] integerValue]] fntFile:@"bmScoreFont.fnt"];
	CCLabelBMFont *lblTurnsSurvived = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%ld", (long)[arrScores[index][DictTurnsSurvived] integerValue]] fntFile:@"bmScoreFont.fnt"];
	
	//lblTurnsSurvived.string = @"1000";
	
	lblScoreNumber.positionType = lblTotalScore.positionType = lblUnitsKilled.positionType = lblTurnsSurvived.positionType = CCPositionTypeNormalized;
	lblScoreNumber.position = ccp(0.15,0.5);
	lblTotalScore.position = ccp(0.35,0.5);
	lblUnitsKilled.position = ccp(0.6,0.5);
	lblTurnsSurvived.position = ccp(0.85,0.5);
	
	lblScoreNumber.color =
	lblTotalScore.color =
	lblUnitsKilled.color =
	lblTurnsSurvived.color = (index == highScoreIndex) ? [CCColor colorWithRed:242/255.f green:195/255.f blue:17/255.f] : [CCColor colorWithRed:52/255.f green:73/255.f blue:94/255.f];
	
	if (index == highScoreIndex)
	{
		CCNodeColor *border = [CCNodeColor nodeWithColor:[CCColor colorWithRed:242/255.f green:195/255.f blue:17/255.f] width:1.02 height:1.1];
		border.contentSizeType = CCSizeTypeNormalized;
		border.positionType = CCPositionTypeNormalized;
		border.position = ccp(0.5,0.5);
		border.anchorPoint = ccp(0.5,0.5);
		[bg addChild:border z:-1];
	}
	
	[cell addChild:lblScoreNumber];
	[cell addChild:lblTurnsSurvived];
	[cell addChild:lblTotalScore];
	[cell addChild:lblUnitsKilled];
	return cell;
}

-(NSUInteger)tableViewNumberOfRows:(CCTableView *)tableView
{
	return [arrScores count];
}

-(float)tableView:(CCTableView *)tableView heightForRowAtIndex:(NSUInteger)index
{
	return 40.f;
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
