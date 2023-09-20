<template>
    <div v-if="wallet">
        <div class="user-principal">
            ID: {{wallet.principal}}
        </div>
        <div class="reservation" v-if="hotel_principal" @click="goReservation">
            Reservation
        </div>
    </div>
</template>

<script setup>
import { useCanister, useWallet } from "@connect2ic/vue"
import { ref, watchEffect } from "vue";

const [wallet] = useWallet()
const [defi] = useCanister("defi")

const emit = defineEmits(['goReservation'])

var hotel_principal = ref(null)

const getConnect = async () => {
    var res = await defi.value.connect()
    console.log(res)
}

const isHotelPrincipal = async () => {
    var res = await defi.value.isHotelPrincipal()
    hotel_principal.value = res
}

const goReservation = () => {
    emit("goReservation")
}

watchEffect(() => {
	if(wallet.value && defi.value) {
		getConnect()
        isHotelPrincipal()
	}else{
        hotel_principal.value = null
    }
});

</script>

<style>
.user-principal{
    color: #424242;
    margin-top: 0.5rem;
}

.reservation{
    color: #424242;
    cursor: pointer;
}
</style>