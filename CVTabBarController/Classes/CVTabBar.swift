//
//  CVTabBar.swift
//  CVBaseKit
//
//  Created by caven on 2018/11/24.
//  Copyright © 2018 caven-twy. All rights reserved.
//

import UIKit


open class CVTabBar: UIView {

    public var backgroundImage: UIImage? { didSet { _backgroundImageDidSet() } }
    
    lazy private var backgroundImageView: UIImageView = { return _backgroundImageView() }()
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}

// MARK: - Life Cycle
extension CVTabBar {
    open override func layoutSubviews() {
        backgroundImageView.frame = self.bounds
    }
}

// MARK: - Public Methods
extension CVTabBar {
    
}

// MARK: - Private Methods
fileprivate extension CVTabBar {
    func commonInit() {
        backgroundColor = UIColor.white
        self.addSubview(backgroundImageView)
    }
}

// MARK: - Getter Setter
fileprivate extension CVTabBar {
  
    func _backgroundImageDidSet() {
        backgroundImageView.image = backgroundImage
    }
    
    func _backgroundImageView() -> UIImageView {
        let iv = UIImageView(frame: self.bounds)
        return iv
    }
}
