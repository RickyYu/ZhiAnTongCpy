//
//  InfoConsulation.swift
//  ZhiAnTongCpy
//
//  Created by Ricky on 2017/2/6.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit

class InfoConsulationController: BaseViewController {
    
    override func viewDidLoad() {
         super.viewDidLoad()
       setNavagation("信息资讯")
    }
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    @IBAction func qyzc(sender: AnyObject) {
        let infolist = InfoListController()
        infolist.infoName = "企业政策"
        infolist.infoType = "QYZC"
        self.navigationController?.pushViewController(infolist, animated: true)
    }

    @IBAction func flfg(sender: AnyObject) {
        let infolist = InfoListController()
        infolist.infoName = "法律法规"
        infolist.infoType = "FLFG"
        self.navigationController?.pushViewController(infolist, animated: true)
    }
    
    @IBAction func jsbz(sender: AnyObject) {
        let infolist = InfoListController()
        infolist.infoName = "技术标准"
        infolist.infoType = "JSBZ"
        self.navigationController?.pushViewController(infolist, animated: true)
    }

    @IBAction func tzgg(sender: AnyObject) {
        let infolist = InfoListController()
        infolist.infoName = "通知公告"
        infolist.infoType = "TZGG"
        self.navigationController?.pushViewController(infolist, animated: true)
    }
    
    @IBAction func aqzs(sender: AnyObject) {
        let infolist = InfoListController()
        infolist.infoName = "安全知识"
        infolist.infoType = "AQZS"
        self.navigationController?.pushViewController(infolist, animated: true)
    }
    
    @IBAction func zjk(sender: AnyObject) {
        let infolist = ExpertLibraryController()
        infolist.infoName = "专家库"
        self.navigationController?.pushViewController(infolist, animated: true)
    }
    
    @IBAction func msds(sender: AnyObject) {
        
        let listMsds = InfoMsdsListController()
         listMsds.infoName = "MSDS查询"
         listMsds.infoType = "MSDS"
        self.navigationController?.pushViewController(listMsds, animated: true)
    }
    
    @IBAction func ajyw(sender: AnyObject) {
        let infolist = InfoListController()
        infolist.infoName = "安检要闻"
        infolist.infoType = "AJYW"
        self.navigationController?.pushViewController(infolist, animated: true)
    }
    
    
}
