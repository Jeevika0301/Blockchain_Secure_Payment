// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OrderStore {
    struct Order {
        address buyer;
        string itemName;
        uint256 price;
        string ipfsHash;
    }

    Order[] public orders;

    event OrderPlaced(
        address indexed buyer,
        string itemName,
        uint256 price,
        string ipfsHash
    );

    // Place a single order
    function placeOrder(
        string memory item,
        uint256 price,
        string memory ipfsHash
    ) public payable {
        require(msg.value >= price, "Insufficient ETH sent for item");

        orders.push(Order(msg.sender, item, price, ipfsHash));
        emit OrderPlaced(msg.sender, item, price, ipfsHash);
    }

    // Place multiple items in one transaction (batch)
    function placeOrderBatch(
        string[] memory itemNames,
        uint256[] memory prices,
        string[] memory ipfsHashes
    ) public payable {
        uint256 count = itemNames.length;
        require(
            count == prices.length && count == ipfsHashes.length,
            "Array length mismatch"
        );

        uint256 totalCost = 0;
        for (uint256 i = 0; i < count; i++) {
            totalCost += prices[i];
        }

        require(msg.value >= totalCost, "Not enough ETH sent for batch order");

        for (uint256 i = 0; i < count; i++) {
            orders.push(Order(msg.sender, itemNames[i], prices[i], ipfsHashes[i]));
            emit OrderPlaced(msg.sender, itemNames[i], prices[i], ipfsHashes[i]);
        }
    }

    // Get all orders for the current user
    function getMyOrders() public view returns (Order[] memory) {
        uint256 total = 0;
        for (uint256 i = 0; i < orders.length; i++) {
            if (orders[i].buyer == msg.sender) {
                total++;
            }
        }

        Order[] memory result = new Order[](total);
        uint256 j = 0;
        for (uint256 i = 0; i < orders.length; i++) {
            if (orders[i].buyer == msg.sender) {
                result[j] = orders[i];
                j++;
            }
        }

        return result;
    }
}
