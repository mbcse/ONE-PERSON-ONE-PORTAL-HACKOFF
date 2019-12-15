pragma solidity ^0.5.0;

contract kyc
{

enum Status { NotExist, Pending, Approved, Rejected }

    struct customer
    {
        address cus_key;
        uint id;
        string fname;
        string lname;
        uint dob;
      
    }


    struct documents_send_recieve
    {
        uint[] docarr;
        uint[] recieveddocarr;
    }

    struct docs
    {
        
        string fname_kyc;
        string lname_kyc;
        uint dob_kyc;
        address dochash;
        string data;
        uint tdocs;
        address cus_key;
    }

    struct recieveddoc
    {
        address r_key;
        address s_key;
        Status status;
        uint rid;
        uint sid;
        string fname_kyc;
        string lname_kyc;
        address dochash;
    }
    
    
  


  
  uint totaldocuments;

  mapping(address => customer) public customers; //customer id mapped to customer structure 
  mapping(uint => docs) public documents; //document id mapped to documents structure
  //mapping(uint => docuarr) public cdmap; //customers mapped to documents
  mapping(uint => bool) public verified; //document mapped to boolean
  
  mapping(uint => recieveddoc) public recieved ;//recieved id mapping to recieveddoc structure
  mapping(uint => bool) public recieved_doc_bool;

  mapping(address => documents_send_recieve ) dsr;

  function createcustomer(uint _id, string memory _fname,string memory _lname,uint _dob)  public  returns (bool)  {
	  customers[msg.sender] = customer(msg.sender,_id,_fname,_lname,_dob);
	  return true;
	}

    function createkyc(uint _id,string memory _fname,string memory _lname,uint _dob,address _dochash,string memory _data,uint _tdocs) public returns (bool)
    {
        
         documents[++totaldocuments] =docs( _fname,_lname, _dob,_dochash, _data, _tdocs,msg.sender);
         dsr[msg.sender].docarr.push(totaldocuments);  

    }


  	modifier verifieddoc(uint did) {
	    require(verified[did]);
	    _;
	}


    function recieveddocuments(address r_key,uint _sid,uint _rid,string memory _fname_kyc,string memory _lname_kyc,address _dochash) public returns (bool)
    {
        uint  temp=bytes(_fname_kyc).length+bytes(_lname_kyc).length+_sid+_rid;
        recieved[temp]=recieveddoc(r_key,msg.sender,Status.Pending,_rid,_sid,_fname_kyc,_lname_kyc,_dochash);
        dsr[r_key].recieveddocarr.push(temp);
        recieved[temp].status = Status.Pending;
        return true;
    }



	function approvekyc(uint doid) public returns (bool)  {
		require(recieved[doid].r_key == msg.sender);
		recieved[doid].status = Status.Approved;
		return true;
	}

    
   function rejectkyc(uint doid) public returns (bool)  {
		require(recieved[doid].r_key == msg.sender);
		recieved[doid].status = Status.Rejected;
		return true;
	}
	
	
	function verifykyc(uint doid) public returns(bool)
	{
	    address  myAddress = 0xE0f5206BBD039e7b0592d8918820024e2a7437b9;
	    require(documents[doid].cus_key != msg.sender);
	    require(myAddress == msg.sender);
	    verified[doid]=true;
		
		return true;
	}
	
	function any_verified(address s) public returns(bool)
	{
	    uint f=0;
	    for(uint i=0; i<dsr[s].docarr.length; i++)
	    {
	        if(verified[dsr[s].docarr[i]] ==true)
	        {
	            f=1;
	            break;
	        }
	    }
	    
	    if(f==1)
	    {
	        return true;
	    }
	    
	    else
	    {
	        return false;
	    }
	}
	
	
	

}

   

    





     




