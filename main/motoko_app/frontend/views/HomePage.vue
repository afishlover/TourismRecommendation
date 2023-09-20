<template>
    <div class="home-page-body">
        <div class="splitview skewed">
            <div class="panel bottom">
                <div class="content">
                    <div class="description">
                        <h1>Optimizing service for customers.</h1>
                        <p>More comfortable, more secure, more convenient.</p>
                    </div>

                    <img src="../assets/image/original-image-background.png" alt="Original">
                </div>
            </div>

            <div class="panel top">
                <div class="content">
                    <div class="description">
                        <h1>The new way to plan your next trip.</h1>
                        <p>Create a fully customized day by day itinerary for free</p>
                    </div>

                    <img src="../assets/image/background-image.png" alt="HongKong">
                </div>
            </div>
            <div class="handle"></div>
        </div>
        <div class="plan-content">
            <div class="pc-action">
                <input class="modal-btn" type="checkbox" id="modal-btn" name="modal-btn" />
                <label for="modal-btn"> START PLANNING </label>
                <div class="modal">
                    <div class="modal-wrap">
                        <div class="pc-action-a2">
                            <h2>Intinerary Planner</h2>
                            <input type="text" v-model="plan_param.destination" class="aa-binput"
                                placeholder="Enter destination (Eg. Da Nang City)">
                            <div class="aa-sitem">
                                <label class="aa-stext">
                                    Budget
                                </label>
                                <input type="text" v-model="plan_param.budget" placeholder="5000000VND"
                                    class="aa-sinput">
                            </div>
                            <div class="aa-sitem">
                                <label class="aa-stext">Start date</label>
                                <!-- <input type="date" v-model="plan_param.startDate" class="aa-sinput"
                                    min="2000-01-01" id="inputDate1"> -->
                                 <input type="date" v-model="plan_param.startDate" class="aa-sinput" /> 
                            </div>
                            <div class="aa-sitem">
                                <label class="aa-stext">End date</label>
                                <!-- <input type="date" v-model="plan_param.endDate" class="aa-sinput"
                                    min="2000-01-01" id="inputDate2" onclick="calendarDueDate()"> -->
                                <input type="date" v-model="plan_param.endDate" class="aa-sinput" />
                            </div>
                            <div class="aa-sbutton">
                                <button @click="planning"> See your trip </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
           <div class="container pc-list">
        <div  class="tour-list-parent">
          <div v-for="post of posts" :key="post" class="tour-child card">
            <div class="top-right"><i class="fa-solid fa-trash-can fa-lg"></i></div>
            <img
              class="card-img-top"
              src="https://hegka.com/storage/image-content/N8GKHx1ldeMY3uv2OPa9Ls5N9rt8U0N31rcFStIWVrRaX.webp"
              alt="Card image cap"
            />
            <div class="caption">
              <h5>{{post.numberOfDays}} days in Hanoi</h5>
              <p class="date-detail">
                {{ formatDate(post.startDate) }} - {{formatDate(post.endDate) }}
              </p>
            </div>
            <div class="card-body">
              <p class="card-text text-center tour-summary">August . Popular Sights</p>
              <a href="#" class="stretched-link"></a>
            </div>
          </div>
        </div>
      </div>
            <div class="pc-advertisement">
                <p> Easy to use, easy to browse </p>
                <ul class="plan-steps">
                    <li class="step">
                        <div class="step__sec">
                            <i class="fa-solid fa-globe fa-3x"></i>
                        </div>
                        <div class="step__sec">
                            <div class="step__title">
                                Get a personalized trip</div>
                            <div class="step__desc">
                                A full day by day itinerary based on your preferences</div>
                        </div>
                    </li>
                    <li class="step">
                        <div class="step__sec">
                            <i class="fa-solid fa-calendar fa-3x"></i>
                        </div>
                        <div class="step__sec">
                            <div class="step__title">
                                Customize it</div>
                            <div class="step__desc">
                                Refine your trip. We'll find the <br>best routes and schedules</div>
                        </div>
                    </li>
                    <li class="step">
                        <div class="step__sec">
                            <i class="fa-solid fa-rocket fa-3x"></i>
                        </div>
                        <div class="step__sec">
                            <div class="step__title">
                                Book it</div>
                            <div class="step__desc">
                                Choose from the best hotels and activities. Up to 50% off</div>
                        </div>
                    </li>
                    <li class="step">
                        <div class="step__sec">
                            <i class="fa-solid fa-address-card fa-3x"></i>
                        </div>
                        <div class="step__sec">
                            <div class="step__title">
                                Manage it</div>
                            <div class="step__desc">
                                Everything in one place. Everyone on the same page.</div>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</template>

<script setup>
import axios from "axios";
import { PlanServices } from "../services/plan.services.js"
import { useCanister, useWallet } from "@connect2ic/vue"
import { Principal } from '@dfinity/principal';
import { ref, watchEffect } from "vue";

