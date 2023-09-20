import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Types "./types";
import Time "mo:base/Time";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Order "mo:base/Order";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Result "mo:base/Result";
import Text "mo:base/Text";
import ExperimentalCycles "mo:base/ExperimentalCycles";
import Cap "./cap/Cap";
import Root "./cap/Root";

shared(msg) actor class Services(
    _owner: Principal
) {

    private var owner_ : Principal = _owner;
    private var this : Principal = Principal.fromText(""); // principal of this canister

    type Room {
        _roomID : Nat;
        _sellPrice : Nat;
        _size : Text;
        _bed: Text;
        _benefits : [Text];
        holder : Principal;
        _wifi : Bool;
        booked : Bool;
    };

    private var roomMap = HashMap.HashMap<Nat, Room>(1, Nat.equal, Hash.hash);
    private var rooms : [Room] = [];


    // returns tx index or error msg
    public type TxReceipt = {
        #Ok: Nat;
        #Err: {
            #InsufficientAllowance;
            #InsufficientBalance;
            #ErrorOperationStyle;
            #Unauthorized;
            #LedgerTrap;
            #ErrorTo;
            #Other: Text;
            #BlockUsed;
            #AmountTooSmall;
        };
    };
    type TokenService = actor{  transfer : (to : Principal, value : Nat) -> async TxReceipt;
                                transferFrom : (from : Principal, to : Principal, value : Nat) -> async TxReceipt;
                                approve : (spender: Principal, value: Nat) -> async TxReceipt;
                                balanceOf : (who: Principal) -> async Nat;
                                allowance : (owner: Principal, spender: Principal) -> async Nat;
                             };
    private var token : TokenService = actor("");

    private var book_fee : Nat = 1;

    public func getRoom(room_id : Nat) : async ?Room {
        return roomMap.get(room_id);
    }

    public func getRoomsLength() : async Nat {
        return rooms.size();
    }

    public func getBookedRooms() : async [Room] {
        var roomList : [Room] = [];
        
        for (i in Iter.range(0, rooms.size() - 1)){
            var temp = roomMap.get(rooms[i]);
            if(temp.booked){
                roomList = Array.append<Nat>(roomList, [temp]);
            }
        }
        return roomList;
    }

    public func getUnBookedRooms() : async [Room] {
        var roomList : [Room] = [];
        
        for (i in Iter.range(0, rooms.size() - 1)){
            var temp = roomMap.get(rooms[i]);
            if(not temp.booked){
                roomList = Array.append<Nat>(roomList, [temp]);
            }
        }
        return roomList;
    }

    public shared({caller}) func book(room_id : Nat) : async Result.Result<Text,Text> {
        switch(roomMap.get(id)){
            case(null) return #err("There is no room with id : " # Nat.toText(room_id));
            case(?room) {
                var price : Nat = room._sellPrice;
                var balance : Nat = await token.balanceOf(caller);
                if(balance >= price){
                    if(not room.booked){
                        roomMap.put(room_id,{
                             _roomID = room.room_id;
                            _sellPrice = room._sellPrice;
                            _size = room._size;
                            _bed = room._bed;
                            _benefits = room._benefits;
                            holder = caller;
                            _wifi = room._wifi;
                            booked = true;
                        })
                        await token.transferFrom(caller, this, book_fee);
                    }else{
                        return #err("This room is booked");
                    }
                }else{
                    return #err("Your balance is not enough to book this room");
                }
            }
        }
        return #ok();
    }

    public shared({caller}) func removeBooking(room_id : Nat) : async Result.Result<Text,Text> {
        switch(roomMap.get(id)){
            case(null) return #err("There is no room with id : " # Nat.toText(room_id));
            case(?room) {
                if(Principal.equal(caller, owner_)){
                    roomMap.put(room_id,{
                        _roomID = room.room_id;
                        _sellPrice = room._sellPrice;
                        _size = room._size;
                        _bed = room._bed;
                        _benefits = room._benefits;
                        holder = owner_;
                        _wifi = room._wifi;
                        booked = false;
                    })
                }else{
                    return #err("You cannot remove this booking");
                }
            }
        }
        return #ok();
    }

    public shared({caller}) func cancelBooking(room_id : Nat) : async Result.Result<Text,Text> {
        switch(roomMap.get(id)){
            case(null) return #err("There is no room with id : " # Nat.toText(room_id));
            case(?room) {
                holder : Principal = room.holder;
                if(Principal.equal(caller, holder)){
                    roomMap.put(room_id,{
                        _roomID = room.room_id;
                        _sellPrice = room._sellPrice;
                        _size = room._size;
                        _bed = room._bed;
                        _benefits = room._benefits;
                        holder = owner_;
                        _wifi = room._wifi;
                        booked = false;
                    })
                    await token.transferFrom(this, caller, book_fee);
                }else{
                    return #err("You cannot remove this booking");
                }
            }
        }
        return #ok();
    }


    public shared({caller}) func addRoom(room_id : Nat, sell_price : Nat, size : Text,
                                         bed : Text, benefits : [Text], wifi : Bool) : async Result.Result<Text,Text> {
        switch(roomMap.get(id)){
            case(null) {
                roomMap.put(room_id, {
                    _roomID = room_id;
                    _sellPrice = sell_price;
                    _size = size;
                    _bed = bed;
                    _benefits = benefits;
                    holder = owner_;
                    _wifi = wifi;
                    booked = false;
                });
            }
            case(?room) return #err("Room with id : " # Nat.toText(room_id) # " already exists");
        }
        return #ok();
    }
}