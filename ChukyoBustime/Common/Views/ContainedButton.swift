//
//  ContainedButton.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/05/16.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

class ContainedButton: UIButton {

    // MARK: IBInspectable

    @IBInspectable var containerColor: UIColor = UIColor.clear {
        didSet {
            setBackgroundImage(containerColor.image(), for: .normal)
        }
    }
    @IBInspectable var highlightedContainerColor: UIColor = UIColor.clear {
        didSet {
            setBackgroundImage(highlightedContainerColor.image(), for: .highlighted)
        }
    }
    @IBInspectable var selectedContainerColor: UIColor = UIColor.clear {
        didSet {
            setBackgroundImage(selectedContainerColor.image(), for: .selected)
        }
    }
    @IBInspectable var disabledContainerColor: UIColor = UIColor.clear {
        didSet {
            setBackgroundImage(disabledContainerColor.image(), for: .disabled)
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 4 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    // MARK: Initizalizer

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()

        if let title = title(for: state) {
            setAttributedTitle(NSAttributedString(string: title, attributes: [NSAttributedString.Key(String(kCTLanguageAttributeName)): "ja"]), for: .normal)
        }
    }

    private func commonInit() {
        isExclusiveTouch = true

        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true

        setBackgroundImage(containerColor.image(), for: .normal)
        setBackgroundImage(highlightedContainerColor.image(), for: .highlighted)
        setBackgroundImage(selectedContainerColor.image(), for: .selected)
        setBackgroundImage(disabledContainerColor.image(), for: .disabled)
    }
}
