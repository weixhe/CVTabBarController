//
//  BaseTabBarController.swift
//  CVTabBarController
//
//  Created by caven on 2018/12/20.
//  Copyright © 2018 caven-twy. All rights reserved.
//

import UIKit

class BaseTabBarController: CVTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let firstVC = FirstViewController()
        firstVC.cv_tabBarItem = CVTabBarItem(image: UIImage(named: "Tabbar_Home_N"), selectedImage: UIImage(named: "Tabbar_Home_H"), title: "首页", selectedTitle: "首页")
        
        let secondVC = SecondViewController()
        secondVC.cv_tabBarItem = CVTabBarItem(image: UIImage(named: "Tabbar_ShopCart_N"), selectedImage: UIImage(named: "Tabbar_ShopCart_H"), title: "购物车", selectedTitle: "购物车")
        
        let thirdVC = ThirdViewController()
        thirdVC.cv_tabBarItem = CVTabBarItem(image: UIImage(named: "Tabbar_Order_N"), selectedImage: UIImage(named: "Tabbar_Order_H"), title: "订单", selectedTitle: "订单")
        
        let forthVC = ForthViewController()
        forthVC.cv_tabBarItem = CVTabBarItem(image: UIImage(named: "Tabbar_Mine_N"), selectedImage: UIImage(named: "Tabbar_Mine_H"), title: "我", selectedTitle: "我")
        
        
        self.viewControllers = [firstVC, secondVC, thirdVC, forthVC]
        
        
        
        let centerView = UIView(frame: CGRect(x: 0, y: 0, width: 49, height: 49))
        centerView.backgroundColor = UIColor.white
        
        let cycle = UIView(frame: CGRect(x: 0, y: -10, width: 49, height: 49))
        cycle.layer.cornerRadius = 49 / 2
        cycle.layer.masksToBounds = true
        cycle.backgroundColor = UIColor.white
        centerView.addSubview(cycle)

        
        let addBtn = UIButton(type: .custom)
        addBtn.frame = CGRect(x: 0, y: -20, width: centerView.frame.width, height: centerView.frame.height + 20)
        addBtn.setTitle("+", for: .normal)
        addBtn.setTitleColor(UIColor.red, for: .normal)
        addBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        addBtn.addTarget(self, action: #selector(addStory(sender:)), for: .touchUpInside)
        centerView.addSubview(addBtn)
        
        self.insert(view: centerView, at: 2)
    }
    

    @objc func addStory(sender: UIButton) {
        UIAlertView(title: "提升", message: "添加分享", delegate: nil, cancelButtonTitle: "Cancel", otherButtonTitles: "OK").show()
    }

}
