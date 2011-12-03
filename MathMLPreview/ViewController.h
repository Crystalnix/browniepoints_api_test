//
//  ViewController.h
//  MathMLPreview
//
//  Created by Michael Rublev on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIWebViewDelegate> {
	BOOL isExerciseLoaded;
}

@property (retain, nonatomic) IBOutlet UIButton *getExerciseButton;
@property (retain, nonatomic) IBOutlet UIWebView *exerciseWebView;

- (IBAction)getExerciseButtonPressed:(id)sender;


@end
