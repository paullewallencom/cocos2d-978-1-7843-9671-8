#import "MainScene.h"
#import "MenuScene.h"
#import "Unit.h"
#import "GameOverScene.h"

NSString *const DataHighScores = @"highScores";
NSString *const DictTotalScore = @"totalScore";
NSString *const DictTurnsSurvived = @"turnsSurvived";
NSString *const DictUnitsKilled = @"unitsKilled";
NSString *const DictHighScoreIndex = @"hsIndex";

@implementation MainScene

+(CCScene *)scene
{
	return [[self alloc] init];
}

-(id)init
{
	if ((self=[super init]))
	{
		//used for positioning items on screen
		winSize = [[CCDirector sharedDirector] viewSize];
		
		float grey = 70 / 255.f;
		//these values range 0 to 1.0, so use float to get ratio
		CCNode *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:grey green:grey blue:grey]];
		[self addChild:background];		
		
		CCLabelBMFont *lblTurnsSurvivedDesc = [CCLabelBMFont labelWithString:@"Turns Survived:" fntFile:@"bmFont.fnt"];
		lblTurnsSurvivedDesc.position = ccp(winSize.width * 0.125, winSize.height * 0.8);
		[self addChild:lblTurnsSurvivedDesc];
		
		lblTurnsSurvived = [CCLabelBMFont labelWithString:@"0" fntFile:@"bmFont.fnt"];
		lblTurnsSurvived.position = ccp(winSize.width * 0.125, winSize.height * 0.75);
		[self addChild:lblTurnsSurvived];
		
		CCLabelBMFont *lblUnitsKilledDesc = [CCLabelBMFont labelWithString:@"Units Killed:" fntFile:@"bmFont.fnt"];
		lblUnitsKilledDesc.position = ccp(winSize.width * 0.125, winSize.height * 0.6);
		[self addChild:lblUnitsKilledDesc];
		
		lblUnitsKilled = [CCLabelBMFont labelWithString:@"0" fntFile:@"bmFont.fnt"];
		lblUnitsKilled.position = ccp(winSize.width * 0.125, winSize.height * 0.55);
		[self addChild:lblUnitsKilled];
		
		CCLabelBMFont *lblTotalScoreDesc = [CCLabelBMFont labelWithString:@"Total Score:" fntFile:@"bmFont.fnt"];
		lblTotalScoreDesc.position = ccp(winSize.width * 0.125, winSize.height * 0.4);
		[self addChild:lblTotalScoreDesc];
		
		lblTotalScore = [CCLabelBMFont labelWithString:@"1" fntFile:@"bmFont.fnt"];
		lblTotalScore.position = ccp(winSize.width * 0.125, winSize.height * 0.35);
		[self addChild:lblTotalScore];
		
		
		CCButton *btnMenu = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"btnMenu.png"]];
		[btnMenu setTarget:self selector:@selector(goToMenu)];

		CCButton *btnRestart = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"btnRestart.png"]];
		[btnRestart setTarget:self selector:@selector(restartGame)];
		
		CCLayoutBox *layoutButtons = [[CCLayoutBox alloc] init];
		[layoutButtons addChild:btnRestart];
		[layoutButtons addChild:btnMenu];
		layoutButtons.spacing = 10.f;
		layoutButtons.anchorPoint = ccp(0.5f, 0.5f);
		layoutButtons.direction = CCLayoutBoxDirectionVertical;
		[layoutButtons layout];
		layoutButtons.position = ccp(winSize.width * 0.125, winSize.height * 0.15);
		[self addChild:layoutButtons];
		
		CCSprite *board = [CCSprite spriteWithImageNamed:@"imgBoard.png"];
		board.position = ccp(winSize.width * 0.625, winSize.height/2);
		[self addChild:board];
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
			board.scale = 0.8;
		
		Unit *friendly = [Unit friendlyUnit];
		friendly.position = [MainScene getPositionForGridCoord:friendly.gridPos];
		[self addChild:friendly];
		
		arrFriendlies = [[NSMutableArray alloc] init];
		[arrFriendlies addObject:friendly];
		
		arrEnemies = [[NSMutableArray alloc] init];
		//[arrEnemies addObject:enemy];
		
		[self spawnNewEnemy];
		
		[self setUserInteractionEnabled:YES];
		
		numTotalScore = 1;
		numTurnSurvived = 0;
		numUnitsKilled = 0;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveUnit:) name:kTurnCompletedNotification object:nil];
	}
	return self;
}

