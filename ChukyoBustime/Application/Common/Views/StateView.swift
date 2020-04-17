//
//  StateView.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/04/16.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

class StateView: UIView {
    
    // MARK: Enum
    
    enum State {
        case none
        case loading
        case empty
    }
    
    // MARK: Properties
    
    private let stackView = UIStackView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    private let indicator = UIActivityIndicatorView()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    init(frame: CGRect, image: UIImage? = nil, title: String? = nil, content: String? = nil) {
        super.init(frame: frame)
        imageView.image = image
        titleLabel.text = title
        contentLabel.text = content
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
    
    // MARK: Private

    private func commonInit() {
        isExclusiveTouch = true
        setupViews()
    }
    
    private func setupViews() {
        // StackView
        stackView.alpha = 0
        stackView.spacing = 4
        stackView.isHidden = true
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        // ImageView
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 108)
        ])
        // TitleLabel
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .primary
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        stackView.addArrangedSubview(titleLabel)
        // ContentLabel
        contentLabel.numberOfLines = 0
        contentLabel.textColor = .primary
        contentLabel.textAlignment = .center
        contentLabel.font = .systemFont(ofSize: 13, weight: .medium)
        stackView.addArrangedSubview(contentLabel)
        // Indicator
        indicator.alpha = 0
        indicator.isHidden = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func animateIndicator(isHidden: Bool) {
        // NOTE: Start activity indicator.
        if !isHidden {
            indicator.startAnimating()
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.indicator.alpha = isHidden ? 0 : 1
                       },
                       completion: { _ in
                        self.indicator.isHidden = isHidden
                        // NOTE: Stop activity indicator animation when finish animation.
                        if isHidden {
                            self.indicator.stopAnimating()
                        }
                       })
    }
    
    private func animateStackView(isHidden: Bool) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.stackView.alpha = isHidden ? 0 : 1
                       },
                       completion: { _ in
                        self.stackView.isHidden = isHidden
                       })
    }
    
    // MARK: Public
    
    func setState(of state: State) {
        isHidden = state == .none
        switch state {
        case .none:
            animateIndicator(isHidden: true)
            animateStackView(isHidden: true)
        case .loading:
            animateIndicator(isHidden: false)
            animateStackView(isHidden: true)
        case .empty:
            animateIndicator(isHidden: true)
            animateStackView(isHidden: false)
        }
    }
}
