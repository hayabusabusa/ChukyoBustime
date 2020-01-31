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
    
    // MARK: Propreties
    
    private let disposeBag = DisposeBag()
    
    // MARK: Initializer
}

extension PdfButtonsViewModel: ViewModelType {
    
    // MARK: I/O
    
    struct Input {
        let calendarButtonDidTap: Driver<Void>
        let timeTableButtonDidTap: Driver<Void>
    }
    
    struct Output {
        let presentSafari: Driver<URL>
    }
    
    // MARK: Transform I/O
    
    func transform(input: PdfButtonsViewModel.Input) -> PdfButtonsViewModel.Output {
        let presentSafariRelay: PublishRelay<URL> = .init()
        
        input.calendarButtonDidTap
            .drive(onNext: { _ in
                // TODO: Replace firebase remote config
                if let url = URL(string: "https://www.chukyo-u.ac.jp/support/pdf/studentlife/buscallender2019.pdf") {
                    presentSafariRelay.accept(url)
                }
            })
            .disposed(by: disposeBag)
        input.timeTableButtonDidTap
            .drive(onNext: { _ in
                // TODO: Replace firebase remote config
                if let url = URL(string: "https://www.chukyo-u.ac.jp/support/pdf/studentlife/bustime.pdf") {
                    presentSafariRelay.accept(url)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(presentSafari: presentSafariRelay.asDriver(onErrorDriveWith: .empty()))
    }
}
