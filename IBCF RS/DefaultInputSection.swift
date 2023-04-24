//
//  DefaultInputSection.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 25/03/23.
//

import UIKit

final class DefaultInputSection: UIView {
    private lazy var mainContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        view.addSubviews(titleLabel, textField)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.height.equalTo(48)
        }
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .secondaryLabel
        
        return titleLabel
    }()
    
    lazy var textField: DefaultTextField = {
        let textField = DefaultTextField()
        
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    init(
        frame: CGRect,
        title: String,
        placeholder: String? = nil
    ) {
        super.init(frame: frame)
        titleLabel.text = title
        textField.placeholder = placeholder
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DefaultInputSection {
    func makeUI() {
        addSubview(mainContainerView)
        mainContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension DefaultInputSection {
    func configure(
        frame: CGRect,
        title: String,
        placeholder: String? = nil
    ) {
        titleLabel.text = title
        textField.placeholder = placeholder
    }
    
    func configureTargetForTextField(
        target: UIViewController,
        selector: Selector
    ) {
        textField.addTarget(target, action: selector, for: .editingChanged)
    }
}
