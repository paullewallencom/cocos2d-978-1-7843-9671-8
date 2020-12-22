#import "MainScene.h"
#import "MenuScene.h"
#import "Unit.h"
#import "GameOverScene.h"

NSString *const DataHighScores = @"highScores";
NSString *const DictTotalScore = @"totalScore";
NSString *const DictTurnsSurvived = @"turnsSurvived";
NSString *const DictUnitsKilled = @"unitsKilled";
NSString *const DictHighScoreIndex = @"hsIndex";

NSString *const KeySound = @"keySound";
NSString *const KeyMusic = @"keyMusic";
NSString *const KeyFinishedTutorial = @"keyFinishedTutorial";

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
		isSoundOn = [[NSUserDefaults standardUserDefaults] boolForKey:KeySound];
		
		CCNode *background = [CCNodeColor nodeWithColor:[CCColor whiteColor] width:winSize.width*5 height:winSize.height*5];
		background.anchorPoint = ccp(0.5,0.5);
		background.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:background z:-2];
		
		CCLabelBMFont *lblTurnsSurvivedDesc = [CCLabelBMFont labelWithString:@"Turns Survived:" fntFile:@"bmFont.fnt"];
		lblTurnsSurvivedDesc.position = ccp(winSize.width * 0.125, winSize.height * 0.9);
		[self addChild:lblTurnsSurvivedDesc];
		
		lblTurnsSurvived = [CCLabelBMFont labelWithString:@"0" fntFile:@"bmScoreFont.fnt"];
		lblTurnsSurvived.position = ccp(winSize.width * 0.125, winSize.height * 0.82);
		[self addChild:lblTurnsSurvived];
		
		CCLabelBMFont *lblUnitsKilledDesc = [CCLabelBMFont labelWithString:@"Units Killed:" fntFile:@"bmFont.fnt"];
		lblUnitsKilledDesc.position = ccp(winSize.width * 0.125, winSize.height * 0.7);
		[self addChild:lblUnitsKilledDesc];
		
		lblUnitsKilled = [CCLabelBMFont labelWithString:@"0" fntFile:@"bmScoreFont.fnt"];
		lblUnitsKilled.position = ccp(winSize.width * 0.125, winSize.height * 0.62);
		[self addChild:lblUnitsKilled];
		
		CCLabelBMFont *lblTotalScoreDesc = [CCLabelBMFont labelWithString:@"Total Score:" fntFile:@"bmFont.fnt"];
		lblTotalScoreDesc.position = ccp(winSize.width * 0.125, winSize.height * 0.5);
		[self addChild:lblTotalScoreDesc];
		
		lblTotalScore = [CCLabelBMFont labelWithString:@"1" fntFile:@"bmScoreFont.fnt"];
		lblTotalScore.position = ccp(winSize.width * 0.125, winSize.height * 0.42);
		[self addChild:lblTotalScore];
		
		lblTurnsSurvivedDesc.color =
		lblTurnsSurvived.color =
		lblTotalScoreDesc.color =
		lblTotalScore.color =
		lblUnitsKilledDesc.color =
		lblUnitsKilled.color = [CCColor colorWithRed:52/255.f green:73/255.f blue:94/255.f];
		
		CCButton *btnMenu = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"btnMenu.png"]];
		[btnMenu setTarget:self selector:@selector(goToMenu)];
		//btnMenu.position = ccp(winSize.width * 0.1, winSize.height * 0.1);
		//[self addChild:btnMenu];
		
		CCButton *btnRestart = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"btnRestart.png"]];
		[btnRestart setTarget:self selector:@selector(restartGame)];
		//btnRestart.position = ccp(winSize.width * 0.1, winSize.height * 0.1);
		//[self addChild:btnRestart];
		
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
		
		[self setUserInteractionEnabled:YES];
		
		numTotalScore = 1;
		numTurnSurvived = 0;
		numUnitsKilled = 0;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveUnit:) name:kTurnCompletedNotification object:nil];
		
		if ([[NSUserDefaults standardUserDefaults] boolForKey:KeyFinishedTutorial])
		{
			[self spawnNewEnemy:[self getRandomEnemy]];
			self.tutorialPhase = 0;
		}
		else
		{
			//spawn enemy on far right with value of 1
			Unit *newEnemy = [Unit enemyUnitWithNumber:1 atGridPosition:ccp(9, 5)];
			newEnemy.position = [MainScene getPositionForGridCoord:newEnemy.gridPos];
			[newEnemy setDirection:DirLeft]; //2 is right wall
			[self spawnNewEnemy:newEnemy];
			self.tutorialPhase = 1;
			
			[self showTutorialInstructions];
		}
	}
	return self;
}

