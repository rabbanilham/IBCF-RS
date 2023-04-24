//
//  XLSXUtilities.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 23/03/23.
//

import CoreXLSX
import Foundation

final class XLSXUtilities {
    static let shared = XLSXUtilities()
    
    func importFile(fileName: String) -> XLSXFile {
        let filepath = Bundle.main.path(forResource: fileName, ofType: "xlsx")
        guard let filepath = filepath, let file = XLSXFile(filepath: filepath) else {
            fatalError("XLSX file at \(String(describing: filepath)) is corrupted or does not exist")
        }
        
        return file
    }
    
    func getRowsFromFile(_ named: String) -> [[String?]] {
        let file = importFile(fileName: named)
        do {
            guard let sharedStrings = try file.parseSharedStrings() else { return [] }
            for workbook in try file.parseWorkbooks() {
                for (name, path) in try file.parseWorksheetPathsAndNames(workbook: workbook) {
                    if let worksheetName = name {
                        print("This worksheet has a name: \(worksheetName)")
                    }
                    let worksheet = try file.parseWorksheet(at: path)
                    var rows = [[String?]]()
                    for row in worksheet.data?.rows ?? []  {
                        var cells = [String?]()
                        for cell in row.cells {
                            if cell == row.cells[0] {
                                cells.append(String(describing: cell.dateValue))
                            }
                            if let cellValue = cell.stringValue(sharedStrings) {
                                cells.append(cellValue)
                            } else if let cellValue = cell.value {
                                cells.append(cellValue)
                            }
                            
                        }
                        rows.append(cells)
                    }
                    return rows
                }
            }
        } catch {
            print(error)
        }
        return []
    }
    
    func getRows(_ named: String) -> [[String?]] {
        let file = importFile(fileName: named)
        do {
            if let sharedStrings = try file.parseSharedStrings() {
                for item in sharedStrings.items {
                    print("text = \(String(describing: item.text)) and richtext is \(item.richText)")
                }
            }
        } catch {
            print(error)
        }
        return []
    }
}
