//
//  HistorySecCheckCell.swift
//  ZhiAnTongCpy
//
//  Created by Ricky on 2017/3/30.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//


import UIKit

class HistorySecCheckCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var  secCheckRecordModel: SecCheckRecordModel?
        {
        didSet{
            if let art = secCheckRecordModel {
                // 设置数据
              self.title?.text = art.checkName
              self.time?.text = art.checkTime
            }
            
        }
    }
}