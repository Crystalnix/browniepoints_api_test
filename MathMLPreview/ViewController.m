//
//  ViewController.m
//  MathMLPreview
//
//  Created by Michael Rublev on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"

@implementation ViewController

@synthesize getExerciseButton;
@synthesize exerciseWebView;


// Default address for the HTTP request
static NSString *exerciseURLString = @"http://browniepoints.com/api/test.html";


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Stuff

// Changes state according to the passed variable
- (void)setExerciseLoaded:(BOOL)isLoaded
{
	isExerciseLoaded = isLoaded;
	if (isLoaded) {
		[getExerciseButton setTitle:@"Clear" forState:UIControlStateNormal];
		exerciseWebView.hidden = NO;
	} else {
		[getExerciseButton setTitle:@"Get Exercise" forState:UIControlStateNormal];
		exerciseWebView.hidden = YES;
	}
	getExerciseButton.enabled = YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	// Set rounded corners for the button
	getExerciseButton.layer.cornerRadius = 10.f;

	// Set controls to the initial state
	[self setExerciseLoaded:NO];
}

- (void)viewDidUnload
{
    [self setGetExerciseButton:nil];
    [self setExerciseWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [getExerciseButton release];
    [exerciseWebView release];
    [super dealloc];
}

- (IBAction)getExerciseButtonPressed:(id)sender
{
	if (isExerciseLoaded) {
		// Exercise is loaded, set to "clean" state
		[self setExerciseLoaded:NO];
	} else {
		NSURLRequest *reqeust = [NSURLRequest requestWithURL:[NSURL URLWithString:exerciseURLString]];
		[exerciseWebView loadRequest:reqeust];
		getExerciseButton.enabled = NO; // Prevent from clicking second time
	}
}

#pragma mark - UIWebViewDelegate methods

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error occurred"
													message:[error localizedDescription]
												   delegate:nil
										  cancelButtonTitle:@"Dismiss"
										  otherButtonTitles:nil,
						  nil];
	[alert show];
	[alert release];
	[self setExerciseLoaded:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self setExerciseLoaded:YES];
}


@end




