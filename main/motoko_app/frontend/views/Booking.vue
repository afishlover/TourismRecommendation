<template>
    <div>
        <div class="b-background">
        <img src="../assets/image/background_booking.png" />
        <div class="b-background-content">
            <h1>Find your next stay</h1>
            <p>Search low prices on hotels, homes and much more...</p>
        </div>
    </div>
    <div class="b-app-navbar">
        <ul class="b-navbar">
            <li class="b-nav-item">
                <!-- <label for="location-search">Name</label> -->
                <input class="search-destination-input" type="search" placeholder="Location or hotel name"
                    id="location-search" />
            </li>
            <li class="b-nav-item">
                <input class="date-input" type="date" /> - <input class="date-input" type="date" />
            </li>
            <li class="b-nav-item">
                <button @click="() => TogglePopup('buttonTrigger')" class="b-nav-item-button-1">{{ adults }} adults - {{
                        children
                }} children - {{ rooms }} rooms</button>
            </li>
            <li class="b-nav-item">
                <button class="b-nav-item-button-2">Find</button>
            </li>
            <!-- <li class="b-nav-item-button">
                <ConnectButton />
            </li> -->
        </ul>
    </div>
    <div class="book-image">
        <div id="main-image">
            <img src="https://khachsantaythi.com.vn/wp-content/uploads/2019/05/DSCF4744-1024x683.jpg" />
        </div>
        <div id="sub-image">
            <img src="https://media-cdn.tripadvisor.com/media/photo-s/16/1a/ea/54/hotel-presidente-4s.jpg" />
            <img src="https://media-cdn.tripadvisor.com/media/photo-s/16/1a/ea/54/hotel-presidente-4s.jpg" />
            <img src="https://media-cdn.tripadvisor.com/media/photo-s/16/1a/ea/54/hotel-presidente-4s.jpg" />
        </div>
    </div>
    <div class="hotel-main-body">
        <div class="hotel-h-item" v-if="hotel">
            <div class="hotel-h-item-up">
                <div class="hotel-item-up-hl">
                    <div class="hiu-header">{{hotel._name}}</div>
                    <div class="hiu-rating">
                        <div class="hiu-star">
                            <span class="fa fa-star checked"></span>
                            <span class="fa fa-star checked"></span>
                            <span class="fa fa-star checked"></span>
                            <span class="fa fa-star checked"></span>
                            <span class="fa fa-star"></span>
                        </div>
                        <div class="hiu-score">
                            {{hotel._rating}}
                        </div>
                    </div>
                    <div class="hm-text-light">
                        {{hotel._information}}
                    </div>
                </div>
                <div class="hotel-item-up-hr">
                    <div class="hm-text-light">
                        Price range from
                    </div>
                    <div class="hm-text-light">
                        <span style="font-size: 30px;">{{hotel._priceRange}} VND</span>/night
                    </div>
                    <div class="hm-button">
                        <a href="#list-room"><button> BOOK A ROOM</button></a>
                    </div>
                </div>
            </div>
            <div class="hotel-h-item-down">
                <div class="hm-text-bold">
                    Hotel Amenities
                </div>
                <div class="hm-row">
                    <div class="hiu-symbol-1">
                        <span><i class="fa-solid fa-wifi"></i> - Wifi</span>
                    </div>
                    <div class="hiu-symbol">
                        <span><i class="fa-solid fa-house"></i> - Family rooms</span>
                    </div>
                    <div class="hiu-symbol">
                        <span><i class="fa-solid fa-p"></i> - Free Parking</span>
                    </div>
                    <div class="rating-symbol" v-if="has_booked">
                        <a @click="ratingAction(hotel._hotelID)"><button> RATING</button></a>
                    </div>
                </div>
            </div>
        </div>
        <div id="list-room" class="hotel-h-item-b" v-for="room in list_rooms" :key="room">
            <div class="hotel-h-item-room">
                <div class="hotel-item-room-name">
                    {{room._name}}
                </div>
                <div class="hotel-item-room-h">
                    <div class="hotel-item-room-hl">
                        <img width="300" height="200"
                            src="https://khachsantaythi.com.vn/wp-content/uploads/2019/05/DSCF4744-1024x683.jpg" />
                        <div class="hiu-symbol">
                            <span><i class="fa-solid fa-house"></i> - {{room._size}}</span>
                        </div>
                        <div class="hiu-symbol">
                            <span><i class="fa-solid fa-bed"></i> - {{room._bed}}</span>
                        </div>
                        <div class="hiu-symbol">
                            <span><i class="fa-solid fa-wifi"></i> - {{room._wifi ? "Wifi" : "no Wifi"}}</span>
                        </div>
                        <div class="hiu-symbol">
                            <span><i class="fa-solid fa-circle-plus"></i> View more</span>
                        </div>
                    </div>
                    <div class="hotel-item-room-hr">
                        <div class="hotel-item-room-card-up">
                            <div class="hirc-u-header">Benefits</div>
                            <div class="hiu-symbol" v-for="benefit in room._benefits" :key="benefit">
                                <span><i class="fa-solid fa-circle-check"></i> {{benefit}}</span>
                            </div>
                        </div>
                        <div class="hotel-item-room-card-dowm">
                            <div class="hirc-d-item">
                                <div class="hm-text-light">
                                    <span style="font-size: 30px;">{{room._sellPrice}} VND</span>/night
                                </div>
                                <div class="hm-button-t">
                                    <input class="modal-btn" type="checkbox" id="modal-btn" name="modal-btn" />
                                    <label for="modal-btn"> BOOK NOW </label>
                                    <div class="modal">
                                        <div class="modal-wrap">
                                            <div class="pc-action-a2">
                                                <h2>Booking Room</h2>
                                                <div class="aa-sitem">
                                                    <label class="aa-stext">Start date</label>
                                                    <input type="datetime-local" v-model="start_date"
                                                        class="aa-sinput">
                                                </div>
                                                <div class="aa-sitem">
                                                    <label class="aa-stext">End date</label>
                                                    <input type="datetime-local" class="aa-sinput" v-model="end_date">
                                                </div>
                                                <div class="aa-sbutton">
                                                    <button @click="bookRoom(room._roomID)"> Book now!</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="hirc-d-text">
                                The above prices include taxes and fees
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="popup" v-if="popupTriggers.buttonTrigger" :TogglePopup="() => TogglePopup('buttonTrigger')">
            Say hello to my friend Golde
            <div class="popup-inner">
                <button class="popup-close" @click="() => TogglePopup('buttonTrigger')">Close</button>
            </div>
        </div>
    </div>
    </div>
