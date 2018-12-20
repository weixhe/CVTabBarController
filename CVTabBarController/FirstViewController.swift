//
//  ViewController.swift
//  CVTabBarController
//
//  Created by caven on 2018/12/20.
//  Copyright © 2018 caven-twy. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.purple
        
        let addBtn = UIButton(type: .custom)
        addBtn.frame = CGRect(x: 20, y: 100, width: 80, height: 40)
        addBtn.setTitle("泡泡", for: .normal)
        addBtn.setTitleColor(UIColor.white, for: .normal)
        addBtn.backgroundColor = UIColor.red
        addBtn.addTarget(self, action: #selector(showBridge), for: .touchUpInside)
        view.addSubview(addBtn)
        
    }


    @objc func showBridge() {
//        self.cv_tabBarItem?.updatePaopao(text: "40")
        
        self.cv_tabBarController?.updatePaopao(text: "30", at: 0)
    }
}

