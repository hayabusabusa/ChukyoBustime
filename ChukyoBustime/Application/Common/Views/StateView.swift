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
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alpha = 0
        stackView.spacing = 4
        stackView.isHidden = true
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 108).isActive = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .lightGray
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        return titleLabel
    }()
    
    private lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.textColor = .lightGray
        contentLabel.textAlignment = .center
        contentLabel.font = .systemFont(ofSize: 14, weight: .regular)
        return contentLabel
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.alpha = 0
        indicator.isHidden = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let buttonStackView = UIStackView()
        buttonStackView.spacing = 8
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return buttonStackView
    }()
    
    private lazy var calendarButton: UIButton = {
        let calendarButton = UIButton()
        calendarButton.tintColor = .primary
        calendarButton.layer.borderWidth = 1
        calendarButton.layer.cornerRadius = 22
        calendarButton.layer.borderColor = UIColor.primary.cgColor
        calendarButton.setTitle(" カレンダー", for: .normal)
        calendarButton.setTitleColor(.primary, for: .normal)
        calendarButton.setImage(UIImage(named: "ic_calendar"), for: .normal)
        calendarButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        return calendarButton
    }()
    
    private lazy var timeTableButton: UIButton = {
        let timeTableButton = UIButton()
        timeTableButton.tintColor = .primary
        timeTableButton.layer.borderWidth = 1
        timeTableButton.layer.cornerRadius = 22
        timeTableButton.layer.borderColor = UIColor.primary.cgColor
        timeTableButton.setTitle(" 時刻表", for: .normal)
        timeTableButton.setTitleColor(.primary, for: .normal)
        timeTableButton.setImage(UIImage(named: "ic_time_table"), for: .normal)
        timeTableButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        return timeTableButton
    }()
    
    private lazy var spacer: UIView = {
        let spacer = UIView()
        spacer.backgroundColor = .clear
        spacer.heightAnchor.constraint(equalToConstant: 12).isActive = true
        return spacer
    }()
    
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

    private func commonInit() {
        isExclusiveTouch = true
        setupViews()
    }
}

// MARK: - Private method

extension StateView {
    
    private func setupViews() {
        // StackView
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        // ImageView
        stackView.addArrangedSubview(imageView)
        // TitleLabel
        stackView.addArrangedSubview(titleLabel)
        // ContentLabel
        stackView.addArrangedSubview(contentLabel)
        // Spacer
        stackView.addArrangedSubview(spacer)
        // ButtonStackView
        stackView.addArrangedSubview(buttonStackView)
        // CalendarButton
        buttonStackView.addArrangedSubview(calendarButton)
        // TimeTableButton
        buttonStackView.addArrangedSubview(timeTableButton)
        // Indicator
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
}

// MARK: - Public method

extension StateView {
    
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
