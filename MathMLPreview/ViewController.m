//
//  ViewController.m
//  MathMLPreview
//
//  Created by Michael Rublev on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"


@interface ViewController ()
@property (retain, nonatomic) NSOperationQueue *connectionQueue;
@end


@implementation ViewController

@synthesize getExerciseButton;
@synthesize exerciseWebView;
@synthesize connectionQueue;


// Default address for the HTTP request
static NSString *exerciseURLString = @"http://browniepoints.com/api/test.html";
// Points to the desired request point for API
static NSString *exerciseAPI = @"http://browniepoints.com/api/";


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

- (void)throwAlertMessage:(NSString *)messageText
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error occurred"
													message:messageText
												   delegate:nil
										  cancelButtonTitle:@"Dismiss"
										  otherButtonTitles:nil,
						  nil];
	[alert show];
	[alert release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	connectionQueue = [[NSOperationQueue alloc] init];

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
	[self.connectionQueue cancelAllOperations];
	[connectionQueue release];
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
		if ([connectionQueue operationCount]) {
			[connectionQueue cancelAllOperations];
			// It's better to figure out why request is pending,
			// but let's rely on network callback (say, in case of connection problem)
			return;
		}

		getExerciseButton.enabled = NO; // Prevent from clicking second time

		ASIFormDataRequest *request =
			[ASIFormDataRequest requestWithURL:[NSURL URLWithString:exerciseAPI]];
		[request addPostValue:@"getexercise" forKey:@"action"];
		[request setDelegate:self];
		[connectionQueue addOperation:request];
	}
}

#pragma mark - UIWebViewDelegate methods

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[self throwAlertMessage:[error localizedDescription]];
	[self setExerciseLoaded:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self setExerciseLoaded:YES];
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestFailed:(ASIHTTPRequest *)request
{
	[self throwAlertMessage:[[request error] localizedDescription]];
	[self setExerciseLoaded:NO];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	// Create a dictionary from return data
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	NSDictionary *responseDict = [parser objectWithData:[request responseData]];
	[parser release];

	// Test return value
	if ([responseDict isKindOfClass:[NSDictionary class]] == NO) {
		NSLog(@"[Error] Unexpected return value");
		NSLog(@"[Details] %@", [request responseString]);
	}

	// Load webview content with data in the memory
	NSString *htmlString = [responseDict objectForKey:@"exercise"];
	NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
	[exerciseWebView loadData:htmlData
					 MIMEType:@"text/html"
			 textEncodingName:@"utf-8"
					  baseURL:nil];
}

@end




