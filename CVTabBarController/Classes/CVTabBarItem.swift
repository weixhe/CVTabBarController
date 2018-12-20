//
//  CVTabBarItem.swift
//  CVBaseKit
//
//  Created by caven on 2018/11/24.
//  Copyright © 2018 caven-twy. All rights reserved.
//

import UIKit

private let DefaultTitleColor: UIColor = UIColor.black
private let DefaultSelectedTitleColor: UIColor = UIColor.blue
private let DefaultTitleFont: UIFont = UIFont.systemFont(ofSize: 11)
private let DefaultPaopaoHeight: CGFloat = 15
private let DefaultHeight: CGFloat = 49

public protocol CVTabBarItemDelegate: class {
    func tabBarItem(_ tabBarItem: CVTabBarItem, didSelected atIndex: Int)
}

open class CVTabBarItem: UIView {

    public weak var delegate: CVTabBarItemDelegate?
    
    public var image: UIImage?
    public var title: String?
    public var titleColor: UIColor?
    public var titleFont: UIFont?
    
    public var selectedImage: UIImage?
    public var selectedTitle: String?
    public var selectedTitleColor: UIColor?
    public var selectedTitleFont: UIFont?
    
    
    public var isSelected: Bool = false { didSet { _isSelectedDidSet() } }
    public var index: Int = 0
    
    private lazy var imageView: UIImageView = { return _imageView() }()
    private lazy var titleLabel: UILabel = { return _titleLabel() }()
    private lazy var paopao: CVPaopao = { return _paopao() }()
    private lazy var button: UIButton = { return _button() }()
    
    private var paopaoOffset: CGSize = CGSize.zero
    private var paopaoIsHidden: Bool = true
    
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
extension CVTabBarItem {
    open override func layoutSubviews() {
        updateLayout()
        updatePaopaoFrame()
    }
}

// MARK: - Public Methods
extension CVTabBarItem {
    convenience public  init(image: UIImage?, selectedImage: UIImage?, title: String?, selectedTitle: String?) {
        self.init()
        
        setImage(image, state: .normal)
        setImage(selectedImage, state: .selected)
        
        setTitle(title, color: DefaultTitleColor, state: .normal)
        setTitle(selectedTitle, color: DefaultSelectedTitleColor, state: .selected)
        
        updateLayout()
    }
    
    public func setImage(_ image: UIImage?, state: UIControl.State) {
        if state == .normal {
            self.image = image
        } else {
            self.selectedImage = image
        }
    }
    
    /// 设置 title，font， color
    public func setTitle(_ title: String?, font: UIFont = UIFont.systemFont(ofSize: 11), color: UIColor, state: UIControl.State) {
        if state == .normal {
            self.title = title
            setTitle(font: font, color: color, state: .normal)
        } else {
            self.selectedTitle = title
            setTitle(font: font, color: color, state: .selected)
        }
    }
    
    /// 设置 font， color
    public func setTitle(font: UIFont = UIFont.systemFont(ofSize: 11), color: UIColor, state: UIControl.State) {
        if state == .normal {
            self.titleColor = color
            self.titleFont = font
        } else {
            self.selectedTitleColor = color
            self.selectedTitleFont = font
        }
    }
    
    public func updatePaopao(text: String?, offset: CGSize = CGSize(width: 15, height: -10), isHidden: Bool = false) {
        paopao.content = text
        paopaoOffset = offset
        paopaoIsHidden = isHidden
        updatePaopaoFrame()
    }
}

// MARK: - Actions
fileprivate extension CVTabBarItem {
    @objc func onClickTouchAction(sender: UIButton) {
        delegate?.tabBarItem(self, didSelected: index)
    }
}

// MARK: - Private Methods
fileprivate extension CVTabBarItem {
    
    func commonInit() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(paopao)
        addSubview(button)
    }
    
