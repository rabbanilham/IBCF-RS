//
//  SubmissionCompleteViewController.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 01/04/23.
//

import UIKit

final class SubmissionCompleteViewController: UIViewController {
    private lazy var mainContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        
        view.addSubviews(successImageView, successTitleLabel, successDescriptionLabel, dismissButton)
        successImageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(successImageView.snp.width)
            make.top.equalTo(view.layoutMarginsGuide)
        }
        
        successTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(successImageView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
        }
        
        successDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(successTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(successTitleLabel)
        }
        
        dismissButton.snp.makeConstraints { make in
            make.width.bottom.equalTo(view.layoutMarginsGuide)
            make.centerX.equalToSuperview()
        }
        
        return view
    }()
    
    private lazy var successImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "submission_complete")
        
        return imageView
    }()
    
    private lazy var successTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Pengumpulan Data Berhasil!"
        
        return label
    }()
    
    private lazy var successDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Data Anda berhasil dimasukkan ke dalam database dan akan digunakan dalam perhitungan pemberian rekomendasi selanjutnya. Terima kasih atas kontribusi Anda!"
        label.setLineSpacing(to: 5, alignment: .center)
        
        return label
    }()
    
    private lazy var dismissButton: DefaultButton = {
        let button = DefaultButton(title: "Kembali Ke Home", type: .filled, size: .regular)
        
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
    }
}

private extension SubmissionCompleteViewController {
    func makeUI() {
        navigationItem.hidesBackButton = true
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(mainContainerView)
        mainContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dismissButton.addTarget(self, action: #selector(didTapDismissButton), for: .touchUpInside)
    }
    
    @objc func didTapDismissButton() {
//        navigationController?.popToRootViewController(animated: true)
        let vc = SystemExplanationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
