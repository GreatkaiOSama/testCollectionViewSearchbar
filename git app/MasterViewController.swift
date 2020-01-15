//
//  MasterViewController.swift
//  git app
//
//  Created by Henry Silva Olivo on 1/15/20.
//  Copyright © 2020 hsilva. All rights reserved.
//

import UIKit
import SDWebImage

class MasterViewController: GeneralViewController, CWebserviceDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UITextFieldDelegate , UIGestureRecognizerDelegate,UISearchResultsUpdating{
    
    @IBOutlet var txtbuscar: UITextField!
    

    @IBOutlet var collectionview: UICollectionView!
    
    
    var listarepositorios = [CRepositorio]()
    var filteredlistarepositorios = [CRepositorio]()
    let cellIdentifier = "cellid"
    
    let itemsPerRow: CGFloat = 2
    let sectionInsets = UIEdgeInsets(top: 30.0,left: 10.0,bottom: 30.0,right: 10.0)
    
    let searchController = UISearchController(searchResultsController: nil)

    
    var isFiltered: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureview()
        self.callwsGetListRepostorios()
    }
    
    private func configureview(){
        // Do any additional setup after loading the view.
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
        }
        definesPresentationContext = true
        
        
        self.title = "Repositorios git"
        
        
        self.collectionview.register(UINib.init(nibName: "RepoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.collectionview.isHidden = true
        
        
    }
    
    private func callwsGetListRepostorios(){
        
        self.showLoadingProgress()
        
        let ws = CWebservice()
        ws.delegate = self
        ws.getListRepositorios()
    }
    
    func returnExecutionWithSuccess(identifier: String, retObject: [NSDictionary]?) {
        self.hideLoadingProgress()
        if let diciontarydata = retObject as? [NSDictionary]{
            self.listarepositorios = CRepositorio.createArrayFrom(dictionarys: diciontarydata)
            print(self.listarepositorios.debugDescription)
            self.loadcollectionview()
        }
    }
    
    func returnExecutionWithError(identifier: String, retObject: [NSDictionary]?) {
        self.hideLoadingProgress()
        UIHelperSwift.sampleAlertController(title: "GitApp", message: "Ha ocurrido un error, favor intente nuevamente", arraytextbtns: ["Reintentar"], vc: self) { [weak self](indice) in
            guard let weakself = self else { return }
            if indice == 0 {
                weakself.callwsGetListRepostorios()
            }
        }
    }
    
    private func loadcollectionview(){
        self.collectionview.isHidden = false
        self.collectionview.dataSource = self
        self.collectionview.delegate = self
        self.collectionview.reloadData()
    }
    
    //MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isFiltered {
            return self.filteredlistarepositorios.count
        }else{
            return self.listarepositorios.count
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var item = CRepositorio()
        
        if self.isFiltered {
            item = self.filteredlistarepositorios[indexPath.row]
            self.txtbuscar.resignFirstResponder()
        }else{
            item = self.listarepositorios[indexPath.row]
        }
        
        
        
        if !item.url.isEmpty{
            if let urlrepo = URL.init(string: item.url) {
                UIApplication.shared.open(urlrepo, options: [:], completionHandler: nil)
            }
        }
        print("url a abrir \(item.url)")
        
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! RepoCollectionViewCell
        
        var element = CRepositorio()
        if self.isFiltered {
            element = self.filteredlistarepositorios[indexPath.row]
        }else{
            element = self.listarepositorios[indexPath.row]
        }
        
        //cell.lbltitle.text = element.text
        //cell.lbltitle.font = UIFont().fontMontserratMedium(15.f)
        
        cell.lblrepo.text = element.name
        if !element.avatar.isEmpty{
            if let urlimage = URL.init(string: element.avatar) {
                cell.imgavatar.sd_setImage(with: urlimage, completed: nil)
            }
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3.f
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
      let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
      let availableWidth = view.frame.width - paddingSpace
      let widthPerItem = availableWidth / itemsPerRow
      
      return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      return sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return sectionInsets.left
    }
    
    
    //MARK: - Searchs Func
    
    func filterContentForSearchText(_ searchText: String) {
        self.filteredlistarepositorios = listarepositorios.filter({ (item: CRepositorio) -> Bool in
            return item.name.lowercased().contains(searchText.lowercased())
        })
        self.collectionview.reloadData()
    }
    
    
    @objc func hidekeyboard(tapgestre: UITapGestureRecognizer){
        //print(tapgestre.view)
        self.txtbuscar.resignFirstResponder()
    }
    
    
    @objc func clearsearchbox(){
        self.txtbuscar.text = ""
        self.txtbuscar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
      // TODO
        
        let searchBar = searchController.searchBar
        if let texttoseatch = searchBar.text,texttoseatch.count > 0{
            //print("Text to Search \(texttoseatch)")
            self.isFiltered = true
            self.filterContentForSearchText(texttoseatch)
        }else{
            
            self.isFiltered = false
            self.collectionview.reloadData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