-(void)showTutorialInstructions
{
	NSString *tutString = @"";
	if (self.tutorialPhase == 1)
	{
		tutString = @"Drag Friendly Units";
		
		CCLabelBMFont *lblHowToPlay = [CCLabelBMFont labelWithString:@"How to Play:" fntFile:@"bmScoreFont.fnt"];
		lblHowToPlay.color = [CCColor colorWithRed:52/255.f green:73/255.f blue:94/255.f];
		lblHowToPlay.position = [MainScene getPositionForGridCoord:ccp(5,1)];
		lblHowToPlay.name = @"lblHowToPlay";
		lblHowToPlay.scale = 0.8;
		[self addChild:lblHowToPlay z:2];
		
		CCSprite9Slice *bgHowTo = [CCSprite9Slice spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"imgUnit.png"]];
		bgHowTo.margin = 0.2;
		bgHowTo.position = ccp(0.5,0.4);
		bgHowTo.positionType = CCPositionTypeNormalized;
		bgHowTo.contentSize = CGSizeMake(1.05f, 1.2f);
		bgHowTo.contentSizeType = CCSizeTypeNormalized;
		[lblHowToPlay addChild:bgHowTo z:-1];
	}
	else if (self.tutorialPhase == 2)
	{
		tutString = @"Combine Friendly Units";
		
		id fadeRemoveHowToPlay = [CCActionSequence actions:[CCActionEaseInOut actionWithAction:[CCActionFadeOut actionWithDuration:0.5f] rate:2], [CCActionCallBlock actionWithBlock:^{
			[self removeChildByName:@"lblHowToPlay"];
		}], nil];
		
		[[self getChildByName:@"lblHowToPlay" recursively:NO] runAction:fadeRemoveHowToPlay];
	}
	else if (self.tutorialPhase == 3)
	{
		tutString = @"Defeat Enemies";
	}
	else if (self.tutorialPhase == 4)
	{
		tutString = @"Protect Center";
	}
	else if (self.tutorialPhase == 5)
	{
		tutString = @"Survive";
	}
	else if (self.tutorialPhase == 6)
	{
		tutString = @"Enjoy! :)";
	}
	
	CCLabelBMFont *lblTutorialText = [CCLabelBMFont labelWithString:tutString fntFile:@"bmScoreFont.fnt"];
	lblTutorialText.color = [CCColor colorWithRed:52/255.f green:73/255.f blue:94/255.f];
	lblTutorialText.position = [MainScene getPositionForGridCoord:ccp(5,2)];
	lblTutorialText.name = @"tutorialText";
	[self addChild:lblTutorialText z:2];
	
	CCSprite9Slice *background = [CCSprite9Slice spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"imgUnit.png"]];
	background.margin = 0.2;
	background.position = ccp(0.5,0.4);
	background.positionType = CCPositionTypeNormalized;
	background.contentSize = CGSizeMake(1.05f, 1.2f);
	background.contentSizeType = CCSizeTypeNormalized;
	[lblTutorialText addChild:background z:-1];
	
	CCSprite *finger = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"imgFinger.png"]];
	finger.anchorPoint = ccp(0.4,1);
	finger.position = [MainScene getPositionForGridCoord:ccp(5,5)];
	finger.name = @"finger";
	finger.opacity = 0;
	[self addChild:finger z:2];
	
	[self runFingerArrowActionsWithFinger:finger];
}

