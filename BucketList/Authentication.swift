//
//  Authentication.swift
//  BucketList
//
//  Created by 최준영 on 2023/01/13.
//

import Foundation
import SwiftUI
import LocalAuthentication

struct AuthenticationManager {
    @Binding var isUnlocked: Bool
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                if success {
                    isUnlocked = true
                } else {
                    print(error?.localizedDescription ?? "Error")
                }
            }
        }
    }
}
