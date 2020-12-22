//
//  Unit.m
//  MathGame
//
//  Created by Alex Ogorek on 12/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Unit.h"
#import "MainScene.h"

NSString *const kTurnCompletedNotification = @"unitDragComplete";
NSString *const kUnitDragging = @"unitDragging";
NSString *const kUnitDragCancel = @"unitDragCancelled";

@implementation Unit

+(Unit*)friendlyUnit
{
	return [[self alloc] initWithFriendlyUnit];
}

+(Unit*)enemyUnitWithNumber:(NSInteger)num atGridPosition:(CGPoint)pos
{
	return [[self alloc] initWithEnemyWithNumber:num atPos:pos];
}

-(id)initCommon
{
	if ((self=[super initWithImageNamed:@"imgUnit.png"]))
	{
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
			self.scale = 0.8;
		
		self.lblValue = [CCLabelBMFont labelWithString:@"1" fntFile:@"bmFont.fnt"];
		self.lblValue.scale = 1.5;
		self.lblValue.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
		[self addChild:self.lblValue];
		
		self.dragDirection = DirStanding;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(repositionUnitToGridPos) name:kUnitDragCancel object:nil];
		
		self.gridWidth = self.boundingBox.size.width + 0.6f;
	}
	return self;
}

-(id)initWithFriendlyUnit
{
	if ((self=[self initCommon]))
	{
		self.isFriendly = YES;
		self.unitValue = 1;
		self.direction = DirStanding;
		self.color = [CCColor colorWithRed:39/255.f green:179/255.f blue:97/255.f]; //green for friendly
		self.gridPos = ccp(5,5);
		
		[self setUserInteractionEnabled:YES];
	}
	return self;
}

-(id)initWithEnemyWithNumber:(NSInteger)num atPos:(CGPoint)p
{
	if ((self=[self initCommon]))
	{
		self.isFriendly = NO;
		self.unitValue = num;
		self.lblValue.string = [NSString stringWithFormat:@"%ld", (long)num];
		self.direction = DirLeft;
		self.color = [CCColor colorWithRed:255/255.f green:91/255.f blue:75/255.f]; //red for enemy
		self.gridPos = p;
	}
	return self;
}

-(void)updateLabel
{
	self.lblValue.string = [NSString stringWithFormat:@"%ld", (long)self.unitValue];
}

-(BOOL)moveUnitDidIncreaseNumber
{
	BOOL didIncrease = YES;
	++self.unitValue;
	
	NSInteger gridX, gridY;
	gridX = self.gridPos.x;
	gridY = self.gridPos.y;
	
	//move unit that direction
	if (self.direction == DirUp)
		--gridY;
	else if (self.direction == DirDown)
		++gridY;
	else if (self.direction == DirLeft)
		--gridX;
	else if (self.direction == DirRight)
		++gridX;
	
	//keep within the grid bounds
	if (gridX < 1) gridX = 1;
	if (gridX > 9) gridX = 9;
	
	if (gridY < 1) gridY = 1;
	if (gridY > 9) gridY = 9;
	
	if (self.gridPos.x == gridX && self.gridPos.y == gridY && self.direction != DirStanding) //if didn't move, it's standing
		self.direction = DirAtWall;
	
	if (self.direction == DirAtWall)
	{
		self.unitValue -= 2;
		didIncrease = NO;
	}
	
	self.gridPos = ccp(gridX, gridY);
	
	[self updateLabel];
	
	return didIncrease;
}

-(void)setDirectionBasedOnWall:(NSInteger)wall
{
	if (wall == 1)
		self.direction = DirDown;
	else if (wall == 2)
		self.direction = DirLeft;
	else if (wall == 3)
		self.direction = DirUp;
	else if (wall == 4)
		self.direction = DirRight;
}

-(void)setNewDirectionForEnemy
{
	NSInteger choice = arc4random() % 2;
	
	if (self.gridPos.x == 4 && self.gridPos.y == 5)
		self.direction = DirRight;
	else if (self.gridPos.x == 5 && self.gridPos.y == 4)
		self.direction = DirDown;
	else if (self.gridPos.x == 5 && self.gridPos.y == 6)
		self.direction = DirUp;
	else if (self.gridPos.x == 6 && self.gridPos.y == 5)
		self.direction = DirLeft;
	//top left corner
	else if (self.gridPos.x == 4 && self.gridPos.y == 4)
	{
		self.direction = choice ? DirRight : DirDown;
	}
	//bottom left corner
	else if (self.gridPos.x == 4 && self.gridPos.y == 6)
	{
		self.direction = choice ? DirRight : DirUp;
	}
	//top right corner
	else if (self.gridPos.x == 6 && self.gridPos.y == 4)
	{
		self.direction = choice ? DirLeft : DirDown;
	}
	//bottom right corner
	else if (self.gridPos.x == 6 && self.gridPos.y == 6)
	{
		self.direction = choice ? DirLeft : DirUp;
	}
	//one of the rows
	else if (self.gridPos.x == 4 || self.gridPos.x == 6)
	{
		if (self.gridPos.y > 5)
			self.direction = DirUp;
		else
			self.direction = DirDown;
	}
	else if (self.gridPos.y == 4 || self.gridPos.y == 6)
	{
		if (self.gridPos.x > 5)
			self.direction = DirLeft;
		else
			self.direction = DirRight;
	}
}

