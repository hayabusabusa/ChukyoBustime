//
//  PdfButtonsViewController.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/30.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

final class PdfButtonsViewController: BaseViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet private weak var calendarButton: UIButton!
    @IBOutlet private weak var timeTableButton: UIButton!
    
    // MARK: Properties
    
    private var viewModel: PdfButtonsViewModel!
    
    // MARK: Lifecycle
    
    static func configure() -> PdfButtonsViewController {
        let vc = Storyboard.PdfButtonsViewController.instantiate(PdfButtonsViewController.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
}

// MARK: - ViewModel

extension PdfButtonsViewController {
    
    private func bindViewModel() {
        let viewModel = PdfButtonsViewModel()
        self.viewModel = viewModel
        
        let input = PdfButtonsViewModel.Input(calendarButtonDidTap: calendarButton.rx.tap.asSignal(),
                                              timeTableButtonDidTap: timeTableButton.rx.tap.asSignal())
        let output = viewModel.transform(input: input)
        
        output.presentSafari
            .drive(onNext: { [weak self] url in self?.presentSafari(url: url) })
            .disposed(by: disposeBag)
    }
}

// MARK: - Transition

extension PdfButtonsViewController {
    
    private func presentSafari(url: URL) {
        let vc = SafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
}
