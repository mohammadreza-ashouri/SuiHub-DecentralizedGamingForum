
// Author: Mohammadreza Ashouri <ashourics@gmail.com>
// web: https://ashoury.net
// contact: ashourics@gmail.com



module 0x01::SuiHubPost{

    use std::vector;
    use std::debug;

    struct Post has store, drop, key{
        id: u64,
        title: vector<u8>,
        text: vector<u8>,
        tags:vector<u8>,
        created_date:u64
    
    }

    public fun create_post(_id:u64, _title:vector<u8>, _text:vector<u8>, _tags:vector<u8>,_created_date: u64): Post{

        let new_post = Post{
            id: _id,
            title: _title,
            text: _text,
            tags:_tags,
            created_date:_created_date

        };
        return new_post // return line is not allow to carry ; at the end 
    }


    #[test]
    public fun test_post(){

       let test_new_post= create_post(1,b"testtitle",b"test text!",b"#crypto#dapp",29012023);
       assert!(test_new_post.id==1,0);
        
    }


}