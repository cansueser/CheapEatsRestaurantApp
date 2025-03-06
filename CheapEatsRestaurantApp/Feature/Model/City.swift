//
//  City.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 5.03.2025.
//
struct CityData: Codable {
    let data: [City]
}

struct City: Codable {
    let ilAdi: String
    let ilceler: [Ilceler]

    enum CodingKeys: String, CodingKey {
        case ilAdi = "il_adi"
        case ilceler
    }
}

struct Ilceler: Codable {
    let ilceAdi: String

    enum CodingKeys: String, CodingKey {
        case ilceAdi = "ilce_adi"
    }
}
