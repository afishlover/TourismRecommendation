<template>
  <div class="process-image" >
    <template v-if="wallet">
        <div class="button-section">
            <input type="file" class="button-t" spellcheck="false" @change="uploadFile($event)">
            <div class="button-t" @click="mintImage"> Mint </div>
        </div>
        <div class="images-section">
            <div v-for="(item, idx) in list_nft" :key="item+idx" @click="selectNft(item.index)" class="image-item" 
            :class="item.index == select_nft ? 'sl-img':'usl-img'">
                <img :src="item.image" width="200" height="300">
            </div>
        </div>
        <div class="nft-section">
            <div>
                Image: {{select_nft}}
            </div>
            <input type="text" v-model="to_principal">
            <div class="button-t" @click="transferNft">
                Transfer
            </div>
        </div>
    </template>
    <template v-else>
        <p> Connect with a wallet to access this function </p>
    </template>
  </div>
</template>

<script setup>
import { useCanister, useWallet } from "@connect2ic/vue"
import { client } from '../utilities/ipfs';
import { Principal } from '@dfinity/principal';
import { customAxios } from '../utilities/custom-axios';
import {ref, watchEffect} from "vue";

const IPFS_LINK = 'https://dweb.link/ipfs/';

const [nft] = useCanister("nft")
const [wallet] = useWallet()

var file = null
var list_nft = ref([])
var select_nft = ref(null)
var to_principal = ref("")

const uploadFile = (event) => {
    file = event.target.files[0]
    console.log("upload success")
}

const mintImage = async () => {
    if(file == null){
        const res = await nft.value.getPrincipal()
        console.log(res.toText())
    }else{
        try{
            const cid = await client.put([file]);
            const nFile = new File(
                            [
                            JSON.stringify({
                                description: "this is description",
                                name: file.name,
                                image: `${IPFS_LINK}${cid}/${file.name}`,
                            }),
                        ],
                        `${file.name}.json`,
                        { type: 'text/plain' }
                    )
            const metadataCID = await client.put([nFile]);
            
            const res = await nft.value.mint(Principal.fromText(wallet.value.principal), [
                { tokenUri: `${IPFS_LINK}${metadataCID}/${file.name}.json` },
            ]);
            console.log(res)
            getListNft()
        }
        catch (error){
            console.log(error)
        }
    }
}

const transferNft = async () => {
    if(select_nft){
        const res = await nft.value.transfer(Principal.fromText(to_principal.value), BigInt(select_nft.value))
        console.log(res)
        to_principal.value = ""
        select_nft.value = null
        getListNft()
    }
}

const getListNft = async () => {
    const res = await nft.value.getUserTokens(Principal.fromText(wallet.value.principal))
    const promise4all = Promise.all(
		res.map(function (el) {
			return customAxios(el.metadata[0]?.tokenUri);
		})
	);
	const resu = await promise4all;
	list_nft.value = res.map((el, index) => {
		return {...el, ...resu[index]}
	})    
    
}

watchEffect(() => {
		if(wallet.value && nft.value) {
			getListNft()
		}else{
            file = null
            list_nft.value = []
            select_nft.value = null
            to_principal.value = ""
        }
});

const selectNft = (val) => {
    select_nft.value = val
}

</script>


<style>
.process-image{
    height: 600px;
    width: 700px;
}

.button-section{
    display: flex;
    justify-content: space-between;
}

.button-t{
    height: 40px;
    width: 100px;
    border: 1px solid black;
    cursor: pointer;
}

.images-section{
    width: 700px;
    height: 400px;
    border: 1px solid black;
    display: flex;
    overflow: auto;
}

.image-item{
    margin-left: 20px;
}

.sl-img{
    border: 1px solid rgb(21, 21, 237);
}

.usl-img{
    border: none;
}
</style>