@interface MainScene : CCScene
{
	CGPoint startPosition;
	BOOL isStreaming;
	CCParticleSystem *smokeParticle;
}
+(CCScene*)scene;
@end