    func updateLayout() {
        
        let space: CGFloat = 5  // 定义image 和 title 之间的间距

        let titleSize: CGSize = size(for: title)
        let imageSize: CGSize = size(for: image)

        if image != nil && title != nil {       // 文字 + 图片
            imageView.frame = CGRect(origin: CGPoint.zero, size: imageSize)
            titleLabel.frame = CGRect(origin: CGPoint.zero, size: titleSize)
            imageView.center = CGPoint(x: frame.width / 2, y: (frame.height - space - titleSize.height) / 2)
            titleLabel.center = CGPoint(x: frame.width / 2, y: (frame.height + space + imageSize.height) / 2)
        } else if image != nil {        // 仅图片
            imageView.frame = CGRect(origin: CGPoint.zero, size: imageSize)
            titleLabel.frame = CGRect(origin: CGPoint.zero, size: titleSize)
            imageView.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        } else {        // 仅文字
            imageView.frame = CGRect(origin: CGPoint.zero, size: imageSize)
            titleLabel.frame = CGRect(origin: CGPoint.zero, size: titleSize)
            titleLabel.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        }

        button.frame = self.bounds
    }
    
    /// 更新Paopao的位置
    func updatePaopaoFrame() {
        if let tx = paopao.content, tx.count > 0 {
            paopao.frame = CGRect(x: 0, y: 0, width: max(paopao.calWidth, DefaultPaopaoHeight), height: DefaultPaopaoHeight)
            paopao.center = CGPoint(x: center.x + paopaoOffset.width, y: center.y + paopaoOffset.height)
        } else {
            paopao.frame = CGRect(x: 0, y: 0, width: max(paopao.calWidth, DefaultPaopaoHeight / 2), height: DefaultPaopaoHeight / 2)
            paopao.center = CGPoint(x: center.x + paopaoOffset.width, y: center.y + paopaoOffset.height)
        }
        
        paopao.layer.cornerRadius = paopao.frame.height / 2
        paopao.layer.masksToBounds = true
        paopao.isHidden = paopaoIsHidden
    }
    
    /// 更新状态，会改变item上的image和title
    func updateState() {
        if !isSelected {
            imageView.image = image
            titleLabel.text = title
            titleLabel.textColor = titleColor ?? DefaultTitleColor
            titleLabel.font = titleFont ?? DefaultTitleFont
        } else {
            imageView.image = selectedImage
            titleLabel.text = selectedTitle
            titleLabel.textColor = selectedTitleColor ?? DefaultSelectedTitleColor
            titleLabel.font = selectedTitleFont ?? DefaultTitleFont
        }
        
        updateLayout()
    }
    
    
    /// 计算文字的需要的size
    func size(for text: String?) -> CGSize {
        guard text != nil else { return CGSize.zero }
        let textRect = (text! as NSString).boundingRect(with: CGSize(width: 9999, height: 9999), options: .usesFontLeading, attributes: [.font: titleLabel.font], context: nil)
        return textRect.size
    }
    
    /// 计算图片的size
    func size(for image: UIImage?) -> CGSize {
        var size: CGSize = CGSize.zero
        if let im = image {
            
            if im.size.height > DefaultHeight {
                let scale = DefaultHeight / im.size.height
                size = CGSize(width: im.size.width * scale, height: DefaultHeight)
            } else {
                size = im.size
            }
        }
        return size
    }
    
}

// MARK: - Getter Setter
fileprivate extension CVTabBarItem {
    
    func _isSelectedDidSet() {
        updateState()
    }
    
    func _imageView() -> UIImageView {
        let iv = UIImageView(frame: CGRect.zero)
        iv.contentMode = .scaleAspectFit
        return iv
    }
    
    func _titleLabel() -> UILabel {
        let lb = UILabel(frame: CGRect.zero)
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }
    
    func _paopao() -> CVPaopao {
        let po = CVPaopao(frame: CGRect.zero)
        po.isHidden = true
        return po
    }
    
    func _button() -> UIButton {
        let bt = UIButton(type: .custom)
        bt.frame = bounds
        bt.addTarget(self, action: #selector(onClickTouchAction(sender:)), for: .touchUpInside)
        return bt
    }
    
}