-(void)spawnNewEnemy
{
	NSInteger xPos = 1;
	NSInteger yPos = 1;
	NSInteger wall = arc4random() % 4 + 1; //1 is top wall, 2 is right wall, 3 is bottom wall, 4 is left wall
	if (wall == 1)
	{
		xPos = arc4random() % 9 + 1;
	}
	else if (wall == 2)
	{
		xPos = 9;
		yPos = arc4random() % 9 + 1;
	}
	else if (wall == 3)
	{
		yPos = 9;
		xPos = arc4random() % 9 + 1;
	}
	else if (wall == 4)
	{
		yPos = arc4random() % 9 + 1;
	}
	
	NSInteger unitValue = (arc4random() % 4) + 1; //need to factor in turn count somehow...
	Unit *newEnemy = [Unit enemyUnitWithNumber:unitValue atGridPosition:ccp(xPos, yPos)];
	newEnemy.position = [MainScene getPositionForGridCoord:newEnemy.gridPos];
	[newEnemy setDirectionBasedOnWall:wall];
	[self addChild:newEnemy];
	[arrEnemies addObject:newEnemy];
}

-(void)goToMenu
{
	[[OALSimpleAudio sharedInstance] playEffect:@"buttonClick.mp3"];
	[[CCDirector sharedDirector] replaceScene:[MenuScene scene]];
}

-(void)restartGame
{
	[[OALSimpleAudio sharedInstance] playEffect:@"buttonClick.mp3"];
	[[CCDirector sharedDirector] replaceScene:[MainScene scene]];
}

+(CGPoint)getPositionForGridCoord:(CGPoint)pos
{
	CGPoint screenPos;
	Unit *u = [Unit friendlyUnit];
	CGSize winSize = [[CCDirector sharedDirector] viewSize];
	
	CGFloat borderValue = .6f;
	
	screenPos.x = winSize.width * 0.625 + (u.boundingBox.size.width + borderValue) * (pos.x-5);
	screenPos.y = winSize.height/2 - (u.boundingBox.size.width + borderValue) * (pos.y-5);
	
	return screenPos;
}

-(void)moveUnit:(NSNotification*)notif
{
	NSDictionary *userInfo = [notif userInfo];
	Unit *u = (Unit*)userInfo[@"unit"];
	u.position = [MainScene getPositionForGridCoord:u.gridPos];
	
	[[OALSimpleAudio sharedInstance] playEffect:@"moveUnit.mp3"];
	
	++numTurnSurvived;
	//++numTotalScore;
	[self checkForNewFriendlyUnit];
	
	[self moveAllUnits];
	
	if (numTurnSurvived % 3 == 0 || [arrEnemies count] == 0)
	{
		[self spawnNewEnemy];
		[self checkForAllCollisions];
	}
	
	[self updateLabels];
	
	BOOL hasUnitAtCenter = NO;
	for (Unit *u in arrFriendlies)
		if (u.gridPos.x == 5 && u.gridPos.y == 5)
			hasUnitAtCenter = YES;
	
	if (!hasUnitAtCenter)
	{
		//end game!
		[self endGame];
	}
}

-(void)checkForNewFriendlyUnit
{
	//if there's a unit standing, that means there's one at the center, so return
	//don't worry about (5,5), as that should be a "combine" case if it ever were to come up...
	for (Unit *friendly in arrFriendlies)
	{
		if (friendly.direction == DirStanding)
		{
			return;
		}
	}
	
	Unit *newFriendly = [Unit friendlyUnit];
	newFriendly.position = [MainScene getPositionForGridCoord:newFriendly.gridPos];
	[self addChild:newFriendly];
	[arrFriendlies addObject:newFriendly];
	++numTotalScore;
	newFriendly.name = @"new";
}

-(void)updateLabels
{
	lblTotalScore.string = [NSString stringWithFormat:@"%ld", (long)numTotalScore];
	lblTurnsSurvived.string = [NSString stringWithFormat:@"%ld", (long)numTurnSurvived];
	lblUnitsKilled.string = [NSString stringWithFormat:@"%ld", (long)numUnitsKilled];
}

