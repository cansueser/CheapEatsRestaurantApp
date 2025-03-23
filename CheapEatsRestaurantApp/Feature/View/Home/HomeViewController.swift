import UIKit

final class HomeViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var foodAddButton: UIButton!
    
    var homeViewModel: HomeViewModel = HomeViewModel()
    var selectedIndexPath: IndexPath?
    var productManageViewModel = ProductManageViewModel()

    //TODO: -Cell güncelle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        homeViewModel.delegate = self

    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "orderCell")
    }
    // burda update yapmaya bak
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      if let savedProducts = UserDefaults.standard.array(forKey: "orderCell") as? [Product] {
          productManageViewModel.product = savedProducts.first!
          print("YENİ??????????? \(savedProducts.first!)")
          
          
        }
        }
    
    @IBAction func foodAddButtonClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let productVC = storyboard.instantiateViewController(withIdentifier: "ProductAddedViewController") as? ProductManageViewController {
            //productVC.orderViewModel = orderViewModel
            productVC.dataTransferDelegate = self
            navigationController?.pushViewController(productVC, animated: true)
        }
    }
}

extension HomeViewController: HomeViewModelOutputProtocol {
    func update() {
        tableView.reloadData()
        print("Update")
    }
    
    func error() {
        print("Error")
    }
}

extension HomeViewController: DataTransferDelegate {
    func didSaveProduct(product: Product) {
        homeViewModel.addProduct(product)
    }
}
