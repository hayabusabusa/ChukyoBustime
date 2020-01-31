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
    
    static func configure(with diagramDriver: Driver<String>) -> DiagramViewController {
        let vc = Storyboard.DiagramViewController.instantiate(DiagramViewController.self)
        vc.viewModel = DiagramViewModel(dependency: diagramDriver)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindView()
    }
}

// MARK: ViewModel

extension DiagramViewController {
    
    private func bindViewModel() {
        
    }
    
    private func bindView() {
        viewModel.dependency
            .drive(diagramLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
