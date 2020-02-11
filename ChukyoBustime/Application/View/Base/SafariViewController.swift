//
//  SafariViewController.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/29.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit
import SafariServices

class SafariViewController: SFSafariViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredControlTintColor = .primary
    }
}