</template>

<script setup>
import { useCanister, useWallet } from "@connect2ic/vue"
import { ref, watchEffect, watch } from "vue";
import { Principal } from '@dfinity/principal';

let adults = 4
let children = 3
let rooms = 100

const popupTriggers = ref({
    buttonTrigger: false,
    bookingButtonTrgigger: false,
})

const TogglePopup = (trigger) => {
    popupTriggers.value[trigger] = !popupTriggers.value[trigger]

}

var hotel = ref(null)
var list_rooms = ref([])
var has_booked = ref(null)

const [wallet] = useWallet()
const [defi] = useCanister("defi")

var start_date = ref("")
var end_date = ref("")

const getUnBookedRooms = async () => {
    var res = await defi.value.getUnBookedRooms()
    list_rooms.value = res
}

const toTimestamp = (strDate) => {
   var datum = Date.parse(strDate);
   return datum/1000;
}
const bookRoom = async (room_id) => {
    let res = await defi.value.book(BigInt(room_id), toTimestamp(start_date.value), toTimestamp(end_date.value))
    if("Ok" in res){
        var temp = []
        for(const i in list_rooms.value){
            if(list_rooms.value[i]._roomID != room_id){
                temp.push(list_rooms.value[i])
            }
        }
        list_rooms.value = temp
    }
}

const getHotelInformation = async () => {
    let res = await defi.value.getHotelInformation();
    hotel.value = res
}

const hasBooked = async () => {
    let res = await defi.value.hasBooked(hotel.value._hotelID)
    has_booked.value = res
    console.log(res)
}

watchEffect(() => {
	if(wallet.value && defi.value) {
        getHotelInformation()
		getUnBookedRooms()
	}else{
        yasuo_balance.value = 0;
        zed_balance.value = 0;
    }
});

