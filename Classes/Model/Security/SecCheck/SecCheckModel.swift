//
//  SecCheckModel.swift
//  ZhiAnTongCpy
//
//  Created by Ricky on 2017/2/8.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit
import SwiftyJSON
//企业信息vo类
class SecCheckModel:BaseModel{
    
    var id :Int!
    var checkName:String!
    var createTime:String!
    var checkRemark:String!
    
    override init() {
        super.init()
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        self.id = dict["id"] as? Int
        self.checkName = dict["checkName"] as? String
        self.createTime = dict["createTime"] as? String
        self.checkRemark = dict["checkRemark"] as? String

    }
}












