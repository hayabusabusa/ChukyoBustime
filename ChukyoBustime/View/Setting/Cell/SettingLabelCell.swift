//
//  SettingLabelCell.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/02/12.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

class SettingLabelCell: UITableViewCell {
    
    // MARK: IBOutlet
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    // MARK: Properties

    static let reuseIdentifier = "SettingLabelCell"
    static let rowHeight: CGFloat = 48
    static var nib: UINib {
        return UINib(nibName: "SettingLabelCell", bundle: nil)
    }

    // MARK: Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: Setup
    
    func setupCell(title: String?, content: String?, selectionStyle: UITableViewCell.SelectionStyle = .none) {
        titleLabel.text = title
        contentLabel.text = content
        self.selectionStyle = selectionStyle
        self.accessoryType = .none
    }
}
