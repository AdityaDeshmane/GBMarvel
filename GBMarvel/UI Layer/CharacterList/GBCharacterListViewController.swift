//
//  ViewController.swift
//  GBMarvel
//
//  Created by Aditya Deshmane on 17/05/21.
//

import UIKit
import Foundation


class GBCharacterListViewController: UIViewController {
    
    @IBOutlet private weak var characterListTableView: UITableView!
    /// footer label to set message
    @IBOutlet private weak var footerLabel: UILabel!
    @IBOutlet private weak var loadingFooterView: UIView!
    
    var presenterRequestDelegate: GBCharacterListPresenterRequestDelegate?//Keeping strong reference as its forward request delegate
    var router: GBCharacterListRouter?
    private var arrCharacterList: [GBUILayerCharacterListItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureData()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = LocalisationKey.MarvelCharacterList.title
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    
    private func configureData() {
        presenterRequestDelegate?.fetchCharacterListUsingPagination()
    }
    
    private func configureUI() {
        characterListTableView.prefetchDataSource = self
        loadingFooterView.isHidden = false
        configureLocalisedStrings()
    }
    
    /// Setup all texts via Localisation file
    private func configureLocalisedStrings() {
        footerLabel.text = LocalisationKey.MarvelCharacterList.footerTitle
    }
    
    class func getViewController() -> GBCharacterListViewController? {
        return UIStoryboard(name: GBUILayerConstants.GBStoryboards.GBCharacterFlow, bundle: nil).instantiateViewController(withIdentifier: GBUILayerConstants.GBViewControllers.GBCharacterListViewController) as? GBCharacterListViewController
    }
}

// MARK: - GBCharacterListPresenterResponseDelegate
extension GBCharacterListViewController: GBCharacterListPresenterResponseDelegate {
    
    
    func success(arrCharacters: [GBUILayerCharacterListItem]) {
        print("GBCharacterListViewController: success")
        arrCharacterList.append(contentsOf: arrCharacters)
        characterListTableView.reloadData()
        self.loadingFooterView.isHidden = true
    }
    
    func failed(error: GBUILayerError) {
        print("GBCharacterListViewController: failed")
        let msg =  GBUILayerErrorUtility.shared.stringForError(error: error)
        let alert = GBUILayerAlertUtility.shared.createSimpleAlertWithMessage(message: msg)
        if let presented = self.presentedViewController {
             presented.removeFromParent()
          }

        if self.presentedViewController == nil {
             self.present(alert, animated: true, completion: nil)
        }
        
        self.loadingFooterView.isHidden = true
    }
}

// MARK: - UITableViewDataSource
extension GBCharacterListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCharacterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GBCharacterListCell.cellIdentifierString) as? GBCharacterListCell else {
            return UITableViewCell()
        }
        let title = "\(indexPath.row+1).  " + arrCharacterList[indexPath.row].name
        cell.configure(strTitle: title)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension GBCharacterListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let navController = self.navigationController {
            router?.rowClicked(navController: navController, characterId: arrCharacterList[indexPath.row].charId)
        }
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension GBCharacterListViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let visibleCellCount = tableView.visibleCells.count// ~20 for bigger iphones
        // Fetch next batch if prefetch requested cell which has index greater than (arrCharacterList.count - visibleCellCount)
        // If array has 100 elements currently and if prefetch requests 80th element (100-20) then make future data request
        if indexPaths.contains(where: {$0.row > (arrCharacterList.count - visibleCellCount) }) {
            if let requestDel = presenterRequestDelegate {
                if requestDel.fetchCharacterListUsingPagination() {
                    loadingFooterView.isHidden = false
                }
            }
        }
    }
}
