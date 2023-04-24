//
//  FBCourse.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 29/03/23.
//

import Foundation

struct FBCourse {
    enum AreaOfInterest: String {
        case natural = "natural"
        case applied = "applied"
        case both = "natural and applied"
    }
    
    let id: String?
    let name: String?
    let oldCurriculumSemesterAvailability: Int?
    let newCurriculumSemesterAvailability: Int?
    let areaOfInterest: AreaOfInterest?
    
    init(
        id: String,
        name: String,
        oldCurriculumSemesterAvailability: Int,
        newCurriculumSemesterAvailability: Int,
        areaOfInterest: AreaOfInterest? = nil
    ) {
        self.id = id
        self.name = name
        self.oldCurriculumSemesterAvailability = oldCurriculumSemesterAvailability
        self.newCurriculumSemesterAvailability = newCurriculumSemesterAvailability
        self.areaOfInterest = areaOfInterest
    }
}

extension FBCourse {
    static func allCourses() -> [FBCourse] {
        let courses = [
            FBCourse(
                id: "1",
                name: "Aljabar Linear Elementer",
                oldCurriculumSemesterAvailability: 1,
                newCurriculumSemesterAvailability: 1
            ),
            FBCourse(
                id: "2",
                name: "Kalkulus 1",
                oldCurriculumSemesterAvailability: 1,
                newCurriculumSemesterAvailability: 1
            ),
            FBCourse(
                id: "3",
                name: "Kalkulus 2",
                oldCurriculumSemesterAvailability: 2,
                newCurriculumSemesterAvailability: 2
            ),
            FBCourse(
                id: "4",
                name: "Metoda Statistika",
                oldCurriculumSemesterAvailability: 2,
                newCurriculumSemesterAvailability: 1
            ),
            FBCourse(
                id: "5",
                name: "Logika Matematika",
                oldCurriculumSemesterAvailability: 2,
                newCurriculumSemesterAvailability: 2
            ),
            FBCourse(
                id: "6",
                name: "Geometri",
                oldCurriculumSemesterAvailability: 2,
                newCurriculumSemesterAvailability: 2
            ),
            FBCourse(
                id: "7",
                name: "Pengantar Riset Operasional",
                oldCurriculumSemesterAvailability: 2,
                newCurriculumSemesterAvailability: 2
            ),
            FBCourse(
                id: "8",
                name: "Matematika Diskrit",
                oldCurriculumSemesterAvailability: 2,
                newCurriculumSemesterAvailability: 2
            ),
            FBCourse(
                id: "9",
                name: "Algoritma dan Pemrograman",
                oldCurriculumSemesterAvailability: 2,
                newCurriculumSemesterAvailability: 2
            ),
            FBCourse(
                id: "10",
                name: "Kalkulus Peubah Banyak",
                oldCurriculumSemesterAvailability: 3,
                newCurriculumSemesterAvailability: 3
            ),
            FBCourse(
                id: "11",
                name: "Struktur Data",
                oldCurriculumSemesterAvailability: 3,
                newCurriculumSemesterAvailability: 3
            ),
            FBCourse(
                id: "12",
                name: "Pengantar Teori Peluang",
                oldCurriculumSemesterAvailability: 3,
                newCurriculumSemesterAvailability: 3
            ),
            FBCourse(
                id: "13",
                name: "Metode Numerik",
                oldCurriculumSemesterAvailability: 3,
                newCurriculumSemesterAvailability: 3
            ),
            FBCourse(
                id: "14",
                name: "Pemrograman Linear",
                oldCurriculumSemesterAvailability: 3,
                newCurriculumSemesterAvailability: 5,
                areaOfInterest: .natural
            ),
            FBCourse(
                id: "15",
                name: "Matematika Komputasi",
                oldCurriculumSemesterAvailability: 3,
                newCurriculumSemesterAvailability: 4
            ),
            FBCourse(
                id: "16",
                name: "Matematika Keuangan",
                oldCurriculumSemesterAvailability: 3,
                newCurriculumSemesterAvailability: 3
            ),
            FBCourse(
                id: "17",
                name: "Basis Data",
                oldCurriculumSemesterAvailability: 4,
                newCurriculumSemesterAvailability: 0
            ),
            FBCourse(
                id: "18",
                name: "Persamaan Diferensial Biasa",
                oldCurriculumSemesterAvailability: 4,
                newCurriculumSemesterAvailability: 3
            ),
            FBCourse(
                id: "19",
                name: "Struktur Aljabar 1",
                oldCurriculumSemesterAvailability: 4,
                newCurriculumSemesterAvailability: 3
            ),
            FBCourse(
                id: "20",
                name: "Matematika Statistika",
                oldCurriculumSemesterAvailability: 4,
                newCurriculumSemesterAvailability: 4
            ),
            FBCourse(
                id: "21",
                name: "Fungsi Kompleks",
                oldCurriculumSemesterAvailability: 4,
                newCurriculumSemesterAvailability: 4
            ),
            FBCourse(
                id: "22",
                name: "Metode Peramalan",
                oldCurriculumSemesterAvailability: 4,
                newCurriculumSemesterAvailability: 4
            ),
            FBCourse(
                id: "23",
                name: "Fungsi Khusus",
                oldCurriculumSemesterAvailability: 4,
                newCurriculumSemesterAvailability: 5,
                areaOfInterest: .natural
            ),
            FBCourse(
                id: "24",
                name: "Struktur Aljabar 2",
                oldCurriculumSemesterAvailability: 5,
                newCurriculumSemesterAvailability: 4
            ),
            FBCourse(
                id: "25",
                name: "Analisis Real 1",
                oldCurriculumSemesterAvailability: 5,
                newCurriculumSemesterAvailability: 4
            ),
            FBCourse(
                id: "26",
                name: "Pemodelan Matematika",
                oldCurriculumSemesterAvailability: 5,
                newCurriculumSemesterAvailability: 5
            ),
            FBCourse(
                id: "27",
                name: "Persamaan Diferensial Parsial",
                oldCurriculumSemesterAvailability: 5,
                newCurriculumSemesterAvailability: 4
            ),
            FBCourse(
                id: "28",
                name: "Proses Stokastik",
                oldCurriculumSemesterAvailability: 5,
                newCurriculumSemesterAvailability: 5
            ),
            FBCourse(
                id: "29",
                name: "Optimisasi",
                oldCurriculumSemesterAvailability: 7,
                newCurriculumSemesterAvailability: 5
            ),
            FBCourse(
                id: "30",
                name: "Analisis Real 2",
                oldCurriculumSemesterAvailability: 6,
                newCurriculumSemesterAvailability: 5
            ),
            FBCourse(
                id: "31",
                name: "Analisis Kombinatorik",
                oldCurriculumSemesterAvailability: 6,
                newCurriculumSemesterAvailability: 7
            ),
            FBCourse(
                id: "32",
                name: "Metodologi Penelitian",
                oldCurriculumSemesterAvailability: 6,
                newCurriculumSemesterAvailability: 5
            ),
            FBCourse(
                id: "33",
                name: "Aljabar Linear Terapan",
                oldCurriculumSemesterAvailability: 5,
                newCurriculumSemesterAvailability: 5,
                areaOfInterest: .natural
            ),
            FBCourse(
                id: "34",
                name: "Teori Graf",
                oldCurriculumSemesterAvailability: 5,
                newCurriculumSemesterAvailability: 5,
                areaOfInterest: .natural
            ),
            FBCourse(
                id: "35",
                name: "Sistem Dinamik",
                oldCurriculumSemesterAvailability: 5,
                newCurriculumSemesterAvailability: 5,
                areaOfInterest: .both
            ),
            FBCourse(
                id: "36",
                name: "Aljabar Linear",
                oldCurriculumSemesterAvailability: 5,
                newCurriculumSemesterAvailability: 6,
                areaOfInterest: .natural
            ),
            FBCourse(
                id: "37",
                name: "Teori Modul",
                oldCurriculumSemesterAvailability: 5,
                newCurriculumSemesterAvailability: 6,
                areaOfInterest: .natural
            ),
            FBCourse(
                id: "38",
                name: "Teori Ukuran dan Integral",
                oldCurriculumSemesterAvailability: 5,
                newCurriculumSemesterAvailability: 6,
                areaOfInterest: .natural
            ),
            FBCourse(
                id: "39",
                name: "Persamaan Beda",
                oldCurriculumSemesterAvailability: 5,
                newCurriculumSemesterAvailability: 6,
                areaOfInterest: .natural
            ),
            FBCourse(
                id: "40",
                name: "Teori Kontrol Optimal",
                oldCurriculumSemesterAvailability: 6,
                newCurriculumSemesterAvailability: 6,
                areaOfInterest: .both
            ),
            FBCourse(
                id: "41",
                name: "Kriptografi",
                oldCurriculumSemesterAvailability: 6,
                newCurriculumSemesterAvailability: 7,
                areaOfInterest: .natural
            ),
            FBCourse(
                id: "42",
                name: "Teori Bilangan",
                oldCurriculumSemesterAvailability: 6,
                newCurriculumSemesterAvailability: 7,
                areaOfInterest: .natural
            ),
            FBCourse(
                id: "43",
                name: "Ruang Linear",
                oldCurriculumSemesterAvailability: 6,
                newCurriculumSemesterAvailability: 7,
                areaOfInterest: .natural
            ),
            FBCourse(
                id: "44",
                name: "Kapita Selekta Matematika Murni",
                oldCurriculumSemesterAvailability: 6,
                newCurriculumSemesterAvailability: 7,
                areaOfInterest: .natural
            ),
            FBCourse(
                id: "45",
                name: "Teori Antrian",
                oldCurriculumSemesterAvailability: 6,
                newCurriculumSemesterAvailability: 5,
                areaOfInterest: .applied
            ),
            FBCourse(
                id: "46",
                name: "Pengendalian Persediaan",
                oldCurriculumSemesterAvailability: 6,
                newCurriculumSemesterAvailability: 5,
                areaOfInterest: .applied
            ),
            FBCourse(
                id: "47",
                name: "Pemrograman Dinamik",
                oldCurriculumSemesterAvailability: 6,
                newCurriculumSemesterAvailability: 5,
                areaOfInterest: .applied
            ),
            FBCourse(
                id: "48",
                name: "Model Survival",
                oldCurriculumSemesterAvailability: 6,
                newCurriculumSemesterAvailability: 5,
                areaOfInterest: .applied
            ),
            FBCourse(
                id: "49",
                name: "Analisis Regresi",
                oldCurriculumSemesterAvailability: 6,
                newCurriculumSemesterAvailability: 5,
                areaOfInterest: .applied
            ),
            FBCourse(
                id: "50",
                name: "Model dan Simulasi",
                oldCurriculumSemesterAvailability: 6,
                newCurriculumSemesterAvailability: 6,
                areaOfInterest: .applied
            ),
            FBCourse(
                id: "51",
                name: "Pemrograman Non Linear",
                oldCurriculumSemesterAvailability: 6,
                newCurriculumSemesterAvailability: 6,
                areaOfInterest: .applied
            ),
            FBCourse(
                id: "52",
                name: "Matematika Aktuaria 1",
                oldCurriculumSemesterAvailability: 6,
                newCurriculumSemesterAvailability: 6,
                areaOfInterest: .applied
            ),
            FBCourse(
                id: "53",
                name: "Aspek Matematika Dana Pensiun",
                oldCurriculumSemesterAvailability: 6,
                newCurriculumSemesterAvailability: 6,
                areaOfInterest: .applied
            ),
            FBCourse(
                id: "54",
                name: "Model Investasi dan Pengelolaan Aset",
                oldCurriculumSemesterAvailability: 6,
                newCurriculumSemesterAvailability: 6,
                areaOfInterest: .applied
            ),
            FBCourse(
                id: "55",
                name: "Matematika Populasi",
                oldCurriculumSemesterAvailability: 6,
                newCurriculumSemesterAvailability: 6,
                areaOfInterest: .applied
            ),
            FBCourse(
                id: "56",
                name: "Matematika Bioekonomi",
                oldCurriculumSemesterAvailability: 6,
                newCurriculumSemesterAvailability: 6,
                areaOfInterest: .applied
            ),
            FBCourse(
                id: "57",
                name: "Analisis Deret Waktu",
                oldCurriculumSemesterAvailability: 7,
                newCurriculumSemesterAvailability: 6,
                areaOfInterest: .applied
            ),
            FBCourse(
                id: "58",
                name: "Statistika Multivariat",
                oldCurriculumSemesterAvailability: 7,
                newCurriculumSemesterAvailability: 6,
                areaOfInterest: .applied
            ),
            FBCourse(
                id: "59",
                name: "Ekonometrika",
                oldCurriculumSemesterAvailability: 6,
                newCurriculumSemesterAvailability: 6,
                areaOfInterest: .applied
            ),
            FBCourse(
                id: "60",
                name: "Teori Keputusan",
                oldCurriculumSemesterAvailability: 7,
                newCurriculumSemesterAvailability: 7,
                areaOfInterest: .applied
            ),
            FBCourse(
                id: "61",
                name: "Teori Risiko",
                oldCurriculumSemesterAvailability: 7,
                newCurriculumSemesterAvailability: 7,
                areaOfInterest: .applied
            ),
            FBCourse(
                id: "62",
                name: "Matematika Aktuaria 2",
                oldCurriculumSemesterAvailability: 7,
                newCurriculumSemesterAvailability: 7,
                areaOfInterest: .applied
            ),
            FBCourse(
                id: "63",
                name: "Matematika Epidemiologi",
                oldCurriculumSemesterAvailability: 7,
                newCurriculumSemesterAvailability: 7,
                areaOfInterest: .applied
            ),
            FBCourse(
                id: "64",
                name: "Analisis Spasial",
                oldCurriculumSemesterAvailability: 7,
                newCurriculumSemesterAvailability: 7,
                areaOfInterest: .applied
            ),
            FBCourse(
                id: "65",
                name: "Kapita Selekta Pemodelan Matematika",
                oldCurriculumSemesterAvailability: 7,
                newCurriculumSemesterAvailability: 7,
                areaOfInterest: .applied
            ),
            FBCourse(
                id: "66",
                name: "Matematika Untuk Data Sains",
                oldCurriculumSemesterAvailability: 0,
                newCurriculumSemesterAvailability: 6,
                areaOfInterest: .both
            )
        ]
        
        return courses
    }
    
    func course(id: String) -> FBCourse? {
        let allCourse = FBCourse.allCourses()
        return allCourse.first(where: { $0.id == id })
    }
}
