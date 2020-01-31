//
//  BusListViewController.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/01/29.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

final class BusListViewController: BaseViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet private weak var firstBusListView: BusListView!
    @IBOutlet private weak var secondBusListView: BusListView!
    @IBOutlet private weak var thirdBusListView: BusListView!
    
    // MARK: Properties
    
    // MARK: Lifecycle
    
    static func configure() -> BusListViewController {
        let vc = Storyboard.BusListViewController.instantiate(BusListViewController.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: IBAction
}
