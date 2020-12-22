//
//  ConstantLineExampleScene.m
//  Ghosts
//
//  Created by Alex Ogorek on 1/18/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "ConstantLineExampleScene.h"
#import "MainScene.h"

@implementation ConstantLineExampleScene
+(CCScene*)scene
{
	return [[self alloc] init];
}

-(id)init
{
	if ((self=[super init]))
	{
		winSize = [[CCDirector sharedDirector] viewSize];
		
		CCLabelTTF *lblTitle = [CCLabelTTF labelWithString:@"Line Example" fontName:@"ArialMT" fontSize:20];
		lblTitle.anchorPoint = ccp(0.5,1);
		lblTitle.position = ccp(winSize.width/2, winSize.height - 5);
		[self addChild:lblTitle];
		
		CCButton *btnBack = [CCButton buttonWithTitle:@"Back" fontName:@"ArialMT" fontSize:24];
		[btnBack setTarget:self selector:@selector(goBackToMenu)];
		btnBack.anchorPoint = ccp(0,1);
		btnBack.position = ccp(5,winSize.height - 5);
		[self addChild:btnBack];
		
		[self setUserInteractionEnabled:YES];
	}
	return self;
}

-(void)goBackToMenu
{
	[[CCDirector sharedDirector] replaceScene:[MainScene scene]];
}

#pragma mark - Touch Methods

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
	startPosition = [touch locationInNode:self];
}

-(void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
	startPosition = [touch locationInNode:self];
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
	
}
@end
