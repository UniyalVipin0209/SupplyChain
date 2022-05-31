// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract SupplyChain{
    //Below variable are pointers currently pointing to the updated identties
    uint32 public product_id=0;// Product_Id
    uint32 public participant_id=0;// Participant_Id
    uint32 public ownership_id=0;// Ownership_Id

    //participant can be any of these value Manufacturers, suppliers, shippers, consumers
    struct participant{
        string userName;
        string password;
        string participantType;
        address participantAddress;
    }
    mapping(uint32=>participant) public participants;

    struct product{
        string modelNumber;
        string partNumber;
        string serialNumber;
        address productOwner;
        uint32 cost;
        uint256 mfgTimeStamp;
    }
    mapping(uint32=>product) public products;

    modifier OnlyOwner(uint32 _productId){
        require(msg.sender == products[_productId].productOwner,"");
        _;
    }

    struct ownership{
        uint32 productId;
        uint32 ownerId;
        uint256 txnTimeStamp;
        address productOwner;
    }
    mapping(uint32=>ownership) public ownerships;
    mapping(uint=>uint32[]) public productTrack;

    event TransferOwnership(uint32 productId);
    function addProduct(uint32 _ownerId,
                        string  memory _modelNumber,
                        string memory _partNumber,
                        string memory _serialNumber,
                        uint32 _cost) public returns(uint32){
            uint32 _productId = product_id++;
            products[_productId].modelNumber = _modelNumber;
            products[_productId].partNumber = _partNumber;
            products[_productId].serialNumber = _serialNumber;
            products[_productId].productOwner = participants[_ownerId].participantAddress;
            products[_productId].cost = _cost;
            products[_productId].mfgTimeStamp = block.timestamp;
            
            return _productId;
    }
    function getProduct(uint32 _productId) public view returns(
                    string memory,
                    string memory,
                    string memory,
                    address,
                    uint32,
                    uint256
                        ){

            product memory p = products[_productId];
            return(
                    p.modelNumber,
                    p.partNumber,
                    p.serialNumber,
                    p.productOwner,
                    p.cost,
                    p.mfgTimeStamp
                );
    }
    function addParticipant(string memory _name,
        string memory _password,
        string memory _pType,
        address _pAddress) public returns(uint32){
            uint32 userid = participant_id++;
            participants[userid].userName = _name;
            participants[userid].password = _password;
            participants[userid].participantType = _pType;
            participants[userid].participantAddress = _pAddress;
            return userid;
        }
 
    function getParticipant(uint32 _participantId) public view
                                 returns(string memory,
                                    string memory,address){
                    return(
                            participants[_participantId].userName,
                            participants[_participantId].participantType,
                            participants[_participantId].participantAddress
                        );
            }

function newOwner(uint32 _user1, uint32 _user2, uint32 _productId) public OnlyOwner(_productId) returns(bool){
        participant memory p1 = participants[_user1];
        participant memory p2 = participants[_user2];
        uint32 ownershipId = ownership_id++;
        //First Participant is Manaufacturer and Second Participant is supplier
        if(keccak256(abi.encodePacked(p1.participantType)) == keccak256("Manufacturer") &&
                keccak256(abi.encodePacked(p2.participantType)) == keccak256("Supplier"))
                {
                    ownerships[ownershipId].productId = _productId;
                    ownerships[ownershipId].ownerId = _user2;
                    ownerships[ownershipId].txnTimeStamp = block.timestamp;
                    ownerships[ownershipId].productOwner = p2.participantAddress;
                    productTrack[_productId].push(ownershipId);

                    //event of Ownership Changed
                    emit TransferOwnership(_productId);
                    return true;
                }
         //First Participant is supplier and Second Participant is also supplier
        else if(keccak256(abi.encodePacked(p1.participantType)) == keccak256("Supplier") &&
                keccak256(abi.encodePacked(p2.participantType)) == keccak256("Supplier"))
                {
                    ownerships[ownershipId].productId = _productId;
                    ownerships[ownershipId].ownerId = _user2;
                    ownerships[ownershipId].txnTimeStamp = block.timestamp;
                    ownerships[ownershipId].productOwner = p2.participantAddress;
                    productTrack[_productId].push(ownershipId);

                    //event of Ownership Changed
                    emit TransferOwnership(_productId);
                    return true;
                }
        //First Participant is supplier and Second Participant is also supplier
        else if(keccak256(abi.encodePacked(p1.participantType)) == keccak256("Supplier") &&
                keccak256(abi.encodePacked(p2.participantType)) == keccak256("Consumer"))
                {
                    ownerships[ownershipId].productId = _productId;
                    ownerships[ownershipId].ownerId = _user2;
                    ownerships[ownershipId].txnTimeStamp = block.timestamp;
                    ownerships[ownershipId].productOwner = p2.participantAddress;
                    productTrack[_productId].push(ownershipId);

                    //event of Ownership Changed
                    emit TransferOwnership(_productId);
                    return true;
                }

        return false;
}




}