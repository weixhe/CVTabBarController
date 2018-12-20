//
//  CVTabBarController.swift
//  CVBaseKit
//
//  Created by caven on 2018/11/24.
//  Copyright © 2018 caven-twy. All rights reserved.
//

import UIKit

private let heightItem: CGFloat = 49


/// 自定义tabBarController，必须调用 updateLayout() 方法才能正确显示item

open class CVTabBarController: UITabBarController {

    open lazy var cv_tabBar: CVTabBar = { return _cv_tabbar() }()
    
    private var tabbarItems: [CVTabBarItem] = []  // tabBar上所有的item
    open var showItems: [Int] = []     // 控制在tabbar上面显示的item
    
    open override var viewControllers: [UIViewController]? { set { _setViewControllers(newValue) } get { return _viewControllers() } }
    open override var selectedIndex: Int { didSet { _selectedIndexDidSet() } }

    private var totalViewCotrollers: [UIViewController]?
    
    // 可以设置特殊的view
    private var specialView: UIView?
    private var specialIndex: Int?
    private var hasInitialized: Bool = false    // 记录是否已经初始化完成
    
}

// MARK: - Life Cycle
extension CVTabBarController {
    
    override open var shouldAutorotate: Bool {
        return selectedViewController?.shouldAutorotate ?? false
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return selectedViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return selectedViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.addSubview(cv_tabBar)
    }
    
    
    open override func viewWillLayoutSubviews() {
        
        updateSubviews()
        updateFrame()
    }
    
    open override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        viewWillLayoutSubviews()
    }
}

// MARK: - Notification
extension CVTabBarController {}

// MARK: - Public Methods
fileprivate var n = 0
extension CVTabBarController {
    
    /// 更新item上的paopao数字, （中心的）偏移量，是否隐藏； 当text==nil时，显示圆点
    public func updatePaopao(text: String?, offset: CGSize = CGSize(width: 15, height: -10), at index: Int, isHidden: Bool = false) {
        guard index >= 0 else { return }
        guard tabbarItems.count > index else { return }
        guard showItems.count > index else { return }
        
        // 判断item是否已经初始化，并设定了frame了
        if hasInitialized == false {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) { [weak self] in
                n += 1
                if n > 10 {
                    print("尝试了10次显示Paopao，但是item位置一直未确定，所以Paopao也不知道该显示到什么位置")
                    return
                }
                guard let `self` = self else { return }
                self.updatePaopao(text: text, offset: offset, at: index, isHidden: isHidden)
            }
            return
        }
        n = 0

        let shown = showItems[index]
        let item: CVTabBarItem = tabbarItems[shown]
        item.updatePaopao(text: text, offset: offset, isHidden: isHidden)
    }
    
    /// 在外界修改tab上的index
    public func changeToIndex(_ index: Int) {
        selectedIndex = index
    }
    
    /// 添加特殊的itemView, 只能添加一个
    public func insert(view: UIView, at index: Int) {
        specialView = view
        specialIndex = index
        
        // 更新 items 和 frame
        viewWillLayoutSubviews()
    }
    
}

// MARK: - CVTabBarItemDelegate
extension CVTabBarController: CVTabBarItemDelegate {
    public func tabBarItem(_ tabBarItem: CVTabBarItem, didSelected atIndex: Int) {
        
        guard tabbarItems.count > 0 else { return }
            
        selectedIndex = showItems.firstIndex(of: atIndex) ?? 0
    }
}

