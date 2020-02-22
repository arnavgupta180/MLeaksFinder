//
//  JIraAPI.m
//  createJiraTicket
//
//  Created by tokopedia on 22/02/20.
//  Copyright © 2020 tokopedia. All rights reserved.
//

#import "JIraAPI.h"
#import "JiraIssueModel.h"

@implementation JIraAPI

+(void)CreateNewIssue:(NSString *)summary{
        
    JIraAPI *jira = [[JIraAPI alloc]init];
    [jira searchJiraTicket:summary completionHandler:^(bool isIssue) {
        if (isIssue){
            [jira createJiraTicket: summary];
        }
    }];
}


-(void)createJiraTicket:(NSString *)summary {
    NSDictionary *headers = @{ @"authorization": @"Basic YXJuYXZndXB0YTE4MEBnbWFpbC5jb206YjRVWnhFUndqdTJUS25UNnlMcjhEM0RB",
                               @"content-type": @"application/json",
                               @"cache-control": @"no-cache",
                               @"postman-token": @"26993417-6fa7-5c2c-7afd-c1ccf2940152" };
    
    NSDictionary *parameters = @{ @"fields": @{ @"project": @{ @"key": @"MEM" }, @"summary": summary, @"description": @"Creating an issue via REST API1", @"issuetype": @{ @"name": @"Story" } } };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://arnavgupta.atlassian.net/rest/api/2/issue/"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSLog(@"%@", httpResponse);
        }
    }];
    [dataTask resume];
}

-(void)searchJiraTicket:(NSString *)summary completionHandler:(void (^)(bool isIssue))completionHandler {
    
    NSDictionary *headers = @{ @"authorization": @"Basic YXJuYXZndXB0YTE4MEBnbWFpbC5jb206YjRVWnhFUndqdTJUS25UNnlMcjhEM0RB",
                               @"content-type": @"application/json",
                               @"cache-control": @"no-cache",
                               @"postman-token": @"cef31d82-7680-df4b-94f1-395d3fdf51ba" };
    
    NSString * str = [NSString stringWithFormat:@"project = MEM and summary ~ \"%@\"",summary];
    NSDictionary *parameters = @{ @"jql": str };
           NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: @"https://arnavgupta.atlassian.net/rest/api/2/search"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
      [request setHTTPMethod:@"POST"];
      [request setAllHTTPHeaderFields:headers];
      [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSLog(@"%@", response);

            JiraIssueModel *issue = [[JiraIssueModel alloc] init];
            issue = [issue issueFromJSONData:data];
            if ([issue.issueSummary containsObject:summary]){
                completionHandler(NO);
            }else {
                completionHandler(YES);
            }
        }
    }];
    [dataTask resume];
}

@end