-(void)runFingerArrowActionsWithFinger:(CCSprite*)finger
{
	Unit *u = [Unit friendlyUnit];
	if (self.tutorialPhase == 1 || self.tutorialPhase == 3)
	{
		id slideRight = [CCActionSequence actions:[CCActionEaseIn actionWithAction:[CCActionFadeIn actionWithDuration:0.25f] rate:2], [CCActionEaseInOut actionWithAction:[CCActionMoveBy actionWithDuration:1.0f position:ccp(u.gridWidth*2, 0)] rate:2],[CCActionDelay actionWithDuration:0.5f], nil];
		
		id fadeOutAndReposition = [CCActionSequence actions:[CCActionDelay actionWithDuration:0.25f], [CCActionEaseInOut actionWithAction:[CCActionFadeOut actionWithDuration:1.0f] rate:2], [CCActionDelay actionWithDuration:0.5f], [CCActionCallBlock actionWithBlock:^{
			finger.position = [MainScene getPositionForGridCoord:ccp(5,5)];
		}], nil];
		
		[finger runAction:[CCActionRepeatForever actionWithAction:slideRight]];
		[finger runAction:[CCActionRepeatForever actionWithAction:fadeOutAndReposition]];
	}
	else if (self.tutorialPhase == 2)
	{
		finger.position = [MainScene getPositionForGridCoord:ccp(6,5)];
		id slideLeft = [CCActionSequence actions:[CCActionEaseIn actionWithAction:[CCActionFadeIn actionWithDuration:0.25f] rate:2], [CCActionEaseInOut actionWithAction:[CCActionMoveBy actionWithDuration:1.0f position:ccp(-u.gridWidth*2, 0)] rate:2],[CCActionDelay actionWithDuration:0.5f], nil];
		
		id fadeOutAndReposition = [CCActionSequence actions:[CCActionDelay actionWithDuration:0.25f], [CCActionEaseInOut actionWithAction:[CCActionFadeOut actionWithDuration:1.0f] rate:2], [CCActionDelay actionWithDuration:0.5f], [CCActionCallBlock actionWithBlock:^{
			finger.position = [MainScene getPositionForGridCoord:ccp(6,5)];
		}], nil];
		
		[finger runAction:[CCActionRepeatForever actionWithAction:slideLeft]];
		[finger runAction:[CCActionRepeatForever actionWithAction:fadeOutAndReposition]];
	}
}

-(void)advanceTutorial
{
	++self.tutorialPhase;
	[self removePreviousTutorialPhase];
	
	if (self.tutorialPhase < 7)
	{
		[self showTutorialInstructions];
	}
	else
	{
		//the tutorial should be marked as "visible"
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:KeyFinishedTutorial];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

-(void)removePreviousTutorialPhase
{
	CCLabelBMFont *lblInstructions = (CCLabelBMFont*)[self getChildByName:@"tutorialText" recursively:NO];
	
	lblInstructions.name = @"old_instructions";
	
	id fadeRemoveInstructions = [CCActionSequence actions:[CCActionEaseInOut actionWithAction:[CCActionFadeTo actionWithDuration:0.5f opacity:0] rate:2], [CCActionCallBlock actionWithBlock:^{
		[self removeChild:lblInstructions];
	}], nil];
	
	[lblInstructions runAction:fadeRemoveInstructions];
	
	
	CCSprite *finger = (CCSprite*)[self getChildByName:@"finger" recursively:NO];
	finger.name = @"old_finger";
	id fadeRemoveFinger = [CCActionSequence actions:[CCActionEaseInOut actionWithAction:[CCActionFadeTo actionWithDuration:0.5f opacity:0] rate:2], [CCActionCallBlock actionWithBlock:^{
		[self removeChild:finger];
	}], nil];
	[finger runAction:fadeRemoveFinger];
}

-(Unit*)getRandomEnemy
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
	
	//base difficulty: 3
	NSInteger upperBound = 3 + (numTurnSurvived / 17); //up difficulty every 17 turns (15 felt a little harsh, 20 might be too easy)
	
	NSInteger unitValue = (arc4random() % upperBound) + 1;
	
	Unit *newEnemy = [Unit enemyUnitWithNumber:unitValue atGridPosition:ccp(xPos, yPos)];
	newEnemy.position = [MainScene getPositionForGridCoord:newEnemy.gridPos];
	[newEnemy setDirectionBasedOnWall:wall];
	
	return newEnemy;
}

