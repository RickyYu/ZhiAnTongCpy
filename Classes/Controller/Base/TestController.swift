//
//  TestController.swift
//  ZhiAnTongGov
//
//  Created by Ricky on 2017/1/20.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit
import SnapKit
import UsefulPickerView
import SwiftyJSON
import Photos
class TestController: SinglePhotoViewController {

    var customView6normal = DetailCellView()
    var isFirst = true
    var rangePoint:NSRange!
 var textField:UITextField!

    override func viewDidLoad() {
        textField = UITextField(frame: CGRectMake(50,300,300,40))
        view.addSubview(textField)
        
        
        textField.borderStyle = .RoundedRect
        textField.clearButtonMode = .WhileEditing
         textField.delegate = self
        
        customView6normal =  DetailCellView(frame:CGRectMake(0, 100, SCREEN_WIDTH, 45))
        customView6normal.setLabelName("现场图片：")
        customView6normal.setRRightLabel("")
        customView6normal.addOnClickListener(self, action: #selector(self.takeImage))
                self.view.addSubview(customView6normal)
        setNavagation("测试")
        //initNormalPage()
        
        
        setImageViewLoc(0, y: 145)
        self.view.addSubview(scrollView)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
        self.tabBarController?.hidesBottomBarWhenPushed = true
        self.automaticallyAdjustsScrollViewInsets = false
    }
//    
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        
//        print("range:\(range) rangeLenght:\(range.length)  rangeLocation:\(range.location)  string:\(string)")
//        
//        if string == "" || string == "\n" {
//            if rangePoint != nil {
//                if range.location == rangePoint.location {
//                    isFirst = true
//                }
//            }
//            return true
//        }
//        if ( Int(string) <= 9 && Int(string) >= 0 ) || string == "." {
//            if isFirst == true {
//                if string == "." {
//                    isFirst = false
//                    rangePoint = range
//                    return true
//                }
//            }else if isFirst == false {
//                if string == "." {
//                    return false
//                }else if range.location - rangePoint.location > 2 {
//                    return false
//                }
//            }
//        }else {return false}
//        return true
//    }
    
    override func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let futureString: NSMutableString = NSMutableString(string: textField.text!)
        futureString.insertString(string, atIndex: range.location)
        
        var flag = 0;
        
        let limited = 2;//小数点后需要限制的个数
        
        if !futureString.isEqualToString("") {
            for i in (futureString.length - 1).stride(through: 0, by: -1) {
                let char = Character(UnicodeScalar(futureString.characterAtIndex(i)))
                if char == "." {
                    if flag > limited {
                        return false
                    }
                    break
                }
                flag += 1
            }
        }
        
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print(textField.text)
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
}




