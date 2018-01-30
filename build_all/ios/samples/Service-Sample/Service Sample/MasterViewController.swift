//
//  MasterViewController.swift
//  Service Sample
//
//  Created by Mark Radbourne on 9/21/17.
//  Copyright © 2017 Mark Radbourne. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [IoTDevice]()
    
    private let connectionString = "HostName=MarkRadHub1.azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey=sEsFWaEWgGaapmCZf/0MwhIU0qS8IxoluSbESXr17ZU="

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
//        navigationItem.

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshDevices(_:)))
        navigationItem.rightBarButtonItems = [refreshButton, addButton]
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }

        refreshDevicesImpl()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(_ sender: Any) {
        //objects.insert((NSDate(), "Test"), at: 0)
        //let indexPath = IndexPath(row: 0, section: 0)
        //tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func refreshDevices(_ sender: Any) {
        refreshDevicesImpl()
        self.tableView.reloadData()
    }
    
    func refreshDevicesImpl() {
        let iotHubServiceClientHandle: IOTHUB_SERVICE_CLIENT_AUTH_HANDLE? = IoTHubServiceClientAuth_CreateFromConnectionString(connectionString)
        
        if (iotHubServiceClientHandle == nil) {
            showPopup(title: "Error", message: "Failed to connect to hub")
            return
        }
        
        let iotHubRegistryHandle: IOTHUB_REGISTRYMANAGER_HANDLE? = IoTHubRegistryManager_Create(iotHubServiceClientHandle)
        let deviceList: SINGLYLINKEDLIST_HANDLE? = singlylinkedlist_create()
        var result: IOTHUB_REGISTRYMANAGER_RESULT?
        
        result = IoTHubRegistryManager_GetDeviceList(iotHubRegistryHandle, 20, deviceList)
        
        if (result != IOTHUB_REGISTRYMANAGER_OK) {
            showPopup(title: "Error", message: "Failed to acquire device list")
        }
        else {
            objects.removeAll(keepingCapacity: true)
            var nextDevice: LIST_ITEM_HANDLE? = singlylinkedlist_get_head_item(deviceList)
            
            while (nextDevice != nil) {
                var rawDevice: UnsafeRawPointer
                
                rawDevice = singlylinkedlist_item_get_value(nextDevice)
                
                var unsafeDevice: UnsafePointer<IOTHUB_DEVICE>
                
                unsafeDevice = UnsafePointer<IOTHUB_DEVICE>(rawDevice.assumingMemoryBound(to: IOTHUB_DEVICE.self))
                let device: IOTHUB_DEVICE = unsafeDevice.pointee
                objects.append(IoTDevice.init(rawDevice: device))
                nextDevice = singlylinkedlist_get_next_item(nextDevice)
            }
            IoTHubRegistryManager_Destroy(iotHubRegistryHandle)
            IoTHubServiceClientAuth_Destroy(iotHubServiceClientHandle)
        }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.connectionString = connectionString
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = objects[indexPath.row] 
        cell.textLabel!.text = object.deviceId
        cell.detailTextLabel?.text = (object.connectionState == IOTHUB_DEVICE_CONNECTION_STATE_CONNECTED) ? "Connected" : "Disconnected"
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func showPopup(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
        present(alertController, animated: true, completion: nil)
    }
}

