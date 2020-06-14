//
//  WError.swift
//  Wasteland
//
//  Created by Liam Stevenson on 3/5/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

/// An error used in WCore.
public protocol WError: Error { }

/// There was an error connecting to the back-end server.
public struct NetworkingError: Error { }

/// The requested object does not exist.
public struct NonExistentError: Error { }

/// There is an attempt to perform a redundant operation
public struct RedundantError: Error { }

/// There is an unknown error.
public struct UnknownError: Error { }
