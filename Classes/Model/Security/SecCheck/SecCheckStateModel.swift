//
//  SecCheckStateModel.swift
//  ZhiAnTongCpy
//
//  Created by Ricky on 2017/2/8.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit
import SwiftyJSON
//企业信息vo类
class SecCheckStateModel:BaseModel{
    
    var id :Int!
    var matterName:String!
    var createTime:String!
    var matterState:Bool!
     var matterRemark:String! = ""
    override init() {
        super.init()
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        self.id = dict["id"] as? Int
        self.matterName = dict["matterName"] as? String
        self.createTime = dict["createTime"] as? String
        self.matterState = dict["matterState"] as? Bool
        if (dict["matterRemark"] != nil){
            self.matterRemark = dict["matterRemark"] as? String
        
        }else{
            self.matterRemark = ""
        }
        
    }
    
    func getParams1() -> Dictionary<String, AnyObject> {
        var params = Dictionary<String, AnyObject>()
        if self.matterRemark == nil{
        self.matterRemark = ""
        }
        params = [
            "id":String(self.id),
            "matterName":self.matterName,
            "createTime":self.createTime,
            "matterState":String(self.matterState),
            "matterRemark":self.matterRemark,
        ]
        return  params
    }
}
