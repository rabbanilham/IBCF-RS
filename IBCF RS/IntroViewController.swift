//
//  IntroViewController.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 23/02/23.
//

import UIKit
import SafariServices
import SnapKit

final class IntroViewController: UIViewController {
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.contentInset.bottom = 144
        scrollView.addSubviews(exclamationImageView, introLabel)
        
        return scrollView
    }()
    
    private lazy var exclamationImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill"))
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var introLabel: UILabel = {
        let label = UILabel()
        label.text = """
Bacalah petunjuk berikut sebelum melanjutkan. Penting bagi Anda untuk membaca petunjuk di bawah demi keakuratan sistem rekomendasi dalam memberikan saran.\n
Tujuan dari sistem rekomendasi ini adalah memberikan rekomendasi mata kuliah yang akan diambil pada semester 5 ke atas bagi mahasiswa. Anda akan memberikan rating untuk tiap mata kuliah yang Anda ambil di semester 1 sampai 4.\n
Setiap pertanyaan yang diberikan yang diberikan dalam kuesioner ini adalah "Berapa rating yang Anda berikan untuk mata kuliah <nama suatu mata kuliah>?". Nilai Rating yang Anda berikan adalah bilangan bulat yang berkisar antara 0 sampai 5, dengan rincian:\n
0 = Tidak/Tidak pernah/belum mengambil mata kuliah tersebut\n
1 = Sangat tidak menyukai mata kuliah tersebut\n
2 = Tidak menyukai mata kuliah tersebut\n
3 = Biasa saja/netral\n
4 = Menyukai mata kuliah tersebut\n
5 = Sangat menyukai mata kuliah tersebut\n
Yang dimaksud "menyukai" suatu mata kuliah adalah:\n
• Anda meminati mata kuliah tersebut dari segi materi yang diajarkan (contoh: Anda menyukai mata kuliah "Aljabar Linier" karena anda menyukai materi yang berhubungan dengan aljabar, maka Anda memberi nilai rating 4)\n
• Anda menanggap suatu mata kuliah mudah dan menyenangkan (contoh: Anda sangat menyukai mata kuliah "Algoritma Pemrograman" karena anda senang dan berpengalaman coding, maka Anda memberi nilai 5)\n
Dimohon untuk tidak mengartikan "menyukai" suatu mata kuliah dikarenakan faktor berikut:\n
• Anda menyukai suatu mata kuliah karena dosen pengampu mata kuliah tersebut adalah dosen favorit Anda (contoh: Dosen A adalah favorit saya, jadi saya menyukai mata kuliah yang beliau ampu)\n
• Anda menyukai suatu mata kuliah karena cara dosen pengampu mengajar mudah dipahami (contoh: "Dosen B kalau mengajar mudah dimengerti ya, Saya jadi suka mata kuliah X")\n
• Anda menyukai suatu mata kuliah karena alasan yang cenderung negatif dari pelaksanaan kelas mata kuliah tersebut (contoh: sering jam kosong, sering bubar lebih dulu)\n
• Anda menganggap suatu mata kuliah cenderung mudah mendapat nilai bagus dari dosen pengampu mata kuliah tersebut\n
• Serta alasan-alasan lainnya yang tidak berhubungan dengan alasan yang disebutkan di atas\n
Dimohon juga untuk tidak mengartikan "tidak menyukai" dikarenakan faktor yang berlawanan dari poin-poin yang disebutkan di atas (contoh: "Saya tidak menyukai mata kuliah X karena Saya tidak klop dengan cara Dosen A menyampaikan materi"). Pemberian nilai rating adalah murni karena alasan yang disebutkan sebelumnya.\n
Sekarang Anda dapat melanjutkan atau pelajari lebih lanjut tentang Item-Based Collaborative Filtering pada sistem rekomendasi.
"""
        label.setLineSpacing(to: 5)
        label.numberOfLines = 0
        label.textAlignment = .left
        
        
        return label
    }()
    
    private lazy var buttonsWrapperView: UIView = {
        let effect = UIBlurEffect(style: .prominent)
        let view = UIVisualEffectView(effect: effect)
        view.contentView.addSubviews(learnMoreButton, continueButton)
        
        return view
    }()
    
    private lazy var learnMoreButton: UIButton = {
        let button = UIButton(configuration: .borderless())
        button.setTitle("Pelajari Lebih Lanjut", for: .normal)
        
        
        return button
    }()
    
    private lazy var continueButton: DefaultButton = {
        let button = DefaultButton(title: "Lanjutkan", type: .filled, size: .regular)
        button.isEnabled = false
        
        return button
    }()
    
    private lazy var feedbackGenerator: UIImpactFeedbackGenerator = {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        
        return generator
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        continueButton.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
}

private extension IntroViewController {
    func makeUI() {
        navigationItem.title = "Tentang Sistem Rekomendasi Ini"
        navigationItem.largeTitleDisplayMode = .never
        
        view.backgroundColor = .systemBackground
        view.addSubviews(scrollView, buttonsWrapperView)
        
        scrollView.delegate = self
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        buttonsWrapperView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        exclamationImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        introLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.top.equalTo(exclamationImageView.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
        }
        
        continueButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom)
            make.leading.trailing.equalTo(introLabel)
            make.height.equalTo(48)
        }
        
        learnMoreButton.snp.makeConstraints { make in
            make.bottom.equalTo(continueButton.snp.top).offset(-8)
            make.leading.trailing.equalTo(introLabel)
            make.height.equalTo(continueButton)
            make.top.equalToSuperview().inset(8)
        }
        
        learnMoreButton.addTarget(self, action: #selector(didTapLearnMoreButton), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
    }
    
    @objc private func didTapLearnMoreButton() {
        if let url = URL(string: "https://en.wikipedia.org/wiki/Item-item_collaborative_filtering") {
            let config = SFSafariViewController.Configuration()
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    @objc func didTapContinueButton() {
        navigationController?.pushViewController(RatingSubmissionViewController(currentSemester: 1), animated: true)
    }
}

extension IntroViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height
        let scrollOffset = scrollView.contentOffset.y
        if (scrollOffset + scrollViewHeight >= scrollContentSizeHeight) {
            continueButton.isEnabled = true
            feedbackGenerator.impactOccurred()
        }
    }
}
