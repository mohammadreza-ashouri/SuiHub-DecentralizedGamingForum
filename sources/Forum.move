
// Author: Mohammadreza Ashouri <ashourics@gmail.com>
// web: https://ashoury.net
// contact: ashourics@gmail.com

module 0x1::SuiHubForum{
   
    use std::vector;
    use std::debug; 


    struct User has store,key,drop {

        id: u64,
        username: vector<u8>, // vector<u8> -> string in the native level 
        email: vector<u8>,
        phone: vector<u8>,
        nftURL: vector<u8>,
        walletAddress: address,
        verified: bool

    }
 // key ->, which allows the object to be persisted in Sui's global storage.

    struct Empty {}
    


    public fun register_user(id: u64, username: vector<u8>, email: vector<u8>, phone: vector<u8>, nftURL: vector<u8>, walletAddress:address, verified: bool): User {
        User {
            id,
            username,
            email,
            phone,
            nftURL,
            walletAddress,
            verified
        }
    }
    

    public fun id(user: User): u64 {
        user.id
    }


    struct Friends has drop,store, key{
        community: vector<User>
    }


    public fun create_friend(x: User, friends: &mut Friends){
        // &mut -> so we can alter the friends in side of the function because it's mutable now
        let newFriend = User {
            id: x.id,
            username: x.username,
            email: x.email,
            phone: x.phone,
            nftURL: x.nftURL,
            walletAddress: x.walletAddress,
            verified: x.verified

        };

        add_friend(newFriend, friends);//return 
    }
    

    public fun add_friend(_user: User, friends: &mut Friends){
        vector::push_back(&mut friends.community, _user)
    }

    public fun test_test(){
         let mo=User {
            id: 7,
            username: b"Mohammadreza", //-->string using vector<u8>
            email: b"ashourics@gmail.com",
            phone: b"0176808080",
            nftURL:b"ipfs://ffffffffeeee0000e",
            walletAddress:@0x00, // the value of the type address starts with @
            verified:false
        };

        let friends = Friends{
            community: (vector[mo])
        };
        
        debug::print(&mo.id);
    }


    #[test]
    fun test_create_community() {
        let mo=User {
            id: 7,
            username: b"Mohammadreza", //-->string using vector<u8>
            email: b"ashourics@gmail.com",
            phone: b"0176808080",
            nftURL:b"ipfs://ffffffffeeee0000e",
            walletAddress:@0x00, 
            verified:false
        };
        assert!(mo.username == b"Mohammadreza",999);
        debug::print(&mo.username);
    }

#[test]
  fun test_test_community() {
        
        test_test();
    }
}


