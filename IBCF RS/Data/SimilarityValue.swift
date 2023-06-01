//
//  SimilarityValue.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 07/05/23.
//

import Foundation

struct SimilarityValue {
    let course: FBCourse
    let similarToCourse: FBCourse
    let similarityValue: Double
}

struct SimilarityValueCounter {
    let similarityValue: Double
    let ratingValue: Double
}
