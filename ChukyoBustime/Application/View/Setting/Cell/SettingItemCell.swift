//
//  SettingItemCell.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/02/12.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

class SettingItemCell: UITableViewCell {

    // MARK: IBOutlet
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var itemLabel: UILabel!
    
    // MARK: Properties
    
    static let reuseIdentifier = "SettingItemCell"
    static let rowHeight: CGFloat = 48
    static var nib: UINib {
        return UINib(nibName: "SettingItemCell", bundle: nil)
    }

    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Setup
    
    func setupCell(title: String, item: String, selectionStyle: UITableViewCell.SelectionStyle = .none) {
        titleLabel.text = title
        itemLabel.text = item
        self.selectionStyle = selectionStyle
        self.accessoryType = .none
    }
}
