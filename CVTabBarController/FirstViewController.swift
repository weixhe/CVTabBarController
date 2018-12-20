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
        addBtn.setTitle("+", for: .normal)
        addBtn.setTitleColor(UIColor.red, for: .normal)
        addBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        addBtn.backgroundColor = UIColor.red
        addBtn.addTarget(self, action: #selector(showBridge), for: .touchUpInside)
        view.addSubview(addBtn)
        
    }


    @objc func showBridge() {
//        self.cv_tabBarItem?.updatePaopao(text: "40")
        
        self.cv_tabBarController?.updatePaopao(text: "", at: 0)
    }
}

