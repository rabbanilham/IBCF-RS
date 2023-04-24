//
//  CheckIDViewController.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 22/03/23.
//

import UIKit

final class CheckIDViewController: UIViewController {
    private lazy var mainContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.addSubviews(checkLabel, inputTextField, checkButton)
        
        return view
    }()
    
    private lazy var checkLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Sebelum memulai, akan dilakukan pengecekan apakah Anda sudah pernah menggunakan sistem rekomendasi ini. Masukkan NPM Anda dengan lengkap."
        label.setLineSpacing(to: 5, alignment: .center)
        
        return label
    }()
    
    private lazy var inputTextField: DefaultTextField = {
        let textField = DefaultTextField()
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .numberPad
        textField.placeholder = "Contoh: 140110190043"
        textField.textAlignment = .center
        
        return textField
    }()
    
    private lazy var checkButton: DefaultButton = {
        let button = DefaultButton(title: "Cek", type: .filled, size: .regular)
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapCheckButton), for: .touchUpInside)
        
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        hideKeyboardWhenTappedAround()
    }
}

private extension CheckIDViewController {
    func makeUI() {
        navigationItem.title = "Pengecekan"
        view.backgroundColor = .systemBackground
        view.addSubview(mainContainerView)
        mainContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        checkLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.layoutMarginsGuide)
        }
        
        inputTextField.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalTo(self.view.layoutMarginsGuide)
            make.height.equalTo(48)
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom).offset(16)
            make.leading.trailing.equalTo(self.view.layoutMarginsGuide)
            make.height.equalTo(48)
        }
        
        inputTextField.addTarget(self, action: #selector(checkNPMValidity), for: .editingChanged)
    }
    
    func goToNextPage(user: FBUser? = nil) {
        navigationController?.dismiss(animated: false)
        let viewController = RegisterViewController()
        viewController.user = user
        viewController.userId = inputTextField.text
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showDataExistAlert(_ data: FBUser?) {
        let cancel = UIAlertAction(title: "Batal", style: .default)
        let proceed = UIAlertAction(title: "Lanjutkan", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.goToNextPage(user: data)
        }
        let alert = UIAlertController(
            title: "Sudah Pernah Menggunakan Sistem",
            message: "Anda sudah pernah menggunakan sistem rekomendasi ini sebelumnya. Jika Anda ingin menggunakan sistem rekomendasi ini lagi, data rating yang sudah pernah digunakan sebelumnya akan digantikan dengan yang terbaru.",
            preferredStyle: .alert
        )
        alert.addAction(cancel)
        alert.addAction(proceed)
        self.dismiss(animated: false) {
            self.present(alert, animated: true)
        }
    }
    
    @objc func didTapCheckButton() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)
        feedbackGenerator.prepare()
        let loadingViewController = LoadingViewController()
        loadingViewController.modalPresentationStyle = .overCurrentContext
        navigationController?.present(loadingViewController, animated: false)
        if let id = inputTextField.text {
            FBUtilities.shared.isUserExist(id: id) { [weak self] isExist, user, error in
                guard let self = self, error == nil else { return }
                if isExist {
                    self.showDataExistAlert(user)
                    feedbackGenerator.impactOccurred()
                } else {
                    self.goToNextPage()
                }
            }
        }
    }
    
    @objc func checkNPMValidity() {
        if let text = inputTextField.text {
            checkButton.isEnabled = text.isValidNPM
            inputTextField.layer.borderColor = text.isValidNPM ? UIColor.systemGray5.cgColor : UIColor.systemRed.cgColor
        }
    }
}
