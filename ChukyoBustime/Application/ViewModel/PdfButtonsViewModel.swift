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
    func calendarButtonTapped()
    
    /// Call when the time table button is tapped.
    func timeTableButtonTapped()
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
    
    private let model: PDFButtonsModel
    
    // MARK: Propreties
    
    private let disposeBag = DisposeBag()
    
    // MARK: Outputs
    
    let presentSafari: Signal<URL>
    
    // MARK: Initializer
    
    init(model: PDFButtonsModel = PDFButtonsModelImpl()) {
        self.model = model
        
        presentSafari = model.pdfURLStream.asSignal(onErrorSignalWith: .empty())
    }
    
    // MARK: Inputs
    
    func calendarButtonTapped() {
        model.getPDFURL(of: .calendar)
    }
    
    func timeTableButtonTapped() {
        model.getPDFURL(of: .timeTable)
    }
}

extension PdfButtonsViewModel: PdfButtonsViewModelType {
    var input: PdfButtonsViewModelInputs { return self }
    var output: PdfButtonsViewModelOutputs { return self }
}