watchEffect(() => {
	if(hotel.value && defi.value) {
        hasBooked()
	}else{
        has_booked.value = null
    }
});

const emit = defineEmits(['ratingReady'])
const ratingAction = (hotel_id) => {
    emit("ratingReady", hotel_id)
}
</script>


<style scoped>
html {
    scroll-behavior: smooth;
}

.modal-wrap {
    width: 500px;
    height: 500px;
    z-index: 10000;
}

/* NavBar css */
.b-app-navbar {
    height: 80px;
    width: 72%;
    top: 0;
    justify-content: center;
    text-align: center;
    margin: auto;
}

.b-background {
    width: 100%;
    height: 320px;
}

.b-background img {
    width: 100%;
    height: 320px;
}

.b-background .b-background-content {
    display: block;
    margin-top: -15%;
    z-index: 10;
    color: white;
    padding-left: 8%;
}

.b-background .b-background-content h1 {
    font-size: 70px;
    margin-top: 40px;
    margin-bottom: 0;
}

.b-background .b-background-content p {
    font-size: 30px;
    margin: 2px;
}

.b-navbar {
    display: flex;
    position: relative;
    z-index: 100;
    justify-content: center;
    background-color: rgb(254, 187, 2);
    border: 1px solid rgb(254, 187, 2);
    border-radius: 3px;
    top: -30px;
    height: 60px;
}

.b-nav-item {
    margin: auto;
}

.b-nav-item-button-1 {
    /* flex-basis: 40%; */
    width: 320px;
    height: 50px;
    padding: 0.5rem 0.5rem 0.5rem 0.5rem;
    font-size: 20px;
    background-color: white;
    border-radius: 3px;
    border: 1px solid white;
}

.b-nav-item-button-2 {
    width: 100px;
    height: 50px;
    padding: 0.5rem 0.5rem 0.5rem 0.5rem;
    font-size: 20px;
    background-color: aquamarine;
    border-radius: 3px;
    border: 1px solid aquamarine;
}

.b-nav-item-button-2:hover {
    cursor: pointer;
    background-color: aqua;
    widows: 98px;
    border: 1px solid aqua;
}

.b-nav-item-button-1:hover {
    cursor: pointer;
    width: 318px;
}

.b-nav-item .b-nav-link {
    font-size: 1rem;
    font-weight: 600;
    line-height: 1.5;
    color: #525c68;
    text-decoration: none;
}

.b-nav-item .search-destination-input {
    height: 50px;
    width: 500px;
    padding-left: 35px;
    font-size: 20px;
    border: 0;
    border-radius: 3px;
}

.b-nav-item .date-input {
    height: 50px;
    padding-left: 35px;
    font-size: 20px;
    border: 0;
    border-radius: 3px;
}

.popup {
    display: flex;
    position: fixed;
    z-index: 300;
    top: 48%;
    left: 50%;
    transition: opacity 2s 2s ease, transform 2s 2s ease, background-color 2s linear, color 2s linear;
}

.popup .popup-inner {
    background-color: #fff;
    background-color: aqua;
}

.book-image {
    height: 685px;
    width: 72%;
    top: 0;
    justify-content: center;
    text-align: center;
    margin: auto;
    display: flex;
    justify-content: space-between;
}

.book-image #main-image {
    flex-basis: 75%;
    height: 100%;
}

.book-image #sub-image {
    flex-basis: 24%;
    height: 100%;
    display: flex;
    justify-content: space-between;
    flex-direction: column;
}

.book-image #main-image img {
    width: 100%;
}

.book-image #sub-image img {
    width: 100%;
}

.hotel-main-body {
    margin-top: 40px;
    height: 80px;
    width: 72%;
    margin-left: 14%;
    justify-content: center;
}

.hotel-h-item {
    height: 330px;
    width: 100%;
    box-shadow: 0 5px 12px rgba(0, 0, 0, .15);
    margin-bottom: 70px;
}

.hotel-h-item-up {
    display: flex;
    padding: 1rem 2rem 2rem 3rem;
    border-bottom: 1px solid rgba(0, 0, 0, .15);
}