const [wallet] = useWallet()
const [defi] = useCanister("defi")

const emit = defineEmits(['tripReady'])

var plan_param = ref({
    destination: null,
    budget: null,
    startDate: null,
    endDate: null
})

const planning = async () => {
    if (wallet.value) {
        try {
            let trip_res = await defi.value.payGenerateTrip()
            console.log(trip_res)

            let res = await PlanServices.createPlan(plan_param.value, wallet.value.principal)
            emit("tripReady", res.data)
            console.log("ll")
        } catch (error) {
            console.log(error)
        }
    } else {
        console.log("you are not connected")
    }
}

var posts = ref([])
var errors = ref([])

const heroku = async () =>{
    await axios.get(`https://tourismrecommendation.herokuapp.com/trip/getByAccount/`+wallet.value.principal)
                .then((response) => {
                    posts.value = response.data;
                    console.log(this.posts)
                })
                .catch((e) => {
                    errors.value.push(e);
                    console.log("fail")
            });
}

watchEffect(() => {
	if(wallet.value) {
		heroku()
	}else{
        posts.value = []
        errors.value = []
    }
});
// var today = new Date();
// var dd = today.getDate();
// var mm = today.getMonth() + 1; //January is 0!
// var yyyy = today.getFullYear();
// if (dd < 10) {
//     dd = '0' + dd
// }
// if (mm < 10) {
//     mm = '0' + mm
// }
// today = yyyy + '-' + mm + '-' + dd;
// document.getElementById("inputDate1").setAttribute("min", today);

// function calendarDueDate() {
//     var startdate = document.getElementById("inputDate1").value;
//     console.log(startdate);
//     document.getElementById("inputDate2").setAttribute("min", startdate);
// }
</script>

<script>
export default {
  data() {
    return {
      
    };
  },
  created() {
    
  },
  methods: {
    formatDate(date) {
      const options = {
        weekday: "long",
        year: "numeric",
        month: "long",
        day: "numeric",
      };
      return new Date(date).toLocaleDateString("en", options);
    },
  },
};
document.addEventListener('DOMContentLoaded', function () {
    var parent = document.querySelector('.splitview'),
        topPanel = parent.querySelector('.top'),
        handle = parent.querySelector('.handle'),
        skewHack = 0,
        delta = 0;

    // If the parent has .skewed class, set the skewHack var.
    if (parent.className.indexOf('skewed') != -1) {
        skewHack = 1000;
    }

    parent.addEventListener('mousemove', function (event) {
        // Get the delta between the mouse position and center point.
        delta = (event.clientX - window.innerWidth / 2) * 0.5;

        // Move the handle.
        handle.style.left = event.clientX + delta + 'px';

        // Adjust the top panel width.
        topPanel.style.width = event.clientX + skewHack + delta + 'px';
    });
});
</script>

<style>
.hp-background {
    width: 100%;
    height: 400px;
    background-color: #edf0f4;
    background-image: url(https://s.inspirockcdn.com/images/home/hero-klarna.png)
}

.plan-content {
    margin-top: 3%;
    background-color: inherit;
    margin-bottom: 5%;
}

.pc-text {
    width: 21rem;
    margin-bottom: 1.5rem;
}

.pc-action {
    width: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
}

.pc-action-a1 {
    width: 200px;
    height: 50px;
    background-color: rgb(65, 59, 177);
    border-radius: 25px;
    color: white;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 12px;
    font-weight: 700;
    line-height: 1;
    cursor: pointer;
}

.pc-action-a1:hover {
    background-color: rgb(74, 87, 183);
}

.pc-action-a2 {
    background-color: #FAFAFA;
    z-index: 100;
    width: 500px;
    height: 400px;
    text-align: center;

}

.pc-action-a2 h2 {
    text-align: center;
    padding: 2%;
}

.pc-action-a2 input {
    text-align: center;
    height: 50px;
}

.pc-list {
    position: relative;
    margin-left: 18%;
    margin-right: auto;
    margin-bottom: 50px;
    width: 100%;
    display: block;
    margin-top: 1%;
}

#list-title {
    font-size: 40px;
    font-weight: bold;
    letter-spacing: .3px;
}

.pc-advertisement {
    position: relative;
    margin-left: auto;
    margin-right: auto;
    margin-bottom: 50px;
    width: 100%;
    display: block;
    margin-top: 1%;
}

.pc-advertisement p {
    font-size: 60px;
    font-weight: bold;
    text-align: center;
    letter-spacing: .3px;
}

/* Reset. */
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    padding: 0;
    font-size: 100%;
    font-family: Arial, Helvetica, sans-serif;
}

/* Panels. */
.splitview {
    position: relative;
    width: 100%;
    min-height: 45vw;
    overflow: hidden;
}

