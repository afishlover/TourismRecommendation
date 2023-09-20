import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Types "./types";
import Time "mo:base/Time";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Order "mo:base/Order";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Result "mo:base/Result";
import Text "mo:base/Text";
import ExperimentalCycles "mo:base/ExperimentalCycles";
import T "./types"

shared(msg) actor class Defi(
    _owner: Principal,
) {
    private stable var owner_ : Principal = _owner;
    private stable var yasuo : Principal = Principal.fromText("r7inp-6aaaa-aaaaa-aaabq-cai");
    private stable var zed : Principal = Principal.fromText("rkp4c-7iaaa-aaaaa-aaaca-cai");
    private stable var this : Principal = Principal.fromText("ryjl3-tyaaa-aaaaa-aaaba-cai");

    // token
    private stable var usersEntries : [(Principal, Bool)] = [];
    private var users = HashMap.HashMap<Principal, Bool>(1, Principal.equal, Principal.hash);
    private stable var free_zed_token : Nat = 100;
    private stable var free_yasuo_token : Nat = 5;

    private stable var zedPool : Nat = 1000000;
    private stable var yasuoPool : Nat = 100000;
    private var invariant : Nat = zedPool * yasuoPool;

    private func addZedToPool(value : Nat): (){
        var newZedPool : Nat = zedPool + value;
        zedPool := newZedPool;
        invariant := zedPool * yasuoPool; 
    };

    private func addYasuoToPool(value : Nat): (){
        var newYasuoPool : Nat = yasuoPool + value;
        yasuoPool := newYasuoPool;
        invariant := zedPool * yasuoPool;
    };

    public shared({caller}) func connect(): async T.TxReceipt{
        switch(users.get(caller)){
            case(null){
                users.put(caller, true);
                let dip20_yasuo = actor (Principal.toText(yasuo)) : T.DIPInterface;
                let res_yasuo = await dip20_yasuo.approveToOwner(caller, 100000000);
                let dip20_zed = actor (Principal.toText(zed)) : T.DIPInterface;
                let res_zed = await dip20_zed.approveToOwner(caller, 100000000);

                ignore dip20_zed.transfer(caller, free_zed_token);
                ignore dip20_yasuo.transfer(caller, free_yasuo_token);

                return #Ok(0);
            };
            case(?user) return #Ok(0);
        }
    };

    public func zedBalanceOf(caller: Principal): async Nat {
        let dip20 = actor (Principal.toText(zed)) : T.DIPInterface;
        return await dip20.balanceOf(caller);
    };

    public func yasuoBalanceOf(caller: Principal): async Nat{
        let dip20 = actor (Principal.toText(yasuo)) : T.DIPInterface;
        return await dip20.balanceOf(caller);
    };

    public shared({caller}) func payGenerateTrip(): async T.TxReceipt {
        let fee : Nat = 10;
        let dip20 = actor (Principal.toText(zed)) : T.DIPInterface;
        return await dip20.transferFrom(caller, this, fee);
    };

    public func transferFrom(from: Principal, to: Principal, value: Nat, token: T.Token): async T.TxReceipt {
        if(token == yasuo){
            let dip20 = actor (Principal.toText(token)) : T.DIPInterface;
            return await dip20.transferFrom(from, to, value);
        };
        return #Err(#Other);
    };

    public shared({caller}) func swapZedToYasuo(value: Nat) : async T.TxReceipt{
        let dip20_zed = actor (Principal.toText(zed)) : T.DIPInterface;
        let zed_balance = await dip20_zed.balanceOf(caller);
        if(zed_balance >= value){
            let update_zed = await dip20_zed.transferFrom(caller, this, value);

            let dip20_yasuo = actor (Principal.toText(yasuo)) : T.DIPInterface;

            var newZedPool : Nat = zedPool + value;
            var newYasuoPool : Nat = invariant / newZedPool;
            var yasuoOut : Nat = yasuoPool - newYasuoPool;
            invariant := newZedPool * newYasuoPool;
            zedPool := newZedPool;
            yasuoPool := newYasuoPool;

            let update_yasuo = dip20_yasuo.transfer(caller, yasuoOut);
            return #Ok(yasuoOut);
        };
        return #Err(#Other);
    };

    public shared({caller}) func swapYasuoToZed(value: Nat) : async T.TxReceipt{
        let dip20_yasuo = actor (Principal.toText(yasuo)) : T.DIPInterface;
        let yasuo_balance = await dip20_yasuo.balanceOf(caller);
        if(yasuo_balance >= value){
            let update_yasuo = await dip20_yasuo.transferFrom(caller, this, value);

            let dip20_zed = actor (Principal.toText(zed)) : T.DIPInterface;
            
            var newYasuoPool : Nat = yasuoPool + value;
            var newZedPool : Nat = invariant / newYasuoPool;
            var zedOut : Nat = zedPool - newZedPool;
            invariant := newYasuoPool * newZedPool;
            zedPool := newZedPool;
            yasuoPool := newYasuoPool;

            let update_zed = dip20_zed.transfer(caller, zedOut);
            return #Ok(zedOut);
        };
        return #Err(#Other);
    };

    public query func getInvariant() : async Nat {
        return invariant;
    };


    public shared({caller}) func transferZed(reciver: Principal, value: Nat) : async T.TxReceipt{
        let dip20_zed = actor (Principal.toText(zed)) : T.DIPInterface;
        let zed_balance = await dip20_zed.balanceOf(caller);
        if(zed_balance >= value){
            let update_zed = await dip20_zed.transferFrom(caller, reciver, value);
            return #Ok(value);
        };
        return #Err(#Other);
    };

    // booking
    private var hotel_principal: Principal = Principal.fromText("nip6r-lmka7-eoixb-44yac-bihfb-gwxzm-5dfwl-fecjn-442hs-jh56o-dqe");

    type Hotel = {
        _hotelID : Principal;
        _name : Text;
        _rating : Nat;
        _information : Text;
        _priceRange : Nat;
    };  

    type Room = {
        _roomID : Nat;
        _name : Text;
        _sellPrice : Nat;
        _size : Text;
        _bed: Text;
        _benefits : [Text];
        holder : Principal;
        _wifi : Bool;
        booked : Bool;
    };

    private stable var roomMapEntries : [(Nat, Room)] = [];
    private var roomMap = HashMap.HashMap<Nat, Room>(1, Nat.equal, Hash.hash);
    private stable var rooms : [Nat] = [];

    type Transaction = {
        _roomID : Nat;
        holder : Principal;
        startDate : Int;
        endDate : Int;
    };
    private stable var bookedEntries : [(Principal, [(Principal, Bool)])] = [];
    private var transactions = HashMap.HashMap<Principal, [Transaction]>(1, Principal.equal, Principal.hash);
    private var booked = HashMap.HashMap<Principal, HashMap.HashMap<Principal, Bool>>(1, Principal.equal, Principal.hash);

    private var book_fee : Nat = 1;

    public shared({caller}) func isHotelPrincipal() : async Bool {
        return caller == hotel_principal;
    };

    public func getHotelInformation() : async Hotel {
        return {
            _hotelID = hotel_principal;
            _name = "Resort Novotel";
            _rating = 4;
            _information = "90. 19 Alley of Ly Thuong Kiet street, Phan Chu Trinh ward. Hoan Kiem district, Hanoi city";
            _priceRange = 1699200;
        };
    }; 

    public func init() : async () {
        var room1 : Room = {
            _roomID = 1;
            _name = "Delux Room";
            _sellPrice = 1899000;
            _size = "40m2";
            _bed = "2 singles bed";
            _benefits = ["Breakfast included"];
            holder = owner_;
            _wifi = true;
            booked = false;
        };
        roomMap.put(1, room1);
        rooms := Array.append<Nat>(rooms, [1]);

        var room2 : Room = {
            _roomID = 2;
            _name = "Superior Room";
            _sellPrice = 1999000;
            _size = "50m2";
            _bed = "2 singles bed";
            _benefits = ["Breakfast included"];
            holder = owner_;
            _wifi = true;
            booked = false;
        };
        roomMap.put(2, room2);
        rooms := Array.append<Nat>(rooms, [2]);
    };

    public func getRoom(room_id : Nat) : async ?Room {
        return roomMap.get(room_id);
    };

    public func getRoomsLength() : async Nat {
        return rooms.size();
    };

    type BookedRoom = {
        _roomID : Nat;
        _name : Text;
        _sellPrice : Nat;
        _size : Text;
        _bed: Text;
        _benefits : [Text];
        holder : Principal;
        _wifi : Bool;
        booked : Bool;
        startDate : Int;
        endDate : Int;
    };

    private func getUserBookedTransaction(user : Principal, room_id : Nat): Transaction {
        switch(transactions.get(user)){
            case(?list_transaction){
                for (i in Iter.range(0, list_transaction.size() - 1)){
                    if(list_transaction[i]._roomID == room_id){
                        return list_transaction[i];
                    };
                };
            };
            case(null){};
        };
        return {
            _roomID = 0;
            holder = owner_;
            startDate = 0;
            endDate = 0;
        };
    };

    public shared({caller}) func getBookedRooms() : async [Room] {
        var roomList : [BookedRoom] = [];
        
        if(caller == hotel_principal){
            for (i in Iter.range(0, rooms.size() - 1)){
                switch(roomMap.get(rooms[i])){
                    case(?room){
                        if(room.booked){
                            var transaction = getUserBookedTransaction(room.holder, room._roomID);
                            var booked_room = {
                                    _roomID = room._roomID;
                                    _name = room._name;
                                    _sellPrice = room._sellPrice;
                                    _size = room._size;
                                    _bed = room._bed;
                                    _benefits = room._benefits;
                                    holder = room.holder;
                                    _wifi = room._wifi;
                                    booked = room.booked;
                                    startDate = transaction.startDate;
                                    endDate = transaction.endDate;
                                };
                                roomList := Array.append<BookedRoom>(roomList, [booked_room]);
                            };
                        };
                    case(null){};
                };
            };
        };
        return roomList;
    };  

    public shared({caller}) func getMyBookedRooms() : async [Room] {
        var roomList : [Room] = [];
        
        switch(transactions.get(caller)){
            case(?list_transaction){
                for (i in Iter.range(0, list_transaction.size() - 1)){
                    switch(roomMap.get(list_transaction[i]._roomID)){
                        case(?room){
                            if(room.booked){
                                roomList := Array.append<Room>(roomList, [room]);
                            }
                        };
                        case(null){};
                    };
                };
            };
            case(null){};
        };
        return roomList;
    };  

    public func getUnBookedRooms() : async [Room] {
        var roomList : [Room] = [];
        
        for (i in Iter.range(0, rooms.size() - 1)){
            switch(roomMap.get(rooms[i])){
                case(?room){
                    if(not room.booked){
                        roomList := Array.append<Room>(roomList, [room]);
                    }
                };
                case(null){};
            }
        };
        return roomList;
    };

    public shared({caller}) func book(room_id : Nat, start_date : Int, end_date : Int) : async T.TxReceipt{
        let dip20_yasuo = actor (Principal.toText(yasuo)) : T.DIPInterface;
        let yasuo_balance = await dip20_yasuo.balanceOf(caller);
        if(yasuo_balance >= book_fee){
            switch(roomMap.get(room_id)){
                case(null) return #Err(#Other);
                case(?room) {
                    if(not room.booked){
                        roomMap.put(room_id,{
                            _roomID = room._roomID;
                            _name = room._name;
                            _sellPrice = room._sellPrice;
                            _size = room._size;
                            _bed = room._bed;
                            _benefits = room._benefits;
                            holder = caller;
                            _wifi = room._wifi;
                            booked = true;
                        });
                        
                        switch(transactions.get(caller)){
                            case(?list_transaction){
                                var new_transaction : Transaction = {
                                        _roomID = room._roomID;
                                        holder = caller;
                                        startDate = start_date;
                                        endDate = end_date;
                                    };
                                var new_list_transaction : [Transaction] = list_transaction;
                                new_list_transaction := Array.append<Transaction>(new_list_transaction, [new_transaction]);
                                transactions.put(caller,  new_list_transaction);
                            };
                            case(null){
                                var new_transaction : Transaction = {
                                        _roomID = room._roomID;
                                        holder = caller;
                                        startDate = start_date;
                                        endDate = end_date;
                                    };
                                var transaction : [Transaction] = [new_transaction];
                                transactions.put(caller, transaction);
                            };
                        };

                        return await dip20_yasuo.transferFrom(caller, this, book_fee);
                    }else{
                        return #Err(#Other);
                    };
                };
            };
            return #Ok(room_id);
        };
        let a = "";
        return #Err(#InsufficientBalance);
    };

    public shared({caller}) func removeBooking(room_id : Nat, done : Bool) : async Result.Result<Text,Text> {
        if(caller == hotel_principal){
            switch(roomMap.get(room_id)){
                case(null) return #err("There is no room with id : " # Nat.toText(room_id));
                case(?room) {
                    roomMap.put(room_id,{
                        _roomID = room._roomID;
                        _name = room._name;
                        _sellPrice = room._sellPrice;
                        _size = room._size;
                        _bed = room._bed;
                        _benefits = room._benefits;
                        holder = owner_;
                        _wifi = room._wifi;
                        booked = false;
                    });

                    var new_transaction : [Transaction] = []; 
                    switch(transactions.get(caller)){
                        case(?list_transaction){
                            for (i in Iter.range(0, list_transaction.size() - 1)){
                                if(list_transaction[i]._roomID == room_id){
                                }else{
                                    new_transaction := Array.append<Transaction>(new_transaction, [list_transaction[i]]);
                                };
                            };
                        };
                        case(null){};
                    };
                    transactions.put(caller, new_transaction);

                    if(done){
                        switch(booked.get(hotel_principal)){
                            case(?done_book) {
                                done_book.put(room.holder, true);
                                booked.put(hotel_principal, done_book);
                            };
                            case(null){
                                var done_book = HashMap.HashMap<Principal, Bool>(1, Principal.equal, Principal.hash);
                                done_book.put(room.holder, true);
                                booked.put(hotel_principal, done_book);
                            };
                        };

                        let dip20_yasuo = actor (Principal.toText(yasuo)) : T.DIPInterface;
                        ignore dip20_yasuo.transfer(room.holder, book_fee);
                    };

                    return #ok("done");
                };
            };
        };
        return #err("You cannot remove this booking");
    };

    public shared({caller}) func cancelBooking(room_id : Nat) : async T.TxReceipt {
        switch(roomMap.get(room_id)){
            case(null) return #Err(#Other);
            case(?room) {
                var holder : Principal = room.holder;
                if(Principal.equal(caller, holder)){
                    roomMap.put(room_id,{
                        _roomID = room._roomID;
                        _name = room._name;
                        _sellPrice = room._sellPrice;
                        _size = room._size;
                        _bed = room._bed;
                        _benefits = room._benefits;
                        holder = owner_;
                        _wifi = room._wifi;
                        booked = false;
                    });
                    
                    var new_transaction : [Transaction] = []; 
                    switch(transactions.get(caller)){
                        case(?list_transaction){
                            for (i in Iter.range(0, list_transaction.size() - 1)){
                                if(list_transaction[i]._roomID == room_id){
                                    var start_time = list_transaction[i].startDate;
                                    var current_time = Time.now() / 1000_000_000;
                                    if(current_time < start_time and ((start_time - current_time) / 86400) > 2){
                                        let dip20_yasuo = actor (Principal.toText(yasuo)) : T.DIPInterface;
                                        ignore dip20_yasuo.transfer(caller, book_fee);
                                    }
                                }else{
                                    new_transaction := Array.append<Transaction>(new_transaction, [list_transaction[i]]);
                                };
                            };
                        };
                        case(null){};
                    };
                    transactions.put(caller, new_transaction);
                }else{
                    return #Err(#Other);
                };
            };
        };
        return #Ok(0);
    };

    public shared({caller}) func addRoom(room_id : Nat, name : Text, sell_price : Nat, size : Text, bed : Text, benefits : [Text], wifi : Bool) : async Result.Result<Text,Text> {
        if(caller == hotel_principal){
            switch(roomMap.get(room_id)){
                case(null) {
                    roomMap.put(room_id, {
                        _roomID = room_id;
                        _name = name;
                        _sellPrice = sell_price;
                        _size = size;
                        _bed = bed;
                        _benefits = benefits;
                        holder = owner_;
                        _wifi = wifi;
                        booked = false;
                    });
                };
                case(?room) return #err("Room with id : " # Nat.toText(room_id) # " already exists");
            };
            return #ok("success");
        };
        return #err("you don't have permission to do this")
    };


    // review
    type Review = {
        reviewer : Principal;
        _reviewText : Text;
        _rating : Nat;
        _score : Int;
        _num : Nat;
    };

    private stable var reviewsEntries : [(Principal, [(Principal, Review)])] = []; 
    private var reviews = HashMap.HashMap<Principal, HashMap.HashMap<Principal, Review>>(1, Principal.equal, Principal.hash);

    private func _hasBooked(location : Principal, caller : Principal): Bool {
        switch(booked.get(location)){
            case(?bookers){
                switch(bookers.get(caller)){
                    case(?done_book) return done_book;
                    case(null) return false;
                };
            };
            case(null) return false;
        };
        return false;
    };

    public shared({caller}) func hasBooked(location : Principal): async Bool{
        return _hasBooked(location, caller);
    };

    public func getReviews(location : Principal): async [Review] {
        var list_review : [Review] = [];
        switch(reviews.get(location)){
            case(?list){
                for ((k, v) in list.entries()){
                    var review = v;
                    list_review := Array.append<Review>(list_review, [review]);
                }
            };
            case(null) {};
        };
        return list_review;
    };

    public shared({caller}) func addReview(location : Principal, rating : Nat, review_text : Text) : async T.TxReceipt {
        let dip20_zed = actor (Principal.toText(zed)) : T.DIPInterface;
        let zed_balance = await dip20_zed.balanceOf(caller);
        if(zed_balance >= 10){
            if(_hasBooked(location, caller)){
                var new_review = {
                    reviewer = caller;
                    _reviewText = review_text;
                    _rating = rating;
                    _score = 0;
                    _num = 0;
                };

                var user_review = HashMap.HashMap<Principal, Review>(1, Principal.equal, Principal.hash);
                user_review.put(caller, new_review);
                reviews.put(location, user_review);

                let award = 10;
                ignore dip20_zed.transfer(caller, award);
                return #Ok(0);
            };
        };
        return #Err(#Other);
    };

    public shared({caller}) func scoreReview(location : Principal, _reviewer : Principal, score : Int): async Int {
        let dip20_zed = actor (Principal.toText(zed)) : T.DIPInterface;
        let zed_balance = await dip20_zed.balanceOf(caller);
        if(zed_balance >= 10){
            switch(reviews.get(location)){
                case(?users){
                    switch(users.get(_reviewer)){
                        case(?user){
                            var new_review = {
                                reviewer = user.reviewer;
                                _reviewText = user._reviewText;
                                _rating = user._rating;
                                _score = (user._score * user._num + score) / (user._num + 1);
                                _num = user._num + 1;
                            };

                            var user_review = HashMap.HashMap<Principal, Review>(1, Principal.equal, Principal.hash);
                            user_review.put(_reviewer, new_review);
                            reviews.put(location, user_review);

                            let award = 5;
                            ignore dip20_zed.transfer(caller, award);

                            return new_review._score;
                        };
                        case(null){};
                    };
                };
                case(null){};
            };
        };
        return -1;
    };

    //let now = Time.now();
    
    private stable var pre : Int = Time.now();
    public shared func rewardReview() : async () {
        let dip20_yasuo = actor (Principal.toText(yasuo)) : T.DIPInterface;
        let reward = 1;

        for((k,v) in reviews.entries()){
            var max : Nat = 0;
            for((k1,v1) in v.entries()){
                if(v1._score >= max){
                    max := Int.abs(v1._score);
                };
            };

            var total_reward : Nat = 0;
            for((k1,v1) in v.entries()){
                if(Int.abs(v1._score) == max){
                    total_reward += reward;
                    ignore dip20_yasuo.transfer(v1.reviewer, reward);
                };
            };
            addYasuoToPool(total_reward);
        };
    };

    system func heartbeat() : async () {
        let now = Time.now();
        
        if ((now - pre)/1000000000 == 86400) {
            await rewardReview();
            pre := now;
        };
    };

     /*
    * upgrade functions
    */
    system func preupgrade() {
        usersEntries := Iter.toArray(users.entries());
        roomMapEntries := Iter.toArray(roomMap.entries());

        var size : Nat = booked.size();
        var temp : [var (Principal, [(Principal, Bool)])] = Array.init<(Principal, [(Principal, Bool)])>(size, (owner_, []));
        size := 0;
        for ((k, v) in booked.entries()) {
            temp[size] := (k, Iter.toArray(v.entries()));
            size += 1;
        };
        bookedEntries := Array.freeze(temp);

        var size2 : Nat = reviews.size();
        var temp2 : [var (Principal, [(Principal, Review)])] = Array.init<(Principal, [(Principal, Review)])>(size2, (owner_, []));
        size2 := 0;
        for ((k, v) in reviews.entries()) {
            temp2[size2] := (k, Iter.toArray(v.entries()));
            size2 += 1;
        };
        reviewsEntries := Array.freeze(temp2);
    };

    system func postupgrade() {
        users := HashMap.fromIter<Principal, Bool>(usersEntries.vals(), 1, Principal.equal, Principal.hash);
        roomMap := HashMap.fromIter<Nat, Room>(roomMapEntries.vals(), 1, Nat.equal, Hash.hash);
        for ((k, v) in bookedEntries.vals()) {
            let allowed_temp = HashMap.fromIter<Principal, Bool>(v.vals(), 1, Principal.equal, Principal.hash);
            booked.put(k, allowed_temp);
        };
        for ((k, v) in reviewsEntries.vals()) {
            let reviews_temp = HashMap.fromIter<Principal, Review>(v.vals(), 1, Principal.equal, Principal.hash);
            reviews.put(k, reviews_temp);
        };
        bookedEntries := [];
        usersEntries := [];
        roomMapEntries := [];
        reviewsEntries := [];
    };
}