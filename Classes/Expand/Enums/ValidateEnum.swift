//
//  ValidateEnum.swift
//  Mineral
//
//  Created by Ricky on 2017/3/27.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import Foundation
enum ValidateEnum {
    case email(_: String)  //邮箱
    case phoneNum(_: String)//手机
    case phsNum(_: String)//固定电话
    case carNum(_: String)
    case username(_: String)
    case password(_: String)
    case nickname(_: String)
    case URL(_: String)
    case IP(_: String)
    case FLOAT(_: String)
    var isRight: Bool {
        var predicateStr:String!
        var currObject:String!
        switch self {
        case let .email(str):
            predicateStr = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            currObject = str
            //"^1[0-9]{10}$"
        case let .phoneNum(str):
            predicateStr = "^((13[0-9])|(15[^4,\\D])|(17[0,0-9])|(18[0,0-9]))\\d{8}|0\\d{2,3}-\\d{5,9}|(0\\d{2,3}-\\d{5,9})$"
            currObject = str
        case let .phsNum(str):
            predicateStr = "^(0\\d{2,3}-\\d{5,9}$|^(0\\d{2,3}-\\d{5,9}))"
            currObject = str
        case let .carNum(str):
            predicateStr = "^[A-Za-z]{1}[A-Za-z_0-9]{5}$"
            currObject = str
        case let .username(str):
            predicateStr = "^[A-Za-z0-9]{6,20}+$"
            currObject = str
        case let .password(str):
            predicateStr = "^[a-zA-Z0-9]{6,20}+$"
            currObject = str
        case let .nickname(str):
            predicateStr = "^[\\u4e00-\\u9fa5]{4,8}$"
            currObject = str
        case let .URL(str):
            predicateStr = "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"
            currObject = str
        case let .IP(str):
            predicateStr = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
            currObject = str
    
        case let .FLOAT(str):
            predicateStr = "^[0-9]*((\\\\.|,)[0-9]{0,2})?$"
            currObject = str
        }
        
        let predicate =  NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
        return predicate.evaluateWithObject(currObject)
    }
}