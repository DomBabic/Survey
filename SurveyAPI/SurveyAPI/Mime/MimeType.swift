//
//  MimeType.swift
//  SurveyAPI
//
//  Created by Dominik Babic on 25.03.2024..
//

import Foundation

/// Enum which defines supported mime types.
public enum MimeType: String {
    /// Used for general requests where content is JSON data.
    case json = "application/json"
    /// Used for multipart requests when uploading files.
    case formData = "multipart/form-data"
    /// Used for multipart reqests when uploading JPEG image data.
    case jpeg = "image/jpeg"
}
