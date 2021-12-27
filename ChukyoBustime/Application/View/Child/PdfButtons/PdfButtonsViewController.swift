//
//  PdfButtonsViewController.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/30.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

final class PdfButtonsViewController: BaseViewController {
    
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
    
    @IBAction private func calendarButtonTapped(_ sender: UIButton) {
        viewModel.input.calendarButtonTapped()
    }
    
    @IBAction private func timeTableButtonTapped(_ sender: UIButton) {
        viewModel.input.timeTableButtonTapped()
    }
    
}

// MARK: - ViewModel

extension PdfButtonsViewController {
    
    private func bindViewModel() {
        let viewModel = PdfButtonsViewModel()
        self.viewModel = viewModel
        
        viewModel.output.presentSafari
            .emit(onNext: { [weak self] url in self?.presentSafari(url: url) })
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