.hotel-item-up-hl {
    width: 70%;
}

.hiu-header {
    font-weight: 700;
    font-size: 35px;
}

.hiu-rating {
    display: flex;
    margin-top: 15px;
    margin-bottom: 10px;
    font-size: 20px;
}

.checked {
    color: orange;
}

.hiu-score {
    font-weight: 400;
    margin-left: 20px;
    color: #8b8c8f;
}

.hm-text-light {
    font-weight: 400;
    font-size: 20px;
    padding: 7px;
}

.hm-button {
    left: 50%;
    margin-top: 15px;
}

.hm-button button {
    width: 300px;
    height: 60px;
    font-size: 22px;
    border-radius: 30px;
    border-color: rgb(77, 69, 173);
    color: #e4e9ee;
    background-color: rgb(77, 69, 173);
}

.hm-button button:hover {
    cursor: pointer;
}

.rating-symbol{
    left: 60%;
    margin-top: 15px;
}

.hm-rating-symbol button {
    width: 240px;
    height: 50px;
    font-size: 20px;
    border-radius: 25px;
    border-color: rgb(77, 69, 173);
    color: #e4e9ee;
    background-color: rgb(77, 69, 173);
    cursor: pointer;
}

.hm-button-t {
    left: 50%;
    margin-top: 15px;
}

.hm-button-t button {
    width: 240px;
    height: 50px;
    font-size: 22px;
    border-radius: 10px;
    border-color: rgb(77, 69, 173);
    color: #e4e9ee;
    background-color: rgb(77, 69, 173);
}

.hm-button-t button:hover {
    cursor: pointer;
}

.hotel-h-item-down {
    padding: 1rem 2rem 2rem 3rem;
    width: 100%;
}

.hm-text-bold {
    font-weight: 600;
    font-size: 25px;
    display: block;
    width: 100%;
}

.hm-row {
    display: flex;
}

.hiu-symbol-1 {
    margin-top: 15px;
    margin-right: 30px;
    margin-bottom: 15px;
    display: flex;
    font-size: 20px;
}

.hiu-symbol {
    margin-left: 30px;
    margin-top: 15px;
    margin-right: 30px;
    margin-bottom: 15px;
    display: flex;
    font-size: 20px;
}

.hotel-h-item-b {
    height: 480px;
    width: 100%;
    box-shadow: 0 5px 12px rgba(0, 0, 0, .15);
    margin-bottom: 70px;
    padding-bottom: 40px;
}

.hotel-h-item-room {
    margin-top: 70px;
    padding-top: 7px;
    height: 300px;
    padding-left: 5%;
    padding-right: 5%;
}

.hotel-item-room-name {
    margin-top: 30px;
    margin-bottom: 20px;
    font-weight: 700;
    font-size: 25px;
}

.hotel-item-room-h{
    display: flex;
}
.hotel-item-room-hl {
    width: 30%;
}
.hotel-item-room-hr{
    width: 70%;
    border: 1px solid rgba(0, 0, 0, .15);
    border-radius: 8px;
}

.hotel-item-room-card-up{
    border-bottom: 1px solid rgba(0, 0, 0, .15);
    height: 160px;
    padding-top: 10px;
    padding-left: 20px;
}

.hirc-u-header{
    font-weight: 600;
    font-size: 20px;
}

.hotel-item-room-card-dowm{
    padding-top: 20px;
    padding-left: 36%;
}

.hirc-d-item{
    display: flex;
    justify-content: space-between;
    padding-right: 20px;
    align-items: center;
}

.hirc-d-text{
    margin-top: 40px;
    color: rgb(66, 66, 66);
    padding-left: 7px;
}

*,
*::before,
*::after {
    box-sizing: border-box;
}

.full-height {
    min-height: 100vh;
}

[type="checkbox"]:checked,
[type="checkbox"]:not(:checked) {
    position: absolute;
    left: -9999px;
}

