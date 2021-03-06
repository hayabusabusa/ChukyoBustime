//
//  DiagramViewController.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/29.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit
import RxCocoa

final class DiagramViewController: BaseViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet private weak var diagramLabel: UILabel!
    
    // MARK: Properties
    
    private var viewModel: DiagramViewModel!
    
    // MARK: Lifecycle
    
    static func configure(with viewModel: DiagramViewModel) -> DiagramViewController {
        let vc = Storyboard.DiagramViewController.instantiate(DiagramViewController.self)
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
}

// MARK: ViewModel

extension DiagramViewController {
    
    private func bindViewModel() {
        viewModel.output.diagramName
            .drive(diagramLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
