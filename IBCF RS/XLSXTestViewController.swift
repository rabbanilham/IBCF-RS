//
//  XLSXTestViewController.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 23/03/23.
//

import UIKit

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
            for cell in fileRow {
                if cell != timestamp, cell != nothing, cell != email, cell != name, cell != id, cell != peminatan, cell != phoneNumber {
                    if let cell = cell, let value = Double(cell) {
                        let rating = FBRating(userId: id, itemId: String(itemId), value: value, createdAt: Date())
                        ratings.append(rating)
                        itemId += 1
                    }
                }
            }
            
            if let id = id, let name = name, let email = email, let phoneNumber = phoneNumber {
                let user = FBUser(id: id, name: name, email: email, phoneNumber: phoneNumber, ratings: ratings)
                FBUtilities.shared.createUser(user: user) { error in
                    self.navigationController?.dismiss(animated: false, completion: {
                        self.showUploadFinishedAlert(error: error)
                    })
                }
            }
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