.modal-btn:checked+label,
.modal-btn:not(:checked)+label {
    position: relative;
    font-family: 'Poppins', sans-serif;
    font-weight: 500;
    font-size: 15px;
    line-height: 2;
    height: 50px;
    transition: all 200ms linear;
    border-radius: 4px;
    width: 240px;
    letter-spacing: 1px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    text-align: center;
    align-self: center;
    border: none;
    cursor: pointer;
    background-color: rgb(77, 69, 173);
    color: #ffeba7;
    box-shadow: 0 12px 35px 0 rgba(16, 39, 112, .25);
}

.modal-btn:not(:checked)+label:hover {
    background-color: #ffeba7;
    color: #102770;
}

.modal-btn:checked+label:after,
.modal-btn:not(:checked)+label:after {
    position: fixed;
    top: 8%;
    right: 2%;
    z-index: 1000;
    width: 50px;
    border-radius: 3px;
    height: 45px;
    text-align: center;
    line-height: 50px;
    font-size: 18px;
    background-color: #ffeba7;
    color: rgb(77, 69, 173);
    content: '\2715';
    box-shadow: 0 12px 25px 0 rgba(16, 39, 112, .25);
    transition: all 200ms linear;
    opacity: 0;
    pointer-events: none;
    transform: translateY(20px);
    font-family: Courier, monospace;
    font-size: 40px;
}

.modal-btn:checked+label:hover:after,
.modal-btn:not(:checked)+label:hover:after {
    background-color: #102770;
    color: #ffeba7;
}

.modal-btn:checked+label:after {
    transition: opacity 300ms 300ms ease, transform 300ms 300ms ease, background-color 250ms linear, color 250ms linear;
    opacity: 1;
    pointer-events: auto;
    transform: translateY(0);
}

.modal {
    position: fixed;
    display: block;
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    margin: 0 auto;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 100;
    overflow-x: hidden;
    background-color: rgba(31, 32, 41, .75);
    pointer-events: none;
    opacity: 0;
    transition: opacity 250ms 700ms ease;
}

.modal-btn:checked~.modal {
    pointer-events: auto;
    opacity: 1;
    transition: all 300ms ease-in-out;
}

.modal-wrap {
    position: relative;
    display: block;
    width: 100%;
    max-width: 500px;
    margin: 0 auto;
    margin-top: 20px;
    margin-bottom: 20px;
    border-radius: 15px;
    overflow: hidden;
    padding-bottom: 20px;
    background-color: rgb(77, 69, 173);
    align-self: center;
    box-shadow: 0 12px 25px 0 rgba(199, 175, 189, .25);
    opacity: 0;
    transform: scale(0.6);
    transition: opacity 250ms 250ms ease, transform 300ms 250ms ease;
    height: 300px;
}

.modal-wrap p {
    padding: 20px 30px 0 30px;
}

.modal-btn:checked~.modal .modal-wrap {
    opacity: 1;
    transform: scale(1);
    transition: opacity 250ms 500ms ease, transform 350ms 500ms ease;
}


.logo img {
    height: 26px;
    width: auto;
    display: block;
    filter: brightness(10%);
    transition: filter 250ms 700ms linear;
}

.modal-btn:checked~.logo img {
    filter: brightness(100%);
    transition: all 250ms linear;
}

.aa-sitem {
    display: flex;
    justify-content: space-between;
    margin-bottom: 7px;
}

.aa-sitem .aa-sinput {
    width: 250px;
    height: 45px;
    border-radius: 4px;
    font-size: 14px;
    font-weight: 400;
    padding-left: 5px;
    margin-right: 15%;
    font-size: 18px;
    font-family: Arial, Helvetica, sans-serif;
}

.aa-sitem .aa-stext {
    font-size: 20px;
    font-weight: 500;
    line-height: 1.2;
    color: #3e3e3e;
    padding-top: 6px;
    margin-left: 10%;
    font-family: inherit;
    font-weight: bold;
}

.aa-sbutton {
    left: 50%;
    margin: 35px;
}

.aa-sbutton button {
    width: 300px;
    height: 45px;
    font-size: 22px;
    border-radius: 30px;
    border-color: #466ce8;
    color: #e4e9ee;
    background-color: #466ce8;
}

.aa-sbutton button:hover {
    background-color: #958ff0;
    border-color: #958ff0;
    cursor: pointer;
}

.pc-action-a2 {
    width: 500px;
    height: 300px;
}
</style>