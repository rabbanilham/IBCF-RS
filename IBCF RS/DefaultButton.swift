//
//  DefaultButton.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 01/04/23.
//

import UIKit

final class DefaultButton: UIButton {
    enum ButtonType {
        case filled
        case bordered
        case ghost
    }
    
    var type: ButtonType?
    
    enum buttonSizeType: CGFloat {
        case regular = 48
        case small = 36
    }
    
    init(title: String, type: ButtonType, size: buttonSizeType) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        configure(size: size.rawValue, type: type)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setImageButton(image: String) {
        self.configuration?.image = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
        self.configuration?.imagePlacement = .leading
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if type == .bordered { layer.borderColor = UIColor.label.cgColor }
    }
}

private extension DefaultButton {
    func configure(size: CGFloat, type: ButtonType) {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerCurve = .continuous
        layer.cornerRadius = 16
        clipsToBounds = true
        heightAnchor.constraint(equalToConstant: size).isActive = true
        self.type = type
        switch type {
        case .filled:
            configuration = .filled()
        case .bordered:
            configuration = .borderless()
            tintColor = .label
            layer.borderColor = UIColor.label.cgColor
            layer.borderWidth = 1
        case .ghost:
            configuration = .plain()
        }
    }
}
