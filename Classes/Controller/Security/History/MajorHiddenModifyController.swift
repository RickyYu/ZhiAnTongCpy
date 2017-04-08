//
//  RecordHiddenNormalController.swift
//  ZhiAnTongGov
//
//  Created by Ricky on 2017/1/4.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON

class MajorHiddenModifyController: PhotoViewController {
    
     //var submitBtn = UIButton()
     var cstScrollView: UIScrollView!
    //隐患地址
    var address = ""
    //联系人
    var people = ""
    var phone  = ""
    var mobile = ""
    var hiddenDes = ""
    var plantTime = ""
    var governMoney = ""
    var chargePerson = ""
    var fillDate = ""
    var fillMan = ""
    var AreaArr = [String]()
    var firstAreaCode :String = "330500"
    var secondAreaCode :String = ""
    var thirdAreaCode :String = ""
    var customView1  = DetailCellView()
    var customView2  = DetailCellView()
    var customView3  = DetailCellView()
    var customView4  = DetailCellView()
    var customView5  = DetailCellView()
    var customView6  = DetailCellView()
    var customView7  = DetailCellView()

    var customView8  = DetailCellView()
    var customView9  = DetailCellView()
    var customView10  = DetailCellView()
    var customView11  = DetailCellView()
    var customView12  = DetailCellView()
    var customView13  = DetailCellView()
    var customView14  = DetailCellView()
    var customView15  = DetailCellView()
    var customView16  = DetailCellView()
    var customView17  = DetailCellView()
    var customView18  = DetailCellView()
    var customView19  = DetailCellView()
    var customView20  = DetailCellView()
    var customView21  = DetailCellView()
    var imageArray = [ImageInfoModel]()
    var checkInfoModel: MajorCheckInfoModel!
    var isGorover:String!
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.title = "重大隐患历史记录"
        initPage()
        getData()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignEdit(_:))))
        
    }
    
    override func resignEdit(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            customView2.textField.resignFirstResponder()
            customView4.textField.resignFirstResponder()
            customView5.textField.resignFirstResponder()
            customView6.textField.resignFirstResponder()
            customView7.textField.resignFirstResponder()
            customView17.textField.resignFirstResponder()
            customView18.textField.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    
    func getData(){
        var parameters = [String : AnyObject]()
        parameters["danger.id"] = checkInfoModel.id
        NetworkTool.sharedTools.loadCompanyDanger(parameters) { (majorCheckInfoModel, error) in
            
            if error == nil{
                self.checkInfoModel = majorCheckInfoModel
                self.setData()
            }else{
                self.showHint("\(error)", duration: 2, yOffset: 0)
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }            }
        }
    }
    
    func setData(){
        let is1 : Bool = self.checkInfoModel.emphasisProject
        if is1 {
        customView1.rightCheckBtn.selected = true
        }else{
        customView1.rightCheckBtn.selected = false
        }
        
        customView2.textField.enabled = false
        customView2.textField.enabled = false
        customView3.textField.enabled = false
        customView4.textField.enabled = false
        customView5.textField.enabled = false
        customView6.textField.enabled = false
        customView7.textField.enabled = false
        customView17.textField.enabled = false
        customView18.textField.enabled = false
        customView19.textField.enabled = false
        customView20.textField.enabled = false
        
        customView2.setRTextFieldGray(checkInfoModel.dangerAdd)
        customView3.setRRightLabelGray("湖州市"+getSecondArea(String(self.checkInfoModel.secondArea))+getThirdArea(String(self.checkInfoModel.thirdArea)))
        customView4.setRTextFieldGray(checkInfoModel.linkMan)
        customView5.setRTextFieldGray(checkInfoModel.linkTel)
        customView6.setRTextFieldGray(checkInfoModel.linkMobile)
        customView7.setRTextFieldGray(checkInfoModel.descriptions)
        customView16.setRRightLabelGray(checkInfoModel.finishDate)

        customView17.setRTextFieldGray(String(checkInfoModel.governMoney))
        customView18.setRTextFieldGray(checkInfoModel.chargePerson)
        customView19.setRRightLabelGray(checkInfoModel.fillDate)
        customView20.setRTextFieldGray(checkInfoModel.fillMan)
        self.customView21.hidden = true
        
        //增加图片
        if checkInfoModel.fileRealPath != "" {
            self.customView21.hidden = false
            self.customView21.setLineViewHidden()
            let base_path = PlistTools.loadStringValue("BASE_URL_YH")
            let image = UIImageView(frame: CGRectMake(0, 905, 100, 100))
            image.kf_setImageWithURL(NSURL(string: base_path+checkInfoModel.fileRealPath)!, placeholderImage: UIImage(named: "icon_photo_bg"))
            
            self.cstScrollView.addSubview(image)
        }
        
        
//        self.imageArray = (checkInfoModel?.imageInfos)!
//        if  imageArray.count != 0 {
//        let base_path = PlistTools.loadStringValue("BASE_URL_YH")
//        for i in 0..<self.imageArray.count{
//            let x = 70*i+5+5*i
//            let image = UIImageView(frame: CGRectMake(CGFloat(x), 335, 70, 100))
//            image.kf_setImageWithURL(NSURL(string: base_path+self.imageArray[i].path)!, placeholderImage: UIImage(named: "image_select"))
//            self.view.addSubview(image)
//        }
//        }
        
        let is9 :Bool = self.checkInfoModel.govCoordination
        let is10 :Bool = self.checkInfoModel.partStopProduct
        let is11 :Bool = self.checkInfoModel.fullStopProduct
        let is12 :Bool = self.checkInfoModel.target
        let is13 :Bool = self.checkInfoModel.resource
        let is14 :Bool = self.checkInfoModel.goods
        let is15 :Bool = self.checkInfoModel.safetyMethod
        
        
        if is9 {
            customView9.rightCheckBtn.selected = true
        }else{
            customView9.rightCheckBtn.selected = false
        }
        
        if is10 {
            customView10.rightCheckBtn.selected = true
        }else{
            customView10.rightCheckBtn.selected = false
        }
        
        if is11 {
            customView11.rightCheckBtn.selected = true
        }else{
            customView11.rightCheckBtn.selected = false
        }
        
        if is12 {
            customView12.rightCheckBtn.selected = true
        }else{
            customView12.rightCheckBtn.selected = false
        }
        
        if is13 {
            customView13.rightCheckBtn.selected = true
        }else{
            customView13.rightCheckBtn.selected = false
        }
        
        if is14 {
            customView14.rightCheckBtn.selected = true
        }else{
            customView14.rightCheckBtn.selected = false
        }
        
        if is15 {
            customView15.rightCheckBtn.selected = true
        }else{
            customView15.rightCheckBtn.selected = false
        }

    
    }

    func initPage(){
        
        
        cstScrollView = UIScrollView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 1000))
       // ScrollView!.pagingEnabled = true
        cstScrollView!.scrollEnabled = true
        cstScrollView!.showsHorizontalScrollIndicator = true
        cstScrollView!.showsVerticalScrollIndicator = false
        cstScrollView!.scrollsToTop = true
        cstScrollView!.contentSize = CGSizeMake(SCREEN_WIDTH, 1000)
        
        
        customView1 = DetailCellView(frame:CGRectMake(0, 0, SCREEN_WIDTH, 45))
        customView1.backgroundColor = UIColor.whiteColor()
        customView1.setLabelName("市级以上重点企业：")
        customView1.setLabelMax()
        customView1.setRCheckBtn()
        customView1.rightCheckBtn.addTarget(self, action:#selector(tapped1(_:)), forControlEvents:.TouchUpInside)
        
         customView2 = DetailCellView(frame:CGRectMake(0, 45, SCREEN_WIDTH, 45))
        customView2.setLabelName("隐患地址：")
        customView2.setRTextField( "")
        
         customView3 = DetailCellView(frame:CGRectMake(0, 90, SCREEN_WIDTH, 45))
        customView3.setLabelName("隐患区域：")
        customView3.setRRightLabel("")
        AreaArr = ["湖州", "长兴县", "画溪街道"]
        customView3.addOnClickListener(self, action: #selector(self.ChoiceArea))
        
        
        
         customView4 = DetailCellView(frame:CGRectMake(0, 135, SCREEN_WIDTH, 45))
        customView4.setLabelName("联系人：")
        customView4.setRTextField( "")
        
        
        customView5 = DetailCellView(frame:CGRectMake(0, 180, SCREEN_WIDTH, 45))
        customView5.setLabelName("联系电话：")
        customView5.setRTextField( "")
        
        
        customView6 = DetailCellView(frame:CGRectMake(0, 225, SCREEN_WIDTH, 45))
        customView6.setLabelName("手机:")
        customView6.setRTextField( "")
        
        
        customView7 = DetailCellView(frame:CGRectMake(0, 270, SCREEN_WIDTH, 45))
        customView7.setLabelName("隐患基本情况：")
        customView7.setRTextField( "") //ImagesInfo 字段
        
        customView8 = DetailCellView(frame:CGRectMake(0, 315, SCREEN_WIDTH, 45))
        customView8.setLabelName("")
        customView8.setRCenterLabel("")
        
        customView9 = DetailCellView(frame:CGRectMake(0, 360, SCREEN_WIDTH, 45))
        customView9.setLabelName("是否需要政府协调：")
        customView9.setRCheckBtn()
        customView9.setLabelMax()
        customView9.rightCheckBtn.addTarget(self, action:#selector(tapped2(_:)), forControlEvents:.TouchUpInside)
        
        customView10 = DetailCellView(frame:CGRectMake(0, 405, SCREEN_WIDTH, 45))
        customView10.setLabelName("是否需要局部停产停业：")
        customView10.setRCheckBtn()
        customView10.setLabelMax()
        customView10.rightCheckBtn.addTarget(self, action:#selector(tapped3(_:)), forControlEvents:.TouchUpInside)
        
        customView11 = DetailCellView(frame:CGRectMake(0, 415, SCREEN_WIDTH, 45))
        customView11.setLabelName("是否需要全部停产停业：")
        customView11.setRCheckBtn()
        customView11.setLabelMax()
        customView11.rightCheckBtn.addTarget(self, action:#selector(tapped4(_:)), forControlEvents:.TouchUpInside)
        
        customView12 = DetailCellView(frame:CGRectMake(0, 460, SCREEN_WIDTH, 45))
        customView12.setLabelName("落实治理目标：")
        customView12.setRCheckBtn()
        customView12.setLabelMax()
        customView12.rightCheckBtn.addTarget(self, action:#selector(tapped5(_:)), forControlEvents:.TouchUpInside)
        
        customView13 = DetailCellView(frame:CGRectMake(0, 505, SCREEN_WIDTH, 45))
        customView13.setLabelName("落实治理机构人员：")
        customView13.setRCheckBtn()
        customView13.setLabelMax()
        customView13.rightCheckBtn.addTarget(self, action:#selector(tapped6(_:)), forControlEvents:.TouchUpInside)
        
        customView14 = DetailCellView(frame:CGRectMake(0, 550, SCREEN_WIDTH, 45))
        customView14.setLabelName("落实安全促使及应急预案：")
        customView14.setRCheckBtn()
        customView14.setLabelMax()
        customView14.rightCheckBtn.addTarget(self, action:#selector(tapped7(_:)), forControlEvents:.TouchUpInside)
        
       customView15 = DetailCellView(frame:CGRectMake(0, 595, SCREEN_WIDTH, 45))
        customView15.setLabelName("落实治理经费物资：")
        customView15.setRCheckBtn()
        customView15.setLabelMax()
        customView15.rightCheckBtn.addTarget(self, action:#selector(Tapped8(_:)), forControlEvents:.TouchUpInside)
        
        customView16 = DetailCellView(frame:CGRectMake(0, 640, SCREEN_WIDTH, 45))
        customView16.setLabelName("计划完成治理时间：")
        customView16.setRRightLabel("")
        customView16.setTimeImg()
        customView16.setLabelMax()
        customView16.addOnClickListener(self, action: #selector(self.ChoicePlanTimes))
        
        customView17 = DetailCellView(frame:CGRectMake(0, 685, SCREEN_WIDTH, 45))
        customView17.setLabelName("落实治理经费:(单位:万)")
        customView17.setLabelMax()
        customView17.setRCenterTextField( "")
        
        customView18 = DetailCellView(frame:CGRectMake(0, 730, SCREEN_WIDTH, 45))
        customView18.setLabelName("单位负责人：")
        customView18.setRTextField( "")
        
        
        customView19 = DetailCellView(frame:CGRectMake(0, 775, SCREEN_WIDTH, 45))
        customView19.setLabelName("录入时间：")
        getSystemTime { (time) in
            self.customView19.setRRightLabel(time)
        }
        customView19.setTimeImg()
        
        customView20 = DetailCellView(frame:CGRectMake(0, 820, SCREEN_WIDTH, 45))
        customView20.setLabelName("填报人：")
        customView20.setRTextField( "")
        
        customView21 = DetailCellView(frame:CGRectMake(0, 865, SCREEN_WIDTH, 45))
        customView21.setLabelName("现场图片：")
        customView21.setRCenterLabel("")
        // customView21.addOnClickListener(self, action: #selector(self.ChoiceImage))
        
      //  initPhoto()
        
        
        
        
        
        
        self.cstScrollView.addSubview(customView1)
        self.cstScrollView.addSubview(customView2)
        self.cstScrollView.addSubview(customView3)
        self.cstScrollView.addSubview(customView4)
        self.cstScrollView.addSubview(customView5)
        self.cstScrollView.addSubview(customView6)
        self.cstScrollView.addSubview(customView7)
        self.cstScrollView.addSubview(customView8)
        self.cstScrollView.addSubview(customView9)
        self.cstScrollView.addSubview(customView10)
        self.cstScrollView.addSubview(customView11)

        self.cstScrollView.addSubview(customView12)
        self.cstScrollView.addSubview(customView13)
        self.cstScrollView.addSubview(customView14)
        self.cstScrollView.addSubview(customView15)
        self.cstScrollView.addSubview(customView16)
        self.cstScrollView.addSubview(customView17)
        self.cstScrollView.addSubview(customView18)
        self.cstScrollView.addSubview(customView19)
        self.cstScrollView.addSubview(customView20)
        self.cstScrollView.addSubview(customView21)
        
//        self.view.addSubview(submitBtn)
        self.view.addSubview(cstScrollView)
//        submitBtn.snp_makeConstraints { make in
//            make.bottom.equalTo(self.view.snp_bottom).offset(-15)
//            make.left.equalTo(self.view.snp_left).offset(50)
//            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-100, 35))
//        }
//        submitBtn.hidden = true
        
        cstScrollView.snp_makeConstraints { make in
            make.top.equalTo(self.view.snp_top).offset(64)
            make.left.equalTo(self.view.snp_left)
            make.bottom.equalTo(self.view.snp_bottom)
            make.right.equalTo(self.view.snp_right)
        }
        
        customView1.snp_makeConstraints { make in
            make.top.equalTo(self.cstScrollView.snp_top)
            make.left.equalTo(self.cstScrollView.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
        
        customView2.snp_makeConstraints { make in
            make.top.equalTo(customView1.snp_bottom)
            make.left.equalTo(self.cstScrollView.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
        
        customView3.snp_makeConstraints { make in
            make.top.equalTo(customView2.snp_bottom)
            make.left.equalTo(self.cstScrollView.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
        
        customView4.snp_makeConstraints { make in
            make.top.equalTo(customView3.snp_bottom)
            make.left.equalTo(self.cstScrollView.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
        
        customView5.snp_makeConstraints { make in
            make.top.equalTo(customView4.snp_bottom)
            make.left.equalTo(self.cstScrollView.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
        
        customView6.snp_makeConstraints { make in
            make.top.equalTo(customView5.snp_bottom)
            make.left.equalTo(self.cstScrollView.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
        
        customView7.snp_makeConstraints { make in
            make.top.equalTo(customView6.snp_bottom)
            make.left.equalTo(self.cstScrollView.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
        
//        customView8.snp_makeConstraints { make in
//            make.top.equalTo(customView7.snp_bottom)
//            make.left.equalTo(self.scrollView.snp_left)
//            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
//        }
        
        customView9.snp_makeConstraints { make in
            make.top.equalTo(customView7.snp_bottom)
            make.left.equalTo(self.cstScrollView.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
        
        customView10.snp_makeConstraints { make in
            make.top.equalTo(customView8.snp_bottom)
            make.left.equalTo(self.cstScrollView.snp_left)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-30, 45))
        }
    
    }
    
    func ChoiceImage(){
        customView21.setLineViewHidden()
        containerView.hidden = false
    }
    
    func initPhoto(){
        setLoc(0, y: 910)
        var listImageFile = [UIImage]()
        listImageFile = getListImage()
        listImageFile.removeAll()
        checkNeedAddButton()
        renderView()
        self.cstScrollView.addSubview(containerView)
        containerView.hidden = true
    }
    
    func ChoicePlanTimes(){
        choiceTime { (time) in
            self.customView16.setRRightLabel(time)
            self.customView16.becomeFirstResponder()
        }
        
    }

    func ChoiceArea(){
        getChoiceArea(AreaArr) { (area,areaArr) in
            self.secondAreaCode =  getSecondArea(areaArr[1])
            self.thirdAreaCode = getThirdArea(areaArr[2])
            self.customView3.setRRightLabel(area)
        }
    }
    
    
    //市级以上重点企业
    var isMagorCpy = false
    func tapped1(button:UIButton){
        button.selected = !button.selected
        if button.selected{
            isMagorCpy = true
        }else{
            isMagorCpy = false
            
        }
        
    }
    //是否需要政府协调
    var is2 = false
    func tapped2(button:UIButton){
        button.selected = !button.selected
        if button.selected{
            is2 = true
            print("tapped1+\(button.selected)")
        }else{
            is2 = false
            print("tapped1+\(button.selected)")
            
        }
        
    }
    //是否需局部停产停业
    var is3 = false
    func tapped3(button:UIButton){
        button.selected = !button.selected
        if button.selected{
            is3 = true
        }else{
            is3 = false
        }
        
    }
    //是否需全部停产停业
    var is4 = false
    func tapped4(button:UIButton){
        button.selected = !button.selected
        if button.selected{
            is4 = true
        }else{
            is4 = false
        }
        
    }
    
    //落实治理目标
    var is5 = false
    func tapped5(button:UIButton){
        button.selected = !button.selected
        if button.selected{
            is5 = true
        }else{
            is5 = false
        }
        
    }
    //落实治理机构人员
    var is6 = false
    func tapped6(button:UIButton){
        button.selected = !button.selected
        if button.selected{
            is6 = true
        }else{
            is6 = false
        }
    }
    //落实安全促使及应急预案
    var is7 = false
    func tapped7(button:UIButton){
        button.selected = !button.selected
        if button.selected{
            is7 = true
        }else{
            is7 = false
        }
    }
    //落实治理经费物资
    var is8 = false
    func Tapped8(button:UIButton){
        button.selected = !button.selected
        if button.selected{
            is8 = true
        }else{
            is8 = false
        }
    }
    

    
    func submit(){
        var parameters = [String : AnyObject]()
        parameters["deletePhoto"] = "0"
                parameters["danger.hzCompany.id"] = AppTools.loadNSUserDefaultsValue("companyId") as! String
                parameters["danger.id"] = String(checkInfoModel.id)
                //市级以上重点企业
                parameters["danger.emphasisProject"] = String(isMagorCpy)
                //隐患地址
                parameters["danger.dangerAdd"] = address
                //隐患区域三级
                parameters["danger.firstArea"] = firstAreaCode
                parameters["danger.secondArea"] = secondAreaCode
                parameters["danger.thirdArea"] = thirdAreaCode
                //联系人
                parameters["danger.linkMan"] = people
                parameters["danger.linkTel"] = phone
                parameters["danger.linkMobile"] = mobile
                parameters["danger.description"] = hiddenDes
        
                parameters["danger.govCoordination"] = String(is2)
                parameters["danger.partStopProduct"] = String(is3)
                parameters["danger.fullStopProduct"] = String(is4)
                parameters["danger.target"] = String(is5)
                parameters["danger.resource"] = String(is6)
                parameters["danger.safetyMethod"] = String(is7)
                parameters["danger.goods"] = String(is8)
        
        
                parameters["danger.finishDate"] = plantTime
                parameters["danger.governMoney"] = governMoney
                
                parameters["danger.chargePerson"] = chargePerson
                parameters["danger.fillDate"] = fillDate
                parameters["danger.fillMan"] = fillMan
        
        NetworkTool.sharedTools.updateCompanyDanger(parameters,imageArrays: getListImage()) { (data, error) in
            if error == nil{
                self.showHint("修改成功", duration: 1, yOffset: 0)
                let viewController = self.navigationController?.viewControllers[0] as! SecurityCheckController
                // viewController.isRefresh = true
                self.navigationController?.popToViewController(viewController , animated: true)
                
                
            }else{
                self.showHint("\(error!)", duration: 2, yOffset: 0)
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }            }
        }
        
        
    }
    
     func submitCheck(){
        address = customView2.textField.text!
        if AppTools.isEmpty(address) {
            alert("隐患地址不可为空", handler: {
                self.customView2.textField.becomeFirstResponder()
            })
            return
        }
        people = customView4.textField.text!
        if AppTools.isEmpty(people) {
            alert("联系人不可为空", handler: {
                self.customView4.textField.becomeFirstResponder()
            })
            return
        }
        phone = customView5.textField.text!
        if AppTools.isEmpty(phone) {
            alert("联系电话不可为空", handler: {
                self.customView5.textField.becomeFirstResponder()
            })
            return
        }
        
        mobile = customView6.textField.text!
        if AppTools.isEmpty(mobile) {
            alert("手机不可为空", handler: {
                self.customView6.textField.becomeFirstResponder()
            })
            return
        }
        hiddenDes = customView7.textField.text!
        if AppTools.isEmpty(hiddenDes) {
            alert("隐患基本情况不可为空", handler: {
                self.customView7.textField.becomeFirstResponder()
            })
            return
        }
        
        plantTime = customView16.rightLabel.text!
        if AppTools.isEmpty(plantTime) {
            alert("计划完成治理时间不可为空", handler: {
                self.customView7.textField.becomeFirstResponder()
            })
            return
        }
        
        
        governMoney = customView17.textField.text!
        if AppTools.isEmpty(governMoney) {
            alert("治理经费不可为空", handler: {
                self.customView17.textField.becomeFirstResponder()
            })
            return
        }
        
        chargePerson = customView18.textField.text!
        if AppTools.isEmpty(chargePerson) {
            alert("单位负责人不可为空", handler: {
                self.customView18.textField.becomeFirstResponder()
            })
            return
        }
        fillDate = customView19.rightLabel.text!
        if AppTools.isEmpty(fillDate) {
            alert("录入时间不可为空", handler: {
                
            })
            return
        }
        
        fillMan = customView20.textField.text!
        if AppTools.isEmpty(fillMan) {
            alert("填报人不可为空", handler: {
                
            })
            return
        }
        
        
        alertNotice("提示", message: "确认提交后，本次检查信息及隐患无法再更改") {
            self.submit()
        }
    }

}