-(void)spawnNewEnemy:(Unit*)enemy
{
//	Unit *newEnemy = [self getRandomEnemy];
	[self addChild:enemy];
	[arrEnemies addObject:enemy];
	
	enemy.scale = 0;
	[self pulseUnit:enemy];
}

-(void)goToMenu
{
	if (isSoundOn)
		[[OALSimpleAudio sharedInstance] playEffect:@"buttonClick.mp3"];
	
	[MainScene rubberBandToScene:[MenuScene scene] fromParent:self withDuration:0.5f withDirection:kMoveDirectionDown];
}

-(void)restartGame
{
	if (isSoundOn)
		[[OALSimpleAudio sharedInstance] playEffect:@"buttonClick.mp3"];
	[[CCDirector sharedDirector] replaceScene:[MainScene scene]];
}

+(CGPoint)getPositionForGridCoord:(CGPoint)pos
{
	CGPoint screenPos;
	Unit *u = [Unit friendlyUnit];
	CGSize winSize = [[CCDirector sharedDirector] viewSize];
	
	CGFloat borderValue = .6f;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		borderValue = 0.75f;
	
	screenPos.x = winSize.width * 0.625 + (u.boundingBox.size.width + borderValue) * (pos.x-5);
	screenPos.y = winSize.height/2 - (u.boundingBox.size.width + borderValue) * (pos.y-5);
	
	return screenPos;
}

-(void)slideAllUnitsWithDistance:(CGFloat)dist withDragDirection:(enum UnitDirection)dir
{
	for (Unit *u in arrFriendlies)
		[u slideUnitWithDistance:dist withDragDirection:dir];
	
	for (Unit *u in arrEnemies)
		[u slideUnitWithDistance:dist withDragDirection:dir];
}

-(void)moveUnit:(NSNotification*)notif
{
	if (self.tutorialPhase == 5 || self.tutorialPhase == 6)
		[self advanceTutorial];
	
	NSDictionary *userInfo = [notif userInfo];
	Unit *u = (Unit*)userInfo[@"unit"];
	u.position = [MainScene getPositionForGridCoord:u.gridPos];
	
	if (isSoundOn)
		[[OALSimpleAudio sharedInstance] playEffect:@"moveUnit.mp3"];
	
	++numTurnSurvived;
	//++numTotalScore;
	
	[self checkForNewFriendlyUnit];
	
	[self moveAllUnits];
	
	NSInteger rate = 3; //spawn a unit every 3 turns
	
	if (numTurnSurvived % rate == 0 || [arrEnemies count] == 0)
	{
		if (self.tutorialPhase == 4)
		{
			Unit *newEnemy = [Unit enemyUnitWithNumber:4 atGridPosition:ccp(5,9)];
			[newEnemy setDirection:DirUp];
			newEnemy.position = [MainScene getPositionForGridCoord:ccp(5,9)];
			[self spawnNewEnemy:newEnemy];
		}
		else
		{
			if (numTurnSurvived > 200)
			{
				//10% chance to spawn a 2nd unit... hehe... and at this level of difficulty? Upper bound of, 18? HAH! Good luck.
				if (arc4random() % 100 < 10)
					[self spawnNewEnemy:[self getRandomEnemy]];
			}
			[self spawnNewEnemy:[self getRandomEnemy]];
		}
	}
	
	[self checkForAllCombines];
	[self checkForAllCollisions];
	
	[self updateLabels];
	
	BOOL hasUnitAtCenter = NO;
	for (Unit *u in arrFriendlies)
		if (u.gridPos.x == 5 && u.gridPos.y == 5)
			hasUnitAtCenter = YES;
	
	if (!hasUnitAtCenter)
	{
		//end game!
		[self endGame];
		return;
	}
	
	if (self.tutorialPhase == 1 || self.tutorialPhase == 2)
		[self advanceTutorial];
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
	[self addChild:newFriendly z:1];
	[arrFriendlies addObject:newFriendly];
	++numTotalScore;
	newFriendly.name = @"new";
	newFriendly.scale = 0;
	[self pulseUnit:newFriendly];
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
			
			[self pulseUnit:other];
		}
		else
		{
			other.name = @"dead";
			[array addObject:other];
			first.unitValue += ov;
			other.direction = first.direction;
			[first updateLabel];
			
			[self pulseUnit:first];
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
				
				[self pulseUnit:other];
			}
			else
			{
				other.name = @"dead";
				[array addObject:other];
				first.unitValue += ov;
				other.direction = first.direction;
				[first updateLabel];
				
				[self pulseUnit:first];
			}
		}
	}
}