-(void)moveAllUnits
{
	//move all friendlies
	NSMutableArray *arrTaggedForDeletion = [[NSMutableArray alloc] init];
	for (Unit *friendly in arrFriendlies)
	{
		if ([friendly.name isEqualToString:@"new"])
		{
			friendly.name = @"";
		}
		else if ([friendly moveUnitDidIncreaseNumber])
		{
			++numTotalScore;
		}
		
		friendly.position = [MainScene getPositionForGridCoord:friendly.gridPos];
		
		if (friendly.unitValue == 0)
		{
			[arrTaggedForDeletion addObject:friendly];
		}
		//if he's not already dead
		else if (![friendly.name isEqualToString:@"dead"])
		{
			for (Unit *other in arrFriendlies)
			{
				//if other unit... and neither are dead... and
				[self checkForCombineWithUnit:friendly andUnit:other usingDeletionArray:arrTaggedForDeletion];

			}
		}
	}//for (all friendlies)
	
	[arrFriendlies removeObjectsInArray:arrTaggedForDeletion];
	for (Unit *u in arrTaggedForDeletion)
		[self removeChild:u];
	
	[arrTaggedForDeletion removeAllObjects];
	
	
	
	[self checkForDirectionalCollisions];
	
	
	
	//move all enemies
	for (Unit *enemy in arrEnemies)
	{
		[enemy moveUnitDidIncreaseNumber];
		enemy.position = [MainScene getPositionForGridCoord:enemy.gridPos];
		[enemy setNewDirectionForEnemy];
		
		if (![enemy.name isEqualToString:@"dead"])
		{
			for (Unit *other in arrEnemies)
			{
				[self checkForCombineWithUnit:enemy andUnit:other usingDeletionArray:arrTaggedForDeletion];
			}
		}
	}
	
	[arrEnemies removeObjectsInArray:arrTaggedForDeletion];
	for (Unit *u in arrTaggedForDeletion)
		[self removeChild:u];
	
	[self checkForAllCollisions];
	
	[self checkForAllCombines];
}

-(void)checkForAllCombines
{
	NSMutableArray *arrTaggedForDeletion = [[NSMutableArray alloc] init];
	for (Unit *friendly in arrFriendlies)
	{
		for (Unit *otherFriendly in arrFriendlies)
		{
			if (friendly != otherFriendly)
				//[self checkForCombineWithUnit:friendly andUnit:otherFriendly usingDeletionArray:arrTaggedForDeletion];
				[self checkForAnyDirectionCombineWithUnit:friendly andUnit:otherFriendly usingDeletionArray:arrTaggedForDeletion];
		}
	}
	
	[arrFriendlies removeObjectsInArray:arrTaggedForDeletion];
	for (Unit *u in arrTaggedForDeletion)
		[self removeChild:u];
	[arrTaggedForDeletion removeAllObjects];
	
	
	for (Unit *enemy in arrEnemies)
	{
		for (Unit *otherEnemy in arrEnemies)
		{
			if (enemy != otherEnemy)
				//[self checkForCombineWithUnit:enemy andUnit:otherEnemy usingDeletionArray:arrTaggedForDeletion];
				[self checkForAnyDirectionCombineWithUnit:enemy andUnit:otherEnemy usingDeletionArray:arrTaggedForDeletion];
		}
	}
	
	[arrEnemies removeObjectsInArray:arrTaggedForDeletion];
	for (Unit *u in arrTaggedForDeletion)
		[self removeChild:u];
	[arrTaggedForDeletion removeAllObjects];
}

-(void)checkForAnyDirectionCombineWithUnit:(Unit*)first andUnit:(Unit*)other usingDeletionArray:(NSMutableArray*)array
{
	if (other != first &&
		![other.name isEqualToString:@"dead"] &&
		![first.name isEqualToString:@"dead"] &&
		first.gridPos.x == other.gridPos.x &&
		first.gridPos.y == other.gridPos.y)
	{
		NSInteger fv = first.unitValue;
		NSInteger ov = other.unitValue;
		
		if (first.isFriendly)
			[self playUnitCombineSoundWithValue:fv+ov];
		
		if (ov > fv)
		{
			first.name = @"dead";
			[array addObject:first];
			other.unitValue += fv;
			first.direction = other.direction;
			[other updateLabel];
		}
		else
		{
			other.name = @"dead";
			[array addObject:other];
			first.unitValue += ov;
			other.direction = first.direction;
			[first updateLabel];
		}
	}
}

