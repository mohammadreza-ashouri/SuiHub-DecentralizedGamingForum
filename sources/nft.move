
module suihub::nft {

    use std::vector::length;
    use std::ascii::{Self, String};
    use std::option::{Self, Option, some};
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};


    /// Max text length ~ 2k text including html tags images voice emojies etc.
    const MAX_TEXT_LENGTH: u64 = 2048;
    const ETextOverflow: u64 = 0;

    /// Suihub Post NFT (i.e., a post, retweet, like, chat message etc).
    struct Post has key, store {
        id: UID,
        app_id: address,
        text: String,
        ref_id: Option<address>,
        metadata: vector<u8>,
    }

    public fun text(post: &Post): String {
        post.text
    }

    fun post_internal(
        app_id: address,
        text: vector<u8>,
        ref_id: Option<address>,
        metadata: vector<u8>,
        ctx: &mut TxContext,
    ) {
        assert!(length(&text) <= MAX_TEXT_LENGTH, ETextOverflow);
        let post = Post {
            id: object::new(ctx),
            app_id,
            text: ascii::string(text),
            ref_id,
            metadata,
        };
        transfer::transfer(post, tx_context::sender(ctx));
    }

    public entry fun post(
        app_identifier: address,
        text: vector<u8>,
        metadata: vector<u8>,
        ctx: &mut TxContext,
    ) {
        post_internal(app_identifier, text, option::none(), metadata, ctx);
    }


    public entry fun post_with_ref(
        app_identifier: address,
        text: vector<u8>,
        ref_identifier: address,
        metadata: vector<u8>,
        ctx: &mut TxContext,
    ) {
        post_internal(app_identifier, text, some(ref_identifier), metadata, ctx);
    }


    public entry fun burn(post: Post) {
        let Post { id, app_id: _, text: _, ref_id: _, metadata: _ } = post;
        object::delete(id);
    }
}
