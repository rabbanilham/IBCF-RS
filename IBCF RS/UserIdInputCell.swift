//
//  UserIdInputCell.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 27/04/23.
//

import UIKit

protocol UserIdInputCellDelegate: AnyObject {
    func didFinishBuildUserId(_ id: String, row: Int)
}

final class UserIdInputCell: UITableViewCell {
    private lazy var mainContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.masksToBounds = false
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 7
        
        view.addSubviews(generationChoiceButton, userIdTextField, userIdResultLabel)
        
        return view
    }()
    
    private lazy var generationChoiceButton: DefaultButton = {
        let button = DefaultButton(title: "Pilih Angkatan", type: .bordered, size: .regular)
        button.showsMenuAsPrimaryAction = true
        
        return button
    }()
    
    private lazy var userIdTextField: DefaultTextField = {
        let textField = DefaultTextField()
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .numberPad
        textField.placeholder = "4 Digit terakhir NPM"
        textField.textAlignment = .center
        
        return textField
    }()
    
    private lazy var userIdResultLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.numberOfLines = 0
        label.text = "_"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    private let generationChoices = ["2019", "2020"]
    private var generationChosen = ""
    private var userIdLastDigits = ""
    private var perfectUserId = ""
    
    weak var delegate: UserIdInputCellDelegate?
    var row: Int?
    var allUserIds: [String?]?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
}

private extension UserIdInputCell {
    func makeUI() {
        selectionStyle = .none
        contentView.addSubview(mainContainerView)
        mainContainerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.layoutMarginsGuide)
        }
        
        generationChoiceButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(contentView.snp.centerX).offset(-16)
        }
        
        userIdTextField.snp.makeConstraints { make in
            make.top.height.equalTo(generationChoiceButton)
            make.leading.equalTo(contentView.snp.centerX).offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        userIdResultLabel.snp.makeConstraints { make in
            make.top.equalTo(generationChoiceButton.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.bottom.equalToSuperview().offset(-16)
        }
        
        userIdTextField.addTarget(self, action: #selector(didChangeUserIdLastDigits), for: .editingChanged)
        makeChoiceButtonOptions()
    }
    
    func makeChoiceButtonOptions() {
        var children = [UIAction]()
        
        for choice in generationChoices {
            let choiceMenu = UIAction(title: choice) { [weak self] _ in
                guard let self = self else { return }
                self.generationChoiceButton.setTitle(choice, for: .normal)
                self.generationChosen = String(choice.suffix(2))
                if !self.userIdLastDigits.isEmpty {
                    self.perfectUserId = "140110" + self.generationChosen + self.userIdLastDigits
                    let isUserIdExist = (self.allUserIds ?? []).contains(self.perfectUserId)
                    let suffix = isUserIdExist ? "ditemukan dalam database ✅" : "tidak ada dalam database ❌"
                    self.userIdResultLabel.text = self.perfectUserId + " \(suffix)"
                    if self.perfectUserId.count == 12, isUserIdExist {
                        self.delegate?.didFinishBuildUserId(self.perfectUserId, row: self.row ?? 0)
                    } else {
                        self.delegate?.didFinishBuildUserId("empty", row: self.row ?? 0)
                    }
                }
            }
            children.append(choiceMenu)
        }
        
        let menu = UIMenu(options: .displayInline, children: children)
        generationChoiceButton.menu = menu
    }
    
    @objc func didChangeUserIdLastDigits() {
        guard userIdTextField.text?.count ?? 0 < 5 else {
            userIdTextField.text = userIdLastDigits
            return
        }
        userIdLastDigits = userIdTextField.text ?? ""
        userIdTextField.layer.borderColor = userIdTextField.text?.count == 4 ? UIColor.secondarySystemBackground.cgColor : UIColor.systemRed.cgColor
        if !generationChosen.isEmpty {
            perfectUserId = "140110" + generationChosen + userIdLastDigits
            let isUserIdExist = (allUserIds ?? []).contains(perfectUserId)
            let suffix = isUserIdExist ? "ditemukan dalam database ✅" : "tidak ada dalam database ❌"
            userIdResultLabel.text = perfectUserId + " \(suffix)"
            if perfectUserId.count == 12, isUserIdExist {
                self.delegate?.didFinishBuildUserId(perfectUserId, row: row ?? 0)
            } else {
                self.delegate?.didFinishBuildUserId("empty", row: row ?? 0)
            }
        }
    }
}
