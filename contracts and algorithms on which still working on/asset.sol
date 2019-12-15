pragma solidity ^0.5.0;
import './kyc.sol';
contract asset {

    kyc k;
    
    
    constructor (kyc a) public
    {
        k=a;
    }
    
	enum Status { NotExist, Pending, Approved, Rejected }
	
	
	 struct property_send_recieve
    {
        uint[] cprop;
        uint[] rprop;
    }
	

	struct PropertyDetail {
		Status status;
		uint value;
		address currOwner;
		address doc_hash_p;//document hash 

	}

	// Dictionary of all the properties, mapped using their { propertyId: PropertyDetail } pair.
	mapping(uint => PropertyDetail) public properties;
	mapping(uint => address) public propOwnerChange;

    mapping(address => int) public users;
    mapping(address => bool) public verifiedUsers;
    
    mapping(address => property_send_recieve)  psr;
    
    	modifier verifiedUser(address s) {
	    require(k.any_verified(s));
	    _;
	}

	modifier onlyOwner(uint _propId) {
		require(properties[_propId].currOwner == msg.sender);
		_;
	}


 

	// Create a new Property.
       function createProperty(uint _propId, uint _value,address doch)  verifiedUser(msg.sender) public returns (bool)  {
		properties[_propId] = PropertyDetail(Status.Pending, _value, msg.sender,doch);
		return true;
	}

	// Approve the new Property.


	// Reject the new Property.


	// Request Change of Ownership.
	function changeOwnership(uint _propId, address _newOwner) onlyOwner(_propId) verifiedUser(_newOwner) public returns (bool)  {
		require(properties[_propId].currOwner != _newOwner);
		require(propOwnerChange[_propId] == address(0));
		propOwnerChange[_propId] = _newOwner;
		psr[_newOwner].rprop.push(_propId);
		deleteasset(_propId);
		
		return true;
	}

	// Approve chage in Onwership.


	// Change the price of the property.
     function changeValue(uint _propId, uint _newValue) onlyOwner(_propId) public returns (bool)  {
        require(propOwnerChange[_propId] == address(0));
        properties[_propId].value = _newValue;
        return true;
    }

	// Get the property details.
	 function getPropertyDetails(uint _propId) view public returns (Status, uint, address)  {
		return (properties[_propId].status, properties[_propId].value, properties[_propId].currOwner);
	}

	
     




function deleteasset(uint assetId) public {
        bool assetFound = false;
        // Check if the asset found is the last asset (or we go out of boundaries)
        if (psr[msg.sender].cprop[psr[msg.sender].cprop.length-1] == assetId){
            assetFound = true;
        }

        else{
            // Iterate over all user assets and find its index
            for (uint i = 0; i < psr[msg.sender].cprop.length-1; i++) {
                if (!assetFound && psr[msg.sender].cprop[i] == assetId)
                    assetFound = true;

                if(assetFound)
                    psr[msg.sender].cprop[i] = psr[msg.sender].cprop[i + 1];
            }
        }

        if (assetFound){
            delete psr[msg.sender].cprop[psr[msg.sender].cprop.length-1];
            psr[msg.sender].cprop.length--;
        }
    }
	
	
	
	

    
}