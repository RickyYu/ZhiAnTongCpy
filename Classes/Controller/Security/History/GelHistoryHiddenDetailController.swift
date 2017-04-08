//
//  GelHistoryHiddenDetailController.swift
//  ZhiAnTongCpy
//
//  Created by Ricky on 2017/2/16.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON
import UsefulPickerView

class GelHistoryHiddenDetailController: SinglePhotoViewController {
    var customView1  = DetailCellView()
    var customView2  = DetailCellView()
    var customView3  = DetailCellView()
    var customView4  = DetailCellView()
    var customView5  = DetailCellView()
    var customView6  = DetailCellView()
    var customView7  = DetailCellView()
    var customView8  = DetailCellView()
    var customView9  = DetailCellView()
    var submitBtn = UIButton()
    var cstScrollView: UIScrollView!
    var generalCheckInfoModel:GeneralCheckInfoModel!
    let singleDatanormal = ["人", "物", "管理"]
    //false 为企业 则能修改  true为政府不能修改
    var isGov = false
    override func viewDidLoad() {
        setNavagation("一般隐患整改历史记录")
        isGov = generalCheckInfoModel.gov
        initCpyPage()
//        if isGov {
//            initGovPage()
//        }else {
//            initCpyPage()
//        }
        getData()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignEdit(_:))))
    }
    
    override func resignEdit(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            customView1.textField.resignFirstResponder()
            customView2.textField.resignFirstResponder()
            customView3.textField.resignFirstResponder()
            customView4.textField.resignFirstResponder()
            customView5.textField.resignFirstResponder()
            customView6.textField.resignFirstResponder()
            customView7.textView.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    //如果来源是政府，则不可修改
    func setData(){
//        if isGov {
//            let isSelected : Bool = generalCheckInfoModel.repaired
//            if isSelected {
//                customView1.rightCheckBtn.selected = true
//            }else{
//                customView1.rightCheckBtn.selected = false
//            }
//            customView2.textField.enabled = false
//            customView3.textField.enabled = false
//            customView4.textField.enabled = false
//            customView5.textField.enabled = false
//            customView6.textField.enabled = false
//            customView7.textView.editable = false
//            customView2.setRTextFieldGray(generalCheckInfoModel.linkMan)
//            customView3.setRTextFieldGray(generalCheckInfoModel.linkTel)
//            customView4.setRTextFieldGray(generalCheckInfoModel.descriptions)
//            customView5.setRTextFieldGray(getTroubleType(String(generalCheckInfoModel.type)))
//            customView6.setRTextFieldGray(generalCheckInfoModel.rectificationPlanTime)
//            customView7.setRTextView(generalCheckInfoModel.remarks)
//            submitBtn.hidden = true
//        }else { //企业则可修改
            customView1.setRTextFieldGray(generalCheckInfoModel.linkMobile)
            customView8.setRTextFieldGray(generalCheckInfoModel.completedDate)
            customView2.setRTextFieldGray(generalCheckInfoModel.linkMan)
            customView3.setRTextFieldGray(generalCheckInfoModel.linkTel)
            customView4.setRTextFieldGray(generalCheckInfoModel.descriptions)
            customView5.setRRightLabelGray(getTroubleType(String(generalCheckInfoModel.type)))
//            customView5.addOnClickListener(self, action: #selector(self.normalHiddenType))
            customView6.setRTextFieldGray(generalCheckInfoModel.rectificationPlanTime)
            customView7.setRTextViewGray(generalCheckInfoModel.remarks)
           
//        }
        self.customView9.hidden = true
        if generalCheckInfoModel.fileRealPath != "" {
            self.customView9.hidden = false
            self.customView9.setLineViewHidden()
            let base_path = PlistTools.loadStringValue("BASE_URL_YH")
            let image = UIImageView(frame: CGRectMake(0, 490, 100, 100))
            image.kf_setImageWithURL(NSURL(string: base_path+generalCheckInfoModel.fileRealPath)!, placeholderImage: UIImage(named: "icon_photo_bg"))
            
            self.cstScrollView.addSubview(image)
        }
        
    }
    
    func initGovPage(){
        cstScrollView = UIScrollView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 550))
        //scrollView!.pagingEnabled = true
        cstScrollView!.scrollEnabled = true
        cstScrollView!.showsHorizontalScrollIndicator = true
        cstScrollView!.showsVerticalScrollIndicator = false
        cstScrollView!.scrollsToTop = true
        cstScrollView!.contentSize = CGSizeMake(SCREEN_WIDTH, 550)
        
        submitBtn.setTitle("保存", forState:.Normal)
        submitBtn.backgroundColor = YMGlobalDeapBlueColor()
        submitBtn.setTitleColor(UIColor.greenColor(), forState: .Highlighted) //触摸状态下文字的颜色
        submitBtn.addTarget(self, action: #selector(self.submitCheck), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        customView1 = DetailCellView(frame:CGRectMake(0, 0, SCREEN_WIDTH, 45))
        customView1.setLabelName("企业确认整改：")
        customView1.setLabelMax()
        customView1.setRCheckBtn()
        customView1.rightCheckBtn.addTarget(self, action:#selector(majortapped1(_:)), forControlEvents:.TouchUpInside)
        
        customView2 = DetailCellView(frame:CGRectMake(0, 45, SCREEN_WIDTH, 45))
        customView2.setLabelName("联系人：")
        
        customView3 = DetailCellView(frame:CGRectMake(0, 90, SCREEN_WIDTH, 45))
        customView3.setLabelName("联系电话：")
        
        
        customView4 = DetailCellView(frame:CGRectMake(0, 135, SCREEN_WIDTH, 45))
        customView4.setLabelName("隐患描述：")
        
        
        customView5 = DetailCellView(frame:CGRectMake(0, 180, SCREEN_WIDTH, 45))
        customView5.setLabelName("隐患类别:")
        customView5.setRRightLabel("")
        
        
        customView6 = DetailCellView(frame:CGRectMake(0, 225, SCREEN_WIDTH, 45))
        customView6.setLabelName("计划整改时间：")
        
        
        customView7 = DetailCellView(frame:CGRectMake(0, 270, SCREEN_WIDTH, 135))
        customView7.setLabelName("备注：")
        customView7.setTextViewShow()
        
        self.cstScrollView.addSubview(customView1)
        self.cstScrollView.addSubview(customView2)
        self.cstScrollView.addSubview(customView3)
        self.cstScrollView.addSubview(customView4)
        self.cstScrollView.addSubview(customView5)
        self.cstScrollView.addSubview(customView6)
        self.cstScrollView.addSubview(customView7)
        self.cstScrollView.addSubview(customView8)
        
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
    
    func  initCpyPage(){
        cstScrollView = UIScrollView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
        //scrollView!.pagingEnabled = true
        cstScrollView!.scrollEnabled = true
        cstScrollView!.showsHorizontalScrollIndicator = true
        cstScrollView!.showsVerticalScrollIndicator = false
        cstScrollView!.scrollsToTop = true
        cstScrollView!.contentSize = CGSizeMake(SCREEN_WIDTH, 600)
        
        submitBtn.setTitle("保存", forState:.Normal)
        submitBtn.backgroundColor = YMGlobalDeapBlueColor()
        submitBtn.setTitleColor(UIColor.greenColor(), forState: .Highlighted) //触摸状态下文字的颜色
        submitBtn.addTarget(self, action: #selector(self.submitCheck), forControlEvents: UIControlEvents.TouchUpInside)
        submitBtn.hidden = true
        
        customView2 = DetailCellView(frame:CGRectMake(0, 0, SCREEN_WIDTH, 45))
        customView2.setLabelName("联系人：")
        
        customView3 = DetailCellView(frame:CGRectMake(0, 45, SCREEN_WIDTH, 45))
        customView3.setLabelName("联系电话：")
        
        customView1 = DetailCellView(frame:CGRectMake(0, 90, SCREEN_WIDTH, 45))
        customView1.setLabelName("联系手机：")
        
        customView4 = DetailCellView(frame:CGRectMake(0, 135, SCREEN_WIDTH, 45))
        customView4.setLabelName("隐患描述：")
        
        
        customView5 = DetailCellView(frame:CGRectMake(0, 180, SCREEN_WIDTH, 45))
        customView5.setLabelName("隐患类别:")
        
        
        customView6 = DetailCellView(frame:CGRectMake(0, 225, SCREEN_WIDTH, 45))
        customView6.setLabelName("计划整改时间：")
        customView6.setTimeImg()
        customView6.setLabelMax()
//        customView6.addOnClickListener(self, action: #selector(self.ChoicePlanTimes))

        customView8 = DetailCellView(frame:CGRectMake(0, 270, SCREEN_WIDTH, 45))
        customView8.setLabelName("整改时间：")
        customView8.setTimeImg()
        customView8.setLabelMax()
//        customView8.addOnClickListener(self, action: #selector(self.rectificationTimes))
        
        customView7 = DetailCellView(frame:CGRectMake(0, 315, SCREEN_WIDTH, 135))
        customView7.setLabelName("备注：")
        customView7.setTextViewShow()
        
        customView9 = DetailCellView(frame:CGRectMake(0, 450, SCREEN_WIDTH, 45))
        customView9.setLabelName("现场图片：")
        customView9.setRRightLabel("")
//        customView9.addOnClickListener(self, action: #selector(self.choiceNormalImage))
//        setImageViewLoc(0, y: 480)
        self.cstScrollView.addSubview(scrollView)
        self.cstScrollView.addSubview(customView9)
        self.cstScrollView.addSubview(customView1)
        self.cstScrollView.addSubview(customView2)
        self.cstScrollView.addSubview(customView3)
        self.cstScrollView.addSubview(customView4)
        self.cstScrollView.addSubview(customView5)
        self.cstScrollView.addSubview(customView6)
        self.cstScrollView.addSubview(customView7)
        self.cstScrollView.addSubview(customView8)
        
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
    func choicePlanTimes(){
        choiceTime { (time) in
            self.customView6.setRRightLabel(time)
            self.customView6.becomeFirstResponder()
        }
        
    }
    
    func rectificationTimes(){
        choiceTime { (time) in
            self.customView8.setRRightLabel(time)
            self.customView8.becomeFirstResponder()
        }
        
    }
    
    func choiceNormalImage(){
        customView9.setLineViewHidden()
        self.takeImage()
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
                }            }
            
        }
        
    }
    
    //是否需要政府协调
    var majoris1 : Bool = false
    func majortapped1(button:UIButton){
        button.selected = !button.selected
        if button.selected{
            majoris1 = true
        }else{
            majoris1 = false
        }
    }
    func submitCheck(){
        let linkMan = customView2.textField.text!
        let linkTel = customView3.textField.text!
        let mobile = customView1.textField.text!
        let hiddenDes = customView4.textField.text!
        let type =   getTroubleType(String(customView5.rightLabel.text!))
        let planTime = customView6.rightLabel.text!
        let rectTime = customView8.rightLabel.text!
        let remark = customView7.textView.text!


        if AppTools.isEmpty(linkMan) {
            alert("联系人不可为空", handler: {
                self.customView4.textField.becomeFirstResponder()
            })
            return
        }

        if AppTools.isEmpty(linkTel) {
            alert("联系电话不可为空", handler: {
                self.customView5.textField.becomeFirstResponder()
            })
            return
        }
        
        if AppTools.isEmpty(mobile) {
            alert("手机不可为空", handler: {
                self.customView5.textField.becomeFirstResponder()
            })
            return
        }
        
        if !ValidateEnum.phoneNum(mobile).isRight
        {
            alert("手机格式错误，请重新输入", handler: {
                self.customView5.textField.becomeFirstResponder()
            })
            return
        }

        if AppTools.isEmpty(remark) {
            alert("备注不可为空", handler: {
                self.customView7.textField.becomeFirstResponder()
            })
            return
        }
        
  
        if AppTools.isEmpty(hiddenDes) {
            alert("隐患描述不可为空", handler: {
                self.customView7.textField.becomeFirstResponder()
            })
            return
        }
        

        if AppTools.isEmpty(planTime) {
            alert("计划整改时间不可为空", handler: {
                
            })
            return
        }
        
        if AppTools.isEmpty(rectTime) {
            alert("整改时间不可为空", handler: {
                
            })
            return
        }
        var parameters = [String : AnyObject]()
        parameters["deletePhoto"] = "0"
        parameters["nomalDanger.companyPassId"] = String(generalCheckInfoModel.companyPassId)
        parameters["nomalDanger.id"] = String(generalCheckInfoModel.id)
        parameters["nomalDanger.linkMan"] = linkMan
        parameters["nomalDanger.linkTel"] = linkTel
        parameters["nomalDanger.linkMobile"] = mobile
        parameters["nomalDanger.danger"] = "true"
        parameters["nomalDanger.type"] = type
        parameters["nomalDanger.description"] = hiddenDes
        parameters["nomalDanger.repaired"] = String(majoris1)
        parameters["nomalDanger.completedDate"] = rectTime
        parameters["nomalDanger.rectificationPlanTime"] = planTime
        parameters["nomalDanger.remarks"] = remark
        parameters["nomalDanger.check"] = "0"
        
        NetworkTool.sharedTools.updateNomalDanger(parameters,imageArrays: getTakeImages()) { (data, error) in
            if error == nil{
                self.showHint("保存成功", duration: 1, yOffset: 0)
                let viewController = self.navigationController?.viewControllers[0] as! SecurityCheckController
                // viewController.isRefresh = true
                self.navigationController?.popToViewController(viewController , animated: true)
                
                
            }else{
                self.showHint("\(error!)", duration: 2, yOffset: 0)
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
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
