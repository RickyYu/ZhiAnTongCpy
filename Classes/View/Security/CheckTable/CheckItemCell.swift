//
//  CheckItemCell.swift
//  ZhiAnTongCpy
//
//  Created by Ricky on 2017/2/10.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit

class CheckItemCell: UITableViewCell {
    
    @IBOutlet weak var checkDes: UILabel!
    @IBOutlet weak var remark: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
}
    
    var  checkDesModel: CheckDesModel?
        {
        didSet{
            if let art = checkDesModel {
                // 设置数据
                self.checkDes?.text = "          " + art.matterName
                self.remark?.text = "          " + art.matterRemark
             
            }
            
        }
    }
}
