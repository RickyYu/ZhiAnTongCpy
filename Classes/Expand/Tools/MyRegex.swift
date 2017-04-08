//
//  MyRegex.swift
//  ZhiAnTongCpy
//
//  Created by Ricky on 2017/4/7.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

//正则表达式使用
import Foundation

struct MyRegex {
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
    }
    
    func match(input: String) -> Bool {
        if let matches = regex?.matchesInString(input,
                                                options: [],
                                                range: NSMakeRange(0, (input as NSString).length)) {
            return matches.count > 0
        }
        else {
            return false
        }
    }
}