-(void)checkForCombineWithUnit:(Unit*)first andUnit:(Unit*)other usingDeletionArray:(NSMutableArray*)array
{
	if (other != first &&
		![other.name isEqualToString:@"dead"] &&
		![first.name isEqualToString:@"dead"] &&
		first.gridPos.x == other.gridPos.x &&
		first.gridPos.y == other.gridPos.y)
	{
		//if the opposite way... or at a wall (but collided just now, so you must've been going the opposite to make that happen)
		if ((first.direction == DirUp && other.direction == DirDown) ||
			(first.direction == DirDown && other.direction == DirUp) ||
			(first.direction == DirLeft && other.direction == DirRight) ||
			(first.direction == DirRight && other.direction == DirLeft) ||
			first.direction == DirAtWall ||
			first.direction == DirStanding)
		{
			NSInteger fv = first.unitValue;
			NSInteger ov = other.unitValue;
			
			if (first.isFriendly)
				[self playUnitCombineSoundWithValue:fv+ov];
			
			if (ov > fv)
			{
				first.name = @"dead";
				[array addObject:first];
				other.unitValue += fv;
				first.direction = other.direction;
				[other updateLabel];
			}
			else
			{
				other.name = @"dead";
				[array addObject:other];
				first.unitValue += ov;
				other.direction = first.direction;
				[first updateLabel];
			}
		}
	}
}

-(void)checkForDirectionalCollisions
{
	NSMutableArray *arrTaggedForDeletion = [[NSMutableArray alloc] init];
	for (Unit *f in arrFriendlies)
	{
		for (Unit *e in arrEnemies)
		{
			//at same coordinate...
			if (f.gridPos.x == e.gridPos.x &&
				f.gridPos.y == e.gridPos.y)
			{
				//if the opposite way... or at a wall (but collided just now, so you must've been going the opposite to make that happen)
				if ((f.direction == DirUp && e.direction == DirDown) ||
					(f.direction == DirDown && e.direction == DirUp) ||
					(f.direction == DirLeft && e.direction == DirRight) ||
					(f.direction == DirRight && e.direction == DirLeft) ||
					f.direction == DirAtWall)
				{
					//collision!
					[self handleCollisionWithFriendly:f andEnemy:e withDeletionArray:arrTaggedForDeletion];
					
					//exit the for so no "bad things" happen
					goto afterDirCollide;
				}
			}
		}
		afterDirCollide:{}
	}
	
	[arrFriendlies removeObjectsInArray:arrTaggedForDeletion];
	for (Unit *u in arrTaggedForDeletion)
		[self removeChild:u];
}

-(void)checkForAllCollisions
{
	NSMutableArray *arrTaggedForDeletion = [[NSMutableArray alloc] init];
	for (Unit *f in arrFriendlies)
	{
		for (Unit *e in arrEnemies)
		{
			//at same coordinate...
			if (f.gridPos.x == e.gridPos.x &&
				f.gridPos.y == e.gridPos.y)
			{
				//collision!
				[self handleCollisionWithFriendly:f andEnemy:e withDeletionArray:arrTaggedForDeletion];
				
				//exit the for so no "bad things" happen
				goto afterAllCollide;
				
			}
		}
	afterAllCollide:{}
	}
	
	[arrFriendlies removeObjectsInArray:arrTaggedForDeletion];
	[arrEnemies removeObjectsInArray:arrTaggedForDeletion];
	for (Unit *u in arrTaggedForDeletion)
		[self removeChild:u];
}

-(void)handleCollisionWithFriendly:(Unit*)friendly andEnemy:(Unit*)enemy withDeletionArray:(NSMutableArray*)array
{
	NSInteger fv = friendly.unitValue;
	NSInteger ev = enemy.unitValue;
	friendly.unitValue -= ev;
	enemy.unitValue -= fv;
	
	[friendly updateLabel];
	[enemy updateLabel];
	
	if (friendly.unitValue <= 0)
		[array addObject:friendly];
	
	if (enemy.unitValue <= 0)
	{
		[arrEnemies removeObject:enemy];
		[self removeChild:enemy];
		++numUnitsKilled;
	}
}

-(void)playUnitCombineSoundWithValue:(NSInteger)total
{
	CGFloat pitchValue = 1.0 - (total / 100.f); //eg: fv+ov = 20 ... 1.0 - 0.2 = 0.8
	if (total < 50)
	{
		[[OALSimpleAudio sharedInstance] playEffect:@"unitCombine.mp3" volume:1 pitch:pitchValue pan:0 loop:NO];
	}
	else
	{
		[[OALSimpleAudio sharedInstance] playEffect:@"largeUnitCombine.mp3"];
	}
}

-(void)endGame
{
	NSDictionary *scoreData = @{ DictTotalScore : @(numTotalScore),
								 DictTurnsSurvived : @(numTurnSurvived),
								 DictUnitsKilled : @(numUnitsKilled)};
	
	[[CCDirector sharedDirector] replaceScene:[GameOverScene sceneWithScoreData:scoreData]];
}

#pragma mark - Touch Methods

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
	//CGPoint pos = [touch locationInNode:self];
	//NSLog(@"ccp(%f,%f)", pos.x / winSize.width, pos.y / winSize.height);
}

-(void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
