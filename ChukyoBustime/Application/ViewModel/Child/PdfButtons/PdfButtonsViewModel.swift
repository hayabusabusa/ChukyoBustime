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

final class PdfButtonsViewModel {
    
    // MARK: Dependency
    
    private let model: PdfButtonsModel
    
    // MARK: Propreties
    
    private let disposeBag = DisposeBag()
    
    // MARK: Initializer
    
    init(model: PdfButtonsModel = PdfButtonsModelImpl()) {
        self.model = model
    }
}

extension PdfButtonsViewModel: ViewModelType {
    
    // MARK: I/O
    
    struct Input {
        let calendarButtonDidTap: Signal<Void>
        let timeTableButtonDidTap: Signal<Void>
    }
    
    struct Output {
        let presentSafari: Driver<URL>
    }
    
    // MARK: Transform I/O
    
    func transform(input: PdfButtonsViewModel.Input) -> PdfButtonsViewModel.Output {
        let presentSafariRelay: PublishRelay<URL> = .init()
        let pdfUrlSignal: Signal<PdfUrl> = model.getPdfUrl()
            .asSignal { error -> SharedSequence<SignalSharingStrategy, PdfUrl> in
                // TODO: Error handling
                return .empty()
            }
        
        input.calendarButtonDidTap
            .flatMapLatest { return pdfUrlSignal }
            .map { URL(string: $0.calendar) }
            .filter { $0 != nil }
            .map { $0! }
            .emit(to: presentSafariRelay)
            .disposed(by: disposeBag)
        input.timeTableButtonDidTap
            .flatMapLatest { return pdfUrlSignal }
            .map { URL(string: $0.timeTable) }
            .filter { $0 != nil } // RxOptional ?
            .map { $0! }
            .emit(to: presentSafariRelay)
            .disposed(by: disposeBag)
        
        return Output(presentSafari: presentSafariRelay.asDriver(onErrorDriveWith: .empty()))
    }
}
