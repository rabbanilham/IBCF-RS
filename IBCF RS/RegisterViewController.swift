//
//  RegisterViewController.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 24/03/23.
//

import UIKit

final class RegisterViewController: UIViewController {
    private lazy var mainContainerView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        
        view.addSubviews(mainStackView, continueButton)
        mainStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(36)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
            make.bottom.equalToSuperview().offset(-UIScreen.main.bounds.height)
        }
        
        return view
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 24
        stackView.addArrangedSubviews(nameInputSection, emailInputSection, phoneNumberInputSection)
        
        return stackView
    }()
    
    private lazy var nameInputSection = DefaultInputSection(
        frame: .zero,
        title: "NAMA LENGKAP",
        placeholder: "Minimal 10 karakter"
    )
    
    private lazy var emailInputSection = DefaultInputSection(
        frame: .zero,
        title: "EMAIL",
        placeholder: "nama19000@mail.unpad.ac.id"
    )
    
    private lazy var phoneNumberInputSection = DefaultInputSection(
        frame: .zero,
        title: "NOMOR TELEPON",
        placeholder: "Diutamakan nomor WhatsApp"
    )
    
    private lazy var continueButton: DefaultButton = {
        let button = DefaultButton(title: "Lanjutkan", type: .filled, size: .regular)
        button.isEnabled = false
        button.addAction(didTapContinueButton(), for: .touchUpInside)
        
        return button
    }()
    
    private var validParameterForButton = [false, false, false] {
        didSet {
            continueButton.isEnabled = !validParameterForButton.contains(false)
        }
    }
    
    var user: FBUser?
    var userId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        configureView()
        
//        let ratings = [
//            FBRating(userId: "1", itemId: "3", value: 4.0, createdAt: nil),
//            FBRating(userId: "1", itemId: "4", value: 5.0, createdAt: nil),
//            FBRating(userId: "1", itemId: "5", value: 5.0, createdAt: nil),
//            FBRating(userId: "2", itemId: "1", value: 4.0, createdAt: nil),
//            FBRating(userId: "2", itemId: "2", value: 5.0, createdAt: nil),
//            FBRating(userId: "2", itemId: "5", value: 3.0, createdAt: nil),
//            FBRating(userId: "3", itemId: "1", value: 5.0, createdAt: nil),
//            FBRating(userId: "3", itemId: "3", value: 4.0, createdAt: nil),
//            FBRating(userId: "3", itemId: "4", value: 1.0, createdAt: nil),
//            FBRating(userId: "4", itemId: "1", value: 5.0, createdAt: nil),
//            FBRating(userId: "4", itemId: "2", value: 4.0, createdAt: nil),
//            FBRating(userId: "4", itemId: "4", value: 1.0, createdAt: nil),
//            FBRating(userId: "5", itemId: "2", value: 4.0, createdAt: nil),
//            FBRating(userId: "5", itemId: "6", value: 5.0, createdAt: nil)
//        ]
//
//        let recommenderSystem = IBCFRecommenderSystem(ratings: ratings)
//        print("the \(recommenderSystem.ratingAverage(by: .user))")
//        print("the \(recommenderSystem.ratingAverage(by: .item))")
//
//        let itemIds = ["1", "2", "3", "4", "5"]
//        itemIds.forEach { itemId in
//            recommenderSystem.weightedSum(userId: "1", itemId: itemId, isAdjusted: false)
//            recommenderSystem.weightedSum(userId: "1", itemId: itemId, isAdjusted: true)
//            recommenderSystem.weightedSum(userId: "2", itemId: itemId, isAdjusted: false)
//            recommenderSystem.weightedSum(userId: "2", itemId: itemId, isAdjusted: true)
//            recommenderSystem.weightedSum(userId: "3", itemId: itemId, isAdjusted: false)
//            recommenderSystem.weightedSum(userId: "3", itemId: itemId, isAdjusted: true)
//            recommenderSystem.weightedSum(userId: "4", itemId: itemId, isAdjusted: false)
//            recommenderSystem.weightedSum(userId: "4", itemId: itemId, isAdjusted: true)
//            recommenderSystem.weightedSum(userId: "5", itemId: itemId, isAdjusted: false)
//            recommenderSystem.weightedSum(userId: "5", itemId: itemId, isAdjusted: true)
//        }
    }
}

private extension RegisterViewController {
    func makeUI() {
        hideKeyboardWhenTappedAround()
        navigationItem.title = "Data Diri"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground
        view.addSubview(mainContainerView)
        mainContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        continueButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(48)
        }
    }
    
    func configureView() {
        nameInputSection.textField.autocapitalizationType = .words
        emailInputSection.textField.keyboardType = .emailAddress
        emailInputSection.textField.autocapitalizationType = .none
        phoneNumberInputSection.textField.keyboardType = .numberPad
        nameInputSection.configureTargetForTextField(target: self, selector: #selector(didChangeNameTextField))
        emailInputSection.configureTargetForTextField(target: self, selector: #selector(didChangeEmailTextField))
        phoneNumberInputSection.configureTargetForTextField(target: self, selector: #selector(didChangePhoneNumberTextField))
        
        if let user = user {
            nameInputSection.textField.text = user.name
            emailInputSection.textField.text = user.email
            phoneNumberInputSection.textField.text = user.phoneNumber
            continueButton.isEnabled = true
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}

private extension RegisterViewController {
    func didTapContinueButton() -> UIAction {
        let action = UIAction { [weak self] _ in
            guard let self = self else { return }
            if let id = self.userId,
               let name = self.nameInputSection.textField.text,
               let email = self.emailInputSection.textField.text,
               let phoneNumber = self.phoneNumberInputSection.textField.text {
                DefaultUtilities.shared.setCurrentUser(id: id, name: name, email: email, phoneNumber: phoneNumber)
            }
            let viewController = IntroViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        return action
    }
    
    @objc func didChangeNameTextField() {
        if let text = nameInputSection.textField.text {
            if text.count >= 10 {
                nameInputSection.textField.changeBorderColor(to: UIColor.systemGray5.cgColor)
                validParameterForButton[0] = true
            } else {
                nameInputSection.textField.changeBorderColor(to: UIColor.systemRed.cgColor)
                validParameterForButton[0] = false
            }
        }
    }
    
    @objc func didChangeEmailTextField() {
        if let text = emailInputSection.textField.text {
            if text.isValidEmail {
                emailInputSection.textField.changeBorderColor(to: UIColor.systemGray5.cgColor)
                validParameterForButton[1] = true
            } else {
                emailInputSection.textField.changeBorderColor(to: UIColor.systemRed.cgColor)
                validParameterForButton[1] = false
            }
        }
    }
    
    @objc func didChangePhoneNumberTextField() {
        if let text = phoneNumberInputSection.textField.text {
            if text.isValidPhoneNumber {
                phoneNumberInputSection.textField.changeBorderColor(to: UIColor.systemGray5.cgColor)
                validParameterForButton[2] = true
            } else {
                phoneNumberInputSection.textField.changeBorderColor(to: UIColor.systemRed.cgColor)
                validParameterForButton[2] = false
            }
        }
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset: UIEdgeInsets = self.mainContainerView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        mainContainerView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        mainContainerView.contentInset = contentInset
    }
}
