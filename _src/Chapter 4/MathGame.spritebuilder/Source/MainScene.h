@interface MainScene : CCScene
{
	CGSize winSize;
	//the labels used for displaying the game info
	CCLabelBMFont *lblTurnsSurvived, *lblUnitsKilled, *lblTotalScore;
	NSInteger numTurnSurvived, numUnitsKilled, numTotalScore;
	NSMutableArray *arrEnemies, *arrFriendlies;
}
+(CCScene*)scene;
@end
