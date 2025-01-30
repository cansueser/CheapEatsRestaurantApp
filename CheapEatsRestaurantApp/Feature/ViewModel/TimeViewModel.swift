//
//  TimeViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 11.12.2024.
//

import Foundation

class TimeViewModel {
    
    // Model referansı
    private var timeModel: TimeModel
    
    // Saatleri formatlayan bir DateFormatter
    private let dateFormatter: DateFormatter
    
    init() {
        // Varsayılan tarih/saat bilgileri
        self.timeModel = TimeModel(time1: Date(), time2: Date())
        
        // DateFormatter yapılandırması
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "HH:mm" // Saat ve dakika formatı
    }
    
    // Model'den saatleri alır
    func getFormattedTimes() -> (String, String) {
        let time1 = dateFormatter.string(from: timeModel.time1)
        let time2 = dateFormatter.string(from: timeModel.time2)
        return (time1, time2)
    }
    
    // Saatleri günceller
    func updateTime1(_ time: Date) {
        timeModel.time1 = time
    }
    
    func updateTime2(_ time: Date) {
        timeModel.time2 = time
    }
    
    // Konsola yazdırma işlemi
    func logSelectedTimes() {
        let formattedTimes = getFormattedTimes()
        print("zaman aralığı: \(formattedTimes.0)- \(formattedTimes.1)")
        
    }
}

