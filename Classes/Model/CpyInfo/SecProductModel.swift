//
//  SecProductModel.swift
//  ZhiAnTongCpy
//
//  Created by Ricky on 2017/2/17.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//
import UIKit
import SwiftyJSON
//企业信息vo类
class SecProductModel:BaseModel{
    
    var yhpc_checks :String!
    var organization_tel:String!
    var hzyj_pre_plan:Int!
    
    var yhpc_danger_num :String!
    var organization_id:Int!
    var hzyj_team:Int!
    
    var yhpc_money :String!
    var hzyj_chemistry_num:Int!
    var hzyj_drill:Int!

    var hzyj_id:Int!
    var hzyj_train:Int!
    var organization_num:Int!
    var yhpc_rollcall_company_num:String!
    var organization_principal:String!
    var hzyj_material:Int!
    
    var hzyj_enum_name:String!
    var hzyj_castTime:String!
  
  override init() {
    super.init()
 }

init(dict: [String: AnyObject]) {
    super.init()
    self.yhpc_checks = dict["yhpc_checks"] as? String
    
    if dict["hzyj_pre_plan"] != nil{
        self.hzyj_pre_plan = dict["hzyj_pre_plan"] as? Int
    }else{
        self.hzyj_pre_plan = 0
    }
    self.yhpc_danger_num = dict["yhpc_danger_num"] as? String
    
    self.organization_id = dict["organization_id"] as? Int
    
    if dict["hzyj_team"] != nil{
        self.hzyj_team = dict["hzyj_team"] as? Int
    }else{
        self.hzyj_team = 0
    }
    
    
    self.yhpc_money = dict["yhpc_money"] as? String
    self.hzyj_chemistry_num = dict["hzyj_chemistry_num"] as? Int ?? 0
    
    if dict["hzyj_drill"] != nil{
        self.hzyj_drill = dict["hzyj_drill"] as? Int
    }else{
        self.hzyj_drill = 0
    }
    
    self.hzyj_id = dict["hzyj_id"] as? Int
    self.hzyj_train = dict["hzyj_train"] as? Int
    self.organization_num = dict["organization_num"] as? Int
    
    self.yhpc_rollcall_company_num = dict["yhpc_rollcall_company_num"] as? String
    

    if dict["hzyj_material"] != nil{
        self.hzyj_material = dict["hzyj_material"] as! Int
    }else{
        self.hzyj_material = 0
    }
    
//    print(dict["organization_tel"])
//    print(dict["organization_tel"] as! String)
//    do{
//     try self.organization_tel = dict["organization_tel"] as! String
//    }catch{
//    self.organization_tel = ""
//    }
    


    if dict["organization_tel"] != nil{
       self.organization_tel = dict["organization_tel"] as! String
    }else{
        self.organization_tel = ""
    }
    
    if dict["organization_principal"] != nil{
        self.organization_principal = dict["organization_principal"] as! String
    }else{
        self.organization_principal = ""
    }
    
    if dict["hzyj_enum_name"] != nil{
    self.hzyj_enum_name = dict["hzyj_enum_name"] as! String
    }else{
     self.hzyj_enum_name = ""
    }
    
    
    if dict["hzyj_castTime"] != nil{
        self.hzyj_castTime = dict["hzyj_castTime"] as! String
    }else{
        self.hzyj_castTime  = ""
    }
    
  }
}

