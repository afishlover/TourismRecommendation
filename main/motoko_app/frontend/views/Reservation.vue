<template>
    <div>
        <div>
            <div class="reservation-body">
                <div class="rb-header">
                    <h2>Hotel Reservation</h2>
                </div>
                <div class="rb-table">
                    <table id="table">
                        <thead>
                            <tr>
                                <th class="rbt-th">ID</th>
                                <th class="rbt-th">Customer</th>
                                <th class="rbt-th">Price</th>
                                <th class="rbt-th">Date checkin</th>
                                <th class="rbt-th">Date checkout</th>
                                <th class="rbt-th">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="booked in list_booked" :key="booked">
                                <td class="rbt-td" scope="row">{{ booked._roomID }}</td>
                                <td class="rbt-td">{{ booked.holder }}</td>
                                <td class="rbt-td">{{ booked._sellPrice }}</td>
                                <td class="rbt-td">{{ "date checkin" }}</td>
                                <td class="rbt-td">{{ "date checkout" }}</td>
                                <td class="rbt-td" style="display: flex">
                                    <button class="rbt-bc" type="button" style="width:100px" @click="removeBooking(booked._roomID, true)">Confirm</button>
                                    <button class="rbt-br" type="button" style="width:100px" @click="removeBooking(booked._roomID, false)">Remove</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { useCanister, useWallet } from "@connect2ic/vue"
import { ref, watchEffect } from "vue";
import { Principal } from '@dfinity/principal';

var list_booked = ref([])

const [wallet] = useWallet()
const [defi] = useCanister("defi")


const getBookedRooms = async () => {
    let res = await defi.value.getBookedRooms()
    console.log(res)
    list_booked.value = res
}

const removeBooking = async (room_id, done) => {
    let res = await defi.value.removeBooking(BigInt(room_id), done)
    if("ok" in res){
        var temp = []
        for(const i in res.value){
            if(list_booked.value[i]._roomID != room_id){
                temp.push(list_rooms.value[i])
            }
        }
        list_booked.value = temp
    }
}

watchEffect(() => {
	if(wallet.value && defi.value) {
        getBookedRooms()
	}else{
        list_booked.value = []
    }
});


</script>

<style scoped>
.reservation-body {
    margin-top: 5%;
    
}

.rb-header {
    margin-left: 25%;
    font-size: 30px;
}

.rb-table {
    margin-left: 10%;
    display: block;
    justify-content: center;
    text-align: center;
    border: 1px solid #171E5C;
    border-radius: 5px;
    width: 70%;
}

.rb-table .rbt-th {
    width: 200px;
    height: 30px;
    border: 1px solid #171E5C;
}

.rb-table .rbt-td {
    width: 200px;
    height: 30px;
    border: 1px solid #171E5C;
}

.rbt-bc {
    height: 30px;
    padding: 5px 25px;
    background-color: rgb(223, 62, 62);
}

.rbt-br {
    height: 30px;
    padding: 5px 25px;
    background-color: rgb(83, 81, 81);
}

.rbt-bc:hover {
    cursor: pointer;
}

.rbt-br:hover {
    cursor: pointer;
}
</style>