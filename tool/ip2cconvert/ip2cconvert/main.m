/*!
    ip2cconvert
    https://github.com/BB9z/CFW
 
    free for any use.
 */

#import <Foundation/Foundation.h>
#import "dout.h"
#include <stdio.h>
#include <stdlib.h>

void prinfHelp () {
    printf("ip-to-country csv file converter.\n");
    printf("usage: ip2cconvert source_file >> output_file.js\n");
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc < 2) {
            prinfHelp();
        }
    
        FILE *csvFile;
        if (!(csvFile = fopen(argv[1], "r"))) {
            fprintf(stderr, "Could not open \"%s\" for reading\n", argv[1]);
            exit(EXIT_FAILURE);
        }
        
        NSString *dictName = @"CNAndHKIpDict";
        size_t restrictSize = 200;
        char *line = (char *)malloc(restrictSize+1);
        
        NSMutableArray *segemntArrayInAIndex = nil;
        NSUInteger currentFirstIPIndex = 0;
        while (getline(&line, &restrictSize, csvFile) != -1) {
            NSArray *fields = [[NSString stringWithCString:line encoding:NSUTF8StringEncoding] componentsSeparatedByString:@","];
            
            NSString *cflag = [fields objectAtIndex:2];     // 地区标识
            
            // 只关心大陆与香港的IP段
            if ([cflag isEqualToString:@"\"CN\""] || [cflag isEqualToString:@"\"HK\""]) {
                long startIP = [[[fields objectAtIndex:0] substringFromIndex:1] longLongValue];
                long endIP = [[[fields objectAtIndex:1] substringFromIndex:1] longLongValue];
                NSUInteger index = startIP/16777216;   // 256^3
                
                if (index != currentFirstIPIndex) {
                    // 结束旧的
                    if (segemntArrayInAIndex) {
                        NSString *dictItem = [NSString stringWithFormat:@"%@.k%d\t= [%@];\n", dictName, currentFirstIPIndex, [segemntArrayInAIndex componentsJoinedByString:@", "]];
                        printf("%s", [dictItem cStringUsingEncoding:NSUTF8StringEncoding]);
                    }
                    
                    // 创建新的
                    segemntArrayInAIndex = [NSMutableArray arrayWithCapacity:30];
                    
                    currentFirstIPIndex = index;
                    
                }
                NSString *segemntString = [NSString stringWithFormat:@"[%ld,%ld]", startIP, endIP];
                [segemntArrayInAIndex addObject:segemntString];
                
                _douto(segemntString)
                _dout_float(index)
            }
        }
        if (segemntArrayInAIndex) {
            NSString *dictItem = [NSString stringWithFormat:@"%@.k%d\t= [%@];\n", dictName, currentFirstIPIndex, [segemntArrayInAIndex componentsJoinedByString:@", "]];
            printf("%s", [dictItem cStringUsingEncoding:NSUTF8StringEncoding]);
        }
        fclose(csvFile);
        
        return 0;
    }
}


