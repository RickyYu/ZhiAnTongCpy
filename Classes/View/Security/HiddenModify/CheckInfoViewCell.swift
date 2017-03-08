//
//  CheckInfoViewCell.swift
//  ZhiAnTongCpy
//
//  Created by Ricky on 2017/2/9.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit

class CheckInfoViewCell: UITableViewCell {
    
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var contact: UILabel!
    @IBOutlet weak var des: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var source: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    var  generalCheckInfoModel: GeneralCheckInfoModel?
        {
        didSet{
            if let art = generalCheckInfoModel {
                // 设置数据
                self.num?.text = String(art.num)
                self.contact?.text = "联系人:"+art.linkMan
                self.des?.text = "隐患描述:"+art.descriptions
                self.time?.text = "录入时间:"+art.createTime
                let isGov:Bool = art.gov
                if isGov{
                    self.source?.text = "隐患来源:政府"
                }else{
                    self.source?.text = "隐患来源:企业"
                }
                            }
            
        }
    }
    
    var  majorCheckInfoModel: MajorCheckInfoModel?
        {
        didSet{
            if let art = majorCheckInfoModel {
                // 设置数据
                self.num?.text = String(art.num)
                self.contact?.text = "隐患编号:"+art.dangerNo
                self.des?.text = "隐患地址:"+art.dangerAdd
                self.time?.text = "录入时间:"+art.createTime
                let isGov:Bool = art.gov
                if isGov{
                    self.source?.text = "隐患来源:政府"
                }else{
                    self.source?.text = "隐患来源:企业"
                }
            }
            
        }
    }

    
}

