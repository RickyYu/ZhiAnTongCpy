//
//  InfoListCell.swift
//  ZhiAnTongGov
//
//  Created by Ricky on 2016/12/9.
//  Copyright © 2016年 safetysafetys. All rights reserved.
//

import UIKit

class InfoDemoCell: UITableViewCell {
    
    @IBOutlet weak var infoTitile: UILabel!
    @IBOutlet weak var infoSubTitle: UILabel!
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    var  info: Info?
        {
        didSet{
            if let art = info {
                // 设置数据
                self.infoTitile?.text = art.caption
                self.infoSubTitle?.text = art.publisher
                self.time?.text = art.modifyTime
            }
            
        }
    }
    
    var  mSDSInfoModel: MSDSInfoModel?
        {
        didSet{
            if let art = mSDSInfoModel {
                // 设置数据
                self.infoTitile?.text = art.chineseName
                self.infoSubTitle?.text = art.englishName
                self.time?.text = ""
            }
            
        }
    }
    
    var  secCheckModel: SecCheckModel?
        {
        didSet{
            if let art = secCheckModel {
                // 设置数据
                self.infoTitile?.text = art.checkName
                self.infoSubTitle?.text = art.checkRemark
                self.time?.text = art.createTime
            }
            
        }
    }
    
    var  secCheckRecordModel: SecCheckRecordModel?
        {
        didSet{
            if let art = secCheckRecordModel {
                // 设置数据
                self.infoTitile?.text = art.checkName
                self.infoSubTitle?.text = ""
                self.time?.text = art.checkTime
            }
            
        }
    }
    
    var expertInfoModel:ExpertInfoModel?
        {
        didSet{
            if let art = expertInfoModel {
                // 设置数据
                self.infoTitile?.text = art.name
                self.infoSubTitle?.text = "职称"+art.jobTitle
                self.time?.text = "工作单位"+art.unit
            }
            
        }
    }
}
