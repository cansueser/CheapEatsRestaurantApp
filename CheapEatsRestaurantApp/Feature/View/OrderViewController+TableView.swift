import UIKit

extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderViewModel.getOrders().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }

        let order = orderViewModel.getOrders()[indexPath.row]
        cell.foodNameLabel.text = order.name
        cell.foodImage.image = order.foodImage
        cell.oldAmountLabel.text = String(order.oldPrice)
        cell.newAmountLabel.text = String(order.newPrice)
        cell.stateLabel.text = order.orderStatus.description
        cell.stateLabel.textColor = order.orderStatus.textColor

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
/*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected order at index \(indexPath.row)")
        //qqqqq
        // Seçilen index ile ilgili veriyi al
        let selectedOrder = orderViewModel.orders[indexPath.row]
        
        // Bilgileri yazdır
        print("Selected order at index \(indexPath.row): \(selectedOrder.name)")
        
        // Seçilen ürün bilgilerini ProductAddedViewController'a aktar
        if let productAddedVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductAddedViewController") as? ProductAddedViewController {
            productAddedVC.selectedOrder = selectedOrder
            self.navigationController?.pushViewController(productAddedVC, animated: true)
        }}
    //aaqqqqq
 */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     let selectedOrder = orderViewModel.orders[indexPath.row]
     selectedIndexPath = indexPath

     if let productAddedVC = storyboard?.instantiateViewController(withIdentifier: "ProductAddedViewController") as? ProductAddedViewController {
         productAddedVC.selectedOrder = selectedOrder
         productAddedVC.orderViewModel = orderViewModel
         productAddedVC.selectedIndexPath = selectedIndexPath
         navigationController?.pushViewController(productAddedVC, animated: true)
     }
 }


}
