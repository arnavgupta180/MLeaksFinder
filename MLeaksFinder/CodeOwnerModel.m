//
//  JiraIssueModel.m
//  createJiraTicket
//
//  Created by tokopedia on 22/02/20.
//  Copyright © 2020 tokopedia. All rights reserved.
//
#import "CodeOwnerModel.h"

@implementation CodeOwnerModel

-(CodeOwnerModel *)parseData:(NSData *)jsonData {
    id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error: nil];
    CodeOwnerModel *model = [[CodeOwnerModel alloc] init];
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:json[@"content"] options:NSDataBase64DecodingIgnoreUnknownCharacters];

    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSASCIIStringEncoding];
   decodedString = [decodedString stringByReplacingOccurrencesOfString:@"# core"
   withString:@"iOS - Platform"];
    decodedString = [decodedString stringByReplacingOccurrencesOfString:@"# whitewalkers - features" withString:@"iOS - Whitewalker"];
    decodedString = [decodedString stringByReplacingOccurrencesOfString:@"# aquaman - features"
     withString:@"iOS - Aquaman"];
    decodedString = [decodedString stringByReplacingOccurrencesOfString:@"# lex luthor - features"
     withString:@"iOS - Lex Luthor"];
    decodedString = [decodedString stringByReplacingOccurrencesOfString:@"# batman - features"
     withString:@"iOS - Platform"];
    decodedString = [decodedString stringByReplacingOccurrencesOfString:@"# catwoman - features"
     withString:@"iOS - Catwoman"];
    decodedString = [decodedString stringByReplacingOccurrencesOfString:@"# nights watch - features" withString:@"iOS - Night's Watch"];
    decodedString = [decodedString stringByReplacingOccurrencesOfString:@"# targaryen - features"
      withString:@"iOS - Targaryens"];
    NSArray *brokenByLines=[decodedString componentsSeparatedByString:@"\n\n"];
    model.squads = brokenByLines;
    model.content = decodedString;
    return model;
}

@end


//    "aquaman": "iOS - Aquaman",
//    "catwoman": "iOS - Catwoman",
//    "joker": "iOS - Joker",
//    "luthor": "iOS - Lex Luthor",
//    "nights watch": "iOS - Night's Watch",
//    "core": "iOS - Platform",
//    "batman": "iOS - Platform",
//    "targaryens": "iOS - Targaryens",
//    "whitewalkers": "iOS - Whitewalker",
