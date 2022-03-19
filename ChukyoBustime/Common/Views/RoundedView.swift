//
//  RoundedView.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/01/29.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

class RoundedView: UIView {
    
    // MARK: IBInspectable
    
    @IBInspectable var cornerRadius: CGFloat = 0
    
    // MARK: Lifecycle
    
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
    }

    private func commonInit() {
        isExclusiveTouch = true
        layer.cornerRadius = cornerRadius
    }
}
