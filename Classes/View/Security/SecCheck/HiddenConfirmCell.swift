//
//  HiddenConfirmCell.swift
//  ZhiAnTongGov
//
//  Created by Ricky on 2017/1/16.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit

class HiddenConfirmCell: UITableViewCell {

    @IBOutlet weak var titile: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var customSwitch: UISwitch!
    @IBOutlet weak var stateDes: UILabel!
    var isHistory:Bool = false
    

    
    @IBAction func changeValue(sender: AnyObject) {
        let sw = sender as! UISwitch
        if sw.on{
            hiddenModel?.matterState = true
        }else{
            hiddenModel?.matterState = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    
    var hiddenModel: SecCheckStateModel?
        {
        didSet{
            if let art = hiddenModel {
                // 设置数据
               
                
                titile.text = art.matterName
                date.text = art.matterRemark
                let isRepair :Bool = art.matterState
                
                if isHistory {
                    stateDes.hidden = false
                    customSwitch.hidden = true
                    if isRepair {
                        stateDes.text = "通过"
                    }else{
                        stateDes.text = "未通过"
                        stateDes.textColor = UIColor.redColor()
                    }
                }else{
                    stateDes.hidden = true
                    customSwitch.hidden = false
                    if isRepair {
                        customSwitch.on = true
                    }else{
                        customSwitch.on = false
                    }
                }
            }
        }
    }

    
}



