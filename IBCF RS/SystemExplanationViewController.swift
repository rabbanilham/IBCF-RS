//
//  SystemExplanationViewController.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 09/04/23.
//

import SwiftMath
import UIKit

final class SystemExplanationViewController: UIViewController {
    
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = true
        
        return scrollView
    }()
    
    private lazy var firstStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .leading
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 16
        
        view.addArrangedSubviews(
            introLabel,
            dataSubmissionLabel,
            dataPreprocessingLabel,
            similarityValueLabel,
            similarityFormulaLabel,
            similarityFormulaExplanationView,
            similarityValue2Label,
            similarityFormula2Label,
            similarityFormula2ExplanationView,
            similarityValue3Label
        )
        
        for subview in view.arrangedSubviews {
            subview.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(16)
                make.trailing.equalToSuperview().offset(-16)
            }
        }
        
        return view
    }()
    
    private lazy var introLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Sistem rekomendasi mata kuliah pilihan bagi mahasiswa S-1 Matematika Universitas Padjadjaran ini menggunakan metode Item-Based Collaborative Filtering. Proses yang terjadi dalam pemberian rekomendasi dijelaskan sebagai berikut:"
        label.setLineSpacing(to: 5)
        
        return label
    }()
    
    private lazy var dataSubmissionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        let title = NSMutableAttributedString(
            string: "Pengumpulan Data",
            attributes: [
                .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
                .paragraphStyle: style
            ]
        )
        let description = "\nData yang dikumpulkan berupa dataset mengenai spesifikasi mata kuliah dan data penilaian user (mahasiswa) terhadap item (mata kuliah) dengan rentang penilaian 0 sampai 5. Dataset diambil langsung dari mahasiswa Program Studi S-1 Matematika Universitas Padjadjaran angkatan 2019 dan 2020."
        title.append(NSAttributedString(string: description, attributes: [.paragraphStyle: style]))
        label.attributedText = title
        
        return label
    }()
    
    private lazy var dataPreprocessingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        let title = NSMutableAttributedString(
            string: "Preprocessing Data",
            attributes: [
                .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
                .paragraphStyle: style
            ]
        )
        let description = "\nData yang sudah dikumpulkan kemudian dibersihkan dari data yang tidak relevan dan data duplikat."
        title.append(NSAttributedString(string: description, attributes: [.paragraphStyle: style]))
        label.attributedText = title
        
        return label
    }()
    
    private lazy var similarityValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        let title = NSMutableAttributedString(
            string: "Perhitungan Nilai Kemiripan",
            attributes: [
                .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
                .paragraphStyle: style
            ]
        )
        let description = "\nNilai kemiripan antar mata kuliah dihitung dengan adjusted cosine similarity, yaitu dengan menganggap item-item adalah vektor-vektor dalam ruang berdimensi (banyaknya baris pada matriks rating) dan mengukur kemiripan antar item dengan menghitung cosinus antara vektor-vektor tersebut (Sarwar et al., 2001).  Adjusted cosine similarity dapat dihitung dengan rumus"
        title.append(NSAttributedString(string: description, attributes: [.paragraphStyle: style]))
        label.attributedText = title
        
        return label
    }()
    
    private lazy var similarityFormulaLabel: MTMathUILabel = {
        let label = MTMathUILabel()
        label.latex = "sim(i,j) = \\cos(\\vec{i}, \\vec{j}) = \\frac{\\vec{i} \\cdot \\vec{j}}{\\| \\vec{i} \\| \\ast \\| \\vec{j} \\|}"
        
        return label
    }()
    
    private lazy var similarityFormulaExplanationView: UIView = {
        let view = createSymbolsExplanationLines(
            title: "Keterangan:",
            symbols: [
                "sim(i,j)",
                "\\vec{i}",
                "\\vec{j}"
            ],
            explanations: [
                "Nilai kemiripan antara item i dan j",
                "vektor item i",
                "vektor item j"
            ]
        )
        
        return view
    }()
    
    private lazy var similarityValue2Label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Adjusted cosine similarity juga dapat dihitung dengan rumus"
        label.setLineSpacing(to: 5)
        
        return label
    }()
    
    private lazy var similarityFormula2Label: MTMathUILabel = {
        let label = MTMathUILabel()
        label.fontSize = 15
        label.latex = """
sim(i,j) =
\\frac
{\\sum_{u \\in U} (R_{u,i} - \\overline{R}_{u}) - (R_{u,j} - \\overline{R}_{u})}
{\\sqrt{\\sum_{u \\in U} (R_{u,i} - \\overline{R}_{u})^2} \\sqrt{\\sum_{u \\in U} (R_{u,j} - \\overline{R}_{u})^2}}
"""
        
        return label
    }()
    
    private lazy var similarityFormula2ExplanationView: UIView = {
        let view = createSymbolsExplanationLines(
            title: "Keterangan:",
            symbols: [
                "\\overline{R}_{u}",
                "R_{u,i}",
                "R_{u,j}"
            ],
            explanations: [
                "Rata-rata rating dari user u",
                "Rating user u untuk item i",
                "Rating user u untuk item j"
            ]
        )
        
        return view
    }()
    
    private lazy var similarityValue3Label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Nilai kemiripan berkisar antara -1 sampai dengan 1, di mana semakin besar nilainya maka semakin mirip antara 2 item yang dihitung nilai kemiripannya. Sebagai contoh, lihat tabel rating berikut ini."
        label.setLineSpacing(to: 5)
        
        return label
    }()
    
    private lazy var ratingTableImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "rating_table_1")
        
        return imageView
    }()
    
    private lazy var similarityValue4Label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Tiap rating yang diberikan oleh mahasiswa kemudian dikurangi oleh rata-rata nilai rating yang diberikan oleh mahasiswa tersebut, sehingga tabel rating menjadi seperti berikut."
        label.setLineSpacing(to: 5)
        
        return label
    }()
    
    private lazy var ratingTable2ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "rating_table_2")
        
        return imageView
    }()
    
    private lazy var secondStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .leading
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 16
        
        view.addArrangedSubviews(
            similarityValue5Label,
            similarityFormula3Label,
            similarityValue6Label,
            predictionValueLabel,
            predictionFormulaLabel,
            predictionFormulaExplanationView
        )
        
        for subview in view.arrangedSubviews {
            subview.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(16)
                make.trailing.equalToSuperview().offset(-16)
            }
        }
        
        return view
    }()
    
    private lazy var similarityValue5Label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = """
Perhitungan cosine similarity menganggap rating yang diberikan oleh pengguna sebagai vektor dalam ruang berdimensi karena teknik ini memanfaatkan sifat geometris dari vektor untuk menghitung kesamaan antara dua item.\n
Dalam representasi vektor, setiap item (dalam konteks penelitian ini adalah mata kuliah) didefinisikan oleh sebuah vektor, di mana setiap dimensi mewakili fitur atau atribut tertentu dari item tersebut. Nilai rating yang diberikan oleh pengguna untuk item tersebut dapat dianggap sebagai bobot atau koefisien pada masing-masing dimensi pada vektor item.\n
Karena mahasiswa A dan B sama-sama memberi rating untuk dua mata kuliah MK1 dan MK2, maka dari rating-rating tersebut dapat direpresentasikan ke dalam vektor-vektor (-1, -0,5) dan (1, 0,5). Maka nilai kemiripan antara mata kuliah MK1 dan MK2 dengan menggunakan adjusted cosine similarity adalah
"""
        label.setLineSpacing(to: 5)
        
        return label
    }()
    
    private lazy var similarityFormula3Label: MTMathUILabel = {
        let label = MTMathUILabel()
        label.fontSize = 15
        label.latex = """
sim(MK1,MK2) =
\\frac
{(-1 . 1) (-0,5 . 0,5)}
{\\sqrt{(-1)^2 + (-0,5)^2} \\sqrt{(1)^2 + (0,5)^2}}
"""
        
        return label
    }()
    
    private lazy var similarityValue6Label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Dan didapat nilai kemiripan antara MK1 dan MK2 adalah 2,2306."
        label.setLineSpacing(to: 5)
        
        return label
    }()
    
    private lazy var predictionValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        let title = NSMutableAttributedString(
            string: "Perhitungan Nilai Prediksi",
            attributes: [
                .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
                .paragraphStyle: style
            ]
        )
        let description = "\nNilai prediksi rating untuk mata kuliah yang belum pernah diambil dihitung dengan adjusted weighted sum, yang dapat dihitung dengan rumus"
        title.append(NSAttributedString(string: description, attributes: [.paragraphStyle: style]))
        label.attributedText = title
        
        return label
    }()
    
    private lazy var predictionFormulaLabel: MTMathUILabel = {
        let label = MTMathUILabel()
        label.fontSize = 20
        label.latex = """
P_{u,j} =
\\overline{R}_{j} +
\\frac
{\\sum_{i = 1}^{n} {(R_{u, i} - \\overline{R}_{i}) sim(i, j)}}
{\\sum_{i = 1}^{n} |sim(i, j)|}
"""
        
        return label
    }()
    
    private lazy var predictionFormulaExplanationView: UIView = {
        let view = createSymbolsExplanationLines(
            title: "Keterangan:",
            symbols: [
                "sim(i, j)",
                "\\overline{R}_{i}",
                "\\overline{R}_{j}",
                "R_{u,i}"
            ],
            explanations: [
                "Nilai kemiripan antara item i dan item j",
                "Rata-rata rating untuk item i",
                "Rata-rata rating untuk item j",
                "Rating dari user u untuk item i"
            ]
        )
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
}

