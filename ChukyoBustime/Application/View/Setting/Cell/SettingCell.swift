//
//  SettingCell.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/02/12.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {

    // MARK: IBOutlet

    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: Properties

    static let reuseIdentifier = "SettingCell"
    static let rowHeight: CGFloat = 48
    static var nib: UINib {
        return UINib(nibName: "SettingCell", bundle: nil)
    }

    // MARK: Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: Setup
    
    func setupCell(title: String?) {
        titleLabel.text = title
    }
}

