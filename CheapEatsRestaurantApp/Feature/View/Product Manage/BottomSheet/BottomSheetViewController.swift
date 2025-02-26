import UIKit

class BottomSheetViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    weak var delegate: BottomSheetViewModelDelegate?
    var bottomSheetViewModel: BottomSheetViewModel = BottomSheetViewModel()
    
    var onDismissWithSelectedMeals: (([String]) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        bottomSheetViewModel.delegate = self
    }
    private func setupUI() {
        view.backgroundColor = .white
        let clearButton = UIBarButtonItem(title: "Temizle", style: .plain, target: self, action: #selector(clearButtonTapped))
        clearButton.tintColor = .yeşil
        navigationItem.rightBarButtonItem = clearButton
        navigationItem.title = "Yemek Türleri"
        let cancelButton = UIBarButtonItem(title: "İptal", style: .plain, target: self, action: #selector(cancelButtonTapped))
        cancelButton.tintColor = .kırmızı
        navigationItem.leftBarButtonItem = cancelButton
        navigationBar.setItems([navigationItem], animated: false)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
    }
    
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        delegate?.didApplySelection(selectedOptions: bottomSheetViewModel.selectedOptions)
        dismiss(animated: true)
    }
    @objc private func clearButtonTapped() {
        bottomSheetViewModel.clearSelection(tableView: tableView)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
}

extension BottomSheetViewController: BottomSheetViewModelOutputProtocol {
    func didChangeSelection() {
        tableView.reloadData()
    }
}
