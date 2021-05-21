//
//  GBCharacterDetailViewController.swift
//  GBMarvel
//
//  Created by Aditya Deshmane on 17/05/21.
//

import Foundation
import UIKit

class GBCharacterDetailViewController: UITableViewController {
    
    var presenterRequestDelegate: GBCharacterDetailPresenterRequestDelegate?//Keeping strong reference as its forward request delegate
    private var charId: String?
    private var charDetail: GBUILayerCharacterDetail?
    @IBOutlet private weak var loadingLabel: UILabel!
    @IBOutlet private weak var loadingView: UIView!

    @IBOutlet private weak var cellName: UITableViewCell!
    @IBOutlet private weak var cellDescription: UITableViewCell!
    @IBOutlet private weak var labelDescription: UILabel!
    @IBOutlet private weak var cellComics: UITableViewCell!
    @IBOutlet private weak var cellStories: UITableViewCell!
    @IBOutlet private weak var cellSeries: UITableViewCell!
    @IBOutlet private weak var cellEvents: UITableViewCell!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureData()
        configureUI()
    }
    
    func inputParameters(charId: String) {
        self.charId = charId
    }
    
    private func configureData() {
        if let charIdentifier = charId {
            loadingView.isHidden = false
            presenterRequestDelegate?.fetchCharacterDetail(charId: charIdentifier)
        }
    }
    
    private func configureUI() {
        configureLocalisedStrings()
        self.tableView.tableFooterView = UIView()
    }
    
    /// Setup all texts via Localisation file
    private func configureLocalisedStrings() {
        self.title = LocalisationKey.MarvelCharacterDetail.title
        loadingLabel.text = LocalisationKey.MarvelCharacterDetail.loadingTitle
     }
    
    /// Using automatic dimension so 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    class func getViewController() -> GBCharacterDetailViewController? {
        return UIStoryboard(name: GBUILayerConstants.GBStoryboards.GBCharacterFlow, bundle: nil).instantiateViewController(withIdentifier: GBUILayerConstants.GBViewControllers.GBCharacterDetailViewController) as? GBCharacterDetailViewController
    }
}

// MARK: - GBCharacterDetailPresenterResponseDelegate
extension GBCharacterDetailViewController: GBCharacterDetailPresenterResponseDelegate {
    
    func success(charDetail: GBUILayerCharacterDetail) {
        print("GBCharacterDetailViewController: success")
        self.charDetail = charDetail
        updateUI()
        self.loadingView.isHidden = true
    }
    
    private func updateUI() {
        cellName.textLabel?.text = LocalisationKey.MarvelCharacterDetail.name + ":  " + (charDetail?.name ?? "")
        labelDescription.text = LocalisationKey.MarvelCharacterDetail.description + ":\n\n" + (charDetail?.description ?? "")
        cellComics.textLabel?.text = LocalisationKey.MarvelCharacterDetail.comics + ":  " + "\(charDetail?.comics ?? 0)"
        cellStories.textLabel?.text = LocalisationKey.MarvelCharacterDetail.stories + ":  " +  "\(charDetail?.stories ?? 0)"
        cellSeries.textLabel?.text = LocalisationKey.MarvelCharacterDetail.series + ":  " +  "\(charDetail?.series ?? 0)"
        cellEvents.textLabel?.text = LocalisationKey.MarvelCharacterDetail.events + ":  " +  "\(charDetail?.events ?? 0)"

        tableView.reloadData()
    }
    
    func failed(error: GBUILayerError) {
        print("GBCharacterDetailViewController: failed")
        let msg =  GBUILayerErrorUtility.shared.stringForError(error: error)
        let alert = GBUILayerAlertUtility.shared.createSimpleAlertWithMessage(message: msg)
        if let presented = self.presentedViewController {
             presented.removeFromParent()
        }

        if self.presentedViewController == nil {
             self.present(alert, animated: true, completion: nil)
        }
        self.loadingView.isHidden = true
    }
}
