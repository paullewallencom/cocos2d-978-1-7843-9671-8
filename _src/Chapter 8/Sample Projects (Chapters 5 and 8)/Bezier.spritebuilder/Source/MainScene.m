#import "MainScene.h"

@implementation MainScene

+(CCScene*)scene
{
	return [[self alloc] init];
}

-(id)init
{
	if ((self=[super init]))
	{
		winSize = [[CCDirector sharedDirector] viewSize];
		
		CCNodeColor *bg = [[CCNodeColor alloc] initWithColor:[CCColor colorWithRed:0.2 green:0.5 blue:0.8]];
		[self addChild:bg];
		
		unitRegular = [[CCNodeColor alloc] initWithColor:[CCColor colorWithRed:0 green:1 blue:1] width:50 height:50];
		//unitRegular.position = ccp(winSize.width/2, winSize.height/2);
		//unitRegular.anchorPoint = ccp(0.5,0.5);
		[self addChild:unitRegular];
		CCNodeColor *shadow1 = [[CCNodeColor alloc] initWithColor:[CCColor blackColor] width:50 height:50];
		shadow1.anchorPoint = ccp(0.5,0.5);
		shadow1.position = ccp(26,24);
		shadow1.opacity = 0.5;
		[unitRegular addChild:shadow1 z:-1];
		
		unitBezier = [[CCNodeColor alloc] initWithColor:[CCColor colorWithRed:1 green:1 blue:0] width:50 height:50];
		//unitBezier.position = ccp(winSize.width * 0.75, winSize.height/2);
		//unitBezier.anchorPoint = ccp(0.5,0.5);
		[self addChild:unitBezier];
		CCNodeColor *shadow2 = [[CCNodeColor alloc] initWithColor:[CCColor blackColor] width:50 height:50];
		shadow2.anchorPoint = ccp(0.5,0.5);
		shadow2.position = ccp(26,24);
		shadow2.opacity = 0.5;
		[unitBezier addChild:shadow2 z:-1];
		
		[self setUserInteractionEnabled:YES];
	}
	return self;
}

-(void)sendFirstUnit
{
	unitRegular.position = ccp(0,0);
	unitBezier.position = ccp(0,0);
	
	[self scheduleOnce:@selector(sendSecondUnit) delay:2];
	
	CCActionMoveTo *move1 = [CCActionMoveTo actionWithDuration:0.5 position:ccp(winSize.width/4, winSize.height * 0.75)];
	CCActionMoveTo *move2 = [CCActionMoveTo actionWithDuration:0.5 position:ccp(winSize.width/2, winSize.height/4)];
	CCActionMoveTo *move3 = [CCActionMoveTo actionWithDuration:0.5 position:ccp(winSize.width*3/4, winSize.height * 0.75)];
	CCActionMoveTo *move4 = [CCActionMoveTo actionWithDuration:0.5 position:ccp(winSize.width - 50, 0)];
	
	[unitRegular runAction:[CCActionSequence actions:move1, move2, move3, move4, nil]];
}

-(void)sendSecondUnit
{
	ccBezierConfig bezConfig1;
	bezConfig1.controlPoint_1 = ccp(0, winSize.height);
	bezConfig1.controlPoint_2 = ccp(winSize.width*3/8, winSize.height);
	bezConfig1.endPosition = ccp(winSize.width*3/8, winSize.height/2);
	CCActionBezierTo *bez1 = [CCActionBezierTo actionWithDuration:1.0 bezier:bezConfig1];
	
	ccBezierConfig bezConfig2;
	bezConfig2.controlPoint_1 = ccp(winSize.width*3/8, 0);
	bezConfig2.controlPoint_2 = ccp(winSize.width*5/8, 0);
	bezConfig2.endPosition = ccp(winSize.width*5/8, winSize.height/2);
	CCActionBezierBy *bez2 = [CCActionBezierTo actionWithDuration:1.0 bezier:bezConfig2];
	
	ccBezierConfig bezConfig3;
	bezConfig3.controlPoint_1 = ccp(winSize.width*5/8, winSize.height);
	bezConfig3.controlPoint_2 = ccp(winSize.width, winSize.height);
	bezConfig3.endPosition = ccp(winSize.width - 50, 0);
	CCActionBezierTo *bez3 = [CCActionBezierTo actionWithDuration:1.0 bezier:bezConfig3];
	
	[unitBezier runAction:[CCActionSequence actions:bez1, bez2, bez3, nil]];
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
	[self unschedule:@selector(sendFirstUnit)];
	[self unschedule:@selector(sendSecondUnit)];
	[unitRegular stopAllActions];
	[unitBezier stopAllActions];
	
	[self sendFirstUnit];
	[self schedule:@selector(sendFirstUnit) interval:4.6];
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
	[self unschedule:@selector(sendFirstUnit)];
}

@end
