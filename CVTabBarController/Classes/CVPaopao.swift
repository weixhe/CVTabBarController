//
//  CVPaopao.swift
//  CVBaseKit
//
//  Created by caven on 2018/11/24.
//  Copyright © 2018 caven-twy. All rights reserved.
//

import UIKit

private let DefaultPaopaoTextColor = UIColor.white
private let DefaultPaopaoFont = UIFont.systemFont(ofSize: 11)
private let DefaultPaopaoBGColor = UIColor.red


/// TabBar上显示的角标，
open class CVPaopao: UIView {

    public var content: String? { didSet { _contentDidSet()} }
    public var textColor: UIColor? { didSet { _textColorDidSet()} }
    public var textFont: UIFont? { didSet { _textFontDidSet()} }
    
    public var autoWidth: Bool = true       // 宽度自适应
    public var marginLR: CGFloat = 3        // 宽度自适应市可设置左右的边距
    public var calWidth: CGFloat = 0        // 宽度自适应根据文字计算宽度结果

    lazy private var textLabel: UILabel = { return _textLabel() }()
    
    
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = DefaultPaopaoBGColor
        
        addSubview(textLabel)
        addNotify()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = DefaultPaopaoBGColor
        
        addSubview(textLabel)
        addNotify()
    }
    
    deinit {
        removeNotify()
    }
}

// MARK: - Life Cycle
extension CVPaopao {
    convenience init(content: String?) {
        self.init()
        updatePaopao(content: content)
    }
    
    open override func layoutSubviews() {
        textLabel.frame = CGRect(x: marginLR, y: 0, width: frame.width - marginLR * 2, height: frame.height)
    }
}

// MARK: - Notification
extension CVPaopao {
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let notiObj = object as? UILabel, notiObj == textLabel, keyPath == "text" {
            if let tx = change?[NSKeyValueChangeKey.newKey] as? String, tx.count > 0 {
                if autoWidth {
                    calWidth = width(for: tx) + 2 * marginLR
                }
            } else {
                if autoWidth {
                    calWidth = 2 * marginLR
                }
            }
        }
    }
}

// MARK: - Public Methods
extension CVPaopao {
    
    public func updatePaopao(content: String?) {
        self.content = content
    }    
}

// MARK: - Private Methods
fileprivate extension CVPaopao {
    
    func addNotify() {
        textLabel.addObserver(self, forKeyPath: "text", options: [.new, .old], context: nil)
    }
    
    func removeNotify() {
        textLabel.removeObserver(self, forKeyPath: "text")
    }
    
    /// 计算文字的需要的宽度
    func width(for text: String) -> CGFloat {
        let textRect = (text as NSString).boundingRect(with: CGSize(width: 9999, height: frame.height), options: .usesFontLeading, attributes: [.font: textLabel.font], context: nil)
        return textRect.size.width
    }
    
}


// MARK: - Getter Setter
fileprivate extension CVPaopao {
    
    
    func _textLabel() -> UILabel {
        let lb = UILabel(frame: self.bounds)
        lb.textColor = textColor ?? DefaultPaopaoTextColor
        lb.font = textFont ?? DefaultPaopaoFont
        lb.textAlignment = .center
        return lb
    }
    
    func _contentDidSet() {
        textLabel.text = content
        textLabel.font = textFont ?? DefaultPaopaoFont
        textLabel.textColor = textColor ?? DefaultPaopaoTextColor
    }
    
    func _textColorDidSet() {
        textLabel.textColor = textColor ?? DefaultPaopaoTextColor
    }
    
    func _textFontDidSet() {
        textLabel.font = textFont ?? DefaultPaopaoFont
    }
}
