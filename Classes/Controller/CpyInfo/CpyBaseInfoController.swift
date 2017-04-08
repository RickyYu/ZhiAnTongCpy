//
//  CpyBaseInfoController.swift
//  ZhiAnTongCpy
//
//  Created by Ricky on 2017/2/17.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON
import UsefulPickerView

class CpyBaseInfoController: BaseViewController,NSXMLParserDelegate {
    var customView1  = DetailSecViewCell()
    var customView2  = DetailSecViewCell()
    var customView3  = DetailSecViewCell()
    var customView4  = DetailSecViewCell()
    var customView5  = DetailSecViewCell()
    var customView6  = DetailSecViewCell()
    var customView7  = DetailSecViewCell()
    var customView8  = DetailSecViewCell()
    var customView9  = DetailSecViewCell()
    var customView10  = DetailSecViewCell()
    var customView11  = DetailSecViewCell()
    var customView12  = DetailSecViewCell()
    var submitBtn = UIButton()
    var scrollView: UIScrollView!

    var  cpyInfoModal = CompanyInfoModel()
    let singleData = ["规上企业", "规下企业", "小微企业"]
    let economyData = ["01国有经济", "02集体经济", "03私营经济","04有限责任公司","05联营经济","06股份合作","07外商投资","08港澳台投资","09其它经济","10股份有限公司"]
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        InitPage()
        getCpyInfo()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignEdit(_:))))
        
    }
    
    override func resignEdit(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            customView9.textField.resignFirstResponder()
            customView10.textField.resignFirstResponder()
           
        }
        sender.cancelsTouchesInView = false
    }
    
    func getCpyInfo(){
        let parameters = [String : AnyObject]()
        NetworkTool.sharedTools.loadCompanyInfo(parameters) { (data, error) in
            if error == nil{
                self.cpyInfoModal = data
                self.setData()
            }else{
                self.showHint("\(error)", duration: 2, yOffset: 0)
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }
            }
            
            
        }
    }
    func InitPage(){
        scrollView = UIScrollView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 550))
        //scrollView!.pagingEnabled = true
        scrollView!.scrollEnabled = true
        scrollView!.showsHorizontalScrollIndicator = true
        scrollView!.showsVerticalScrollIndicator = false
        scrollView!.scrollsToTop = true
        scrollView!.contentSize = CGSizeMake(SCREEN_WIDTH, 550)
        
        submitBtn.frame = CGRectMake(50, 370,SCREEN_WIDTH-100, 35)
        submitBtn.setTitle("提交", forState:.Normal)
        submitBtn.backgroundColor = YMGlobalDeapBlueColor()
        submitBtn.setTitleColor(UIColor.greenColor(), forState: .Highlighted) //触摸状态下文字的颜色
        submitBtn.addTarget(self, action: #selector(self.submit), forControlEvents: UIControlEvents.TouchUpInside)
        
        customView1 = DetailSecViewCell(frame:CGRectMake(0, 0, SCREEN_WIDTH, 30))
        customView1.setLabelColorName("单位名称：")
        
        customView2 = DetailSecViewCell(frame:CGRectMake(0, 30, SCREEN_WIDTH, 30))
        customView2.setLabelColorName("单位地址：")
        
        
        customView3 = DetailSecViewCell(frame:CGRectMake(0, 60, SCREEN_WIDTH, 30))
        customView3.setLabelColorName("所属区域：")
        
        
        customView4 = DetailSecViewCell(frame:CGRectMake(0, 90, SCREEN_WIDTH, 30))
        customView4.setLabelColorName("工商注册号:")
        
        
        customView5 = DetailSecViewCell(frame:CGRectMake(0, 120, SCREEN_WIDTH, 30))
        customView5.setLabelColorName("行业分类：")
        
        
        customView6 = DetailSecViewCell(frame:CGRectMake(0, 150, SCREEN_WIDTH, 30))
        customView6.setLabelColorName("所属行业大类：")
        
        
        customView7 = DetailSecViewCell(frame:CGRectMake(0, 180, SCREEN_WIDTH, 30))
        customView7.setLabelColorName("所属行业中类：")
        
        customView8 = DetailSecViewCell(frame:CGRectMake(0, 210, SCREEN_WIDTH, 30))
        customView8.setLabelColorName("所属行业小类：")
        
        customView9 = DetailSecViewCell(frame:CGRectMake(0, 240, SCREEN_WIDTH, 30))
        customView9.setLabelColorName("法定代表人：")
        //customView9.textField.becomeFirstResponder()
        
        customView10 = DetailSecViewCell(frame:CGRectMake(0, 270, SCREEN_WIDTH, 30))
        customView10.setLabelColorName("联系电话：")
        
        customView11 = DetailSecViewCell(frame:CGRectMake(0, 300, SCREEN_WIDTH, 30))
        customView11.setLabelColorName("经济类型：")
        customView11.addOnClickListener(self, action: #selector(self.choiceEconomyType))
        customView12 = DetailSecViewCell(frame:CGRectMake(0, 330, SCREEN_WIDTH, 30))
        
        customView12.setLabelColorName("规模情况：")
        customView12.addOnClickListener(self, action: #selector(self.choiceCpyType))
        
        self.scrollView.addSubview(customView1)
        self.scrollView.addSubview(customView2)
        self.scrollView.addSubview(customView3)
        self.scrollView.addSubview(customView4)
        self.scrollView.addSubview(customView5)
        self.scrollView.addSubview(customView6)
        self.scrollView.addSubview(customView7)
        self.scrollView.addSubview(customView8)
        self.scrollView.addSubview(customView9)
        self.scrollView.addSubview(customView10)
        self.scrollView.addSubview(customView11)
        self.scrollView.addSubview(customView12)
        self.scrollView.addSubview(submitBtn)
        self.view.addSubview(scrollView)
        

        
    }
    

    func setData(){
        
        let parse:NSXMLParser = NSXMLParser(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("huzhou_enum", ofType: "xml")!))!
        parse.delegate = self
        // 开始解析
        parse.parse()
        
        customView1.setRLeftLabel(cpyInfoModal.companyName)
        customView2.setRLeftLabel(cpyInfoModal.address)
        let address = "湖州市"+getSecondArea(String(cpyInfoModal.secondArea))+""+getThirdArea(String(cpyInfoModal.thirdArea))
        customView3.setRLeftLabel(address)
        customView4.setRLeftLabel(cpyInfoModal.businessRegNumber)
        customView5.setRLeftLabel(cpyInfoModal.tradeTypes)
        customView9.setRTextField(cpyInfoModal.fdDelegate)
        customView10.setRTextField(cpyInfoModal.phone)
     
        customView11.setRRightLabelImg(getEconomyType(cpyInfoModal.economyKind))
        
        customView12.setRRightLabelImg(getCpyType(cpyInfoModal.isEnterprise))
    
    }
    
    
    // 监听解析节点的属性
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        // 保存当前的解析到的节点名称
        //  self.currentNodeName = elementName
        if(elementName == cpyInfoModal.tradeType){
            customView6.setRLeftLabel(attributeDict["name"]!)
        }
        if(elementName == cpyInfoModal.tradeBig){
            customView7.setRLeftLabel(attributeDict["name"]!)
        }
        if(elementName == cpyInfoModal.tradeMid){
            customView8.setRLeftLabel(attributeDict["name"]!)
        }
        
    }
    func choiceCpyType(){
        
        UsefulPickerView.showSingleColPicker("请选择", data: singleData, defaultSelectedIndex: 1) {[unowned self] (selectedIndex, selectedValue) in
            self.customView12.setRRightLabelImg(selectedValue)
        }
        
    }
    
    
    func choiceEconomyType(){
        UsefulPickerView.showSingleColPicker("请选择", data: economyData, defaultSelectedIndex: 2) {[unowned self] (selectedIndex, selectedValue) in
            self.customView11.setRRightLabelImg(selectedValue)
        }
        
    }

    
    func submit(){
        var parameters = [String : AnyObject]()
        parameters["company.id"] = cpyInfoModal.id
        parameters["company.companyName"] = cpyInfoModal.companyName
        parameters["company.address"] = cpyInfoModal.address
        parameters["company.businessRegNumber"] = cpyInfoModal.businessRegNumber
        parameters["company.firstArea"] = cpyInfoModal.firstArea
        parameters["company.secondArea"] = cpyInfoModal.secondArea
        parameters["company.thirdArea"] = cpyInfoModal.thirdArea
        parameters["company.fdDelegate"] = customView9.textField.text
        parameters["company.phone"] = customView10.textField.text
        parameters["company.economyKind"] = getEconomyType(customView11.label.text!)
        parameters["company.isEnterprise"] = getCpyType(customView12.label.text!)
//        if AppTools.isExisNSUserDefaultsKey("lng")||AppTools.isExisNSUserDefaultsKey("lat"){
//            parameters["point.x"] = AppTools.loadNSUserDefaultsValue("lng") as! String
//            parameters["point.y"] = AppTools.loadNSUserDefaultsValue("lat") as! String
//            
//            print(AppTools.loadNSUserDefaultsValue("lng") as! String)
//             print(AppTools.loadNSUserDefaultsValue("lat") as! String)
//        }
        

        NetworkTool.sharedTools.updateCompany(parameters) { (datas, error,totalCount) in
            
            if error == nil{
                self.showHint("修改成功", duration: 2, yOffset: 0)
             
            }else{
                self.showHint("\(error)", duration: 2, yOffset: 0)
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }
                
            }
        }

    }

}
