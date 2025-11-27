// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ChainVantage {
    struct Record {
        address owner;
        uint256 timestamp;
        string metadata; // Could be IPFS link or description
    }

    // Mapping of record ID to record
    mapping(uint256 => Record) private records;
    uint256 private nextRecordId = 1;

    // Event emitted when a new record is created
    event RecordCreated(uint256 indexed recordId, address indexed owner, uint256 timestamp, string metadata);

    // Event emitted when a record is updated
    event RecordUpdated(uint256 indexed recordId, string metadata);

    // Function to create a new record
    function createRecord(string memory metadata) external {
        records[nextRecordId] = Record({
            owner: msg.sender,
            timestamp: block.timestamp,
            metadata: metadata
        });

        emit RecordCreated(nextRecordId, msg.sender, block.timestamp, metadata);
        nextRecordId++;
    }

    // Function to view a record by ID
    function viewRecord(uint256 recordId) external view returns (address owner, uint256 timestamp, string memory metadata) {
        Record memory r = records[recordId];
        require(r.timestamp != 0, "Record does not exist");
        return (r.owner, r.timestamp, r.metadata);
    }

    // Function to update a record (only by owner)
    function updateRecord(uint256 recordId, string memory metadata) external {
        Record storage r = records[recordId];
        require(r.owner == msg.sender, "Not the owner");
        r.metadata = metadata;

        emit RecordUpdated(recordId, metadata);
    }

    // Get total number of records
    function totalRecords() external view returns (uint256) {
        return nextRecordId - 1;
    }
}
