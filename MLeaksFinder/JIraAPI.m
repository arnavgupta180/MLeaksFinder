//
//  JIraAPI.m
//  createJiraTicket
//
//  Created by tokopedia on 22/02/20.
//  Copyright © 2020 tokopedia. All rights reserved.
//

#import "JIraAPI.h"
#import "JiraIssueModel.h"
#import "CodeOwnerModel.h"

@implementation JIraAPI

+(void)CreateNewIssue:(NSString *)summary{
    
    JIraAPI *jira = [[JIraAPI alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableString *message = [NSMutableString stringWithFormat:@"Memory leak found at path %@",summary];
    if (![defaults objectForKey:@"codeOwners"]){
        [jira fetchCodeOwners:summary completionHandler:^(NSArray *array) {
            [defaults setObject: array forKey:@"codeOwners"];
            NSString *squadName = [jira findSquadName:summary];
            if ([squadName length] > 0){
                [jira searchJiraTicket:message completionHandler:^(bool isIssue) {
                    if (isIssue){
                        [jira createJiraTicket:message :squadName];
                    }
                }];
            }
        }];
        
    }else {
        NSString *squadName = [jira findSquadName:summary];
        if ([squadName length] > 0){
            [jira searchJiraTicket:message completionHandler:^(bool isIssue) {
                if (isIssue){
                    [jira createJiraTicket:message :squadName];
                }
            }];
        }
    }
}

-(void)createJiraTicket:(NSString *)summary :(NSString *)squadName {
    NSDictionary *headers = @{ @"authorization": @"Basic YXJuYXYuZ3VwdGFAdG9rb3BlZGlhLmNvbTpEbWwzYzc5UTlTTE4yTGlIUzNDOTEyMzI=",
                               @"content-type": @"application/json",
                               @"cache-control": @"no-cache",
                               @"postman-token": @"8aec318c-879e-2b93-93fe-ec1189d3a395" };
    
    NSString *desc = @"“Memory that was allocated at some point, but was never released and is no longer referenced by your app.This might lead to crashes.";
    
    NSDictionary *parameters = @{ @"fields": @{ @"project": @{ @"key": @"IOS" }, @"summary": summary, @"description": desc, @"issuetype": @{ @"name": @"Story"},@"customfield_10181": @{ @"value": squadName} } };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://tokopedia.atlassian.net/rest/api/2/issue/"]
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

    NSDictionary *headers = @{ @"authorization": @"Basic YXJuYXYuZ3VwdGFAdG9rb3BlZGlhLmNvbTpEbWwzYzc5UTlTTE4yTGlIUzNDOTEyMzI=",
                               @"content-type": @"application/json",
                               @"cache-control": @"no-cache",
                               @"postman-token": @"10b68e4b-b6d1-2286-3168-585e640d3f1a" };
    
    NSString * str = [NSString stringWithFormat:@"project = iOS and summary ~ \"%@\"",summary];
    NSDictionary *parameters = @{ @"jql": str };
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: @"https://tokopedia.atlassian.net/rest/api/2/search"]
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

-(void)fetchCodeOwners:(NSString *)summary completionHandler: (void (^)(NSArray * array))completionHandler {
    NSDictionary *headers = @{ @"user-agent": @"arnavgupta180",
                               @"authorization": @"Basic YXJuYXYuZ3VwdGFAdG9rb3BlZGlhLmNvbTo0OTI3ZDU1OWJlZWY1ZmU1ODc1YzVhYmZiYjA0M2E0MjA2YjU2ZWEz",
                               @"cache-control": @"no-cache",
                               @"postman-token": @"40bce4f1-62ac-119e-769b-bc47c55c6084" };
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.github.com/repos/tokopedia/ios-tokopedia/contents/.github/CODEOWNERS"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            CodeOwnerModel *model = [[CodeOwnerModel alloc] init];
            model = [model parseData:data];
            completionHandler(model.squads);
            NSLog(@"%@", model.content);
        }
    }];
    [dataTask resume];
}

-(NSString*)findSquadName:(NSString *)summary{
    
    NSArray *brokenByDot = [summary componentsSeparatedByString:@"."];
    NSString *moduleName = @"MLeak";
    if ([brokenByDot count] > 0){
        moduleName = brokenByDot[0];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *squads = [defaults objectForKey:@"codeOwners"];
    
    for (NSString *squad in squads) {
        if ([squad containsString: moduleName]){
            NSArray *brokenByNewLine = [squad componentsSeparatedByString:@"\n"];
            if ([brokenByNewLine count] > 0){
                return brokenByNewLine[0];
            }
        }
    }
    return @"";
}
@end
