//
//  MajorHiddenDetailController.swift
//  ZhiAnTongCpy
//
//  Created by Ricky on 2017/2/9.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//


import UIKit
import SnapKit
import SwiftyJSON
import UsefulPickerView

class MajorHiddenDetailController: SinglePhotoViewController {
    
    var customView1  = DetailCellView()
    var customView2  = DetailCellView()
    var customView3  = DetailCellView()
    var customView4  = DetailCellView()
    var customView8  = DetailCellView()
    var customView9  = DetailCellView()
    var customView10  = DetailCellView()
    var customView11  = DetailCellView()
    var customView12  = DetailCellView()
    var customView13  = DetailCellView()
    var customView14  = DetailCellView()
    var submitBtn = UIButton()
    var cstScrollView: UIScrollView!
    var normalDangerId:String!
    var majorCheckInfoModel:MajorCheckInfoModel!
    var isGorover:String!
    
    override func viewDidLoad() {
        setNavagation("")
        if isGorover == "1"{
            self.title = "重大隐患整改历史记录"
            self.initZgPage()
        }else{
            getData()
        }
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignEdit(_:))))
    }
    
    override func resignEdit(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            customView1.textField.resignFirstResponder()
            customView2.textField.resignFirstResponder()
            customView3.textField.resignFirstResponder()
            customView4.textView.resignFirstResponder()
            customView10.textField.resignFirstResponder()
            customView11.textField.resignFirstResponder()
            customView13.textView.resignFirstResponder()
           
        }
        sender.cancelsTouchesInView = false
    }
    

    func getData(){
        var parameters = [String : AnyObject]()
        parameters["danger.id"] = majorCheckInfoModel.id
        NetworkTool.sharedTools.loadCompanyDanger(parameters) { (majorCheckInfoModel, error) in
            
            if error == nil{
                self.majorCheckInfoModel = majorCheckInfoModel
                let isGov:Bool = majorCheckInfoModel.gov
                if isGov {
                    self.title = "重大隐患查看"
                    self.showHint("政府端录入隐患不能整改", duration: 1, yOffset: 0)
                    self.initViewPage()
                    return
                }else{
                    self.title = "重大隐患整改"
                    //初始化整改页面
                    self.initZgPage()
                    self.setZgData()
                }
            }else{
                self.showHint("\(error)", duration: 2, yOffset: 0)
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()                }
            }
        }
    }
    

  
    func initViewPage(){
        cstScrollView = UIScrollView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 700))
        //scrollView!.pagingEnabled = true
        cstScrollView!.scrollEnabled = true
        cstScrollView!.showsHorizontalScrollIndicator = true
        cstScrollView!.showsVerticalScrollIndicator = false
        cstScrollView!.scrollsToTop = true
        cstScrollView!.contentSize = CGSizeMake(SCREEN_WIDTH, 700)
        customView1 = DetailCellView(frame:CGRectMake(0, 0, SCREEN_WIDTH, 45))
        customView1.setLabelName("联系人：")
        customView1.setRTextFieldGray(majorCheckInfoModel.linkMan)
        customView1.textField.addTarget(self, action: #selector(self.textDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        customView2 = DetailCellView(frame:CGRectMake(0, 45, SCREEN_WIDTH, 45))
        customView2.setLabelName("联系电话：")
        customView2.setRTextFieldGray(majorCheckInfoModel.linkTel)
        customView2.textField.addTarget(self, action: #selector(self.textDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        customView3 = DetailCellView(frame:CGRectMake(0, 90, SCREEN_WIDTH, 45))
        customView3.setLabelName("手机：")
        customView3.setRTextFieldGray(majorCheckInfoModel.linkMobile)
        customView3.textField.addTarget(self, action: #selector(self.textDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        customView4 = DetailCellView(frame:CGRectMake(0, 135, SCREEN_WIDTH, 45))
        customView4.setLabelName("隐患治理情况:")
        customView4.setMinTextViewShow()
        customView4.setRTextViewGray(majorCheckInfoModel.descriptions)

        
        customView10 = DetailCellView(frame:CGRectMake(0, 180, SCREEN_WIDTH, 45))
        customView10.setLabelName("单位负责人:")
        customView10.setRTextFieldGray(majorCheckInfoModel.chargePerson)
        customView10.textField.addTarget(self, action: #selector(self.textDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
      
        customView11 = DetailCellView(frame:CGRectMake(0, 225, SCREEN_WIDTH, 45))
        customView11.setLabelName("填表人:")
        customView11.setRTextFieldGray(majorCheckInfoModel.fillMan)
          customView11.textField.addTarget(self, action: #selector(self.textDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        customView13 = DetailCellView(frame:CGRectMake(0, 270, SCREEN_WIDTH, 145))
        customView13.setLabelName("备注：")
        customView13.setTextViewShow()
        
        customView1.textField.enabled = false
        customView2.textField.enabled = false
        customView3.textField.enabled = false
        customView4.textView.editable = false
        customView10.textField.enabled = false
        customView11.textField.enabled = false
        customView13.textView.editable = false
        
        self.cstScrollView.addSubview(customView1)
        self.cstScrollView.addSubview(customView2)
        self.cstScrollView.addSubview(customView3)
        self.cstScrollView.addSubview(customView4)
        self.cstScrollView.addSubview(customView10)
        self.cstScrollView.addSubview(customView11)
        self.cstScrollView.addSubview(customView13)
        self.view.addSubview(cstScrollView)
        
        cstScrollView.snp_makeConstraints { make in
            make.top.equalTo(self.view.snp_top).offset(64)
            make.left.equalTo(self.view.snp_left)
            make.bottom.equalTo(self.view.snp_bottom).offset(-5)
            make.right.equalTo(self.view.snp_right)
        }

    }
    
    func setZgData(){
        //true 为政府
        let isGov :Bool = majorCheckInfoModel.gov
        if isGov {
           submitBtn.hidden = true
            
             customView1.textField.enabled = false
            customView2.textField.enabled = false
            customView3.textField.enabled = false
            customView4.textView.editable = false
            customView10.textField.enabled = false
            customView11.textField.enabled = false
           
            
            
            customView1.setRTextFieldGray(majorCheckInfoModel.linkMan)
            customView2.setRTextFieldGray(majorCheckInfoModel.linkTel)
            customView8.setRRightLabelGray(majorCheckInfoModel.finishDate)
            customView3.setRTextFieldGray(majorCheckInfoModel.linkMobile)
            customView4.setRTextViewGray(majorCheckInfoModel.descriptions)
            customView10.setRTextFieldGray(majorCheckInfoModel.chargePerson)
            customView12.setRRightLabelGray(majorCheckInfoModel.modifyTime)
            customView11.setRTextFieldGray(majorCheckInfoModel.fillMan)

        }else {
            submitBtn.hidden = false
            customView1.setRTextField(majorCheckInfoModel.linkMan)
            customView2.setRTextField(majorCheckInfoModel.linkTel)
            customView8.setRRightLabel(majorCheckInfoModel.finishDate)
            customView3.setRTextField(majorCheckInfoModel.linkMobile)
            customView4.setRTextView(majorCheckInfoModel.descriptions)
            customView9.setRTextField(String(format: "%.2f",majorCheckInfoModel.governMoney))
            customView10.setRTextField(majorCheckInfoModel.chargePerson)
            customView12.setRRightLabel(majorCheckInfoModel.modifyTime)
            customView11.setRTextField(majorCheckInfoModel.fillMan)
            if majorCheckInfoModel.fileRealPath != "" {
                self.customView9.hidden = false
                self.customView9.setLineViewHidden()
                let base_path = PlistTools.loadStringValue("BASE_URL_YH")
                let imageView = UIImageView()
                
                imageView.kf_setImageWithURL(NSURL(string: base_path+majorCheckInfoModel.fileRealPath)!, placeholderImage: UIImage(named: "icon_photo_bg"), optionsInfo: nil, progressBlock: { (receivedSize, totalSize) in
                    
                    }, completionHandler: { (image, error, cacheType, imageURL) in
                        self.addImageView(imageView)
                })
            }
        }

    }
    
    func initZgPage(){
        cstScrollView = UIScrollView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
        //scrollView!.pagingEnabled = true
        cstScrollView!.scrollEnabled = true
        cstScrollView!.showsHorizontalScrollIndicator = true
        cstScrollView!.showsVerticalScrollIndicator = false
        cstScrollView!.scrollsToTop = true
        cstScrollView!.contentSize = CGSizeMake(SCREEN_WIDTH, 825)
        
        submitBtn.setTitle("提交", forState:.Normal)
        submitBtn.backgroundColor = YMGlobalDeapBlueColor()
        submitBtn.setTitleColor(UIColor.greenColor(), forState: .Highlighted) //触摸状态下文字的颜色
        submitBtn.addTarget(self, action: #selector(self.submit), forControlEvents: UIControlEvents.TouchUpInside)
      
        
        customView1 = DetailCellView(frame:CGRectMake(0, 0, SCREEN_WIDTH, 45))
        customView1.setLabelName("联系人：")
        customView1.textField.addTarget(self, action: #selector(self.textDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        
        customView2 = DetailCellView(frame:CGRectMake(0, 45, SCREEN_WIDTH, 45))
        customView2.setLabelName("联系电话：")
        customView2.textField.addTarget(self, action: #selector(self.textDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        
        
        customView3 = DetailCellView(frame:CGRectMake(0, 90, SCREEN_WIDTH, 45))
        customView3.setLabelName("手  机：")
        customView3.textField.addTarget(self, action: #selector(self.textDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        customView4 = DetailCellView(frame:CGRectMake(0, 135, SCREEN_WIDTH, 45))
        customView4.setLabelName("隐患治理情况:")
        customView4.setMinTextViewShow()
        customView4.setRTextViewGray(majorCheckInfoModel.descriptions)
        
    
        let customView5 = DetailCellView(frame:CGRectMake(0, 180, SCREEN_WIDTH, 45))
        customView5.setLabelName("自评：")
        customView5.setLabelMax()
        customView5.setRCheckBtn()
        customView5.rightCheckBtn.addTarget(self, action:#selector(majortapped1(_:)), forControlEvents:.TouchUpInside)
        
        let customView6 = DetailCellView(frame:CGRectMake(0, 225, SCREEN_WIDTH, 45))
        customView6.setLabelName("专家评估：")
        customView6.setLabelMax()
        customView6.setRCheckBtn()
        customView6.rightCheckBtn.addTarget(self, action:#selector(majortapped2(_:)), forControlEvents:.TouchUpInside)
        
        let customView7 = DetailCellView(frame:CGRectMake(0, 270, SCREEN_WIDTH, 45))
        customView7.setLabelName("政府验收：")
        customView7.setLabelMax()
        customView7.setRCheckBtn()
        customView7.rightCheckBtn.addTarget(self, action:#selector(majortapped3(_:)), forControlEvents:.TouchUpInside)
        
        customView8 = DetailCellView(frame:CGRectMake(0, 315, SCREEN_WIDTH, 45))
        customView8.setLabelName("完成整治时间：")
        customView8.setTimeImg()
        customView8.addOnClickListener(self, action: #selector(self.finishTimes))
        
        
        customView9 = DetailCellView(frame:CGRectMake(0, 360, SCREEN_WIDTH, 45))
        customView9.setLabelName("实际投入资金:(单位：万)")
        customView9.setLabelMax()
        customView9.setTextFieldMax()
        customView9.setRTextField("")
        customView9.textField.keyboardType = .DecimalPad
        customView9.textField.delegate = self
        
        customView10 = DetailCellView(frame:CGRectMake(0, 405, SCREEN_WIDTH, 45))
        customView10.setLabelName("单位负责人:")
        customView10.textField.addTarget(self, action: #selector(self.textDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        customView11 = DetailCellView(frame:CGRectMake(0, 450, SCREEN_WIDTH, 45))
        customView11.setLabelName("填表人:")
        customView11.textField.addTarget(self, action: #selector(self.textDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        customView12 = DetailCellView(frame:CGRectMake(0, 495, SCREEN_WIDTH, 45))
        customView12.setLabelName("填报时间：")
        
        customView12.setTimeImg()
        customView12.addOnClickListener(self, action: #selector(self.uploadTimes))

        customView13 = DetailCellView(frame:CGRectMake(0, 540, SCREEN_WIDTH, 145))
        customView13.setLabelName("备注：")
        customView13.setTextViewShow()
        
        customView14 = DetailCellView(frame:CGRectMake(0, 685, SCREEN_WIDTH, 45))
        customView14.setLabelName("现场图片：")
        customView14.setRCenterLabel("")
        customView14.setPhotoImg()
        customView14.addOnClickListener(self, action: #selector(self.choiceImage))
        setImageViewLoc(0, y: 725)
        self.cstScrollView.addSubview(scrollView)
        
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

        
        self.view.addSubview(submitBtn)
        self.view.addSubview(cstScrollView)
        submitBtn.snp_makeConstraints { make in
            make.bottom.equalTo(self.view.snp_bottom).offset(-15)
            make.left.equalTo(self.view.snp_left).offset(50)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-100, 35))
        }
        
        cstScrollView.snp_makeConstraints { make in
            make.top.equalTo(self.view.snp_top).offset(64)
            make.left.equalTo(self.view.snp_left)
            make.bottom.equalTo(submitBtn.snp_top).offset(-5)
            make.right.equalTo(self.view.snp_right)
        }
        self.setZgData()
    }
    
    func choiceImage(){
        self.takeImage()
        customView14.setLineViewHidden()
    }

    var majoris1 = false
    func majortapped1(button:UIButton){
        button.selected = !button.selected
        if button.selected{
            majoris1 = true
        }else{
            majoris1 = false
        }
        
    }
    
    var majoris2 = false
    func majortapped2(button:UIButton){
        button.selected = !button.selected
        if button.selected{
            majoris2 = true
        }else{
            majoris2 = false
        }
        
    }
    
    var majoris3 = false
    func majortapped3(button:UIButton){
        button.selected = !button.selected
        if button.selected{
            majoris3 = true
        }else{
            majoris3 = false
        }
    }
    
    func finishTimes(){
        choiceTime { (time) in
            self.customView8.setRRightLabel(time)
            self.customView8.becomeFirstResponder()
        }
        
    }
    
    func uploadTimes(){
        choiceTime { (time) in
            self.customView12.setRRightLabel(time)
            self.customView12.becomeFirstResponder()
        }
        
    }
    
    
    func submit(){
        contact = customView1.textField.text!
        if AppTools.isEmpty(contact) {
            alert("联系人不可为空", handler: {
                self.customView1.textField.becomeFirstResponder()
            })
            return
        }
        lenthLimit("联系人", count: contact.characters.count)
        
        tel = customView2.textField.text!
        if AppTools.isEmpty(tel) {
            alert("联系电话不可为空", handler: {
                self.customView2.textField.becomeFirstResponder()
            })
            return
        }
        
        if !ValidateEnum.phoneNum(tel).isRight{
            alert("联系电话格式错误，请重新输入！", handler: {
                self.customView2.textField.becomeFirstResponder()
            })
            return
        }
        
        lenthLimit("联系电话", count: tel.characters.count)
        
        mobile = customView3.textField.text!
        
        if AppTools.isEmpty(mobile) {
            alert("手机不可为空", handler: {
                self.customView3.textField.becomeFirstResponder()
            })
            return
        }
        lenthLimit("手机", count: mobile.characters.count)
 
        if !ValidateEnum.phoneNum(mobile).isRight{
            alert("手机号码格式错误，请重新输入！", handler: {
                self.customView3.textField.becomeFirstResponder()
            })
            return
        }
       
        hiddendes = customView4.textView.text!
        if AppTools.isEmpty(hiddendes) {
            alert("隐患治理情况不可为空", handler: {
                self.customView4.textView.becomeFirstResponder()
            })
            return
        }
        
        if hiddendes.characters.count>200{
            alert("隐患治理情况最大输入200字!", handler: {
                self.customView4.textView.becomeFirstResponder()
            })
            return
        }
        
        finishTime = customView8.rightLabel.text!
        if AppTools.isEmpty(finishTime) {
            alert("完成整治时间不可为空", handler: {
                self.customView8.textField.becomeFirstResponder()
            })
            return
        }
        
        money = customView9.textField.text!
        if AppTools.isEmpty(money) {
            alert("实际投入资金不可为空", handler: {
                self.customView9.textField.becomeFirstResponder()
            })
            return
        }
        
        delegate = customView10.textField.text!
        if AppTools.isEmpty(delegate) {
            alert("单位负责人不可为空", handler: {
                self.customView10.textField.becomeFirstResponder()
            })
            return
        }
        
        tablePerson = customView11.textField.text!
        if AppTools.isEmpty(tablePerson) {
            alert("填表人不可为空", handler: {
                self.customView11.textField.becomeFirstResponder()
            })
            return
        }
        
        
        
        uploadTime = customView12.rightLabel.text!
        if AppTools.isEmpty(uploadTime) {
            alert("填报时间不可为空", handler: {
                self.customView12.textField.becomeFirstResponder()
            })
            return
        }
        
        remark = customView13.textView.text!
        if AppTools.isEmpty(remark) {
            alert("备注不可为空", handler: {
                self.customView13.textField.becomeFirstResponder()
            })
            return
        }
        
        
        alertNotice("提示", message: "确认提交后，本次检查信息及隐患无法再更改") {
            var parameters = [String : AnyObject]()
            parameters["dangerGorver.daDanger.id"] = self.majorCheckInfoModel.id
            parameters["dangerGorver.linkMan"] = self.contact
            parameters["dangerGorver.linkTel"] = self.tel
            parameters["dangerGorver.linkMobile"] = self.mobile
            parameters["dangerGorver.gorverContent"] = self.hiddendes
            parameters["dangerGorver.evaluate"] = self.majoris1
            parameters["dangerGorver.evaluateExpert"] = self.majoris2
            parameters["dangerGorver.evaluateGovernment"] = self.majoris3
            parameters["dangerGorver.finishDate"] = self.finishTime
            parameters["dangerGorver.money"] = self.money
            parameters["dangerGorver.memo"] = self.remark
            parameters["dangerGorver.chargePerson"] = self.delegate
            parameters["dangerGorver.fillDate"] = self.uploadTime
            parameters["dangerGorver.fillMan"] = self.tablePerson
            if self.isGorover == "1"{
            self.submitHistoryRecordHidden(parameters)
            }else{
            self.submitMajorHidden(parameters)
            }
        }
    }
    
 
    
    var contact = ""
    var tel = ""
    var mobile = ""
    var hiddendes = ""
    var type = ""
    var finishTime = ""
    var money = ""
    var delegate = ""
    var tablePerson = ""
    var uploadTime = ""
    var remark = ""
    
    
    func submitHistoryRecordHidden(parameters:[String : AnyObject]){
        
        NetworkTool.sharedTools.updateDangerGorver(parameters) { (login, error) in
            if error == nil {
                self.showHint("重大隐患整改历史记录修改成功", duration: 1, yOffset: 0)
                let viewController = self.navigationController?.viewControllers[0] as! SecurityCheckController
                self.navigationController?.popToViewController(viewController , animated: true)
            }else{
                self.showHint("\(error!)", duration: 2, yOffset: 0)
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()                }
            }
            
        }

    }
    
    func submitMajorHidden(parameters:[String : AnyObject]){
        
        NetworkTool.sharedTools.creatDangerGorver(parameters) { (login, error) in
            if error == nil {
                self.showHint("重大隐患修改成功", duration: 1, yOffset: 0)
                let viewController = self.navigationController?.viewControllers[0] as! SecurityCheckController
                self.navigationController?.popToViewController(viewController , animated: true)
            }else{
                self.showHint("\(error!)", duration: 2, yOffset: 0)
                if error == NOTICE_SECURITY_NAME {
                    self.alertNotice("提示", message: error, handler: {
                        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                        self.presentViewController(controller, animated: true, completion: nil)
                    })
                }
            }
            
        }
    }

}