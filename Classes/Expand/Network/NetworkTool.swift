//
//  NetworkTool.swift
//  ZhiAnTongGov
//
//  Created by Ricky on 2016/11/23.
//  Copyright © 2016年 safetysafetys. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SVProgressHUD


class NetworkTool: Alamofire.Manager {
    // MARK: - 单例
    internal static let sharedTools: NetworkTool = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        var header : Dictionary =  Manager.defaultHTTPHeaders
        configuration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
        return NetworkTool(configuration: configuration)
        
    }()
    
    //MARK: - 登陆
    func login(parameters:[String:AnyObject],finished:(login:Login!,error:String!)->()){
          SVProgressHUD.showWithStatus("正在加载...")
        let identify = ""
        var addParameters = parameters
        addParameters["client"] = "ios"
        let key = "SAFETYS_CLIENT_AUTH_KEY_2016="+identify
        let headers = [
            "Cookie": key,
            "Accept-Language" : "zh-CN,zh;q=0.8,en;q=0.6"
        ]
        //"Content-Type": "application/json;charset=UTF-8"  加上此header报type不能为空
        print(AppTools.getServiceURLWithYh("LOGIN"))
        request(.POST, AppTools.getServiceURLWithYh("LOGIN"), parameters: addParameters, encoding: .URL, headers: headers).responseJSON(queue: dispatch_get_main_queue(), options: []){(response) in
            guard response.result.isSuccess else {
                SVProgressHUD.dismiss()
                //SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(login:nil,error: NOTICE_NETWORK_ERROR)
                return
            }
            if let dictValue = response.result.value{
                let dict = JSON(dictValue)
                print("login.dict = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                //  字典转成模型
                if success {
                    let login = Login(json:dict)
                    finished(login: login, error: nil)
                    
                }else{
                    
                    finished(login: nil,error: message) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                finished(login: nil,error: "数据异常")
            }
        }
    }
    
    //MARK: 获取MSDS列表
    func getMSDSInfo(parameters:[String:AnyObject],finished: (mSDSInfoModels: [MSDSInfoModel]!, error: String!,totalCount:Int!)->()) {
        
        self.sendPostRequest(AppTools.getServiceURLWithDa("LOAD_DANGEROUS_CHEMICALS"), parameters: parameters) { (response) in
            
            guard response!.result.isSuccess else {
                finished(mSDSInfoModels:nil,error: NOTICE_NETWORK_ERROR,totalCount: nil)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("getMSDSInfo.dict = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                let totalCount = dict["totalCount"].intValue
                //  字典转成模型
                if success {
                    if let items = dict["json"].arrayObject {
                        var mSDSInfoModels = [MSDSInfoModel]()
                        for item in items {
                            let homeItem = MSDSInfoModel(dict: item as! [String: AnyObject])
                            mSDSInfoModels.append(homeItem)
                        }
                        finished(mSDSInfoModels: mSDSInfoModels,error: nil,totalCount: totalCount)
                    }
                    
                }else{
                    finished(mSDSInfoModels: nil,error: message,totalCount: 0) //success  false
                }
            }else {
                finished(mSDSInfoModels: nil,error: "数据异常",totalCount: 0)
            }
            
        }
    }
    
    //获取统计数据
    func loadCpyCount(parameters:[String:AnyObject],finished: (data : ChartModel!, error: String!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithYh("LOAD_COMPANY_COUNT"), parameters: parameters) { (response) in
            
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(data:nil,error: NOTICE_NETWORK_ERROR)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("loadCpyCount = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                //  字典转成模型
                if success {
                    if let data = dict["entity"].dictionaryObject{
                        let dataModel = ChartModel(dict:data)
                        finished(data: dataModel, error: nil)
                    }
                    
                }else{
                    finished(data: nil,error: message) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                finished(data: nil,error: "数据异常")
            }
            
        }
    }

    //新增检查表
    func createSafetyCheck(parameters:[String:AnyObject],finished: (data : ChartModel!, error: String!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithYh("CREATE_SAFETY_CHECK"), parameters: parameters) { (response) in
            
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(data:nil,error: NOTICE_NETWORK_ERROR)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("CREATE_SAFETY_CHECK = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                //  字典转成模型
                if success {
                    finished(data: nil, error: nil)
                }else{
                    finished(data: nil,error: message) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                finished(data: nil,error: "数据异常")
            }
            
        }
    }
    //更新检查表
    func updateSafetyCheck(parameters:[String:AnyObject],finished: (data : ChartModel!, error: String!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithYh("UPDATE_SAFETY_CHECK"), parameters: parameters) { (response) in
            
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(data:nil,error: NOTICE_NETWORK_ERROR)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("updateSafetyCheck = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                //  字典转成模型
                if success {
                    finished(data: nil, error: nil)
                }else{
                    finished(data: nil,error: message) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                finished(data: nil,error: "数据异常")
            }
            
        }
    }
    //MARK:保存企业经纬度
    func savePoint(parameters:[String:AnyObject],finished:(cpyInfoModels:CompanyInfoModel!,error:String!,totalCount:Int!)->()){
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithDa("SAVE_POINT"), parameters: parameters) { (response) in
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(cpyInfoModels:nil,error: NOTICE_NETWORK_ERROR,totalCount: nil)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("savePoint.dict = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                let totalCount = dict["totalCount"].intValue
                //  字典转成模型
                if success {
                    finished(cpyInfoModels: nil,error: nil,totalCount: totalCount)
                    
                }else{
                    finished(cpyInfoModels: nil,error: message,totalCount: nil) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                finished(cpyInfoModels: nil,error: "数据异常",totalCount: nil)
            }
            
        }
    }
    //MARK:获取企业经纬度
    func getPoint(parameters:[String:AnyObject],finished:(locInfoModel:LocInfoModel!,error:String!)->()){
        SVProgressHUD.showWithStatus("正在加载...")
        print(AppTools.getServiceURLWithDa("GET_POINT"))
        self.sendPostRequest(AppTools.getServiceURLWithDa("GET_POINT"), parameters: parameters) { (response) in
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(locInfoModel:nil,error: NOTICE_NETWORK_ERROR)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("getPoint.dict = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                //  字典转成模型
                if success {
                    
                    let data = LocInfoModel(dict:dict["entity"].dictionaryObject!)
                    finished(locInfoModel: data, error: nil)
                }else{
                    finished(locInfoModel: nil,error: message) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                finished(locInfoModel: nil,error: "数据异常")
            }
            
        }
    }
    //获取统计数据
    func loadCpySafetyInfo(parameters:[String:AnyObject],finished: (data : SecProductModel!, error: String!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithDa("LOAD_COMPANY_SAFETYINFO"), parameters: parameters) { (response) in
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(data:nil,error: NOTICE_NETWORK_ERROR)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("loadCpySafetyInfo = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                //  字典转成模型
                if success {
                    if let data = dict["entity"].dictionaryObject{
                        let dataModel = SecProductModel(dict:data)
                        finished(data: dataModel, error: nil)
                    }
                    
                }else{
                    finished(data: nil,error: message) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                finished(data: nil,error: "数据异常")
            }
            
        }
    }
    
    func loadSafety(parameters:[String:AnyObject],finished: (data : [CheckDesModel]!, error: String!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithYh("LOAD_SAFETY"), parameters: parameters) { (response) in
            
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(data:nil,error: NOTICE_NETWORK_ERROR)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("LOAD_SAFETY = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                //  字典转成模型
                if success {
                    if let items = dict["json"].arrayObject {
                        var checkDesModels = [CheckDesModel]()
                        for item in items {
                            let homeItem = CheckDesModel(dict: item as! [String: AnyObject])
                            checkDesModels.append(homeItem)
                        }
                        finished(data: checkDesModels,error: nil)
                        
                    }
                    
                }else{
                    finished(data: nil,error: message) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                finished(data: nil,error: "数据异常")
            }
            
        }
    }

    //MARK:  处罚模块 ->加载企业信息
    func loadCompanyInfo(parameters:[String:AnyObject],finished:(data:CompanyInfoModel!,error:String!)->()){
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithYh("LOAD_COMPANY_INFO"), parameters: parameters) { (response) in
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(data:nil,error: NOTICE_NETWORK_ERROR)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("loadCompanyInfo.dict = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                //  字典转成模型
                if success {
                    let data = CompanyInfoModel(dict:dict["entity"].dictionaryObject!)
                    finished(data: data, error: nil)
                    
                }else{
                    finished(data: nil,error: message) //success  false
                }
                SVProgressHUD.dismiss()
                
            }else {
                finished(data: nil,error: "数据异常")
            }
        }
    }

    
    //MARK: - 信息查询模块 获取政策条款信息
    func getLawInfoList(parameters:[String:AnyObject],finished: (infos: [Info]!, error: String!,totalCount:Int!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithDa("GET_LAW_INFO_LIST"), parameters: parameters) { (response) in
            
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(infos:nil,error: NOTICE_NETWORK_ERROR,totalCount: nil)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("loadCompanys.dict = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                let totalCount = dict["totalCount"].intValue
                //  字典转成模型
                if success {
                    if let items = dict["json"].arrayObject {
                        var infos = [Info]()
                        for item in items {
                            let homeItem = Info(dict: item as! [String: AnyObject])
                            infos.append(homeItem)
                        }
                        finished(infos: infos,error: nil,totalCount: totalCount)
                        
                    }
                    
                }else{
                    finished(infos: nil,error: message,totalCount: nil) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                 SVProgressHUD.dismiss()
                finished(infos: nil,error: "数据异常",totalCount: nil)
            }
            
        }
    }
    
    //MARK: - 信息查询模块 获取政策条款信息
    func loadExperts(parameters:[String:AnyObject],finished: (datas: [ExpertInfoModel]!, error: String!,totalCount:Int!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithDa("LOAD_EXPERTS"), parameters: parameters) { (response) in
            
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(datas:nil,error: NOTICE_NETWORK_ERROR,totalCount: nil)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("loadExperts.dict = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                let totalCount = dict["totalCount"].intValue
                //  字典转成模型
                if success {
                    if let items = dict["json"].arrayObject {
                        var expertInfoModels = [ExpertInfoModel]()
                        for item in items {
                            let homeItem = ExpertInfoModel(dict: item as! [String: AnyObject])
                            expertInfoModels.append(homeItem)
                        }
                        finished(datas: expertInfoModels,error: nil,totalCount: totalCount)
                    }
                    
                }else{
                    finished(datas: nil,error: message,totalCount: nil) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                finished(datas: nil,error: "数据异常",totalCount: nil)
            }
            
        }
    }
    
    //MARK: - 安全检查模块 获取安全检查信息
    func loadList(parameters:[String:AnyObject],finished: (secCheckModels: [SecCheckModel]!, error: String!,totalCount:Int!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithYh("LOAD_LIST"), parameters: parameters) { (response) in
            
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(secCheckModels:nil,error: NOTICE_NETWORK_ERROR,totalCount: nil)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("loadList.dict = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                let totalCount = dict["totalCount"].intValue
                //  字典转成模型
                if success {
                    if let items = dict["json"].arrayObject {
                        var infos = [SecCheckModel]()
                        for item in items {
                            let homeItem = SecCheckModel(dict: item as! [String: AnyObject])
                            infos.append(homeItem)
                        }
                        finished(secCheckModels: infos,error: nil,totalCount: totalCount)
                        
                    }
                    
                    
                }else{
                    finished(secCheckModels: nil,error: message,totalCount: nil) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                finished(secCheckModels: nil,error: "数据异常",totalCount: nil)
            }
            
        }
    }

    
    //MARK: - 安全检查模块 更改安全检查信息
    func loadMatterList(parameters:[String:AnyObject],finished: (secCheckStateModels: [SecCheckStateModel]!, error: String!,totalCount:Int!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithYh("LOAD_MATTER_LIST"), parameters: parameters) { (response) in
            
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(secCheckStateModels:nil,error: NOTICE_NETWORK_ERROR,totalCount: nil)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("loadMatterList = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                let totalCount = dict["totalCount"].intValue
                //  字典转成模型
                if success {
                    if let items = dict["json"].arrayObject {
                        var infos = [SecCheckStateModel]()
                        for item in items {
                            let homeItem = SecCheckStateModel(dict: item as! [String: AnyObject])
                            infos.append(homeItem)
                        }
                        finished(secCheckStateModels: infos,error: nil,totalCount: totalCount)
                    }
                }else{
                    finished(secCheckStateModels: nil,error: message,totalCount: nil) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                finished(secCheckStateModels: nil,error: "数据异常",totalCount: nil)
            }
            
        }
    }
    
    //LOAD_MATTER_HISTORY_LIST
    func loadMatterHistoryList(parameters:[String:AnyObject],finished: (secCheckStateModels: [SecCheckStateModel]!, error: String!,totalCount:Int!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithYh("LOAD_MATTER_HISTORY_LIST"), parameters: parameters) { (response) in
            
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(secCheckStateModels:nil,error: NOTICE_NETWORK_ERROR,totalCount: nil)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("LOAD_MATTER_HISTORY_LIST = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                let totalCount = dict["totalCount"].intValue
                //  字典转成模型
                if success {
                    if let items = dict["json"].arrayObject {
                        var infos = [SecCheckStateModel]()
                        for item in items {
                            let homeItem = SecCheckStateModel(dict: item as! [String: AnyObject])
                            infos.append(homeItem)
                        }
                        finished(secCheckStateModels: infos,error: nil,totalCount: totalCount)
                    }
                }else{
                    finished(secCheckStateModels: nil,error: message,totalCount: nil) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                finished(secCheckStateModels: nil,error: "数据异常",totalCount: nil)
            }
            
        }
    }
    //MARK: - 安全检查模块 更改安全检查信息
    func createSafetyMatter(parameters:[String:AnyObject],finished: (id: String!, error: String!,totalCount:Int!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithYh("CREATE_SAFETY_MATTER"), parameters: parameters) { (response) in
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(id:nil,error: NOTICE_NETWORK_ERROR,totalCount: nil)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("createSafetyMatter = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                let totalCount = dict["totalCount"].intValue
                //  字典转成模型
                if success {
                let id =  dict["entity"].dictionaryObject!["id"] as? Int
                    finished(id:String(id!),error: nil,totalCount: totalCount)
                }else{
                    finished(id: nil,error: message,totalCount: nil) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                finished(id: nil,error: "数据异常",totalCount: nil)
            }
            
        }
    }
    
    //更新企业信息
    func updateCompany(parameters:[String:AnyObject],finished: (secCheckStateModels: [SecCheckStateModel]!, error: String!,totalCount:Int!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithDa("UPDATE_COMPANY"), parameters: parameters) { (response) in
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(secCheckStateModels:nil,error: NOTICE_NETWORK_ERROR,totalCount: nil)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("createSafetyMatter = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                let totalCount = dict["totalCount"].intValue
                //  字典转成模型
                if success {
                    finished(secCheckStateModels: nil,error: nil,totalCount: totalCount)
                }else{
                    finished(secCheckStateModels: nil,error: message,totalCount: nil) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                finished(secCheckStateModels: nil,error: "数据异常",totalCount: nil)
            }
            
        }
    }
    
    
    
    //MARK: - 安全检查模块  隐患整改-一般隐患
    func loadNormalDangers(parameters:[String:AnyObject],pageSize:Int!,finished: (datas: [GeneralCheckInfoModel]!, error: String!,totalCount:Int!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithYh("LOAD_NORMAL_DANGERS"), parameters: parameters) { (response) in
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(datas:nil,error: NOTICE_NETWORK_ERROR,totalCount: nil)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("loadNormalDangers = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                let totalCount = dict["totalCount"].intValue
                //  字典转成模型
                if success {
                    if let items = dict["json"].arrayObject {
                        var infos = [GeneralCheckInfoModel]()
                         var a = 0+pageSize
                        for item in items {
                            let homeItem = GeneralCheckInfoModel(dict: item as! [String: AnyObject])
                            a = a+1
                            homeItem.num = a
                            infos.append(homeItem)
                        }
                        finished(datas: infos,error: nil,totalCount: totalCount)
                    }
                }else{
                    finished(datas: nil,error: message,totalCount: nil) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                finished(datas: nil,error: "数据异常",totalCount: nil)
            }
            
        }
    }
    
    
    //MARK: - 安全检查模块  隐患整改-重大隐患
    func loadDangers(parameters:[String:AnyObject],pageSize:Int!,finished: (datas: [MajorCheckInfoModel]!, error: String!,totalCount:Int!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithYh("LOAD_DANGERS"), parameters: parameters) { (response) in
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(datas:nil,error: NOTICE_NETWORK_ERROR,totalCount: nil)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("LOAD_DANGERS = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                let totalCount = dict["totalCount"].intValue
                //  字典转成模型
                if success {
                    if let items = dict["json"].arrayObject {
                        var infos = [MajorCheckInfoModel]()
                         var a = 0+pageSize
                        for item in items {
                            let homeItem = MajorCheckInfoModel(dict: item as! [String: AnyObject])
                            a = a+1
                            homeItem.num = a
                            infos.append(homeItem)
                        }
                        finished(datas: infos,error: nil,totalCount: totalCount)
                    }
                }else{
                    finished(datas: nil,error: message,totalCount: nil) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                finished(datas: nil,error: "数据异常",totalCount: nil)
            }
            
        }
    }

    //MARK: - 安全检查模块 删除检查表
    func deleteSafetyCheck(parameters:[String:AnyObject],finished: (generalCheckInfoModel: GeneralCheckInfoModel!, error: String!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithYh("DELETE_SAFETY_CHECK"), parameters: parameters) { (response) in
            
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
               // finished(generalCheckInfoModel:nil,error: NOTICE_NETWORK_ERROR)
                return
            }
            
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("deleteSafetyCheck = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                //  字典转成模型
                if success {
                   finished(generalCheckInfoModel: nil,error: nil) //success  false
                }else{
                    finished(generalCheckInfoModel: nil,error: message) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                finished(generalCheckInfoModel: nil,error: "数据异常")
            }
            
        }
    }

    
    //MARK: - 安全检查模块 一般隐患整改 获取隐患信息
    func loadCpyNormalDanger(parameters:[String:AnyObject],finished: (generalCheckInfoModel: GeneralCheckInfoModel!, error: String!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithYh("LOAD_CPY_NORMALDANGER"), parameters: parameters) { (response) in
            
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(generalCheckInfoModel:nil,error: NOTICE_NETWORK_ERROR)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("LOAD_CPY_NORMALDANGER = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                //  字典转成模型
                if success {
                    let data = GeneralCheckInfoModel(dict:dict["entity"].dictionaryObject!)
                    finished(generalCheckInfoModel: data, error: nil)

                }else{
                    finished(generalCheckInfoModel: nil,error: message) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                finished(generalCheckInfoModel: nil,error: "数据异常")
            }
            
        }
    }
    
    //MARK: - 安全检查模块 重大隐患整改 获取隐患信息
    func loadCompanyDanger(parameters:[String:AnyObject],finished: (majorCheckInfoModel: MajorCheckInfoModel!, error: String!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithYh("LOAD_COMPANY_DANGER"), parameters: parameters) { (response) in
            
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(majorCheckInfoModel:nil,error: NOTICE_NETWORK_ERROR)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("loadCompanyDanger = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                //  字典转成模型
                if success {
                    if let data = dict["json"].dictionaryObject{
                        let dataModel = MajorCheckInfoModel(dict:data)
                         finished(majorCheckInfoModel: dataModel,error: nil)
                    }
                 
                }else{
                    finished(majorCheckInfoModel: nil,error: message) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                finished(majorCheckInfoModel: nil,error: "数据异常")
            }
            
        }
    }
    
    

    
    //提交，一般隐患记录整改
    func updateNomalDanger(parameters:[String:AnyObject],imageArrays:[UIImage],finished:(data:CheckRecordInfoModel!,error:String!)->()){
        SVProgressHUD.showWithStatus("正在加载...")
        let identify = AppTools.loadNSUserDefaultsValue("identify") as! String
        var addParameters = parameters
        addParameters["client"] = "ios"
        let key = "SAFETYS_CLIENT_AUTH_KEY_2016="+identify
        let headers = [
            "Cookie": key,
            "Accept-Language" : "zh-CN,zh;q=0.8,en;q=0.6"
        ]
        print(AppTools.getServiceURLWithYh("UPDATE_NOMAL_DANGER"))
        upload(.POST, AppTools.getServiceURLWithYh("UPDATE_NOMAL_DANGER"), headers:headers,multipartFormData: { (multipartFormData) in
            
            print("imageArrays.count = \(imageArrays.count)")
            if !imageArrays.isEmpty{
                for i in 0..<imageArrays.count{
                    let data = UIImageJPEGRepresentation(imageArrays[i] , 0.5)
                    let randomNum :Int = AppTools.createRandomMan(0, end: 100000)()
                    let imageName = String(NSDate()) + "\(randomNum).jpg"
                    print("imageName = \(imageName)")
                        multipartFormData.appendBodyPart(data: data!, name: "nomalDanger.file", fileName: imageName, mimeType: "image/jpg")
                }
            }
            
            // 这里就是绑定参数的地方 param 是需要上传的参数，我这里是封装了一个方法从外面传过来的参数，你可以根据自己的需求用NSDictionary封装一个param
            for (key, value) in parameters {
                print("key = \(key)value = \(value)")
                assert(value is String, "参数必须能够转换为NSData的类型，比如String")
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key )
                
            }
            
        }) { (encodingResult) in
            switch encodingResult {
            case .Success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    if let dictValue = response.result.value{
                        let dict = JSON(dictValue)
                        print("createCheckRecord.dict = \(dict)")
                        let success = dict["success"].boolValue
                        let message = dict["msg"].stringValue
                        //  字典转成模型
                        if success {
//                            let json =  JSON(data: (dict["entity"].string!).dataUsingEncoding(NSUTF8StringEncoding)!)
                            finished(data: nil,error: nil) //success  false
                            
                        }else{
                            finished(data: nil,error: message) //success  false
                        }
                        SVProgressHUD.dismiss()
                        
                    }else {
                        SVProgressHUD.dismiss()
                        finished(data: nil,error: "数据异常")
                    }
                    
                })
            case .Failure( _):
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(data:nil,error: NOTICE_NETWORK_ERROR)
            }
        }
    }

    //重大隐患记录修改
    func updateCompanyDanger(parameters:[String:AnyObject],imageArrays:[UIImage],finished:(data:CheckRecordInfoModel!,error:String!)->()){
        SVProgressHUD.showWithStatus("正在加载...")
        let identify = AppTools.loadNSUserDefaultsValue("identify") as! String
        var addParameters = parameters
        addParameters["client"] = "ios"
        let key = "SAFETYS_CLIENT_AUTH_KEY_2016="+identify
        let headers = [
            "Cookie": key,
            "Accept-Language" : "zh-CN,zh;q=0.8,en;q=0.6"
        ]
        
        upload(.POST, AppTools.getServiceURLWithYh("UPDATE_COMPANY_DANGER"), headers:headers,multipartFormData: { (multipartFormData) in
            
            print("imageArrays.count = \(imageArrays.count)")
            if !imageArrays.isEmpty{
                for i in 0..<imageArrays.count{
                    let data = UIImageJPEGRepresentation(imageArrays[i] , 0.5)
                    let randomNum :Int = AppTools.createRandomMan(0, end: 100000)()
                    let imageName = String(NSDate()) + "\(randomNum).jpg"
                    print("imageName = \(imageName)")
                        multipartFormData.appendBodyPart(data: data!, name: "nomalDanger.file", fileName: imageName, mimeType: "image/jpg")
                }
            }
            
            // 这里就是绑定参数的地方 param 是需要上传的参数，我这里是封装了一个方法从外面传过来的参数，你可以根据自己的需求用NSDictionary封装一个param
            for (key, value) in parameters {
                print("key = \(key)value = \(value)")
                assert(value is String, "参数必须能够转换为NSData的类型，比如String")
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key )
                
            }
            
        }) { (encodingResult) in
            switch encodingResult {
            case .Success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    //completeBlock(responseObject: response.result.value!, error: nil)
                    if let dictValue = response.result.value{
                        let dict = JSON(dictValue)
                        print("UPDATE_COMPANY_DANGER = \(dict)")
                        let success = dict["success"].boolValue
                        let message = dict["msg"].stringValue
                        //  字典转成模型
                        if success {
                            //                            let json =  JSON(data: (dict["entity"].string!).dataUsingEncoding(NSUTF8StringEncoding)!)
                            finished(data: nil,error: nil) //success  false
                            
                        }else{
                            finished(data: nil,error: message) //success  false
                        }
                        SVProgressHUD.dismiss()
                        
                    }else {
                         SVProgressHUD.dismiss()
                        finished(data: nil,error: "数据异常")
                    }
                    
                })
            case .Failure( _):
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(data:nil,error: NOTICE_NETWORK_ERROR)
            }
        }
    }
    //提交，重大隐患记录整改
    
    //MARK: - 重大隐患修改
    func creatDangerGorver(parameters:[String:AnyObject],finished:(login:Login!,error:String!)->()){
        SVProgressHUD.showWithStatus("正在加载...")
        sendPostRequest(AppTools.getServiceURLWithYh("CREATE_DANGER_GORVER"), parameters: parameters) { (response) in
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(login:nil,error: NOTICE_NETWORK_ERROR)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("CREATE_DANGER_GORVER = \(dict)")
                //let login = Login(json:dict)
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                //  字典转成模型
                if success {
                    // 接口数据有误，不应传null值过来
                    //finished(login: login, error: nil)
                    finished(login: Login(), error: nil)
                }else{
                    finished(login: nil,error: message) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                SVProgressHUD.dismiss()
                finished(login: nil,error: "数据异常")
            }
        }
        
    }
    
    //MARK: - 重大隐患记录修改
    func updateDangerGorver(parameters:[String:AnyObject],finished:(login:Login!,error:String!)->()){
        SVProgressHUD.showWithStatus("正在加载...")
        sendPostRequest(AppTools.getServiceURLWithYh("UPDATE_DANGER_GORVER"), parameters: parameters) { (response) in
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(login:nil,error: NOTICE_NETWORK_ERROR)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("creatDangerGorverInit = \(dict)")
                //let login = Login(json:dict)
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                //  字典转成模型
                if success {
                    // 接口数据有误，不应传null值过来
                    //finished(login: login, error: nil)
                    finished(login: Login(), error: nil)
                }else{
                    finished(login: nil,error: message) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                 SVProgressHUD.dismiss()
                finished(login: nil,error: "数据异常")
            }
        }
        
    }
    
        //MARK: - 修改密码
        func changePwd(parameters:[String:AnyObject],finished:(login:Login!,error:String!)->()){
            SVProgressHUD.showWithStatus("正在加载...")
            sendPostRequest(AppTools.getServiceURLWithDa("CHANGE_PASSWORD"), parameters: parameters) { (response) in
                guard response!.result.isSuccess else {
                    SVProgressHUD.showErrorWithStatus("加载失败...")
                    finished(login:nil,error: NOTICE_NETWORK_ERROR)
                    return
                }
                if let dictValue = response!.result.value{
                    let dict = JSON(dictValue)
                    print("changePwd = \(dict)")
                    //let login = Login(json:dict)
                    let success = dict["success"].boolValue
                    let message = dict["msg"].stringValue
                    //  字典转成模型
                    if success {
                        // 接口数据有误，不应传null值过来
                        //finished(login: login, error: nil)
                        finished(login: Login(), error: nil)
                    }else{
                        finished(login: nil,error: message) //success  false
                    }
                    SVProgressHUD.dismiss()
                }else {
                     SVProgressHUD.dismiss()
                    finished(login: nil,error: "数据异常")
                }
            }
            
        }
    //MARK:  获取政策条款详情
    func getArticle(parameters:[String:AnyObject],finished: (info: Info!, error: String!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithDa("GET_LAW_INFO_LIST_DETAIL"), parameters: parameters) { (response) in
            
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(info:nil,error: NOTICE_NETWORK_ERROR)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("getArticle.dict = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                //  字典转成模型
                if success {
                    if let data = dict["entity"].dictionaryObject{
                        let info = Info(dict:data)
                        finished(info: info, error: nil)
                    }
                    
                }else{
                    finished(info: nil,error: message) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                 SVProgressHUD.dismiss()
                finished(info: nil,error: "数据异常")
            }
            
        }
    }
    
    //安全检查记录
    
    func loadCheckHistoryList(parameters:[String:AnyObject],finished: (secCheckRecordModels: [SecCheckRecordModel]!, error: String!,totalCount:Int!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithYh("LOAD_CHECK_HISTORY_LIST"), parameters: parameters) { (response) in
            
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(secCheckRecordModels:nil,error: NOTICE_NETWORK_ERROR,totalCount: nil)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("loadCheckHistoryList = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                let totalCount = dict["totalCount"].intValue
                //  字典转成模型
                if success {
                    if let items = dict["json"].arrayObject {
                        var infos = [SecCheckRecordModel]()
                        for item in items {
                            let homeItem = SecCheckRecordModel(dict: item as! [String: AnyObject])
                            infos.append(homeItem)
                        }
                        finished(secCheckRecordModels: infos,error: nil,totalCount: totalCount)
                        
                    }
                    
                    
                }else{
                    finished(secCheckRecordModels: nil,error: message,totalCount: nil) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                 SVProgressHUD.dismiss()
                finished(secCheckRecordModels: nil,error: "数据异常",totalCount: nil)
            }
            
        }
    }
    
  
    //提交，新增检查记录
    func createCheckRecordImage(parameters:[String:AnyObject],imageArrays:[UIImage],finished:(data:CheckRecordInfoModel!,error:String!,noteId:String!)->()){
        SVProgressHUD.showWithStatus("正在加载...")
        let identify = AppTools.loadNSUserDefaultsValue("identify") as! String
        var addParameters = parameters
        addParameters["client"] = "ios"
        let key = "SAFETYS_CLIENT_AUTH_KEY_2016="+identify
        let headers = [
            "Cookie": key,
            "Accept-Language" : "zh-CN,zh;q=0.8,en;q=0.6"
        ]
        
        upload(.POST, AppTools.getServiceURLWithYh("CREATE_CHECK_RECORD"), headers:headers,multipartFormData: { (multipartFormData) in
            
            print("imageArrays.count = \(imageArrays.count)")
            if !imageArrays.isEmpty{
                for i in 0..<imageArrays.count{
                    let data = UIImageJPEGRepresentation(imageArrays[i] , 0.5)
                    let randomNum :Int = AppTools.createRandomMan(0, end: 100000)()
                    let imageName = String(NSDate()) + "\(randomNum).jpg"
                    print("imageName = \(imageName)")
                        multipartFormData.appendBodyPart(data: data!, name: "nomalDanger.file", fileName: imageName, mimeType: "image/jpg")
                }
            }
            
            // 这里就是绑定参数的地方 param 是需要上传的参数，我这里是封装了一个方法从外面传过来的参数，你可以根据自己的需求用NSDictionary封装一个param
            for (key, value) in parameters {
                print("key = \(key)value = \(value)")
                assert(value is String, "参数必须能够转换为NSData的类型，比如String")
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key )
                
            }
            
        }) { (encodingResult) in
            switch encodingResult {
            case .Success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    //completeBlock(responseObject: response.result.value!, error: nil)
                    if let dictValue = response.result.value{
                        let dict = JSON(dictValue)
                        print("createCheckRecord.dict = \(dict)")
                        let success = dict["success"].boolValue
                        let message = dict["msg"].stringValue
                        //  字典转成模型
                        if success {
                            let json =  JSON(data: (dict["entity"].string!).dataUsingEncoding(NSUTF8StringEncoding)!)
                            finished(data: nil,error: nil,noteId: String(json["noteId"].int!)) //success  false
                            
                        }else{
                            finished(data: nil,error: message,noteId: "") //success  false
                        }
                        SVProgressHUD.dismiss()
                        
                    }else {
                         SVProgressHUD.dismiss()
                        finished(data: nil,error: "数据异常",noteId: "")
                    }
                    
                })
            case .Failure( _):
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(data:nil,error: NOTICE_NETWORK_ERROR,noteId: "")
            }
        }
    }
    
    //提交重大隐患
    
    func createCompanyDanger(parameters:[String:AnyObject],imageArrays:[UIImage],finished:(data:CheckRecordInfoModel!,error:String!)->()){
        SVProgressHUD.showWithStatus("正在加载...")
        let identify = AppTools.loadNSUserDefaultsValue("identify") as! String
        var addParameters = parameters
        addParameters["client"] = "ios"
        let key = "SAFETYS_CLIENT_AUTH_KEY_2016="+identify
        let headers = [
            "Cookie": key,
            "Accept-Language" : "zh-CN,zh;q=0.8,en;q=0.6"
        ]
        
        upload(.POST, AppTools.getServiceURLWithYh("CREATE_COMPANY_DANGER"), headers:headers,multipartFormData: { (multipartFormData) in
            
            print("imageArrays.count = \(imageArrays.count)")
            if !imageArrays.isEmpty{
                for i in 0..<imageArrays.count{
                    let data = UIImageJPEGRepresentation(imageArrays[i] , 0.5)
                    let randomNum :Int = AppTools.createRandomMan(0, end: 100000)()
                    let imageName = String(NSDate()) + "\(randomNum).jpg"
                    print("imageName = \(imageName)")
//                    multipartFormData.appendBodyPart(data: data!, name: "file[\(i)]", fileName: imageName, mimeType: "image/jpg")
//                    multipartFormData.appendBodyPart(data: imageName.dataUsingEncoding(NSUTF8StringEncoding)!, name: "fileFileName[\(i)]" )
                        multipartFormData.appendBodyPart(data: data!, name: "danger.file", fileName: imageName, mimeType: "image/jpg")

                }
            }
            
            // 这里就是绑定参数的地方 param 是需要上传的参数，我这里是封装了一个方法从外面传过来的参数，你可以根据自己的需求用NSDictionary封装一个param
            for (key, value) in parameters {
                print("key = \(key)value = \(value)")
                assert(value is String, "参数必须能够转换为NSData的类型，比如String")
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key )
                
            }
            
        }) { (encodingResult) in
            switch encodingResult {
            case .Success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    //completeBlock(responseObject: response.result.value!, error: nil)
                    if let dictValue = response.result.value{
                        let dict = JSON(dictValue)
                        print("createDanger.dict = \(dict)")
                        let success = dict["success"].boolValue
                        let message = dict["msg"].stringValue
                        //  字典转成模型
                        if success {
                            finished(data: nil,error: nil) //success  false
                            
                        }else{
                            finished(data: nil,error: message) //success  false
                        }
                        SVProgressHUD.dismiss()
                        
                    }else {
                         SVProgressHUD.dismiss()
                        finished(data: nil,error: "数据异常")
                    }
                    
                })
            case .Failure( _):
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(data:nil,error: NOTICE_NETWORK_ERROR)
            }
        }
    }
    
    //提交一般隐患
    func creatNormalDanger(parameters:[String:AnyObject],imageArrays:[UIImage],finished:(data:CheckRecordInfoModel!,error:String!)->()){
        SVProgressHUD.showWithStatus("正在加载...")
        let identify = AppTools.loadNSUserDefaultsValue("identify") as! String
        var addParameters = parameters
        addParameters["client"] = "ios"
        let key = "SAFETYS_CLIENT_AUTH_KEY_2016="+identify
        let headers = [
            "Cookie": key,
            "Accept-Language" : "zh-CN,zh;q=0.8,en;q=0.6"
        ]
        
        upload(.POST, AppTools.getServiceURLWithYh("CREATE_NORMAL_DANGER"), headers:headers,multipartFormData: { (multipartFormData) in
            
            print("imageArrays.count = \(imageArrays.count)")
            if !imageArrays.isEmpty{
                for i in 0..<imageArrays.count{
                    let data = UIImageJPEGRepresentation(imageArrays[i] , 0.5)
                    let randomNum :Int = AppTools.createRandomMan(0, end: 100000)()
                    let imageName = String(NSDate()) + "\(randomNum).jpg"
                    print("imageName = \(imageName)")
                    multipartFormData.appendBodyPart(data: data!, name: "nomalDanger.file", fileName: imageName, mimeType: "image/jpg")
//                    multipartFormData.appendBodyPart(data: imageName.dataUsingEncoding(NSUTF8StringEncoding)!, name: "nomalDanger.file" )
                }
            }
            
            // 这里就是绑定参数的地方 param 是需要上传的参数，我这里是封装了一个方法从外面传过来的参数，你可以根据自己的需求用NSDictionary封装一个param
            for (key, value) in parameters {
                print("key = \(key)value = \(value)")
                assert(value is String, "参数必须能够转换为NSData的类型，比如String")
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key )
                
            }
            
        }) { (encodingResult) in
            switch encodingResult {
            case .Success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    //completeBlock(responseObject: response.result.value!, error: nil)
                    if let dictValue = response.result.value{
                        let dict = JSON(dictValue)
                        print("CREATE_HIDDEN_TROUBLE.dict = \(dict)")
                        let success = dict["success"].boolValue
                        let message = dict["msg"].stringValue
                        //  字典转成模型
                        if success {
                            
                            finished(data: nil,error: nil) //success  false
                            
                        }else{
                            finished(data: nil,error: message) //success  false
                        }
                        SVProgressHUD.dismiss()
                        
                    }else {
                         SVProgressHUD.dismiss()
                        finished(data: nil,error: "数据异常")
                    }
                    
                })
            case .Failure( _):
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(data:nil,error: NOTICE_NETWORK_ERROR)
            }
        }
    }

    

    func sendPostRequest(URL:String,parameters:[String:AnyObject],finished:(response:Response<AnyObject, NSError>!)->()){
        let identify = AppTools.loadNSUserDefaultsValue("identify") as! String
        var addParameters = parameters
        addParameters["client"] = "ios"
        let key = "SAFETYS_CLIENT_AUTH_KEY_2016="+identify
               let headers = [
            "Cookie": key,
            "Accept-Language" : "zh-CN,zh;q=0.8,en;q=0.6"
            ]
        //"Content-Type": "application/json;charset=UTF-8"  加上此header报type不能为空
          request(.POST, URL, parameters: addParameters, encoding: .URL, headers: headers).responseJSON(queue: dispatch_get_main_queue(), options: []){(response) in
               finished(response: response)
        }

    }
    }
