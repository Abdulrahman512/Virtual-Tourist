//
//  File.swift
//  Virtual Tourist
//
//  Created by Abdulrahman Althobaiti on 13/11/1440 AH.
//  Copyright © 1440 Abdulrahman Althobaiti. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate {


    @IBOutlet weak var mapUIView: MKMapView!
    var fetchResultController : NSFetchedResultsController<Pin>!
    
    func loadPins() {
        let fetchRequest : NSFetchRequest<Pin>
        fetchRequest = Pin.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        
        do {
            try fetchResultController.performFetch()
            addMapAnnotations()
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func addMapAnnotations() {
        var annotaions = [MKPointAnnotation]()
        
        guard let pins = fetchResultController.fetchedObjects else {return}
        
        for pin in pins {
            if mapUIView.annotations.contains(where: { pin.compare(to: $0.coordinate)}) {continue}
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = pin.coordinate
            annotaions.append(annotation)
        }
        mapUIView.addAnnotations(annotaions)
    }
    
    func  mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let pin = fetchResultController.fetchedObjects?.filter { $0.compare(to: view.annotation!.coordinate)}.first!
        performSegue(withIdentifier: "goToPhotoAlbum", sender: pin)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        addMapAnnotations()
}

    @IBAction func longPressGesture(sender: UIGestureRecognizer) {
        if sender.state == .began {
            let locationOnMap =  sender.location(in: mapUIView)
            let coordinate = mapUIView.convert(locationOnMap, toCoordinateFrom: mapUIView)
            let pin = Pin(context: DataController.shared.viewContext)
            pin.coordinate = coordinate
            try? DataController.shared.viewContext.save()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPins()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchResultController = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPhotoAlbum" {
            let photoCollection = segue.destination as! PhotoCollectionVC
            photoCollection.pin = sender as? Pin
        }
    }
    
    
    @IBAction func signOut(_ sender: Any) {
        UdacityAPI.deleteSession { (error) in
            if let error = error {
                self.alert(title: "Error", message: error.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
}

