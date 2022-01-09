//
//  CustomButton.swift
//  GitHubApp
//
//  Created by Анна on 09.01.2022.
//

import UIKit

class CustomButton: UIButton {
    var borderWidth: CGFloat = 2.0 {
        didSet {
            clipsToBounds = true
            layer.borderWidth = borderWidth
        }
    }
    
    var borderColor = UIColor.white.cgColor {
        didSet {
            layer.borderColor = borderColor
        }
    }
    
    var titleColor: UIColor = .black {
        didSet {
            setTitleColor(titleColor, for: .normal)
        }
    }
    
    var titleText: String? {
        didSet {
            setTitle(titleText, for: .normal)
        }
    }
    
    var cornerRadiusDivider: CGFloat = 2
    
    var contentSpacing: CGFloat = 0 {
        didSet {
            contentEdgeInsets = UIEdgeInsets(top: 0, left: contentSpacing, bottom: 0, right: contentSpacing)
        }
    }
    
    var topBottomSpacing: CGFloat = 0 {
        didSet {
            contentEdgeInsets.top = topBottomSpacing
            contentEdgeInsets.bottom = topBottomSpacing
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height / cornerRadiusDivider
    }
    
    private func setup() {
        setTitle("Custom Button", for: .normal)
        backgroundColor = .green
    }
}
