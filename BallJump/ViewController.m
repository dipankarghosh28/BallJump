//
//  ViewController.m
//  BallJump
//
//  Created by Dipankar Ghosh on 2/18/17.
//  Copyright © 2017 Dipankar Ghosh. All rights reserved.
//

#import "ViewController.h"

int highScoreNumber;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *highScore;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    highScoreNumber = [[NSUserDefaults standardUserDefaults]integerForKey:@"highScoreNumber"];
    _highScore.text = [NSString stringWithFormat:@"HighScore:",highScoreNumber];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
