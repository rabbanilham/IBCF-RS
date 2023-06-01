//
//  XLSXTestViewController.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 23/03/23.
//

import UIKit
import SwiftXLSX

final class XLSXTestViewController: UITableViewController {
    var rows: [[String?]]?
    
    private lazy var uploadDataBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "arrow.up.doc")
        button.action = #selector(didTapUploadButton)
        button.target = self
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        loadXLSXFile()
    }
}

internal extension XLSXTestViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rows = rows {
            return rows.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "xlsxCell", for: indexPath)
        
        var config = cell.defaultContentConfiguration()
        var text = ""
        if let cellRow = rows?[row] {
            for string in cellRow {
                text.append(" \(string ?? "")")
            }
        }
        config.text = text
        cell.contentConfiguration = config
        
        return cell
    }
}

private extension XLSXTestViewController {
    func makeUI() {
        navigationItem.rightBarButtonItem = uploadDataBarButton
        navigationItem.title = "XLSX Import"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "xlsxCell")
    }
    
    func loadXLSXFile() {
        let fileRows = XLSXUtilities.shared.getRowsFromFile("responses")
        self.rows = fileRows
        tableView.reloadData()
//        createUsersExcelFile()
        createNewSimilarityValuesExcelFile()

    }
    
    func uploadXLSXDataToFirebase() {
        let loadingViewController = LoadingViewController()
        loadingViewController.modalPresentationStyle = .overCurrentContext
        navigationController?.present(loadingViewController, animated: false)
        
        var fileRows = XLSXUtilities.shared.getRowsFromFile("responses")
        fileRows.removeFirst()
        
        for fileRow in fileRows {
            let timestamp = fileRow[0]
            let nothing = fileRow[1]
            let email = fileRow[2]
            let name = fileRow[3]
            let id = fileRow[4]
            let peminatan = fileRow[37]
            let phoneNumber = fileRow.last
            var ratings = [FBRating]()
            var itemId = 1
            for (index, cell) in fileRow.enumerated() {
                if cell != timestamp, cell != nothing, cell != email, cell != name, cell != id, cell != peminatan, cell != phoneNumber {
                    if let cell = cell, let value = Double(cell), value > 0 {
                        switch index {
                        case 54:
                            let rating = FBRating(userId: id, itemId: "35", value: value, createdAt: Date())
                            ratings.append(rating)
                            
                        case 61:
                            let rating = FBRating(userId: id, itemId: "40", value: value, createdAt: Date())
                            ratings.append(rating)
                            
                        default:
                            if 50...55 ~= itemId {
                                let rating = FBRating(userId: id, itemId: String(itemId - 1), value: value, createdAt: Date())
                                ratings.append(rating)
                            } else if 57...100 ~= itemId {
                                let rating = FBRating(userId: id, itemId: String(itemId - 2), value: value, createdAt: Date())
                                ratings.append(rating)
                            } else {
                                let rating = FBRating(userId: id, itemId: String(itemId), value: value, createdAt: Date())
                                ratings.append(rating)
                            }
                        }
                    }
                    itemId += 1
                }
            }
            
            if let id = id, let name = name, let email = email, let phoneNumber = phoneNumber {
                print("called hehe")
                let user = FBUser(id: id, name: name, email: email, phoneNumber: phoneNumber, ratings: ratings)
                FBUtilities.shared.createUser(user: user) { error in
                    self.navigationController?.dismiss(animated: false, completion: {
                        self.showUploadFinishedAlert(error: error)
                    })
                }
            }
        }
    }
    
    func createUsersExcelFile() {
        FBUtilities.shared.getRatings { [weak self] ratings, error in
            guard let _ = self, let ratings = ratings?.sorted(by: { $0.userId ?? "" < $1.userId ?? "" }) else { return }
            let book = XWorkBook()
            let sheet = book.NewSheet("Sheet1")
            let allCourseId = FBCourse.allCourses().map({ $0.id })
            for (row, rating) in ratings.enumerated() {
                let userIdCell = sheet.AddCell(XCoords(row: row + 1, col: 1))
                let itemIdCell = sheet.AddCell(XCoords(row: row + 1, col: 2))
                let ratingCell = sheet.AddCell(XCoords(row: row + 1, col: 3))
                userIdCell.value = .text(rating.userId ?? "")
                itemIdCell.value = .text(rating.itemId ?? "")
                ratingCell.value = .text("\(rating.value ?? 0)")
            }
            let _ = book.save("users.xlsx")
        }
    }
    
    func createSimilarityValuesExcelFile() {
        FBUtilities.shared.getRatings { [weak self] ratings, error in
            guard let _ = self, let ratings = ratings else { return }
            let recommenderSystem = IBCFRecommenderSystem(ratings: ratings)
            let allCourseId = FBCourse.allCourses().map({ $0.id })
            let book = XWorkBook()
            let sheet = book.NewSheet("Sheet1")
            for (row, course1) in allCourseId.enumerated() {
                for (column, course2) in allCourseId.enumerated() {
                    let similarityValue = recommenderSystem.cosineSimilarity(item1: course1, item2: course2, isAdjusted: true)
                    let cell = sheet.AddCell(XCoords(row: row + 1, col: column + 1))
                    let ceil = ceil(similarityValue * 10000) / 10000.0
                    cell.value = .text("\(ceil)")
                    cell.width = 15
                }
            }
            let _ = book.save("testingexcel.xlsx")
//            XWorkBook.test()
        }
    }
    
    func createNewSimilarityValuesExcelFile() {
        FBUtilities.shared.getRatings { [weak self] ratings, error in
            guard let _ = self, let ratings = ratings else { return }
            let recommenderSystem = IBCFRecommenderSystem(ratings: ratings)
            let courses = FBCourse.allCourses()
            let book = XWorkBook()
            let sheet = book.NewSheet("Sheet1")
//            for (row, course1) in allCourseId.enumerated() {
//                for (column, course2) in allCourseId.enumerated() {
//                    let similarityValue = recommenderSystem.cosineSimilarity(item1: course1, item2: course2, isAdjusted: true)
//                    let course1IdCell = sheet.AddCell(XCoords(row: row + 1, col: 1))
//                    let course2IdCell = sheet.AddCell(XCoords(row: row + 1, col: 2))
//                    let valueCell = sheet.AddCell(XCoords(row: row + 1, col: 3))
//                    let ceil = ceil(similarityValue * 10000) / 10000.0
//
//                    course1IdCell.value = .text(course1 ?? "")
//                    course2IdCell.value = .text(course2 ?? "")
//                    valueCell.value = .text("\(ceil)")
//                }
//            }
            
            for (row, course) in courses.enumerated() {
                let courseIdCell = sheet.AddCell(XCoords(row: row + 1, col: 1))
                let courseNameCell = sheet.AddCell(XCoords(row: row + 1, col: 2))
                courseIdCell.value = .text(course.id ?? "")
                courseNameCell.value = .text(course.name ?? "")
            }
            
//            for row in 0...64 {
//                sheet.MergeRect(XRect((row * 65) + 1, 1, 1, 65))
//            }
            let _ = book.save("courses.xlsx")
//            XWorkBook.test()
        }
    }
}

private extension XLSXTestViewController {
    @objc func didTapUploadButton() {
        showUploadAlert()
    }
    
    func showUploadAlert() {
        let alert = UIAlertController(
            title: "Upload XLSX data to Firebase",
            message: "Upload data?",
            preferredStyle: .alert
        )
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let upload = UIAlertAction(title: "Upload", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.uploadXLSXDataToFirebase()
        }
        
        alert.addAction(cancel)
        alert.addAction(upload)
        
        navigationController?.present(alert, animated: true)
    }
    
    func showUploadFinishedAlert(error: Error?) {
        guard let error = error else {
            let alert = UIAlertController(
                title: "Upload Success",
                message: "Data uploaded successfully.",
                preferredStyle: .alert
            )
            
            let dismiss = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(dismiss)
            navigationController?.present(alert, animated: true)
            
            return
        }
        
        let alert = UIAlertController(
            title: "Upload Failed",
            message: "Data uploaded failed withh error: \(error).",
            preferredStyle: .alert
        )
        
        let dismiss = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(dismiss)
        navigationController?.present(alert, animated: true)
    }
}
