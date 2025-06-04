import UIKit
extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderViewModel.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        let order = orderViewModel.orders[indexPath.row]
        if let product = orderViewModel.product(for: order) {
            cell.configureWithOrder(order: order, product: product)
        } else {
            cell.configureWithOrderOnly(order: order)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Seçilen siparişi al
        guard indexPath.row < orderViewModel.orders.count else {
            print("Geçersiz sipariş indeksi!")
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        let order = orderViewModel.orders[indexPath.row]
        
        // İlişkili ürünü al (nil olabilir)
        let product = orderViewModel.product(for: order)
        
        // Storyboard'dan detay view controller'ı al
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "OrderDetailViewController") as? OrderDetailViewController {
            // Detay sayfasına sipariş ve ürün bilgisini aktar
            detailVC.order = order
            detailVC.product = product
            
            // Durum değiştiğinde OrderViewModel'i güncelle
            detailVC.onOrderStatusChanged = { [weak self] status in
                self?.orderViewModel.updateOrderStatus(orderId: order.orderId, newStatus: status) { success in
                    if success {
                        DispatchQueue.main.async {
                            self?.orderTableView.reloadData()
                        }
                    }
                }
            }
            
            // Detay sayfasına git
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            print("OrderDetailViewController bulunamadı!")
        }
        
        // Hücre seçimini kaldır
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        110
    }
}
