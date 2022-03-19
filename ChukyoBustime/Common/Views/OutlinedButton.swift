//
//  OutlinedButton.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/03/12.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

class OutlinedButton: UIButton {

    // MARK: IBInspectable

    @IBInspectable var cornerRadius: CGFloat = 8
    @IBInspectable var borderWidth: CGFloat = 1
    @IBInspectable var borderColor: UIColor = .lightGray

    // MARK: Properties

    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1 : 0.4
        }
    }

    // MARK: Initializer

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

        backgroundColor = .clear
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor

        titleLabel?.textColor = UIColor(red: 242 / 255, green: 97 / 255, blue: 97 / 255, alpha: 1)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
}