// MARK: - Private Methods
fileprivate extension CVTabBarController {
    
    /// 更新TabBar上的item
    func updateSubviews() {
        guard tabbarItems.count > 0 else { return }
        guard totalViewCotrollers != nil else { return }
        
        for item in tabbarItems {
            item.delegate = nil
            item.removeFromSuperview()
        }
        
        // 如果没有手动控制tabbar上显示的item，则直接从头布局
        if showItems.count == 0 {
            for i in 0..<tabbarItems.count {
                showItems.append(i)
            }
        }
        
        // 遍历showItems 数组中的index， 从 tabBarItems 中取出对应的item显示到tabbar上，以实现多个item，任意显示
        var cacheViewControllers: [UIViewController] = []
        
        for (index, key) in showItems.enumerated() {
            if totalViewCotrollers!.count <= key { continue }
            cacheViewControllers.append(totalViewCotrollers![key])
            
            let item = tabbarItems[key]
            item.delegate = self
            cv_tabBar.addSubview(item)
            item.isSelected = index == selectedIndex ? true : false
        }
        
        if let view = specialView {
            cv_tabBar.addSubview(view)
        }
        
        self.viewControllers = cacheViewControllers
    }
    
    /// 更新布局
    func updateFrame() {
        // 计算显示的个数
        var willShownCount: Int = 0
        for value in showItems {
            if tabbarItems.count > value {
                willShownCount += 1
            }
        }
        
        cv_tabBar.frame = tabBar.bounds
        
        // 计算宽度
        let width: CGFloat
        if let view = specialView {
            
            width = (tabBar.frame.width - view.frame.width) / CGFloat(willShownCount)
            // 布局宽度
            var off_x: CGFloat = 0
            for i in 0..<willShownCount + 1 {
                if i < specialIndex! {
                    let item = tabbarItems[i]
                    item.frame = CGRect(x: off_x, y: 0, width: width, height: heightItem)
                    off_x = item.frame.maxX
                } else if i == specialIndex! {
                    specialView!.frame = CGRect(origin: CGPoint(x: off_x, y: 0), size: specialView!.frame.size)
                    off_x = specialView!.frame.maxX
                } else {
                    let item = tabbarItems[i-1]
                    item.frame = CGRect(x: off_x, y: 0, width: width, height: heightItem)
                    off_x = item.frame.maxX
                }
            }
        } else {
            width = tabBar.frame.width / CGFloat(willShownCount)
            // 布局宽度
            for i in 0..<willShownCount {
                let item = tabbarItems[i]
                item.frame = CGRect(x: width * CGFloat(i), y: 0, width: width, height: heightItem)
            }
        }
        
        // 已经计算好了item的frame
        hasInitialized = true
    }
}

// MARK: - Getter Setter
fileprivate extension CVTabBarController {
    
    func _cv_tabbar() -> CVTabBar {
        let tb = CVTabBar(frame: self.tabBar.bounds)
        return tb
    }
    
    func _selectedIndexDidSet() {
        // 遍历，修改 item 选中状态
        for (index, key) in showItems.enumerated() {
            if tabbarItems.count <= key { continue }
            let item = tabbarItems[key]
            if index == selectedIndex {
                item.isSelected = true
            } else {
                item.isSelected = false
            }
        }
    }
    
    func _setViewControllers(_ viewControllers: [UIViewController]?) {
        
        if showItems.count > 0 {
            super.viewControllers = viewControllers
            self.moreNavigationController.isNavigationBarHidden = true
        }
        
        if totalViewCotrollers == nil || totalViewCotrollers!.count == 0 {
            totalViewCotrollers = viewControllers
            
            // 遍历所有的控制器，生成对应的cv_tabBarItem
            if viewControllers != nil {
                for vc in viewControllers! {
                    if vc.isKind(of: UINavigationController.self) {
                        
                        if let controller = (vc as! UINavigationController).viewControllers.first, let item = controller.cv_tabBarItem {
                            tabbarItems.append(item)
                            item.index = tabbarItems.count - 1
                        }
                    } else if vc.isKind(of: UIViewController.self) {
                        if let item = vc.cv_tabBarItem {
                            tabbarItems.append(item)
                            item.index = tabbarItems.count - 1
                        }
                    }
                }
            }
        }
    }
    
    func _viewControllers() -> [UIViewController]? {
        return super.viewControllers
    }
}

extension UITabBar {
    
    // 为了只添加自定义的tabbar，重写父类的方法，进行过滤
    open override func addSubview(_ view: UIView) {
        if view.isKind(of: CVTabBar.self) {
            super.addSubview(view)
        }
    }
}
