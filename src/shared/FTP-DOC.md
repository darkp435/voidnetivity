# File Transfer Protocol, Version 1.2.9
RFC 2  
Date of publish: April 9, 2070  
Publisher: The Networks Development Task Force  
*This document has been intercepted by the VoidNet association. Some modifications have been applied to the contents of this file. Notes made by the VoidNet association start with "!!!" to avoid potential ambiguity.*
## Abstract
File Transfer Protocol (FTP) is a protocol that allows for a user to exchange files between two hosts efficiently, assuming they have the correct permissions to do so.
## Status of this memo
This document is available to the public for referral. There are no risks in owning this document or referring to it externally.  
## Publication notes
This document has been published from the host "ndtf-misc", containing the original copy and all preserved versions of it for historical and review purposes. This document is mutable and the content is subject to change without warning or notice.
## Introduction
*!!! The rest of this section has been removed in this file due to it being deemed unnecessary for VoidNet purposes.*
## Functionality
### Initiation
A user will go to the FTP daemon of one host to launch it. Then, the user will be prompted to log in to a target host, and, if succeeded, will be in a menu where they can send FTP methods. The "origin host" refers to the host where the user is interacting with FTP, and the "target host" refers to the changeable host where the connection is connected to.
### FTP Methods
Any unnecessary extra data being sent to the server will be ignored (e.g. sending a file name in a List request will result in the server ignoring it).  
*!!! Although the server ignores it, it still gets transferred. This property could be used in other files...*
#### "Get" method
The Get method, suggested by the name, attempts to transfer a file from the target host to the origin host. The client **must** send the file name in the request as well, failure to do so will result in an error.
#### "Put" method
The Put method, contrary to the Get method, attempts to transfer a file from the origin host to the target host. Similar to the Get method, you **must** also send the file name in the request.
#### "List" method
The List method lists the transferrable files on the origin host. It does not send any request to the server, as the list of files are local.  
*!!! If a file is hidden and the client hasn't discovered it, it **does not** appear in the response.*
#### "ListRemote" method
The ListRemote method queries the target host for the list of transferrable files there.
#### "Open" method
*!!! The rest of this section has been removed in this file due to it being deemed unnecessary for VoidNet purposes.*
#### "Exit" method
*!!! The rest of this section has been removed in this file due to it being deemed unnecessary for VoidNet purposes.*
#### "SwitchHost" method
The SwitchHost method closes the connection between the origin and target host in favor of a new target host specified by the client.
#### "Pay" method
The Pay method confirms if the user wants to pay the specified FTP fee in order to continue.
## Response status codes
Status codes prefixed with 1 indicates success (e.g. 100), status codes prefixed with 2 indicates errors raised by the server (e.g. 201), status codes prefixed with 3 indicates that the request has currently been successful but may fail later on (e.g. 300), status codes prefixed with 4 indicates errors raised by the client, and status codes prefixed with 5 (e.g. 500) are all other errors that do not fit into the categories described above.
### 100 Success
Indicates that the request was successful.
### 101 Data Discarded
Indicates that the request was successful, but the request had unnecessary data being sent that the server has discarded.
### 200 Broken Pipe
Indicates that the connection has been terminated during transmission by the target host.
### 201 Interrupted
Indicates that the connection was interrupted, but not broken.
*!!! This is usually due to malicious personnel being near and attempting to interrupt the connection.*
### 202 Permission Denied
Indicates that the user has insufficient privilege to transfer the file on the server.
### 203 Blacklisted
Indicates that the connection cannot continue because the user has been blacklisted from interacting with FTP on the target host.
### 204 Server Protocol Incompatible
The protocol on the server is outdated or incompatible with the one on the client.
### 300 Pending
Indicates that the request is ongoing.
### 301 Switching Encryption
Indicates that the target host is currently switching encryption algorithms to match the one used by the origin host.
### 400 Too Many Requests
Indicates that there were too many requests being sent.
*!!! Very rare to happen normally.*
### 401 Invalid Method
The method was invalid.
### 402 Data Needed
The method required extra data to be sent, but the request did not have the extra data.
*!!! Very rare to happen normally*
### 403 Client Protocol Incompatible
The protocol on the client is outdated or incompatible with the one on the server (i.e. the protocol on the server should be favoured).
### 404 Not Found
The file to be transferred was not found.
### 500 Unknown Error
An unusual error has occured that does not fit the criteria of any other errors.
*!!! Very rare to happen normally.*
### 501 Unstable Connection
The connection is shutting down because the connection was too unstable to be used.
## Implementation
*!!! The rest of this section has been removed in this file due to it being deemed unnecessary for VoidNet purposes.*
## Security considerations
The connection **must** be encrypted (preferably with the ENC50021 algorithm). However, developers should take extra security measures when programming and running the daemons to minimise potential hackers tampering with it. Due to that reason, take caution when transferring confidential and/or important files.
## Request for comments
*!!! The rest of this section has been removed in this file due to it being deemed unnecessary for VoidNet purposes.*
## Acknowledgements
*!!! The rest of this section has been removed in this file due to it being deemed unnecessary for VoidNet purposes.*