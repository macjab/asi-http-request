//
//  ASIS3RequestTests.m
//  asi-http-request
//
//  Created by Ben Copsey on 12/07/2009.
//  Copyright 2009 All-Seeing Interactive. All rights reserved.
//

#import "ASIS3RequestTests.h"
#import "ASIS3Request.h"

@implementation ASIS3RequestTests


- (void)testAuthenticationHeaderGeneration
{
	// All these tests are based on Amazon's examples at: http://docs.amazonwebservices.com/AmazonS3/2006-03-01/
	
	NSString *secretAccessKey = @"uV3F3YluFJax1cknvbcGwgjvx4QpvB+leU8dUj2o";
	NSString *accessKey = @"0PN5J17HBGZHT7JJ3X82";
	NSString *bucket = @"johnsmith";
	
	
	// Test GET
	NSString *path = @"photos/puppy.jpg";
	NSString *dateString = @"Tue, 27 Mar 2007 19:36:42 +0000";
	ASIS3Request *request = [ASIS3Request requestWithBucket:bucket path:path];
	[request setDateString:dateString];
	[request setSecretAccessKey:secretAccessKey];
	[request setAccessKey:accessKey];
	[request generateS3Headers];
	BOOL success = [[[request requestHeaders] valueForKey:@"Authorization"] isEqualToString:@"AWS 0PN5J17HBGZHT7JJ3X82:xXjDGYUmKxnwqr5KXNPGldn5LbA="];
	GHAssertTrue(success,@"Failed to generate the correct authorisation header for a GET request");
	
	// Test PUT
	path = @"photos/puppy.jpg";
	dateString = @"Tue, 27 Mar 2007 21:15:45 +0000";
	request = [ASIS3Request requestWithBucket:bucket path:path];
	[request setRequestMethod:@"PUT"];
	[request setMimeType:@"image/jpeg"];
	[request setDateString:dateString];
	[request setSecretAccessKey:secretAccessKey];
	[request setAccessKey:accessKey];
	[request generateS3Headers];
	success = [[[request requestHeaders] valueForKey:@"Authorization"] isEqualToString:@"AWS 0PN5J17HBGZHT7JJ3X82:hcicpDDvL9SsO6AkvxqmIWkmOuQ="];
	GHAssertTrue(success,@"Failed to generate the correct authorisation header for a PUT request");	
	
	// Test List
	path = @"";
	dateString = @"Tue, 27 Mar 2007 19:42:41 +0000";
	request = [ASIS3Request listRequestWithBucket:bucket prefix:@"photos" maxResults:50 marker:@"puppy"];
	[request setDateString:dateString];
	[request setSecretAccessKey:secretAccessKey];
	[request setAccessKey:accessKey];
	[request generateS3Headers];
	success = [[[request requestHeaders] valueForKey:@"Authorization"] isEqualToString:@"AWS 0PN5J17HBGZHT7JJ3X82:jsRt/rhG+Vtp88HrYL706QhE4w4="];
	GHAssertTrue(success,@"Failed to generate the correct authorisation header for a list request");
	
	// Test fetch ACL
	path = @"?acl";
	dateString = @"Tue, 27 Mar 2007 19:44:46 +0000";
	request = [ASIS3Request requestWithBucket:bucket path:path];
	[request setDateString:dateString];
	[request setSecretAccessKey:secretAccessKey];
	[request setAccessKey:accessKey];
	[request generateS3Headers];
	success = [[[request requestHeaders] valueForKey:@"Authorization"] isEqualToString:@"AWS 0PN5J17HBGZHT7JJ3X82:thdUi9VAkzhkniLj96JIrOPGi0g="];
	GHAssertTrue(success,@"Failed to generate the correct authorisation header for a list request");	
	
	// Test Unicode keys
	// (I think Amazon's name for this example is misleading since this test actually only uses URL encoded strings)
	bucket = @"dictionary";
	path = @"fran%C3%A7ais/pr%c3%a9f%c3%a8re";
	dateString = @"Wed, 28 Mar 2007 01:49:49 +0000";
	request = [ASIS3Request requestWithBucket:bucket path:path];
	[request setDateString:dateString];
	[request setSecretAccessKey:secretAccessKey];
	[request setAccessKey:accessKey];
	[request generateS3Headers];
	success = [[[request requestHeaders] valueForKey:@"Authorization"] isEqualToString:@"AWS 0PN5J17HBGZHT7JJ3X82:dxhSBHoI6eVSPcXJqEghlUzZMnY="];
	GHAssertTrue(success,@"Failed to generate the correct authorisation header for a list request");		
}

// To run this test, uncomment and fill in your S3 access details
/*
- (void)testREST
{
	NSString *secretAccessKey = @"my-secret-key";
	NSString *accessKey = @"my-access-key";
	NSString *bucket = @"bucket-name";
	NSString *path = @"path/to/file";
	
	// Create the fle
	NSString *text = @"This is my content";
	NSString *filePath = [[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"testfile.txt"];
	[[text dataUsingEncoding:NSUTF8StringEncoding] writeToFile:filePath atomically:NO];
	
	// PUT the file
	ASIS3Request *request = [ASIS3Request PUTRequestForFile:filePath withBucket:bucket path:path];
	[request setRequestMethod:@"PUT"];
	[request setSecretAccessKey:secretAccessKey];
	[request setAccessKey:accessKey];
	[request start];
	BOOL success = [[request responseString] isEqualToString:@""];
	GHAssertTrue(success,@"Failed to PUT a file to S3");	

	// GET the file
	request = [ASIS3Request requestWithBucket:bucket path:path];
	[request setSecretAccessKey:secretAccessKey];
	[request setAccessKey:accessKey];
	[request start];
	success = [[request responseString] isEqualToString:@"This is my content"];
	GHAssertTrue(success,@"Failed to GET the correct data from S3");	

	// DELETE the file
	request = [ASIS3Request requestWithBucket:bucket path:path];
	[request setSecretAccessKey:secretAccessKey];
	[request setRequestMethod:@"DELETE"];
	[request setAccessKey:accessKey];
	[request start];
	success = [[request responseString] isEqualToString:@""];
	GHAssertTrue(success,@"Failed to DELETE the file from S3");	
}
*/


@end
