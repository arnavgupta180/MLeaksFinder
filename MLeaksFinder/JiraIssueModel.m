//
//  JiraIssueModel.m
//  createJiraTicket
//
//  Created by tokopedia on 22/02/20.
//  Copyright © 2020 tokopedia. All rights reserved.
//
#import "JiraIssueModel.h"

@implementation JiraIssueModel

-(JiraIssueModel *)issueFromJSONData:(NSData *)jsonData {
    id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error: nil];
    JiraIssueModel *issue = [[JiraIssueModel alloc] init];
    issue.total = [json[@"total"] intValue];
    NSArray *issues = json[@"issues"];
    NSMutableArray *summaryArray = [NSMutableArray array];
    for (NSDictionary *dict in issues){
        NSDictionary *fields = dict[@"fields"];
        [summaryArray addObject: fields[@"summary"]];
    }
    issue.issueSummary = summaryArray;
    return issue;
}

@end
