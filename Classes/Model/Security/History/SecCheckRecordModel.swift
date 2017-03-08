//
//  SecCheckRecordModel.swift
//  ZhiAnTongCpy
//
//  Created by Ricky on 2017/2/16.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//


import UIKit
import SwiftyJSON
//企业信息vo类
class SecCheckRecordModel:BaseModel{
    
    var id :Int!
    var checkName:String!
    var createTime:String!
    var checkTime:String!
    
    override init() {
        super.init()
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        self.id = dict["id"] as? Int
        self.checkName = dict["checkName"] as? String
        self.createTime = dict["createTime"] as? String
        self.checkTime = dict["checkTime"] as? String
    }
}