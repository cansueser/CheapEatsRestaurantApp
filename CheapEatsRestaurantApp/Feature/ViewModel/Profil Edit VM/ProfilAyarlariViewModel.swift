//
//  ProfilAyarlariViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 6.06.2025.
//

import Foundation

protocol ProfilAyarlariViewModelProtocol: AnyObject {
    var delegate: ProfilAyarlariViewModelOutputProtocol? { get set }
    func getKullaniciBilgisi()
    func profilDuzenlemeEkraninaGit()
    func sifreDegistirmeEkraninaGit()
    func cikisYap()
}

protocol ProfilAyarlariViewModelOutputProtocol: AnyObject {
    func kullaniciBilgisiniGuncelle(kullanici: EditUser)
    func profilDuzenlemeEkraninaGit(kullanici: EditUser)
    func sifreDegistirmeEkraninaGit(kullanici: EditUser)
    func cikisYapildi()
}

class ProfilAyarlariViewModel: ProfilAyarlariViewModelProtocol {
    weak var delegate: ProfilAyarlariViewModelOutputProtocol?
    private var kullanici: EditUser
    
    init() {
        // Gerçek uygulamada, bu bilgiler ağ çağrısından veya yerel depolamadan yüklenecektir
        self.kullanici = EditUser(
            isim: "Ahmet",
            soyisim: "Yılmaz",
            kullaniciAdi: "ahmetyilmaz",
            email: "ahmet.yilmaz@ornek.com",
            telefonNumarasi: "+905001234567",
            restoranAdi: "Lezzetli Lokantası",
            sifre: "sifre123"
        )
    }
    
    func getKullaniciBilgisi() {
        // Gerçek uygulamada, bu API'dan veya yerel depolamadan kullanıcı bilgisini getirecektir
        delegate?.kullaniciBilgisiniGuncelle(kullanici: kullanici)
    }
    
    func profilDuzenlemeEkraninaGit() {
        delegate?.profilDuzenlemeEkraninaGit(kullanici: kullanici)
    }
    
    func sifreDegistirmeEkraninaGit() {
        delegate?.sifreDegistirmeEkraninaGit(kullanici: kullanici)
    }
    
    func cikisYap() {
        // Gerçek uygulamada, oturum verilerini, belirteçleri vb. temizlersiniz
        delegate?.cikisYapildi()
    }
    
    // Bu yöntem, düzenleme sonrası ProfilDuzenlemeViewController'dan çağrılacaktır
    func kullaniciBilgisiniGuncelle(guncellenmisKullanici: EditUser) {
        self.kullanici = guncellenmisKullanici
        delegate?.kullaniciBilgisiniGuncelle(kullanici: kullanici)
    }
}
