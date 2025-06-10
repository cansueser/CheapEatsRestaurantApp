import UIKit

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return homeViewModel.products.count
        } else if tableView == orderTableView {
            return homeViewModel.orders.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as? ProductTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            let product = homeViewModel.products[indexPath.row]
            cell.configureCell(wtih: product)
            return cell
        } else if tableView == orderTableView {
            if indexPath.row >= homeViewModel.orders.count { return UITableViewCell() }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as? ProductTableViewCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            let order = homeViewModel.orders[indexPath.row]
            if let product = homeViewModel.orderProduct(for: order) {
                cell.configureWithOrder(order: order, product: product)
            } else {
                cell.configureWithOrderOnly(order: order)
            }
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        if tableView == self.tableView {
            let SB = UIStoryboard(name: "Main", bundle: nil)
            let productUpdateVC = SB.instantiateViewController(withIdentifier: "ProductAddedViewController") as! ProductManageViewController
            productUpdateVC.productManageViewModel.product = homeViewModel.products[indexPath.row]
            productUpdateVC.productManageViewModel.goSource = .updateProduct
            navigationController?.pushViewController(productUpdateVC, animated: true)
        } else if tableView == orderTableView {
            let alert = UIAlertController(title: "Sipariş Durumunu Seç", message: nil, preferredStyle: .actionSheet)
            for status in OrderStatus.allCases {
                alert.addAction(UIAlertAction(title: status.rawValue, style: .default, handler: { [weak self] _ in
                    self?.homeViewModel.updateOrderStatus(index: indexPath.row, newStatus: status)
                }))
            }
            alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }
}
