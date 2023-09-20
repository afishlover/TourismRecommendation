<template>
<div class='container'>
        <div class="wrap-body row">
            <div class="col-md-8">
                <img class="img-thumb"
                    src="https://khachsantaythi.com.vn/wp-content/uploads/2019/05/DSCF4744-1024x683.jpg">
            </div>
            <div class="col-md-4">
                <h4><b>{{hotel._name}}</b></h4>
                <div class="hiu-rating">
                    <div class="hiu-star">
                        <span class="fa fa-star" :class="hotel._rating >= 1 ? 'checked' : ''"></span>
                        <span class="fa fa-star" :class="hotel._rating >= 2 ? 'checked' : ''"></span>
                        <span class="fa fa-star" :class="hotel._rating >= 3 ? 'checked' : ''"></span>
                        <span class="fa fa-star" :class="hotel._rating >= 4 ? 'checked' : ''"></span>
                        <span class="fa fa-star" :class="hotel._rating >= 5 ? 'checked' : ''"></span>
                    </div>
                    <div class="hiu-score">
                        {{hotel._rating}}
                    </div>
                </div>
                <br>
                <h4><b>Address</b></h4>
                <p>
                    {{hotel._information}}
                </p>
            </div>
        </div>

        <div class="wrap-body row">
            <div class="col-md-4">
                <div>
                    <h5>Rate this attraction: </h5>
                    <div class="rate">
                        <input type="radio" id="star5" name="rate" value="5" @click="rate = 5" />
                        <label for="star5" title="text">5 stars</label>
                        <input type="radio" id="star4" name="rate" value="4" @click="rate = 4"/>
                        <label for="star4" title="text">4 stars</label>
                        <input type="radio" id="star3" name="rate" value="3" @click="rate = 3"/>
                        <label for="star3" title="text">3 stars</label>
                        <input type="radio" id="star2" name="rate" value="2" @click=" rate = 2"/>
                        <label for="star2" title="text">2 stars</label>
                        <input type="radio" id="star1" name="rate" value="1" @click="rate = 1"/>
                        <label for="star1" title="text">1 star</label>
                    </div>
                </div>
            </div>

        </div>
        <div class="wrap-body row">
            <div class="margin-f-none col-md-12">
                <span class="h4">Lake of the Restored Sword (Hoan Kiem Lake) reviews</span>
                <br>
            </div>
        </div>
        <div class="wrap-body row" v-for="review in reviews" :key="review">
            <div class="col-8">
                <div class="static-rate">
                    <span class="fa fa-star" :class="review._rating >= 1 ? 'checked' : ''"></span>
                    <span class="fa fa-star" :class="review._rating >= 2 ? 'checked' : ''"></span>
                    <span class="fa fa-star" :class="review._rating >= 3 ? 'checked' : ''"></span>
                    <span class="fa fa-star" :class="review._rating >= 4 ? 'checked' : ''"></span>
                    <span class="fa fa-star" :class="review._rating >= 5 ? 'checked' : ''"></span>
                </div>
                <div>
                    <span class="review"> <span>By</span>
                        <span class="author"> {{review.reviewer}} </span>
                    </span>
                    <br>
                    <p>{{review._reviewText}}</p>
                    Rate this comment:  <input type="number" min="1" max="5" v-model="review._score"/> <span class="fa fa-star checked"></span> 
                    <button style="border:0;"><span class="fa fa-check" @click="scoreReview(review)"></span></button><br />
                    Point: {{review._score}} <span class="fa fa-star checked"></span>
                </div>
            </div>
        </div>
        <div class="wrap-body row">
            <div class="col-8">
                <div class="form-group">
                    <h4>Leave a comment</h4>

                    <textarea name="msg" id="" msg cols="30" rows="5" class="form-control" v-model="comment"></textarea>
                </div>
                <div class="form-group">
                    <button type="button" id="post" class="btn" @click="postReview">Post Comment</button>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
/* eslint-disable */
import { useCanister, useWallet } from "@connect2ic/vue"
import { ref, watchEffect, watch } from "vue";
import { Principal } from '@dfinity/principal';

