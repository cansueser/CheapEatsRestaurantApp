import UIKit

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderViewModel.orders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        if let order = orderViewModel.orders?[indexPath.row] {
            print("Order: \(order)")
            cell.configureCell(wtih: order)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let selectedOrder = orderViewModel.orders?[indexPath.row]
        //selectedIndexPath = indexPath
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let productAddedVC = SB.instantiateViewController(withIdentifier: "ProductAddedViewController") as! ProductManageViewController
        //productAddedVC.selectedOrder = selectedOrder
        //productAddedVC.selectedIndexPath = selectedIndexPath
        navigationController?.pushViewController(productAddedVC, animated: true)
    }
   /* func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Global alert yaz
        
         let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] (action, view, completion) in
         guard let self = self else { return }
         
         let alert = UIAlertController(title: "Emin misiniz?", message: "Bu siparişi silmek istediğinize emin misiniz?", preferredStyle: .alert)
         
         alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
         alert.addAction(UIAlertAction(title: "Sil", style: .destructive, handler: { _ in
         let order = self.orderViewModel.getOrders()[indexPath.row]
         
         guard let orderID = order.productId else {
         print("Hata: Order ID bulunamadı")
         return
         }
         
         self.orderViewModel.deleteOrder(orderID: orderID) { success in
         if success {
         // TableView'ı güncelle
         DispatchQueue.main.async {
         self.tableView.deleteRows(at: [indexPath], with: .automatic)
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
    */
}
