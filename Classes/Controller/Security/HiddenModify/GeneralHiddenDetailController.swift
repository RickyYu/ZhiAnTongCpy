//
//  HiddenDetailController.swift
//  ZhiAnTongCpy
//
//  Created by Ricky on 2017/2/9.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//


import UIKit
import SnapKit
import SwiftyJSON
import UsefulPickerView

class GeneralHiddenDetailController: SinglePhotoViewController {
  
    var submitBtn = UIButton()
    var cstScrollView: UIScrollView!
    var generalCheckInfoModel:GeneralCheckInfoModel!
    //历史记录入口进入则为true
    var isRead:Bool = false
    //false 为企业 则能修改  true为政府不能修改
    var isGov = false
    var customView1  = DetailCellView()
    var customView2  = DetailCellView()
    var customView3  = DetailCellView()
    var customView4  = DetailCellView()
    var customView5  = DetailCellView()
    var customView6  = DetailCellView()
    var customView7  = DetailCellView()
    var customView8  = DetailCellView()
    var customView9  = DetailCellView()
    
    let singleDatanormal = ["人", "物", "管理"]
    
    override func viewDidLoad() {
        isGov = generalCheckInfoModel.gov
        setNavagation("一般隐患整改")
        if isRead {
        setNavagation("一般隐患历史记录")
        }
        initPage()
        //历史记录开始获取
        getData()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignEdit(_:))))
    }
    
    override func resignEdit(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            customView1.textField.resignFirstResponder()
            customView2.textField.resignFirstResponder()
            customView3.textField.resignFirstResponder()
            customView4.textField.resignFirstResponder()
            customView8.textView.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    func getData(){
        var parameters = [String : AnyObject]()
        parameters["nomalDanger.id"] = generalCheckInfoModel.id
        NetworkTool.sharedTools.loadCpyNormalDanger(parameters) { (generalCheckInfoModel, error) in
            if error == nil{
              self.generalCheckInfoModel = generalCheckInfoModel
              self.setData()
            }else{
                self.showHint("\(error!)", duration: 2, yOffset: 0)
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }
            }

        }
    
    }
    
    func setData(){
        let isGov:Bool = generalCheckInfoModel.gov
        
        if isGov || isRead{
            //政府端
            let customView10 = DetailCellView(frame:CGRectMake(0, 0, SCREEN_WIDTH, 45))
            customView10.setLabelName("企业确认整改：")
            customView10.setLabelMax()
            customView10.setRCheckBtn()
            customView10.rightCheckBtn.addTarget(self, action:#selector(majortapped4(_:)), forControlEvents:.TouchUpInside)
            self.cstScrollView.addSubview(customView10)
            customView1.frame = CGRectMake(0, 45, SCREEN_WIDTH, 45)
            customView2.frame = CGRectMake(0, 90, SCREEN_WIDTH, 45)
            customView3.frame = CGRectMake(0, 135, SCREEN_WIDTH, 45)
            customView4.frame = CGRectMake(0, 180, SCREEN_WIDTH, 45)
            customView5.frame = CGRectMake(0, 225, SCREEN_WIDTH, 45)
            customView6.frame = CGRectMake(0, 270, SCREEN_WIDTH, 45)
            customView7.frame = CGRectMake(0, 315, SCREEN_WIDTH, 45)
            customView8.frame = CGRectMake(0, 360, SCREEN_WIDTH, 145)
            customView9.frame = CGRectMake(0, 505, SCREEN_WIDTH, 45)
            
            
            customView1.textField.enabled = false
            customView2.textField.enabled = false
            customView3.textField.enabled = false
            customView4.textField.enabled = false
//            customView5.textField.enabled = false
            customView8.textView.editable = false
//            customView7.textField.enabled = false
            customView6.textField.enabled = false
            submitBtn.hidden = false
            customView9.hidden = true
            
            
            customView1.setRTextFieldGray(generalCheckInfoModel.linkMan)
            customView2.setRTextFieldGray(generalCheckInfoModel.linkTel)
            customView3.setRTextFieldGray(generalCheckInfoModel.linkMobile)
            customView4.setRTextFieldGray(generalCheckInfoModel.descriptions)
            customView8.setRTextViewGray(generalCheckInfoModel.remarks)
            customView5.setRRightLabelGray(getTroubleType(String(generalCheckInfoModel.type)))
            customView6.setRTextFieldGray(generalCheckInfoModel.rectificationPlanTime)
//            customView7.setRTextFieldGray(generalCheckInfoModel.completedDate)
            customView7.setRRightLabelGray(generalCheckInfoModel.completedDate)
            
            //增加图片
            if generalCheckInfoModel.fileRealPath != "" {
             self.customView9.hidden = false
                self.customView9.setLineViewHidden()
                let base_path = PlistTools.loadStringValue("BASE_URL_YH")
                let image = UIImageView(frame: CGRectMake(0, 560, 100, 100))
                image.kf_setImageWithURL(NSURL(string: base_path+generalCheckInfoModel.fileRealPath)!, placeholderImage: UIImage(named: "icon_photo_bg"))
                
                self.cstScrollView.addSubview(image)
            }
            
        }else {
            //一般隐患整改，企业端
            customView6.addOnClickListener(self, action: #selector(self.ChoicePlanTimes))
            customView7.addOnClickListener(self, action: #selector(self.ChoiceModifyTimes))
            customView5.addOnClickListener(self, action: #selector(self.normalHiddenType))
            submitBtn.hidden = false
            customView9.hidden = false
            customView1.setRTextField(generalCheckInfoModel.linkMan)
            customView2.setRTextField(generalCheckInfoModel.linkTel)
            customView3.setRTextField(generalCheckInfoModel.linkMobile)
            customView4.setRTextField(generalCheckInfoModel.descriptions)
            customView5.setRRightLabel(getTroubleType(String(generalCheckInfoModel.type)))
            customView6.setRTextField(generalCheckInfoModel.rectificationPlanTime)
            customView7.setRRightLabel(generalCheckInfoModel.completedDate)
            customView8.setRTextView(generalCheckInfoModel.remarks)
            if generalCheckInfoModel.fileRealPath != "" {
                self.customView9.hidden = false
                self.customView9.setLineViewHidden()
                let base_path = PlistTools.loadStringValue("BASE_URL_YH")
                let imageView = UIImageView()
                
                imageView.kf_setImageWithURL(NSURL(string: base_path+generalCheckInfoModel.fileRealPath)!, placeholderImage: UIImage(named: "icon_photo_bg"), optionsInfo: nil, progressBlock: { (receivedSize, totalSize) in
                    
                    }, completionHandler: { (image, error, cacheType, imageURL) in
                       self.addImageView(imageView)
                })
            }
        }
    }
    
    func initPage(){
        cstScrollView = UIScrollView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
        //scrollView!.pagingEnabled = true
        cstScrollView!.scrollEnabled = true
        cstScrollView!.showsHorizontalScrollIndicator = true
        cstScrollView!.showsVerticalScrollIndicator = false
        cstScrollView!.scrollsToTop = true
        cstScrollView!.contentSize = CGSizeMake(SCREEN_WIDTH, 605)
        
        submitBtn.setTitle("提交", forState:.Normal)
        submitBtn.backgroundColor = YMGlobalDeapBlueColor()
        submitBtn.setTitleColor(UIColor.greenColor(), forState: .Highlighted) //触摸状态下文字的颜色
        submitBtn.addTarget(self, action: #selector(self.submit), forControlEvents: UIControlEvents.TouchUpInside)
        
        customView1 = DetailCellView(frame:CGRectMake(0, 0, SCREEN_WIDTH, 45))
        customView1.setLabelName("联系人：")
        
        customView2 = DetailCellView(frame:CGRectMake(0, 45, SCREEN_WIDTH, 45))
        customView2.setLabelName("联系电话：")
        
        
        customView3 = DetailCellView(frame:CGRectMake(0, 90, SCREEN_WIDTH, 45))
        customView3.setLabelName("手机：")
        
        
        customView4 = DetailCellView(frame:CGRectMake(0, 135, SCREEN_WIDTH, 45))
        customView4.setLabelName("隐患描述:")
        
        
         customView5 = DetailCellView(frame:CGRectMake(0, 180, SCREEN_WIDTH, 45))
        customView5.setLabelName("隐患类别：")
       

        customView6 = DetailCellView(frame:CGRectMake(0, 225, SCREEN_WIDTH, 45))
        customView6.setLabelName("计划整改时间：")
       
        
        customView7 = DetailCellView(frame:CGRectMake(0, 270, SCREEN_WIDTH, 45))
        customView7.setLabelName("整改时间：")
        
        if !isRead {
            customView5.setRRightLabel("")
            
//            getSystemTime { (time) in
//                self.customView6.setRRightLabel(time)
//            }
            customView6.setTimeImg()
            
            customView7.setRRightLabel("")
            customView7.setTimeImg()
            

        }
        
        customView8 = DetailCellView(frame:CGRectMake(0, 315, SCREEN_WIDTH, 145))
        customView8.setLabelName("备注：")
        customView8.setTextViewShow()
        
        customView9 = DetailCellView(frame:CGRectMake(0, 460, SCREEN_WIDTH, 45))
        customView9.setLabelName("现场图片：")
        customView9.setRCenterLabel("")
        customView9.setPhotoImg()
        customView9.addOnClickListener(self, action: #selector(self.choiceImage))
        setImageViewLoc(0, y: 505)
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
        
    }
    
    
    //企业确认整改
    var majoris4:Bool = false
    func majortapped4(button:UIButton){
        button.selected = !button.selected
        if button.selected{
            majoris4 = true
        }else{
            majoris4 = false
        
        }
    }
    
    func choiceImage(){
        self.takeImage()
        customView9.setLineViewHidden()
    }
    
    
    func ChoicePlanTimes(){
        choiceTime { (time) in
            self.customView6.setRRightLabel(time)
            self.customView6.becomeFirstResponder()
        }
        
    }
    
    func ChoiceModifyTimes(){
        choiceTime { (time) in
            self.customView7.setRRightLabel(time)
            self.customView7.becomeFirstResponder()
        }
        
    }


    var contact = ""
    var tel = ""
    var mobile = ""
    var hiddendes = ""
    var type = ""
    var planTime = ""
    var modifyTime = ""
    var remark = ""

    func submit(){
        contact = customView1.textField.text!
        if AppTools.isEmpty(contact) {
            alert("联系人不可为空", handler: {
                self.customView1.textField.becomeFirstResponder()
            })
            return
        }
    
        tel = customView2.textField.text!
//        if AppTools.isEmpty(tel) {
//            alert("联系电话不可为空", handler: {
//                self.customView2.textField.becomeFirstResponder()
//            })
//            return
//        }
//        
//        if !ValidateEnum.phoneNum(tel).isRight  {
//            alert("联系电话格式不对", handler: {
//                self.customView2.textField.becomeFirstResponder()
//            })
//            return
//        }
        
        mobile = customView3.textField.text!
//        if AppTools.isEmpty(mobile) {
//            alert("手机不可为空", handler: {
//                self.customView3.textField.becomeFirstResponder()
//            })
//            return
//        }
//        
//        if !ValidateEnum.phoneNum(mobile).isRight {
//            alert("手机格式不对", handler: {
//                self.customView3.textField.becomeFirstResponder()
//            })
//            return
//        }
        lenthLimit("手机", count: mobile.characters.count)
        lenthLimit("联系电话", count: tel.characters.count)
        lenthLimit("联系人", count: contact.characters.count)
        
        hiddendes = customView4.textField.text!
        if AppTools.isEmpty(hiddendes) {
            alert("隐患描述不可为空", handler: {
                self.customView4.textField.becomeFirstResponder()
            })
            return
        }
        
        type = customView5.rightLabel.text!
        
        planTime = customView6.textField.text!
        if AppTools.isEmpty(planTime) {
            alert("计划整改时间不可为空", handler: {
                self.customView4.textField.becomeFirstResponder()
            })
            return
        }
        
        
        modifyTime = customView7.rightLabel.text!
//        if AppTools.isEmpty(modifyTime) {
//            alert("整改时间不可为空", handler: {
//                self.customView7.textField.becomeFirstResponder()
//            })
//            return
//        }
        
        remark = customView8.textView.text!
//        if AppTools.isEmpty(remark) {
//            alert("备注不可为空", handler: {
//                self.customView8.textField.becomeFirstResponder()
//            })
//            return
//        }

        
        alertNotice("提示", message: "确认提交后，本次检查信息及隐患无法再更改") {
            self.submitNormalHidden()
        }
    }
    
    func submitNormalHidden(){
        var parameters = [String : AnyObject]()
        parameters["deletePhoto"] = "0"
        parameters["nomalDanger.companyPassId"] = String(generalCheckInfoModel.companyPassId)
        parameters["nomalDanger.id"] = String(generalCheckInfoModel.id)
        parameters["nomalDanger.linkMan"] = contact
        parameters["nomalDanger.linkTel"] = tel
        parameters["nomalDanger.linkMobile"] = mobile
        parameters["nomalDanger.danger"] = "true"
        parameters["nomalDanger.type"] =  getTroubleType(type)
        parameters["nomalDanger.description"] = hiddendes
        parameters["nomalDanger.repaired"] = String(generalCheckInfoModel.repaired)
        parameters["nomalDanger.completedDate"] = planTime
        parameters["nomalDanger.rectificationPlanTime"] = modifyTime
        parameters["nomalDanger.remarks"] = remark
        parameters["nomalDanger.check"] = String(majoris4)

        NetworkTool.sharedTools.updateNomalDanger(parameters,imageArrays: getTakeImages()) { (data, error) in
            if error == nil{
                self.showHint("一般隐患修改成功", duration: 1, yOffset: 0)
                let viewController = self.navigationController?.viewControllers[0] as! SecurityCheckController
                // viewController.isRefresh = true
                self.navigationController?.popToViewController(viewController , animated: true)
                
            }else{
                
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }else{
                    self.showHint("\(error!)", duration: 1, yOffset: 0)
                }
            }
        }

    
    }
    
    func normalHiddenType(){
        UsefulPickerView.showSingleColPicker("请选择", data: singleDatanormal, defaultSelectedIndex: 1) {[unowned self] (selectedIndex, selectedValue) in
            self.customView5.setRRightLabel(selectedValue)
        }
    }
}
