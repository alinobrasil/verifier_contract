
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import '@sismo-core/sismo-connect-solidity/contracts/libs/SismoLib.sol';


contract Vlance is SismoConnect{
    address payable public owner;
    event verifiedGithubContributor(address contributor);

    bytes16 public constant APP_ID = 0xc8296b55ab40894b58d094e76248898b;
    bytes16 public constant GROUP_ID = 0xfb20933ed4261d329255c10c64c53ff0;


    constructor() SismoConnect(buildConfig(APP_ID, false)) payable {
        // isImpersonationMode is set to true
        owner = payable(msg.sender);
    }

    
    function checkSismoGithub(bytes memory sismoResponse) public returns (uint256) {
        


        AuthRequest[] memory auths = new AuthRequest[](2);
        auths[0] = buildAuth({authType: AuthType.VAULT});
        auths[1] = buildAuth({authType: AuthType.GITHUB});



        ClaimRequest[] memory claims = new ClaimRequest[](1);
        claims[0] = buildClaim({
            groupId: GROUP_ID,
            isSelectableByUser: true,
            isOptional: false
        });


        SismoConnectVerifiedResult memory result =  verify({
            responseBytes: sismoResponse,
            // we want the user to prove that he owns a Sismo Vault
            auths: auths,
            claims: claims

            // signature: buildSignature({message: abi.encode(receiver)})
    });

        uint256 userId = SismoConnectHelper.getUserId(result, AuthType.VAULT);
        //AuthType.GITHUB

    
        return userId;
    }
}
