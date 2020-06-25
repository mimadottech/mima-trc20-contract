pragma solidity ^0.5.4;

import "./SafeMath.sol";


/**
* @title KYC.Crypto
*/

contract KYCCrypto {
    /**
     * MATH
     */
    using SafeMath for uint256;


    /**
     * DATA
     */

    // INITIALIZATION DATA
    bool private initialized = false;

    // RRC20 BASIC DATA
    mapping(address => uint256) internal balances;
    uint256 internal totalSupply_;
    string public constant name = "KYC.Crypto"; // solium-disable-line uppercase
    string public constant symbol = "MIMA"; // solium-disable-line uppercase

  
    // TRC20 DATA
    mapping (address => mapping (address => uint256)) internal allowed;

    // OWNER DATA
    address public owner;

    // PAUSABILITY DATA
    bool public paused = false;

    // LAW ENFORCEMENT DATA
    address public lawEnforcementRole;
    mapping(address => bool) internal frozen;

    /**
     * EVENTS
     */
    // TRC20 BASIC EVENTS
    event Transfer(address indexed from, address indexed to, uint256 value);

    // TRC20 EVENTS
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    // OWNABLE EVENTS
    event OwnershipTransferred(
        address indexed oldOwner,
        address indexed newOwner
    );

    // PAUSABLE EVENTS
    event Pause();
    event Unpause();

    // LAW ENFORCEMENT EVENTS
    event AddressFrozen(address indexed addr);
    event AddressUnfrozen(address indexed addr);
    event FrozenAddressWiped(address indexed addr);
    event LawEnforcementRoleSet (
        address indexed oldLawEnforcementRole,
        address indexed newLawEnforcementRole
    );

    /**
     * FUNCTIONALITY
     */

    // INITIALIZATION FUNCTIONALITY

  
    function initialize() public {
        require(!initialized, "already initialized");
        owner = msg.sender;
        lawEnforcementRole = address(0);
        totalSupply_ = 104000000 ;
	    balances[msg.sender] = totalSupply_;
	    initialized = true;
    }




    /**
     * The constructor is used here to ensure that the implementation
     * contract is initialized. An uncontrolled implementation
     * contract might lead to misleading state
     * for users who accidentally interact with it.
     */
    constructor() payable public {
        initialize();
    }




    // TRC20 BASIC FUNCTIONALITY
    
    function () external payable {}




    /**
    * @dev Total number of tokens in existence
    */
    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }




    /**
    * @dev Transfer token for a specified address
    * @param _to The address to transfer to.
    * @param _value The amount to be transferred.
    */
    function transfer(address _to, uint256 _value)  public  returns (bool) {
        require(_to != address(0), "cannot transfer to address zero");
   	    require(!frozen[_to] && !frozen[msg.sender], "address frozen");
        require(_value <= balances[msg.sender], "insufficient funds");

        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }


    /**
    * @dev Gets the balance of the specified address.
    * @param _addr The address to query the the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address _addr) public view returns (uint256) {
        return balances[_addr];
    }




    // TRC20 FUNCTIONALITY

    /**
     * @dev Transfer tokens from one address to another
     * @param _from address The address which you want to send tokens from
     * @param _to address The address which you want to transfer to
     * @param _value uint256 the amount of tokens to be transferred
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    )
    public
    returns (bool)
    {
        require(_to != address(0), "cannot transfer to address zero");
        require(!frozen[_to] && !frozen[_from] && !frozen[msg.sender], "address frozen");
        require(_value <= balances[_from], "insufficient funds");
        require(_value <= allowed[_from][msg.sender], "insufficient allowance");




        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }




    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param _spender The address which will spend the funds.
     * @param _value The amount of tokens to be spent.
     */
    function approve(address _spender, uint256 _value) public  returns (bool) {
        require(!frozen[_spender] && !frozen[msg.sender], "address frozen");
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }




    /**
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param _owner address The address which owns the funds.
     * @param _spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     */
    function allowance(
        address _owner,
        address _spender
    )
    public
    view
    returns (uint256)
    {
        return allowed[_owner][_spender];
    }
    
    // OWNER FUNCTIONALITY

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "onlyOwner");
        _;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param _newOwner The address to transfer ownership to.
     */
    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "cannot transfer ownership to address zero");
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }


    // LAW ENFORCEMENT FUNCTIONALITY

    /**
     * @dev Sets a new law enforcement role address.
     * @param _newLawEnforcementRole The new address allowed to freeze/unfreeze addresses and seize their tokens.
     */
    function setLawEnforcementRole(address _newLawEnforcementRole) public {
        require(msg.sender == lawEnforcementRole || msg.sender == owner, "only lawEnforcementRole or Owner");
        emit LawEnforcementRoleSet(lawEnforcementRole, _newLawEnforcementRole);
        lawEnforcementRole = _newLawEnforcementRole;
    }

    modifier onlyLawEnforcementRole() {
        require(msg.sender == lawEnforcementRole, "onlyLawEnforcementRole");
        _;
    }

    /**
     * @dev Freezes an address balance from being transferred.
     * @param _addr The new address to freeze.
     */
    function freeze(address _addr) public onlyLawEnforcementRole {
        require(!frozen[_addr], "address already frozen");
        frozen[_addr] = true;
        emit AddressFrozen(_addr);
    }


    /**
     * @dev Unfreezes an address balance allowing transfer.
     * @param _addr The new address to unfreeze.
     */
    function unfreeze(address _addr) public onlyLawEnforcementRole {
        require(frozen[_addr], "address already unfrozen");
        frozen[_addr] = false;
        emit AddressUnfrozen(_addr);
    }


    /**
    * @dev Gets the balance of the specified address.
    * @param _addr The address to check if frozen.
    * @return A bool representing whether the given address is frozen.
    */
    function isFrozen(address _addr) public view returns (bool) {
        return frozen[_addr];
    }

}





