//
//  DefaultTextField.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 25/03/23.
//

import UIKit

final class DefaultTextField: UITextField {
    var textPadding = UIEdgeInsets(
        top: 0,
        left: 20,
        bottom: 0,
        right: 20
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.rightViewRect(forBounds: bounds)
        return rect.offsetBy(dx: -24, dy: 0)
    }

    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.clearButtonRect(forBounds: bounds)
        return rect.offsetBy(dx: -24, dy: 0)
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemGray5.cgColor
        layer.cornerCurve = .continuous
        layer.cornerRadius = 16
        clipsToBounds = true
        backgroundColor = .systemBackground
        clearButtonMode = .whileEditing
        
        self.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
    
    func changeBorderColor(to color: CGColor?) {
        layer.borderColor = color
    }
    
    func setPlaceholder(placeholder: String) {
        self.placeholder = placeholder
    }
    
    func setForPasswordTextfield() {
        clearButtonMode = .never
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        rightView = button
        rightViewMode = .always
    }

    @objc func togglePasswordView(_ sender: UIButton) {
        isSecureTextEntry.toggle()
        sender.isSelected.toggle()
    }
}
