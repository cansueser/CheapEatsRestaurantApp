import UIKit
import FirebaseFirestore

extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderViewModel.getOrders().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        let order = orderViewModel.getOrders()[indexPath.row]
        print("Order: \(order)")
        cell.foodNameLabel.text = order.name
        cell.oldAmountLabel.text = "\(order.oldPrice) TL"
        cell.newAmountLabel.text = "\(order.newPrice) TL"
        cell.stateLabel.text = order.orderStatus.description
        cell.stateLabel.textColor = order.orderStatus.textColor
        //RESİM
        /* if let urlString = order.imageURL, let url = URL(string: urlString) {
         cell.foodImage.load(url: url) // URL'den resim yükleme fonksiyonu
         }*/
        // Tarih formatlama
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        cell.dateLabel.text = dateFormatter.string(from: order.endTime)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOrder = orderViewModel.getOrders()[indexPath.row]
        selectedIndexPath = indexPath
        
        if let productAddedVC = storyboard?.instantiateViewController(withIdentifier: "ProductAddedViewController") as? ProductAddedViewController {
            productAddedVC.selectedOrder = selectedOrder
            productAddedVC.orderViewModel = orderViewModel
            productAddedVC.selectedIndexPath = selectedIndexPath
            
            navigationController?.pushViewController(productAddedVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] (action, view, completion) in
            guard let self = self else { return }
            
            let alert = UIAlertController(title: "Emin misiniz?", message: "Bu siparişi silmek istediğinize emin misiniz?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
            alert.addAction(UIAlertAction(title: "Sil", style: .destructive, handler: { _ in
                let order = self.orderViewModel.getOrders()[indexPath.row]
                
                guard let orderID = order.id else {
                    print("Hata: Order ID bulunamadı")
                    return
                }
                
                self.orderViewModel.deleteOrder(orderID: orderID) { success in
                    if success {
                        // TableView'ı güncelle
                        DispatchQueue.main.async {
                            self.orderTableView.deleteRows(at: [indexPath], with: .automatic)
                        }
                    } else {
                        // Hata mesajı göster
                        let errorAlert = UIAlertController(title: "Hata", message: "Silme işlemi başarısız oldu", preferredStyle: .alert)
                        errorAlert.addAction(UIAlertAction(title: "Tamam", style: .default))
                        self.present(errorAlert, animated: true)
                    }
                }
            }))
            
            self.present(alert, animated: true)
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
