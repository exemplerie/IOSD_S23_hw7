import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var table: UITableView!
    private let manager: NetworkManagerProtocol = NetworkManager()
    private var fetchedResultsController: NSFetchedResultsController<Character>!
    private let launchCounterKey = "LaunchCounter"
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load CoreData stack: \(error)")
            }
        }
        return container
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        initializeFetchedResultsController()
        loadData()
        showLaunchAlertIfNeeded()
        
        
    }
    
    private func showLaunchAlertIfNeeded() {
        var launchCounter = UserDefaults.standard.integer(forKey: launchCounterKey)
            launchCounter += 1
            UserDefaults.standard.set(launchCounter, forKey: launchCounterKey)
            
            if launchCounter % 3 == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                    guard let self = self else { return }
                    
                    let alert = UIAlertController(title: "Welcome back!", message: "This is your \(launchCounter)th launch of the app.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        let currentSection = sections[section]
        return currentSection.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RickAndMortyCell") as? CustomTableViewCell else {
            return UITableViewCell()
        }
        let character = fetchedResultsController.object(at: indexPath)
        
        cell.setUpData(character)
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }
        
        detailViewController.delegate = self
        present(detailViewController, animated: true)
        detailViewController.data = fetchedResultsController.object(at: indexPath)
    }
    
    private func initializeFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Character> = Character.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
                fetchRequest.returnsDistinctResults = true // Add this line
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to initialize fetched results controller: \(error)")
        }
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            table.beginUpdates()
        }
        
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            table.endUpdates()
        }
        
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            switch type {
            case .insert:
                if let newIndexPath = newIndexPath {
                    table.insertRows(at: [newIndexPath], with: .automatic)
                }
                
            case .update:
                if let indexPath = indexPath, let cell = table.cellForRow(at: indexPath) as? CustomTableViewCell {
                    let character = fetchedResultsController.object(at: indexPath)
                    cell.setUpData(character)
                }
                
            case .move:
                if let indexPath = indexPath, let newIndexPath = newIndexPath {
                    table.moveRow(at: indexPath, to: newIndexPath)
                }
                
            case .delete:
                if let indexPath = indexPath {
                    table.deleteRows(at: [indexPath], with: .automatic)
                }
                
            @unknown default:
                break
            }
        }
    
    private func loadData() {
        manager.fetchCharacters { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(response):
                let context = self.persistentContainer.viewContext
                
                context.perform {
                    for characterData in response.results {
                        let fetchRequest: NSFetchRequest<Character> = Character.fetchRequest()
                        fetchRequest.predicate = NSPredicate(format: "id == %d", characterData.id)
                        
                        do {
                            let existingCharacters = try context.fetch(fetchRequest)
                            if let existingCharacter = existingCharacters.first {
                                existingCharacter.name = characterData.name
                            } else {
                                let character = Character(context: context)
                                character.id = Int64(characterData.id)
                                character.name = characterData.name
                                character.gender = characterData.gender
                                character.image = characterData.image
                                character.location = characterData.location.name
                                character.species = characterData.species
                                character.status = characterData.status
                            }
                            
                            try context.save()
                        } catch {
                            print("Failed to fetch or save character: \(error)")
                        }
                    }
                }
                
            case let .failure(error):
                print(error)
            }
        }
    }
}

extension ViewController: DetailViewControllerDelegate {
    func changeLocation(with id: Int, value: String) {
        let context = persistentContainer.viewContext
        
        context.perform {
            let fetchRequest: NSFetchRequest<Character> = Character.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            
            do {
                let characters = try context.fetch(fetchRequest)
                if let character = characters.first {
                    character.location? = value
                    try context.save()
                }
            } catch {
                print("Failed to fetch character: \(error)")
            }
        }
        table.reloadData()
        dismiss(animated: true)
    }
    
    func changeSpecies(with id: Int, value: String) {
        let context = persistentContainer.viewContext
        
        context.perform {
            let fetchRequest: NSFetchRequest<Character> = Character.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            
            do {
                let characters = try context.fetch(fetchRequest)
                if let character = characters.first {
                    character.species = value
                    try context.save()
                }
            } catch {
                print("Failed to fetch character: \(error)")
            }
        }
        table.reloadData()
        dismiss(animated: true)
    }
}
