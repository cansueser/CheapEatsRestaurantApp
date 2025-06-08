import UIKit

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let order = homeViewModel.products[indexPath.row]
        cell.configureCell(wtih: order)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let productUpdateVC = SB.instantiateViewController(withIdentifier: "ProductAddedViewController") as! ProductManageViewController
        productUpdateVC.productManageViewModel.product = homeViewModel.products[indexPath.row]
        productUpdateVC.dataTransferDelegate = self
        productUpdateVC.productManageViewModel.goSource = .updateProduct
        navigationController?.pushViewController(productUpdateVC, animated: true)
    }
   /* func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       if editingStyle == .delete {
        
       }
    }*/
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
