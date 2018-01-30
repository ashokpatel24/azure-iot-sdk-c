//
//  DetailViewController.swift
//  Service Sample
//
//  Created by Mark Radbourne on 9/21/17.
//  Copyright © 2017 Mark Radbourne. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var lblDeviceId: UILabel!
    @IBOutlet weak var lblConnected: UILabel!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var lblReceived: UILabel!
    
    var recvdLabelCount: Int = 0
    let maxLabelCount = 22
    var iotHubServiceClientHandle: IOTHUB_SERVICE_CLIENT_AUTH_HANDLE!
    var iotHubMessagingHandle: IOTHUB_MESSAGE_HANDLE!
    
    var timerDoWork: Timer!
    
    let openCompleteCallback: IOTHUB_OPEN_COMPLETE_CALLBACK! = { userContext
        in
        
        print("Open is complete")
    }
    
    let sendCompleteCallback: IOTHUB_SEND_COMPLETE_CALLBACK! = { userContext, messagingResult
        in
        
        print("Send result: %d", messagingResult)

        var mySelf: DetailViewController = Unmanaged<DetailViewController>.fromOpaque(userContext!).takeUnretainedValue()
        
        mySelf.btnSend.isEnabled = true
    }
    
    let feedbackMessageReceivedCallback: IOTHUB_FEEDBACK_MESSAGE_RECEIVED_CALLBACK = { userContext, feedbackBatchPtr
        in
        
        // Get pointer to class instance
        var mySelf: DetailViewController = Unmanaged<DetailViewController>.fromOpaque(userContext!).takeUnretainedValue()
        
        let feedbackBatch: IOTHUB_SERVICE_FEEDBACK_BATCH? = (feedbackBatchPtr?.pointee)!
        
        if (feedbackBatch != nil && feedbackBatch?.feedbackRecordList != nil) {
            
            var feedbackRecord: LIST_ITEM_HANDLE! = singlylinkedlist_get_head_item(feedbackBatch?.feedbackRecordList)
            
            while (feedbackRecord != nil) {
                
                var rawFeedback: UnsafeRawPointer = singlylinkedlist_item_get_value(feedbackRecord)
                
                var unsafeFeedback: UnsafePointer<IOTHUB_SERVICE_FEEDBACK_RECORD>
                
                unsafeFeedback = UnsafePointer<IOTHUB_SERVICE_FEEDBACK_RECORD>(rawFeedback.assumingMemoryBound(to: IOTHUB_SERVICE_FEEDBACK_RECORD.self))
                let feedback: IOTHUB_SERVICE_FEEDBACK_RECORD = unsafeFeedback.pointee
                
                // Do something with feedback here
                print("deviceId: %s\r\n", feedback.deviceId)
            }
        }
    }

    func dowork() {
        if (iotHubMessagingHandle != nil) {
            IoTHubMessaging_LL_DoWork(iotHubMessagingHandle)
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = lblDeviceId {
                label.text = detail.deviceId
            }
            if let label = lblConnected {
                label.text = (detail.connectionState == IOTHUB_DEVICE_CONNECTION_STATE_CONNECTED) ? "Connected" : "Disconnected"
            }
        }
    }
    
    func connectToHub() {
        
        lblReceived.sizeToFit()
        iotHubServiceClientHandle = IoTHubServiceClientAuth_CreateFromConnectionString(connectionString)
        
        if (iotHubServiceClientHandle == nil) {
            showPopup(title: "Error", message: "Failed to connect to hub")
            return
        }
        
        iotHubMessagingHandle = IoTHubMessaging_LL_Create(iotHubServiceClientHandle)
        
        if (iotHubMessagingHandle == nil) {
            showPopup(title: "Error", message: "Failed to create messaging handle")
            IoTHubServiceClientAuth_Destroy(iotHubServiceClientHandle)
            iotHubServiceClientHandle = nil
            return
        }
        
        let that = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        
        if (IOTHUB_MESSAGING_OK != IoTHubMessaging_LL_SetFeedbackMessageCallback(iotHubMessagingHandle, feedbackMessageReceivedCallback, that)) {
            showPopup(title: "Error", message: "Failed to set up feedback callback")
            IoTHubMessaging_LL_Destroy(iotHubMessagingHandle)
            iotHubMessagingHandle = nil
            IoTHubServiceClientAuth_Destroy(iotHubServiceClientHandle)
            iotHubServiceClientHandle = nil
            return
        }
        
        if (IOTHUB_MESSAGING_OK != IoTHubMessaging_LL_Open(iotHubMessagingHandle, openCompleteCallback, that)) {
            showPopup(title: "Error", message: "Failed to set up feedback callback")
            IoTHubMessaging_LL_Destroy(iotHubMessagingHandle)
            iotHubMessagingHandle = nil
            IoTHubServiceClientAuth_Destroy(iotHubServiceClientHandle)
            iotHubServiceClientHandle = nil
            return
        }
        
        timerDoWork = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(dowork), userInfo: nil, repeats: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        connectToHub()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        if (iotHubServiceClientHandle != nil) {
            if (iotHubMessagingHandle != nil) {
                IoTHubMessaging_LL_Close(iotHubMessagingHandle)
                IoTHubMessaging_LL_Destroy(iotHubMessagingHandle)
            }
            
            IoTHubServiceClientAuth_Destroy(iotHubServiceClientHandle)
        }
        
        timerDoWork?.invalidate()
    }

    var detailItem: IoTDevice? {
        didSet {
            // Update the view.
            //configureView()
        }
    }
    
    // Public - value set by masterViewController
    var connectionString: String?

    @IBAction func sendMessage(sender: UIButton) {
        
        if ((txtMessage.text?.characters.count)! > 0) {
            let that = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
            let messageHandle = IoTHubMessage_CreateFromString(txtMessage.text?.cString(using: String.Encoding.utf8))
            
            if (IOTHUB_MESSAGING_OK != IoTHubMessaging_LL_Send(iotHubMessagingHandle, lblDeviceId.text, messageHandle, sendCompleteCallback, that)) {
                showPopup(title: "Error", message: "Message send failed")
            }
            else {
                btnSend.isEnabled = false
            }
        }
        else {
            showPopup(title: "Error", message: "You must input a message to send")
        }
    }
    
    func showPopup(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
        present(alertController, animated: true, completion: nil)
    }
}

