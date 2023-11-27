
import UIKit

final class TaskListViewController: UITableViewController {
	
    private let storageManager = Storagemanager.shared
	private let cellID = "task"
    private var taskList: [Task] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
		view.backgroundColor = .white
		setupNavigationBar()
	}
	
    
    override func viewWillAppear(_ animated: Bool) {
        taskList = storageManager.getfetchData()
        tableView.reloadData()
    }
	
    @objc
	private func addNewTask() {
		showAlert(with: "New Task", and: "What do you want to do?")
        
	}
}

// MARK: - Private Methods
private extension TaskListViewController {
	func setupNavigationBar() {
		title = "Task List"
		navigationController?.navigationBar.prefersLargeTitles = true
		
		let navBarAppearance = UINavigationBarAppearance()
		navBarAppearance.configureWithOpaqueBackground()
		
		navBarAppearance.backgroundColor = UIColor(named: "MilkBlue")
		
		navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
		navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
		
		navigationController?.navigationBar.standardAppearance = navBarAppearance
		navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .add,
			target: self,
			action: #selector(addNewTask)
		)
		
		navigationController?.navigationBar.tintColor = .white
	}
	

	
	func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		
		let saveAction = UIAlertAction(title: "Save Task", style: .default) { [unowned self] _ in
			guard let text = alert.textFields?.first?.text, !text.isEmpty else { return }
            storageManager.saveTask(text) { task in
                self.taskList.insert(task, at: 0)
            }
            tableView.reloadData()
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
		alert.addAction(saveAction)
		alert.addAction(cancelAction)
		alert.addTextField { textField in
			textField.placeholder = "NewTask"
		}
		present(alert, animated: true)
	}
    
    
    func showAlertForRefresh(with title: String, and message: String, index: Int) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save change", style: .destructive) { [unowned self] _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            refreshTask(task, index: index)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        saveAction.setValue(UIColor.milkBlue, forKey: "titleTextColor")
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "ChangeTask"
        }
        present(alert, animated: true)
    }
    
    
    func refreshTask(_ taskName: String, index: Int) {
        let task = taskList[index]
       // let task = storageManager.getfetchData()[index]
        task.title = taskName
    
        taskList.remove(at: index)
        taskList.insert(task, at: index)
        storageManager.refreshContext(task)
        tableView.reloadData()
    }
    

}


// MARK: - Override func TableViewDataSourse
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        
        return cell
    }
    
// MARK: - Override func TableViewDelegate
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let task = taskList[indexPath.row]
            storageManager.deleteContext(task)
            taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title:  "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
        })
        editAction.backgroundColor = .blue
        showAlertForRefresh(with: "Change task", and: "What do you want to do?", index: indexPath.row)
       
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        return UISwipeActionsConfiguration(actions: [editAction])
    }
}

