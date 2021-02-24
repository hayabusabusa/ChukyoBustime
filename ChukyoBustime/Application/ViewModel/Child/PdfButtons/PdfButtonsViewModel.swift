//
//  PdfButtonsViewModel.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/31.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Protocols

protocol PdfButtonsViewModelInputs {
    /// Call when the calendar button is tapped.
    func tappedCalendarButton()
    
    /// Call when the time table button is tapped.
    func tappedTimeTableButton()
}

protocol PdfButtonsViewModelOutputs {
    /// Emits a URL that should be used to present `SFSafariViewController`.
    var presentSafari: Signal<URL> { get }
}

protocol PdfButtonsViewModelType {
    var input: PdfButtonsViewModelInputs { get }
    var output: PdfButtonsViewModelOutputs { get }
}

// MARK: - ViewModel

final class PdfButtonsViewModel: PdfButtonsViewModelInputs, PdfButtonsViewModelOutputs {
    
    // MARK: Dependency
    
    private let model: PdfButtonsModel
    
    // MARK: Propreties
    
    private let disposeBag = DisposeBag()
    private let presentSafariRelay: PublishRelay<URL>
    
    // MARK: Outputs
    
    let presentSafari: Signal<URL>
    
    // MARK: Initializer
    
    init(model: PdfButtonsModel = PdfButtonsModelImpl()) {
        self.model = model
        self.presentSafariRelay = .init()
        
        presentSafari = presentSafariRelay.asSignal()
    }
    
    // MARK: Inputs
    
    func tappedCalendarButton() {
        model.getPdfUrl().asSignal(onErrorSignalWith: .empty())
            .map { URL(string: $0.calendar) }
            .compactMap { $0 }
            .emit(to: presentSafariRelay)
            .disposed(by: disposeBag)
    }
    
    func tappedTimeTableButton() {
        model.getPdfUrl().asSignal(onErrorSignalWith: .empty())
            .map { URL(string: $0.timeTable) }
            .compactMap { $0 }
            .emit(to: presentSafariRelay)
            .disposed(by: disposeBag)
    }
}

extension PdfButtonsViewModel: PdfButtonsViewModelType {
    var input: PdfButtonsViewModelInputs { return self }
    var output: PdfButtonsViewModelOutputs { return self }
}
