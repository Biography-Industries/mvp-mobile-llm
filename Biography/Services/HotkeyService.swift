//
//  HotkeyService.swift
//  Biography
//
//  Created by Augustinas Malinauskas on 11/02/2024.
//

#if os(macOS)
import Foundation
import Magnet
import SwiftUI

final class HotkeyService {
    static let shared = HotkeyService()
    
    func registerSingleUseSpace(modifiers: NSEvent.ModifierFlags, completion: @escaping () -> ()?) {
        if let keyCombo = KeyCombo(key: .space, cocoaModifiers: modifiers) {
            let hotKey = HotKey(identifier: "space", keyCombo: keyCombo) { hotKey in
                completion()
                hotKey.unregister()
            }
            hotKey.register()
        }
    }
    
//    func registerSingleUseEscape(modifiers: NSEvent.ModifierFlags, completion: @escaping () -> ()?) {
//        if let keyCombo = KeyCombo(key: .escape, cocoaModifiers: modifiers) {
//            let hotKey = HotKey(identifier: "escape", keyCombo: keyCombo) { hotKey in
//                completion()
//                hotKey.unregister()
//            }
//            hotKey.register()
//        }
//    }
}

#endif