-(void)slideUnitWithDistance:(CGFloat)dist withDragDirection:(enum UnitDirection)dir
{
	CGFloat newX = self.position.x, newY = self.position.y;
	CGPoint originalPos = [MainScene getPositionForGridCoord:self.gridPos];
	
	if (!self.isBeingDragged && (((self.direction == DirUp || self.direction == DirRight) && (dir == DirDown || dir == DirLeft)) ||
								 ((self.direction == DirDown || self.direction == DirLeft) && (dir == DirUp || dir == DirRight))))
	{
		dist *= -1;
	}
	
	if (self.dragDirection == DirUp || (!self.isBeingDragged && self.direction == DirUp))
	{
		newY += dist;
		if (newY > originalPos.y + self.gridWidth)
			newY = originalPos.y + self.gridWidth;
		else if (newY < originalPos.y)
			newY = originalPos.y;
	}
	else if (self.dragDirection == DirDown || (!self.isBeingDragged && self.direction == DirDown))
	{
		newY += dist;
		if (newY < originalPos.y - self.gridWidth)
			newY = originalPos.y - self.gridWidth;
		else if (newY > originalPos.y)
			newY = originalPos.y;
	}
	else if (self.dragDirection == DirLeft || (!self.isBeingDragged && self.direction == DirLeft))
	{
		newX += dist;
		if (newX < originalPos.x - self.gridWidth)
			newX = originalPos.x - self.gridWidth;
		else if (newX > originalPos.x)
			newX = originalPos.x;
	}
	else if (self.dragDirection == DirRight || (!self.isBeingDragged && self.direction == DirRight))
	{
		newX += dist;
		if (newX > originalPos.x + self.gridWidth)
			newX = originalPos.x + self.gridWidth;
		else if (newX < originalPos.x)
			newX = originalPos.x;
	}
	
	self.position = ccp(newX, newY);
}

-(void)repositionUnitToGridPos
{
	self.position = [MainScene getPositionForGridCoord:self.gridPos];
}

#pragma mark - Touch Methods

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
	self.touchDownPos = [touch locationInNode:self.parent];
}

-(void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
	CGPoint touchPos = [touch locationInNode:self.parent];
	
	//if it's not already being dragged and the touch is dragged far enough away...
	if (!self.isBeingDragged && ccpDistance(touchPos, self.touchDownPos) > 20)
	{
		self.isBeingDragged = YES;
		//add it here:
		self.previousTouchPos = self.touchDownPos;
		
		CGPoint difference = ccp(touchPos.x - self.touchDownPos.x, touchPos.y - self.touchDownPos.y);
		//determine direction
		if (difference.x > 0)
		{
			if (difference.x > fabsf(difference.y))
				self.dragDirection = DirRight;
			else if (difference.y > 0)
				self.dragDirection = DirUp;
			else
				self.dragDirection = DirDown;
		}
		else
		{
			if (difference.x < -1* fabsf(difference.y))
				self.dragDirection = DirLeft;
			else if (difference.y > 0)
				self.dragDirection = DirUp;
			else
				self.dragDirection = DirDown;
		}
	}
	
	if (self.isBeingDragged)
	{
		CGFloat dist = 0;
		if (self.dragDirection == DirUp || self.dragDirection == DirDown)
			dist = touchPos.y - self.previousTouchPos.y;
		else if (self.dragDirection == DirLeft || self.dragDirection == DirRight)
			dist = touchPos.x - self.previousTouchPos.x;
		
		dist /= 2; //optional
		[(MainScene*)self.parent slideAllUnitsWithDistance:dist withDragDirection:self.dragDirection];
		//[self slideUnitWithDistance:dist withDragDirection:self.dragDirection];
		
		self.previousTouchPos = touchPos;
	}
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
	//if it was being dragged in the first place
	if (self.isBeingDragged)
	{
		//CGPoint touchPos = [touch locationInNode:self.parent];
		//stop the dragging
		self.isBeingDragged = NO;
		
		CGPoint oldSelfPos = [MainScene getPositionForGridCoord:self.gridPos];
		CGFloat dist = ccpDistance(oldSelfPos, self.position);
		NSLog(@"dist: %f", dist);
		if (dist > self.gridWidth/2)
		{
			NSInteger gridX, gridY;
			gridX = self.gridPos.x;
			gridY = self.gridPos.y;
			
			//move unit that direction
			if (self.dragDirection == DirUp)
				--gridY;
			else if (self.dragDirection == DirDown)
				++gridY;
			else if (self.dragDirection == DirLeft)
				--gridX;
			else if (self.dragDirection == DirRight)
				++gridX;
			
			//keep within the grid bounds
			if (gridX < 1) gridX = 1;
			if (gridX > 9) gridX = 9;
			
			if (gridY < 1) gridY = 1;
			if (gridY > 9) gridY = 9;
			
			//if it's not in the same place... aka, a valid move taken
			if (!(gridX == self.gridPos.x && gridY == self.gridPos.y))
			{
				//self.gridPos = ccp(gridX, gridY);
				//self.unitValue++;
				if (self.direction == DirStanding)
					self.unitValue++;
				self.direction = self.dragDirection;
				//[self updateLabel];
				
				//pass the unit through to the MainScene
				[[NSNotificationCenter defaultCenter] postNotificationName:kTurnCompletedNotification object:nil userInfo:@{@"unit" : self}];
			}
		}
		//else... dist NOT > gridWidth/2
		else
		{
			//[self repositionUnitToGridPos];
			[[NSNotificationCenter defaultCenter] postNotificationName:kUnitDragCancel object:nil];
		}
		
		self.dragDirection = DirStanding;
	}
}

-(void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
