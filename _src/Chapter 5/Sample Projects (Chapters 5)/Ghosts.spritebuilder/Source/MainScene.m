#import "MainScene.h"
#import "SpriteExampleScene.h"
#import "ParticleExampleScene.h"
#import "ConstantLineExampleScene.h"

@implementation MainScene

+(CCScene*)scene
{
	return [[self alloc] init];
}

-(id)init
{
	if ((self=[super init]))
	{		
		CCButton *btnSprite = [CCButton buttonWithTitle:@"Sprite Example" fontName:@"ArialMT" fontSize:30];
		[btnSprite setTarget:self selector:@selector(goToSpriteExample)];
		
		CCButton *btnParticle = [CCButton buttonWithTitle:@"Particle Example" fontName:@"ArialMT" fontSize:30];
		[btnParticle setTarget:self selector:@selector(goToParticleExample)];
		
		CCButton *btnLine = [CCButton buttonWithTitle:@"Line Example" fontName:@"ArialMT" fontSize:30];
		[btnLine setTarget:self selector:@selector(goToLineExample)];
		
		CCLayoutBox *layout = [[CCLayoutBox alloc] init];
		
		[layout addChild:btnLine];
		[layout addChild:btnParticle];
		[layout addChild:btnSprite];
		
		layout.anchorPoint = ccp(0.5,0.5);
		[layout setDirection:CCLayoutBoxDirectionVertical];
		[layout setSpacing:10];
		layout.position = ccp([[CCDirector sharedDirector] viewSize].width /2, [[CCDirector sharedDirector] viewSize].height / 2);
		[self addChild:layout];
	}
	return self;
}

-(void)goToSpriteExample
{
	[[CCDirector sharedDirector] replaceScene:[SpriteExampleScene scene]];
}

-(void)goToParticleExample
{
	[[CCDirector sharedDirector] replaceScene:[ParticleExampleScene scene]];
}

-(void)goToLineExample
{
	[[CCDirector sharedDirector] replaceScene:[ConstantLineExampleScene scene]];
}

@end