.panel {
    position: absolute;
    width: 100vw;
    min-height: 45vw;
    overflow: hidden;
}

.panel .content {
    position: absolute;
    width: 100vw;
    min-height: 45vw;
    color: #FFF;
}

.panel .description {
    width: 25%;
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    text-align: center;
}

.panel img {
    box-shadow: 0 0 20px 20px rgba(0, 0, 0, 0.15);
    width: 35%;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
}


.bottom {
    background-color: rgb(44, 44, 44);
    z-index: 1;
}

.bottom .description {
    right: 5%;
}

.top {
    background-color: rgb(77, 69, 173);
    z-index: 2;
    width: 50vw;

    /*-webkit-clip-path: polygon(60% 0, 100% 0, 100% 100%, 40% 100%);
    clip-path: polygon(60% 0, 100% 0, 100% 100%, 40% 100%);*/
}

.top .description {
    left: 5%;
}

/* Handle. */
.handle {
    height: 100%;
    position: absolute;
    display: block;
    background-color: rgb(253, 171, 0);
    width: 5px;
    top: 0;
    left: 50%;
    z-index: 3;
}

/* Skewed. */
.skewed .handle {
    top: 50%;
    transform: rotate(30deg) translateY(-50%);
    height: 200%;
    -webkit-transform-origin: top;
    -moz-transform-origin: top;
    transform-origin: top;
}

.skewed .top {
    transform: skew(-30deg);
    margin-left: -1000px;
    width: calc(50vw + 1000px);
}

.skewed .top .content {
    transform: skew(30deg);
    margin-left: 1000px;
}

/* Responsive. */
@media (max-width: 900px) {
    body {
        font-size: 75%;
    }
}


.plan-steps {
    width: 70%;
    display: flex;
    justify-content: center;
    padding: 0;
    margin: auto;
}

.step {
    text-align: center;
    position: relative;
    width: 100%;
}

.step__sec {
    margin: 5%;
}

.step__title {
    margin: 0 0 8px;
    display: inline-block;
    font-weight: bold;
}

.aa-binput {
    width: 350px;
    height: 34px;
    border-radius: 4px;
    margin-bottom: 20px;
    padding-left: 5px;
    font-size: 15px;
    font-weight: 400;
    font-size: 16px;
    font-family: Arial, Helvetica, sans-serif;
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
    width: 380px;
    height: 45px;
    font-size: 22px;
    border-radius: 30px;
    border-color: rgb(77, 69, 173);
    color: #e4e9ee;
    background-color: rgb(77, 69, 173);
}

.aa-sbutton button:hover {
    background-color: #958ff0;
    border-color: #958ff0;
    cursor: pointer;
}

.cards {
    width: 90%;
    display: flex;
}

.card {
    /* Add shadows to create the "card" effect */
    box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
    transition: 0.3s;
    width: 22%;
    margin: 1%;
    height: 300px;
    text-align: center;
}

.card-title {
    height: 250px;
    align-items: center;
}

.card-content {
    position: relative;
    opacity: 1;
    color: #0E0E0F;
    text-align: left;
    background: rgba(119, 108, 108, 0.92);
    padding: 15px 20px;
    height: 50px;
    text-transform: capitalize;
    transition: none;
    bottom: 0;
}

/* On mouse-over, add a deeper shadow */
.card:hover {
    box-shadow: 0 8px 16px 0 rgba(0, 0, 0, 0.2);
    transition: all 0.5s ease;
}

.card-title:hover {
    height: 200px;
    transition: all 1s ease;
}

.card:hover .card-title {
    height: 200px;
    background-color: orange;
}

.card-content:hover {
    height: 100px;
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
    color: #163394;
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
    background-color: rgb(70, 108, 232);
    align-self: center;
    box-shadow: 0 12px 25px 0 rgba(199, 175, 189, .25);
    opacity: 0;
    transform: scale(0.6);
    transition: opacity 250ms 250ms ease, transform 300ms 250ms ease;

}

.modal-wrap img {
    display: block;
    width: 100%;
    height: auto;
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
.tour-list-parent {
    display: flex;
    flex-wrap: wrap;
    margin-top: 50px;
}

.tour-child {
    flex: 0 0 30%;
    /* explanation below */
    margin: 10px
}

.caption {
    position: absolute;
    top: 0;
    left: 0;
    text-align: center;
    color: white;
    transform: translate(0%, 90%);
}

.tour-detail {
    display: none;
}

.top-right {
    position: absolute;
    top: 8px;
    right: 16px;
    color: white;
    z-index: 5;
    cursor: pointer;
}

.create-trip-btn {
    float: right;
    border-radius: 20px;
    background-color: gray;
    color: white;
}

.create-trip-btn:hover {
    background-color: black;
    color: white;
}

.card-img-top {
    filter: brightness(50%)
}

.full-trip-link {
    margin: 0 auto;
}
</style>