-(void)pulseUnit:(CCNode*)unit
{
	CGFloat baseScale = 1.0f;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
		baseScale = 0.8f;
	
	id scaleUp = [CCActionEaseInOut actionWithAction:[CCActionScaleTo actionWithDuration:0.15f scale:baseScale * 1.2f] rate:2];
	id scaleDown = [CCActionEaseInOut actionWithAction:[CCActionScaleTo actionWithDuration:0.15f scale:baseScale * 0.9f] rate:2];
	id scaleToFinal = [CCActionEaseInOut actionWithAction:[CCActionScaleTo actionWithDuration:0.25f scale:baseScale] rate:2];
	id seq = [CCActionSequence actions:scaleUp, scaleDown, scaleToFinal, nil];
	
	[unit stopAllActions];
	[unit runAction:seq];
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
					[self handleCollisionWithFriendly:f andEnemy:e withDeletionArray:arrTaggedForDeletion isFromDirectional:YES];
					
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
				[self handleCollisionWithFriendly:f andEnemy:e withDeletionArray:arrTaggedForDeletion isFromDirectional:NO];
				
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

-(void)handleCollisionWithFriendly:(Unit*)friendly andEnemy:(Unit*)enemy withDeletionArray:(NSMutableArray*)array isFromDirectional:(BOOL)isDirectional
{
	NSInteger fv = friendly.unitValue;
	NSInteger ev = enemy.unitValue;
	if (isDirectional)
	{
		enemy.unitValue -= fv;
		friendly.unitValue -= (ev+1);
	}
	else
	{
		friendly.unitValue -= ev;
		enemy.unitValue -= fv;
	}
	
	[friendly updateLabel];
	[enemy updateLabel];
	
	if (friendly.unitValue <= 0)
		[array addObject:friendly];
	
	if ((enemy.unitValue <= 0 && !isDirectional) ||
		(enemy.unitValue < 0 && isDirectional))
	{
		[arrEnemies removeObject:enemy];
		[self removeChild:enemy];
		++numUnitsKilled;
		
		if (self.tutorialPhase == 3 || self.tutorialPhase == 4)
			[self advanceTutorial];
	}
}

-(void)playUnitCombineSoundWithValue:(NSInteger)total
{
	CGFloat pitchValue = 1.0 - (total / 100.f); //eg: fv+ov = 20 ... 1.0 - 0.2 = 0.8
	if (total < 50)
	{
		if (isSoundOn)
			[[OALSimpleAudio sharedInstance] playEffect:@"unitCombine.mp3" volume:1 pitch:pitchValue pan:0 loop:NO];
	}
	else
	{
		if (isSoundOn)
			[[OALSimpleAudio sharedInstance] playEffect:@"largeUnitCombine.mp3"];
	}
}

-(NSInteger)saveHighScore
{
	//save top 20 scores
	
	//an array of Dictionaries...
	//keys in each dictionary:
	//	[DictTotalScore]
	//	[DictTurnsSurvived]
	//	[DictUnitsKilled]
	NSMutableArray *arrScores = [[[NSUserDefaults standardUserDefaults] arrayForKey:DataHighScores] mutableCopy];
	
	NSInteger index = -1;
	for (NSDictionary *dictHighScore in arrScores)
	{
		if (numTotalScore > [dictHighScore[DictTotalScore] integerValue])
		{
			index = [arrScores indexOfObject:dictHighScore];
			break;
		}
	}
	
	if (index > -1)
	{
		NSDictionary *newHighScore = @{ DictTotalScore : @(numTotalScore),
										DictTurnsSurvived : @(numTurnSurvived),
										DictUnitsKilled : @(numUnitsKilled) };
		
		[arrScores insertObject:newHighScore atIndex:index];
		
		[arrScores removeLastObject];
		
		[[NSUserDefaults standardUserDefaults] setObject:arrScores forKey:DataHighScores];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	
	return index;
}

-(UIImage*)takeScreenshot
{
	[CCDirector sharedDirector].nextDeltaTimeZero = YES;
	
	//CGSize winSize = [CCDirector sharedDirector].winSize;
	CCRenderTexture* rtx =
	[CCRenderTexture renderTextureWithWidth:winSize.width
									 height:winSize.height];
	[rtx begin];
	//[startNode visit];
	[[[CCDirector sharedDirector] runningScene] visit];
	[rtx end];
	
	return [rtx getUIImage];
}

-(void)endGame
{
	//right here:
	NSInteger hsIndex = [self saveHighScore];
	
	UIImage *image = [self takeScreenshot];
	
	NSDictionary *scoreData = @{ DictTotalScore : @(numTotalScore),
								 DictTurnsSurvived : @(numTurnSurvived),
								 DictUnitsKilled : @(numUnitsKilled),
								 DictHighScoreIndex : @(hsIndex),
								 @"screenshot" : image};
	
	[MainScene rubberBandToScene:[GameOverScene sceneWithScoreData:scoreData] fromParent:self withDuration:0.5f withDirection:kMoveDirectionUp];
	
}

+(void)rubberBandToScene:(CCScene*)scene fromParent:(CCNode*)parent withDuration:(CGFloat)duration withDirection:(enum kMoveDirection)direction
{
	//grab the view size, so we know the width/height of the screen
	CGSize winSize = [[CCDirector sharedDirector] viewSize];
	
	//add the new scene to the current scene
	[parent addChild:scene z:-1];
	
	//set a distance to "over move" by
	NSInteger distance = 25;
	
	//variables for how much to move in each direction
	CGPoint posBack = ccp(0,0);
	CGPoint posForward = ccp(0,0);
	
	//determine the specifics based on which direction the slide is going to go
	if (direction == kMoveDirectionUp)
	{
		posBack.y = -distance;
		posForward.y = winSize.height + distance*2;
		scene.position = ccp(0,-winSize.height);
	}
	else if (direction == kMoveDirectionDown)
	{
		posBack.y = distance;
		posForward.y = -(winSize.height + distance*2);
		scene.position = ccp(0,winSize.height);
	}
	else if (direction == kMoveDirectionLeft)
	{
		posBack.x = distance;
		posForward.x = -(winSize.width + distance*2);
		scene.position = ccp(winSize.width, 0);
	}
	else if (direction == kMoveDirectionRight)
	{
		posBack.x = -distance;
		posForward.x = winSize.width + distance*2;
		scene.position = ccp(-winSize.width,0);
	}
	
	//declare the slide actions
	id slideBack = [CCActionEaseInOut actionWithAction:[CCActionMoveBy actionWithDuration:duration/4 position:posBack] rate:2];
	id slideForward = [CCActionEaseInOut actionWithAction:[CCActionMoveBy actionWithDuration:duration/2 position:posForward] rate:2];
	id slideBackAgain = [CCActionEaseInOut actionWithAction:[CCActionMoveBy actionWithDuration:duration/4 position:posBack] rate:2];
	id replaceScene = [CCActionCallBlock actionWithBlock:^{
		
		//remove the new scene from the current scene (so we can use it in the replace)
		[parent removeChild:scene cleanup:NO];
		
		//reset its position to (0,0)
		scene.position = ccp(0,0);
		
		//actually replace our scene with the passed-in one
		[[CCDirector sharedDirector] replaceScene:scene];
	}];
	
	//arrange the actions into a sequence (which also includes the replacing)
	id slideSeq = [CCActionSequence actions:slideBack, slideForward, slideBackAgain, replaceScene, nil];
	
	//execute the sequence of actions
	[parent runAction:slideSeq];
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
