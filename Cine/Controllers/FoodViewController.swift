//
//  AlimentosViewController.swift
//  Cine
//
//  Created by Pedro Carlos Monzalvo Navarro on 10/7/19.
//  Copyright © 2019 Pedro Carlos Monzalvo Navarro. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cellFood"

class FoodViewController: UICollectionViewController {

    let foodServiceManager = CineAppManager.shared
    var foodItems: [FoodModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Anda en Alimentos")
        let itemSize = UIScreen.main.bounds.width/2
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.foodItems = OrderManager.shared.foodItems
        self.loadData()
    }

    func loadData() {
        foodServiceManager.updateFoodMenu { [weak self] (finishedWithSuccess) in
            guard finishedWithSuccess else {
                //Error
                return
            }
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

    func addToCart() {
        OrderManager.shared.foodItems = foodItems
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let foodItem = foodServiceManager.foodMenu?.foodItems?[indexPath.row], let cell = collectionView.cellForItem(at: indexPath) as? FoodCollectionViewCell else { return }
        OrderManager.shared.foodItems.append(foodItem)

        UIView.animate(withDuration: 0.2) {
            cell.imageFood.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
        }
        UIView.animate(withDuration: 0.3, delay: 0.22, options: [], animations: {
            cell.imageFood.transform = CGAffineTransform.identity
        }, completion: nil)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return foodServiceManager.foodMenu?.foodItems?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FoodCollectionViewCell, let foodItem = foodServiceManager.foodMenu?.foodItems?[indexPath.row] else {
            return UICollectionViewCell()
        }
        // Configure the cell
        cell.update(with: foodItem)
        return cell
    }


}

extension UIViewController {
    func presentDefaultAlert(withMessage message: String) {
        let controller = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "De acuerdo", style: .default, handler: nil)
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
    func presentUserActionRequestAlert(withMessage message: String, andAction action: ((UIAlertAction)->Void)?) {
        let controller = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "No estoy listo", style: .default, handler: nil)
        let action = UIAlertAction(title: "De acuerdo", style: .default, handler: action)
        controller.addAction(action)
        controller.addAction(cancelAction)
        self.present(controller, animated: true, completion: nil)
    }
}
