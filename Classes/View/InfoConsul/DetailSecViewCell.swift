//
//  DetailSecViewCell.swift
//  ZhiAnTongCpy
//
//  Created by Ricky on 2017/2/17.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//
import UIKit
import SnapKit


class DetailSecViewCell: UIView {
    var lineView = UIView()
    var label = UILabel()
    var textField = UITextField()
    var rightLabel =  UILabel()
    var leftLabel =  UILabel()
    var rightImg  = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.font = UIFont.boldSystemFontOfSize(11)
        label.frame = CGRectMake(6, 2, 100, 25)
        label.textColor = YMGlobalDeapBlueColor()
        
        
        lineView.frame = CGRectMake(3, 29, SCREEN_WIDTH-6, 1)
        lineView.backgroundColor = UIColor.lightGrayColor()
        
        self.addSubview(label)
        self.addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setLabelName(name:String) {
        label.text = name
    }
    
    func setLabelColorName(name:String) {
        label.text = name
        label.textColor = YMGlobalDeapBlueColor()
    }
    
    func setRRightLabel(name:String){
        
        rightLabel.text = name
        rightLabel.textAlignment = .Right
        rightLabel.font = UIFont.boldSystemFontOfSize(11)
        rightLabel.frame = CGRectMake(SCREEN_WIDTH-120, 2, 110, 25)
        rightLabel.textColor = UIColor.grayColor()

        self.addSubview(rightLabel)
    }
    
    func setRRightLabelImg(name:String){
        
        rightLabel.text = name
        rightLabel.textAlignment = .Right
        rightLabel.font = UIFont.boldSystemFontOfSize(11)
        rightLabel.frame = CGRectMake(SCREEN_WIDTH-120, 2, 100, 25)
        rightLabel.textColor = UIColor.grayColor()
        
        rightImg  = UIImageView()
        rightImg.image = UIImage(named: "right_arrow")
        rightImg.frame = CGRectMake(SCREEN_WIDTH-20, 5, 20, 20)
        self.addSubview(rightLabel)
        self.addSubview(rightImg)
    }
    
    func setRTextField(name:String){
        
        textField.frame = CGRectMake(100, 2, SCREEN_WIDTH-80, 25)
        textField.borderStyle = UITextBorderStyle.None
        textField.adjustsFontSizeToFitWidth=true
        textField.font = UIFont.boldSystemFontOfSize(11)
        textField.contentVerticalAlignment = .Center //垂直居中对齐
        textField.text = name
        self.addSubview(textField)
    }
    
    func setRLeftLabel(name:String){
        
        leftLabel.text = name
        leftLabel.textAlignment = .Left
        leftLabel.font = UIFont.boldSystemFontOfSize(11)
        leftLabel.frame = CGRectMake(100, 2, SCREEN_WIDTH-20, 25)
        leftLabel.textColor = UIColor.grayColor()
        
        self.addSubview(leftLabel)
    }
}

