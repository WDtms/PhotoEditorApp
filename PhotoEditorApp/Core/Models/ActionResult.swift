//
//  ActionResult.swift
//  PhotoEditorApp
//
//  Created by Aleksey Shepelev on 09.08.2024.
//

import Foundation

enum ActionResult<TRes, TErr> {
    case error(error: TErr)
    case success(result: TRes)
}
