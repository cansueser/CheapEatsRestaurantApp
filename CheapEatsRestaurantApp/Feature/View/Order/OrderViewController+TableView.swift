import UIKit
extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderViewModel.orderDetailsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        let orderDetail = orderViewModel.orderDetailsList[indexPath.row]
        cell.configureWithOrder(orderDetail: orderDetail)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let orderDetailVC = SB.instantiateViewController(withIdentifier: "OrderDetailViewController") as! OrderDetailViewController
        orderDetailVC.orderDetailViewModel.order = orderViewModel.orderDetailsList[indexPath.row]
        navigationController?.pushViewController(orderDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        110
    }
}