const [defi] = useCanister("defi")
const [wallet] = useWallet()

var rate = ref(0)
var comment = ref("")
var hotel = ref(null)
var reviews = ref([])

const getHotelInformation = async () => {
    let res = await defi.value.getHotelInformation();
    hotel.value = res
}

const getReviews = async () => {
    let res = await defi.value.getReviews(hotel.value._hotelID)
    console.log(res)
    reviews.value = res
}

const scoreReview = async (r) => {
    console.log(r)
    let res = await defi.value.scoreReview(hotel.value._hotelID, r.reviewer, r._score)
    console.log(res)
}

const postReview = async () => {
    let res = await defi.value.addReview(hotel.value._hotelID, BigInt(rate.value), comment.value)
    console.log(res)
    if("Ok" in res){
        reviews.value.push({
            reviewer: Principal.fromText(wallet.value.principal),
            _reviewText: comment.value ,
            _rating: rate.value,
            _score: 0,
            _num: 0,
        })
    }
}

watchEffect(() => {
	if(wallet.value && defi.value) {
        getHotelInformation()
	}else{
        comment.value = ""
        rate.value = 0
        hotel.value = null
    }
});

watchEffect(() => {
	if(hotel.value && defi.value) {
        getReviews()
	}else{
        reviews.value = []
    }
});

</script>


<style scoped>
.title {
    font-weight: 1000;
    font-family: 'Klarna Text';
    font-size: 32px;
    letter-spacing: .3px;
}

.img-thumb {
    box-sizing: border-box;
    width: 100%;
    height: 500px;
}

.activate-time {
    width: 70%;
    font-size: 16px;
}

td {
    padding: 2px;
}

.wrap-body {
    padding: 0 70px;
    margin-bottom: 15px;
}

.description {
    font-size: 18px;
    text-align: justify;
    text-justify: inter-word;
    font-weight: 500;
}

.rate {
    float: left;
    height: 46px;
    padding: 0 10px;
}

.rate:not(:checked)>input {
    position: absolute;
    top: -9999px;
}

.rate:not(:checked)>label {
    float: right;
    width: 1em;
    overflow: hidden;
    white-space: nowrap;
    cursor: pointer;
    font-size: 30px;
    color: #ccc;
}

.rate:not(:checked)>label:before {
    content: '★ ';
}

.rate>input:checked~label {
    color: #ffc700;
}

.rate:not(:checked)>label:hover,
.rate:not(:checked)>label:hover~label {
    color: #deb217;
}

.rate>input:checked+label:hover,
.rate>input:checked+label:hover~label,
.rate>input:checked~label:hover,
.rate>input:checked~label:hover~label,
.rate>label:hover~input:checked~label {
    color: #c59b08;
}

.author {
    font-weight: 700;
    display: inline;
}


.static-rate:not(:checked)>label:before {
    content: '★ ';
}

.static-rate>input:checked~label {
    color: #ffc700;
}

.static-rate:not(:checked)>label {
    float: right;
    width: 1em;
    overflow: hidden;
    white-space: nowrap;
    cursor: pointer;
    font-size: 20px;
    color: #ccc;
}

.static-rate:not(:checked)>input {
    position: absolute;
    top: -9999px;
}

.static-rate {
    float: left;
    height: fit-content;
    margin-right: 15px;
}

.review {
    font-size: 20px;
}

.checked {
    color: orange;
}

.form-group input,
.form-group textarea {
    border: 1px solid rgba(16, 46, 46, 1);
    border-radius: 12px;
}

form {
    border: 1px solid rgba(16, 46, 46, 1);
    border-radius: 5px;
    padding: 20px;
}

#post {
    margin: 10px;
    padding: 6px;
    padding-top: 2px;
    padding-bottom: 2px;
    text-align: center;
    border-color: #a88734 #9c7e31 #846a29;
    color: black;
    border-width: 1px;
    border-style: solid;
    border-radius: 13px;
    width: 20%;
    transition: .5s;
}

#post:hover {
    background-color: #deb217;
}
</style>