private extension SystemExplanationViewController {
    func makeUI() {
        navigationItem.hidesBackButton = false
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainScrollView.addSubviews(
            firstStackView,
            ratingTableImageView,
            similarityValue4Label,
            ratingTable2ImageView,
            secondStackView
        )
        
        firstStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalTo(view)
//            make.bottom.equalToSuperview().offset(-8)
        }
        
        let ratingTableScale = (ratingTableImageView.image?.size.height ?? 0) / (ratingTableImageView.image?.size.width ?? 0)
        ratingTableImageView.snp.makeConstraints { make in
            make.top.equalTo(firstStackView.snp.bottom).offset(16)
//            make.centerX.equalToSuperview()
            make.leading.equalTo(view).offset(64)
            make.trailing.equalTo(view).offset(-64)
            make.height.equalTo(ratingTableImageView.snp.width).multipliedBy(ratingTableScale)
//            make.bottom.equalToSuperview().offset(-8)
        }
        
        similarityValue4Label.snp.makeConstraints { make in
            make.top.equalTo(ratingTableImageView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
        }
        
        let ratingTable2Scale = (ratingTable2ImageView.image?.size.height ?? 0) / (ratingTable2ImageView.image?.size.width ?? 0)
        ratingTable2ImageView.snp.makeConstraints { make in
            make.top.equalTo(similarityValue4Label.snp.bottom).offset(16)
//            make.centerX.equalToSuperview()
            make.leading.equalTo(view).offset(64)
            make.trailing.equalTo(view).offset(-64)
            make.height.equalTo(ratingTableImageView.snp.width).multipliedBy(ratingTable2Scale)
        }
        
        secondStackView.snp.makeConstraints { make in
            make.top.equalTo(ratingTable2ImageView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(view)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
}

private extension SystemExplanationViewController {
    func createSymbolsExplanationLines(
        title: String,
        symbols: [String],
        explanations: [String]
    ) -> UIView {
        guard symbols.count == explanations.count else { return UIView() }
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        
        let titleLabel = UILabel()
        titleLabel.text = title
        stackView.addArrangedSubview(titleLabel)
        
        for index in 0...symbols.count - 1 {
            let symbol = symbols[index]
            let explanation = explanations[index]
            
            let symbolLabel = MTMathUILabel()
            symbolLabel.latex = symbol
            
            let explanationLabel = UILabel()
            explanationLabel.text = ": " + explanation
            explanationLabel.setLineSpacing(to: 5)
            
            let rowView = UIView()
            rowView.backgroundColor = .systemBackground
            rowView.addSubviews(symbolLabel, explanationLabel)
            symbolLabel.snp.makeConstraints { make in
                make.top.leading.equalToSuperview().offset(4)
            }
            explanationLabel.snp.makeConstraints { make in
                make.top.equalTo(rowView).offset(2)
                make.leading.equalToSuperview().offset(100)
                make.bottom.trailing.equalToSuperview().offset(-4)
            }
            
            stackView.addArrangedSubview(rowView)
        }
        
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return view
    }
    
    func createMathLabel(latex: String) -> MTMathUILabel {
        let label = MTMathUILabel()
        label.latex = latex
        
        return label
    }
}
