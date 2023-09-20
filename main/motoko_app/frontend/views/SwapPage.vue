<template>
    <div>
        <div class="swap-body">
            <div class="swap-background"></div>
            <div class="swap-content">
                <div class="swap-nav">
                    <div v-if="nav_check == 'transaction'">
                        <ul class="sn-ul">
                            <li style="font-size: 18px; color: white;" class="checked">
                                <a style="color: black;" href="#"
                                    @click="display = 'transaction', nav_check = 'transaction'">Transaction</a>
                            </li>
                            <li style="font-size: 18px; color: white;">
                                <a style="color: black;" href="#" @click="display = 'swap', nav_check = 'swap'">Swap</a>
                            </li>
                        </ul>
                    </div>
                    <div v-if="nav_check == 'swap'">
                        <ul class="sn-ul">
                            <li style="font-size: 18px; color: white;">
                                <a style="color: black;" href="#"
                                    @click="display = 'transaction', nav_check = 'transaction'">Transaction</a>
                            </li>
                            <li style="font-size: 18px; color: white;" class="checked">
                                <a style="color: black;" href="#" @click="display = 'swap', nav_check = 'swap'">Swap</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="swap-card" v-if="display == 'swap'">
                <div class="sc-title">
                    <h4 style="margin-top: 0; margin-bottom: 0; font-size: 25px;"> Swap </h4>
                    <button @click="() => TogglePopup('buttonTrigger')" class="b-nav-item-button-1">
                        <i class="fa-solid fa-gear"></i>
                    </button>
                </div>
                <div class="sc-swap-content">
                    <div class="sc-input">
                        <div class="sci-hl">
                            <div class="sci-hl-input">
                                <input placeholder="0" v-model="zed_swap" :disabled="arrow"/>
                            </div>
                            <div class="sci-hl-info">
                                <h4
                                    style="margin-top: 0; margin-bottom: 0; font-size: 25px; margin-top: 3px; margin-right: 5px;">
                                    ZED</h4>
                                <p style="margin-top: 0; margin-bottom: 0; font-size: 15px; margin-top: 10px;">
                                    balance: {{ zed_balance }}</p>
                            </div>
                        </div>
                        <div class="sci-hr"></div>
                    </div>
                    <div class="sc-arrow-input">
                        <button @click="arrow = !arrow" :class="arrow ? 'rotate-up' : ''"><i class="fa-solid fa-arrow-down fa-2x"></i></button>
                    </div>
                    <div class="sc-output">
                        <div class="sci-hl">
                            <div class="sci-hl-input">
                                <input placeholder="0" v-model="yasuo_swap" :disabled="!arrow"/>
                            </div>
                            <div class="sci-hl-info">
                                <h4
                                    style="margin-top: 0; margin-bottom: 0; font-size: 25px; margin-top: 3px; margin-right: 5px;">
                                    YASUO</h4>
                                <p style="margin-top: 0; margin-bottom: 0; font-size: 15px; margin-top: 10px;">
                                    balance: {{ yasuo_balance }}</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="sc-button-swap">
                    <button @click="swapToken">Swap</button>
                </div>
            </div>
            <div class="transaction-card" v-if="display == 'transaction'">
                <div class="tc-title">
                    <h4 style="margin-top: 0; margin-bottom: 0; font-size: 25px;"> Transaction </h4>
                    <button @click="() => TogglePopup('buttonTrigger')">
                        <i class="fa-solid fa-gear"></i>
                    </button>
                </div>
                <div class="tc-swap-content">
                    <div class="sc-input">
                        <div class="sci-hl">
                            <div class="sci-hl-input">
                                <input placeholder="0" v-model="zed_transfer"/>
                            </div>
                            <div class="sci-hl-info">
                                <h4
                                    style="margin-top: 0; margin-bottom: 0; font-size: 25px; margin-top: 3px; margin-right: 5px;">
                                    ZED</h4>
                                <p style="margin-top: 0; margin-bottom: 0; font-size: 15px; margin-top: 10px;">balance:
                                    {{ zed_balance }}</p>
                            </div>
                        </div>
                        <div class="sci-hr"></div>
                    </div>
                    <div class="sc-output">
                        <div class="sci-hl">
                            <div class="sci-hl-input">
                                <input placeholder="aaaaa-aa" v-model="recive_principal"/>
                            </div>
                            <div class="sci-hl-info">
                                <h4
                                    style="margin-top: 0; margin-bottom: 0; font-size: 25px; margin-top: 3px; margin-right: 5px;">
                                    Principal</h4>
                                <p style="margin-top: 0; margin-bottom: 0; font-size: 15px; margin-top: 10px;"></p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="tc-button-swap">
                    <button @click="transferZed">Transfer</button>
                </div>
            </div>
        </div>
        <div class="list-token">
            <h4>Hello Beautiful Lady!</h4>
        </div>
    </div>
</template>

<script setup>
import { useCanister, useWallet } from "@connect2ic/vue"
import { ref, watchEffect, watch } from "vue";
import { Principal } from '@dfinity/principal';

const popupTriggers = ref({
    buttonTrigger: false,
})

const TogglePopup = (trigger) => {
    popupTriggers.value[trigger] = !popupTriggers.value[trigger]

}

const display = ref('transaction')
const nav_check = ref('transaction')
var arrow = ref(false)

const [wallet] = useWallet()
const [defi] = useCanister("defi")

var yasuo_balance = ref(0)
var zed_balance = ref(0)

const getBalance = async () => {
    zed_balance.value = await defi.value.zedBalanceOf(Principal.fromText(wallet.value.principal))
    yasuo_balance.value = await defi.value.yasuoBalanceOf(Principal.fromText(wallet.value.principal))
    console.log(zed_balance)
    console.log(yasuo_balance)
}

