//
//  Course.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 21/02/23.
//

import Foundation

struct Course {
    enum AreaOfInterest: String {
        case natural = "natural"
        case applied = "applied"
        case both = "natural and applied"
    }
    
    let id: Int
    let name: String
    let availableSinceSemester: Int
    let areaOfInterest: AreaOfInterest?
    
    init(id: Int, name: String, availableSinceSemester: Int, areaOfInterest: AreaOfInterest? = nil) {
        self.id = id
        self.name = name
        self.availableSinceSemester = availableSinceSemester
        self.areaOfInterest = areaOfInterest
    }
}

extension Course {
    static func allCourses() -> [Course] {
        let courses = [
            Course(id: 1, name: "Aljabar Linear Elementer", availableSinceSemester: 1),
            Course(id: 2, name: "Kalkulus 1", availableSinceSemester: 1),
            Course(id: 3, name: "Metoda Statistika", availableSinceSemester: 1),
            Course(id: 4, name: "Logika Matematika", availableSinceSemester: 2),
            Course(id: 5, name: "Matematika Diskrit", availableSinceSemester: 2),
            Course(id: 6, name: "Kalkulus 2", availableSinceSemester: 2),
            Course(id: 7, name: "Geometri Analitik", availableSinceSemester: 2),
            Course(id: 8, name: "Pendahuluan Riset Operasi", availableSinceSemester: 2),
            Course(id: 9, name: "Algoritma dan Pemrograman", availableSinceSemester: 2),
            Course(id: 10, name: "Struktur Aljabar 1", availableSinceSemester: 3),
            Course(id: 11, name: "Kalkulus Peubah Banyak", availableSinceSemester: 3),
            Course(id: 12, name: "Persamaan Diferensial Biasa", availableSinceSemester: 3),
            Course(id: 13, name: "Matematika Keuangan", availableSinceSemester: 3),
            Course(id: 14, name: "Pengantar Teori Peluang", availableSinceSemester: 3),
            Course(id: 15, name: "Metode Numerik", availableSinceSemester: 3),
            Course(id: 16, name: "Struktur Data", availableSinceSemester: 3),
            Course(id: 17, name: "Struktur Aljabar 2", availableSinceSemester: 4),
            Course(id: 18, name: "Persamaan Diferensial Parsial", availableSinceSemester: 4),
            Course(id: 19, name: "Analisis Real 1", availableSinceSemester: 4),
            Course(id: 20, name: "Fungsi Kompleks", availableSinceSemester: 4),
            Course(id: 21, name: "Matematika Statistika", availableSinceSemester: 4),
            Course(id: 22, name: "Metode Peramalan", availableSinceSemester: 4),
            Course(id: 23, name: "Matematika Komputasi", availableSinceSemester: 4),
            Course(id: 24, name: "Analisis Real 2", availableSinceSemester: 5),
            Course(id: 25, name: "Optimisasi", availableSinceSemester: 5),
            Course(id: 26, name: "Pemodelan Matematika", availableSinceSemester: 5),
            Course(id: 27, name: "Proses Stokastik", availableSinceSemester: 5),
            Course(id: 28, name: "Metode Penelitian", availableSinceSemester: 5, areaOfInterest: .natural),
            Course(id: 29, name: "Aljabar Linear Terapan", availableSinceSemester: 5, areaOfInterest: .natural),
            Course(id: 30, name: "Teori Graf", availableSinceSemester: 5, areaOfInterest: .natural),
            Course(id: 31, name: "Fungsi Khusus", availableSinceSemester: 5, areaOfInterest: .natural),
            Course(id: 32, name: "Topologi", availableSinceSemester: 5, areaOfInterest: .natural),
            Course(id: 33, name: "Sistem Dinamik", availableSinceSemester: 5, areaOfInterest: .both),
            Course(id: 34, name: "Pemrograman Linear", availableSinceSemester: 5, areaOfInterest: .applied),
            Course(id: 35, name: "Teori Antrian", availableSinceSemester: 5, areaOfInterest: .applied),
            Course(id: 36, name: "Pengendalian Persediaan", availableSinceSemester: 5, areaOfInterest: .applied),
            Course(id: 37, name: "Pemrograman Dinamik", availableSinceSemester: 5, areaOfInterest: .applied),
            Course(id: 38, name: "Model Survival", availableSinceSemester: 5, areaOfInterest: .applied),
            Course(id: 39, name: "Analisis Regresi", availableSinceSemester: 5, areaOfInterest: .applied),
            Course(id: 40, name: "Aljabar Linear", availableSinceSemester: 6, areaOfInterest: .natural),
            Course(id: 41, name: "Teori Modul", availableSinceSemester: 6, areaOfInterest: .natural),
            Course(id: 42, name: "Teori Ukuran dan Integral", availableSinceSemester: 6, areaOfInterest: .natural),
            Course(id: 43, name: "Persamaan Beda", availableSinceSemester: 6, areaOfInterest: .natural),
            Course(id: 44, name: "Teori Kontrol Optimal", availableSinceSemester: 6, areaOfInterest: .both),
            Course(id: 45, name: "Matematika untuk Data Sains", availableSinceSemester: 6, areaOfInterest: .both),
            Course(id: 46, name: "Model dan Simulasi", availableSinceSemester: 6, areaOfInterest: .applied),
            Course(id: 47, name: "Pemrograman Non Linear", availableSinceSemester: 6, areaOfInterest: .applied),
            Course(id: 48, name: "Matematika Aktuaria 1", availableSinceSemester: 6, areaOfInterest: .applied),
            Course(id: 49, name: "Aspek Matematika Dana Pensiun", availableSinceSemester: 6, areaOfInterest: .applied),
            Course(id: 50, name: "Model Investasi dan Pengelolaan Aset", availableSinceSemester: 6, areaOfInterest: .applied),
            Course(id: 51, name: "Matematika Populasi", availableSinceSemester: 6, areaOfInterest: .applied),
            Course(id: 52, name: "Matematika Bioekonomi", availableSinceSemester: 6, areaOfInterest: .applied),
            Course(id: 53, name: "Analisis Deret Waktu", availableSinceSemester: 6, areaOfInterest: .applied),
            Course(id: 54, name: "Statistika Multivariat", availableSinceSemester: 6, areaOfInterest: .applied),
            Course(id: 55, name: "Ekonometrika", availableSinceSemester: 6, areaOfInterest: .applied),
            Course(id: 56, name: "Analisis Kombinatorik", availableSinceSemester: 6),
            Course(id: 57, name: "Teori Grup Hingga", availableSinceSemester: 7, areaOfInterest: .natural),
            Course(id: 58, name: "Kriptografi", availableSinceSemester: 7, areaOfInterest: .natural),
            Course(id: 59, name: "Teori Bilangan", availableSinceSemester: 7, areaOfInterest: .natural),
            Course(id: 60, name: "Ruang Linear", availableSinceSemester: 7, areaOfInterest: .natural),
            Course(id: 61, name: "Kapita Selekta Matematika Murni", availableSinceSemester: 7, areaOfInterest: .natural),
            Course(id: 62, name: "Teori Keputusan", availableSinceSemester: 7, areaOfInterest: .applied),
            Course(id: 63, name: "Pemodelan dan Teori Risiko", availableSinceSemester: 7, areaOfInterest: .applied),
            Course(id: 64, name: "Matematika Aktuaria 2", availableSinceSemester: 7, areaOfInterest: .applied),
            Course(id: 65, name: "Matematika Epidemiologi", availableSinceSemester: 7, areaOfInterest: .applied),
            Course(id: 66, name: "Analisis Spasial", availableSinceSemester: 7, areaOfInterest: .applied),
            Course(id: 67, name: "Kapita Selekta Matematika Terapan", availableSinceSemester: 7, areaOfInterest: .applied)
        ]
        
        return courses
    }
    
    func course(_ courseId: Int) -> Course {
        let allCourse = Course.allCourses()
        return allCourse[courseId - 1]
    }
}
