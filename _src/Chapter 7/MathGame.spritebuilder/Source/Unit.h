//
//  Unit.h
//  MathGame
//
//  Created by Alex Ogorek on 12/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

FOUNDATION_EXPORT NSString *const kTurnCompletedNotification;
FOUNDATION_EXPORT NSString *const kUnitDragCancel;

NS_ENUM(NSInteger, UnitDirection)
{
	DirUp,
	DirDown,
	DirLeft,
	DirRight,
	DirAtWall,
	DirStanding //for when a new one spawns at the center
};

@interface Unit : CCSprite

@property (nonatomic, assign) NSInteger unitValue;
@property (nonatomic, assign) BOOL isFriendly;
@property (nonatomic, assign) enum UnitDirection direction;
@property (nonatomic, assign) CGPoint gridPos; //9x9 grid, 1,1 is top left, 9,9 is bottom right
@property (nonatomic, strong) CCColor *color;
@property (nonatomic, strong) CCLabelBMFont *lblValue;

@property (nonatomic, assign) BOOL isBeingDragged;
@property (nonatomic, assign) CGPoint touchDownPos;
@property (nonatomic, assign) enum UnitDirection dragDirection;

@property (nonatomic, assign) CGPoint previousTouchPos;
@property (nonatomic, assign) NSInteger gridWidth;

+(Unit*)friendlyUnit;
+(Unit*)enemyUnitWithNumber:(NSInteger)value atGridPosition:(CGPoint)pos;
-(void)updateLabel;
-(BOOL)moveUnitDidIncreaseNumber;
-(void)setDirectionBasedOnWall:(NSInteger)wall;
-(void)setNewDirectionForEnemy;

-(void)slideUnitWithDistance:(CGFloat)dist withDragDirection:(enum UnitDirection)dir;
@end