watchEffect(() => {
	if(wallet.value && defi.value) {
		getBalance()
	}else{
        yasuo_balance.value = 0;
        zed_balance.value = 0;
    }
});

var yasuo_swap = ref(0)
var zed_swap = ref(0)
var recive_principal = ref("")
var zed_transfer = ref(0)

watch(zed_swap, (newValue, oldValue) => {
    if(!arrow.value){
        //yasuo_swap.value = Math.floor(newValue / 10)
    }
});

watch(yasuo_swap, (newValue, oldValue) => {
    if(arrow.value){
        //zed_swap.value = newValue * 10
    }
})

const swapToken = async () => {
    if(!arrow.value){
        let res = await defi.value.swapZedToYasuo(BigInt(zed_swap.value))
        if("Ok" in res){
            zed_balance.value -= BigInt(zed_swap.value)
            yasuo_balance.value += BigInt(res["Ok"])
        }
    }else{
        let res = await defi.value.swapYasuoToZed(BigInt(yasuo_swap.value))
        if("Ok" in res){
            zed_balance.value += BigInt(res["Ok"])
            yasuo_balance.value -= BigInt(yasuo_swap.value)
        }
    }
}

const transferZed = async () => {
    let res = await defi.value.transferZed(Principal.fromText(recive_principal.value),zed_transfer.value)
    console.log(res)
    if("Ok" in res){
        zed_balance.value -= zed_transfer.value
    }
}
</script>


<style scoped>
.swap-content {
    display: block;
    margin-top: -40%;
}

.sn-ul {
    display: flex;
    color: white;
    justify-content: center;
}

.swap-nav {
    margin-left: 42%;
    width: 16%;
    margin-bottom: 60px;
    background-color: white;
    padding: 2px;
    border-radius: 10px;
}

.swap-nav li {
    margin: auto;
}

.checked {
    font-weight: bold;
}

.swap-background {
    width: 100%;
    height: 841px;
    background: -moz-linear-gradient(top, rgb(77, 69, 173) 0%, rgb(141, 138, 178) 100%);
    background: -webkit-linear-gradient(top, rgb(77, 69, 173) 0%, rgb(141, 138, 178) 100%);
    background: -o-linear-gradient(top, rgb(77, 69, 173) 0%, rgb(141, 138, 178) 100%);
    background: linear-gradient(top, rgb(77, 69, 173)f 0%, rgb(141, 138, 178) 100%);
}

.swap-card {
    display: block;
    z-index: 10;
    width: 40%;
    background-color: rgb(241, 236, 236);
    box-shadow: 0.2px 2px 129px black;
    margin-left: 30%;
    border-radius: 5px;
    height: 400px;
}

.sc-title {
    display: flex;
    padding: 10px 15PX;
    margin: auto;
}

.sc-title button {
    margin-left: 88%;
    font-size: 20px;
    border: 0;
    background-color: rgb(241, 236, 236);
}

.sc-title button:hover {
    cursor: pointer;
    font-size: 22px;
}

.sc-swap-content {
    margin: 30px;
}

.sc-input {
    width: 80%;
    background-color: rgb(190, 233, 233);
    display: block;
    height: 80px;
    margin-left: 10%;
    margin-bottom: 25px;
    border-radius: 5px;
}

.sci-hl {
    width: 90%;
    display: flex;
    height: 100%;
}

.sci-hl {
    width: 100%;
    display: flex-end;
    height: 100%;
}

.sci-hl-input {
    margin: 3%;
    height: 75%;
    width: 90%;
    font-size: 30px;
}

.sci-hl-input input {
    border-radius: 5px;
    border: 0;
    font-size: 30px;
}

.sci-hl-info {
    width: 25%;
    margin: 1px;
}

.sc-output {
    margin-top: 25px;
    width: 80%;
    background-color: rgb(190, 233, 233);
    display: block;
    height: 80px;
    margin-left: 10%;
    border-radius: 5px;
}

.list-token {
    display: none;
    margin-top: -21%;
    z-index: 10;
    width: 20%;
    background-color: rgb(247, 247, 247);
    box-shadow: 0.2px 2px 129px black;
    margin-left: 75%;
    border-radius: 5px;
    height: 400px;
}

.sc-button-swap {
    text-align: center;
    align-items: center;
}

.sc-button-swap button {
    width: 240px;
    height: 50px;
    font-size: 22px;
    border-radius: 10px;
    border-color: rgb(77, 69, 173);
    color: #e4e9ee;
    background-color: rgb(77, 69, 173);
}

.tc-title {
    display: flex;
    padding: 10px 15PX;
    margin: auto;
}

.tc-title button {
    margin-left: 80%;
    font-size: 20px;
    border: 0;
    background-color: rgb(241, 236, 236);
}

.tc-title button:hover {
    cursor: pointer;
    font-size: 22px;
}


.tc-button-swap {
    text-align: center;
    align-items: center;
    margin-top: 25px;
}

.tc-button-swap button {
    width: 240px;
    height: 50px;
    font-size: 22px;
    border-radius: 10px;
    border-color: rgb(77, 69, 173);
    color: #e4e9ee;
    background-color: rgb(77, 69, 173);
}

.tc-swap-content {
    margin: 30px;
}

.transaction-card {
    display: block;
    z-index: 10;
    width: 40%;
    background-color: rgb(241, 236, 236);
    box-shadow: 0.2px 2px 129px black;
    margin-left: 30%;
    border-radius: 5px;
    height: 400px;
}

.sc-arrow-input {
    display: flex;
    text-align: center;
    justify-content: center;
    border: 0;
}

.rotate-up{
    transform: rotate(180deg);
}
</style>