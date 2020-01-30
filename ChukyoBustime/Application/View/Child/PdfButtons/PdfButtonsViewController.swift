//
//  PdfButtonsViewController.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/30.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

final class PdfButtonsViewController: UIViewController {
    
    // MARK: IBOutlet
    
    // MARK: Properties
    
    // MARK: Lifecycle
    
    static func configure() -> PdfButtonsViewController {
        let vc = Storyboard.PdfButtonsViewController.instantiate(PdfButtonsViewController.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
