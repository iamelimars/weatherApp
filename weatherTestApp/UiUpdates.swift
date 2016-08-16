//
//  UiUpdates.swift
//  weatherTestApp
//
//  Created by iMac on 8/9/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}