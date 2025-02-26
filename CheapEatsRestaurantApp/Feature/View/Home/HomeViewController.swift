import UIKit

final class HomeViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var foodAddButton: UIButton!
    
    var orderViewModel: HomeViewModel = HomeViewModel()
    var selectedIndexPath: IndexPath?
    
    //TODO: -Cell güncelle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        orderViewModel.delegate = self
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "orderCell")
    }
    
    @IBAction func foodAddButtonClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let productVC = storyboard.instantiateViewController(withIdentifier: "ProductAddedViewController") as? ProductManageViewController {
            //productVC.orderViewModel = orderViewModel
            navigationController?.pushViewController(productVC, animated: true)
        }
    }
}

extension HomeViewController: OrderViewModelOutputProtocol {
    func update() {
        tableView.reloadData()
        print("Update")
    }
    
    func error() {
        print("Error")
    }
}
