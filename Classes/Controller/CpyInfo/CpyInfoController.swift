//
//  CpyInfoController.swift
//  ZhiAnTongCpy
//
//  Created by Ricky on 2017/2/6.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit


//调整字体宽度
private let topItemWid:CGFloat = 100
private let topItemHei:CGFloat = 44
class CpyInfoController: BaseViewController,LocationParameterDelegate  {

    var lng:String = "" //经度
    var lat:String = "" //纬度
    private var viewControllers = [UIViewController]()
    private var topValues:[String] = ["企业基本信息","安全生产信息"]
    /// 顶部bar的颜色
    var topBarColor:UIColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
    
    private var angelLayer:CALayer!
    private var scrollView:UIScrollView!
    private var topBarView:UIView!
    private var toplabs:[ZZTapLabel] = []
    var selectedItem:Int = 0{
        didSet{
            toplabs.forEach { (lab) -> () in
                lab.textColor = UIColor(white: 0.8, alpha: 0.8)
            }
            toplabs[selectedItem].textColor = UIColor.whiteColor()
        }
    }
    var topLayerOriX:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavagation("企业信息")
        let v1 = CpyBaseInfoController()
        let v2 = SecProduceInfoController()

        self.viewControllers =  [v1,v2]
        self.topValues = ["企业基本信息","安全生产信息"]
        self.scrollView = UIScrollView()
        if viewControllers.count == 0 || topValues.count == 0{
            fatalError("子VC和topValues不能为0个")
        }
        
        topBarView = UIView()
        topBarView.frame = CGRectMake(0,127, SCREEN_WIDTH, 64)
        self.view.addSubview(topBarView)
        topBarView.backgroundColor = YMGlobalBlueColor()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.scrollView.frame = CGRectMake(0, 181, SCREEN_WIDTH, SCREEN_HEIGHT-64)
        self.view.addSubview(self.scrollView)
        let x = CGFloat(self.viewControllers.count)
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*x,SCREEN_HEIGHT-64)
        //        self.scrollView.contentOffset = CGPointMake(0,0)
        self.scrollView.pagingEnabled = true
        self.scrollView.delegate = self
        var originX = (SCREEN_WIDTH - x*topItemWid)/3
        topLayerOriX = originX+40
        angelLayer = CALayer()
        angelLayer.frame = CGRectMake(topLayerOriX, 51 , 20 , 13)
        angelLayer.contents = UIImage(named: "angel")?.CGImage
        angelLayer.contentsGravity = kCAGravityTop
        angelLayer.contentsScale = UIScreen.mainScreen().scale
        //        angelLayer.backgroundColor = UIColor.redColor().CGColor
        self.topBarView.layer.addSublayer(angelLayer)
        
        var i = 0
        for vc in self.viewControllers{
            
            self.addChildViewController(vc)
            self.scrollView.addSubview(vc.view)
            vc.view.frame = CGRectMake(CGFloat(i)*SCREEN_WIDTH, 10, SCREEN_WIDTH, SCREEN_HEIGHT-54)
            
            let lab = ZZTapLabel(frame: CGRectMake(originX, 20, topItemWid, topItemHei))
            lab.text = topValues[i]
            lab.font = UIFont.systemFontOfSize(13)
            lab.textAlignment = .Center
            lab.tag = i
            lab.delegate = self
            //            lab.textColor = UIColor.whiteColor()
            self.toplabs.append(lab)
            originX += topItemWid+50
            self.topBarView.addSubview(lab)
            
            i += 1
        }
        selectedItem = 0
    }
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    @IBAction func toLocation(sender: AnyObject) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LocationSaveController") as! LocationSaveController
        controller.companyId = AppTools.loadNSUserDefaultsValue("companyId") as! String
        controller.delegate = self
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func passParams(lng: String, lat: String) {
        self.lng = lng
        self.lat = lat
        AppTools.setNSUserDefaultsValue("lng", lng)
        AppTools.setNSUserDefaultsValue("lat", lat)
    }

}


extension CpyInfoController:UIScrollViewDelegate,ZZTapLabelDelegate{
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let x = topItemWid*scrollView.contentOffset.x/SCREEN_WIDTH
        guard x >= 0 && x <= CGFloat(topItemWid)*CGFloat(viewControllers.count-1) else{return}
        let oriX = topLayerOriX+x
        if x == 0 {
            self.angelLayer.frame.origin.x = oriX
        }else{
            self.angelLayer.frame.origin.x = oriX+50
        }
        if x%topItemWid == 0 && self.selectedItem != Int(x/topItemWid){
            self.selectedItem = Int(x/topItemWid)
        }
    }
    
    func tapLabel(label: ZZTapLabel) {
        let index = label.tag
        
        let oriX = topLayerOriX+CGFloat(index*100)
        
        let scrollX = CGFloat(index)*SCREEN_WIDTH
        self.scrollView.contentOffset.x = scrollX
        let ani = CABasicAnimation()
        ani.duration = 0.4
        ani.keyPath = "frame.origin.x"
        ani.fromValue = self.angelLayer.frame.origin.x
        ani.toValue = oriX
        self.angelLayer.addAnimation(ani, forKey: "xxs")
        
        self.selectedItem = index
    }
    
    
}
