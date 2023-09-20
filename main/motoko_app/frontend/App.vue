<script setup>
  /*
   * Connect2ic provides essential utilities for IC app development
   */
  import { createClient } from "@connect2ic/core"
  import { defaultProviders } from "@connect2ic/core/providers"
  import { ConnectButton, ConnectDialog, Connect2ICProvider } from "@connect2ic/vue"
  import "@connect2ic/core/style.css"
  import {ref} from "vue";
  /*
   * Import canister definitions like this:
   */
  import * as defi from "../.dfx/local/canisters/defi"
  /*
   * Some examples to get you started
   */
  import HomePage from "./views/HomePage.vue"
  import TripPage from "./views/TripPage.vue"
  import BookingPage from "./views/Booking.vue";
  import Principal from "./components/Principal.vue"
  import SwapPage from "./views/SwapPage.vue";
  import MyBooking from "./views/MyBooking.vue"
  import Rating from "./views/Rating.vue"
  import Reservation from "./views/Reservation.vue"
  
  const client = createClient({
    canisters: {
      defi
    },
    providers: defaultProviders,
    globalProviderConfig: {
      dev: import.meta.env.DEV,
    },
  })
  
  
  var routing = ref("home")
  var trip_date = ref({})
  
  const getTrip = (trip) => {
    trip_date.value = trip
    routing.value = "trip"
  }
  
  </script>
  
  <template>
    <Connect2ICProvider :client="client">
      <div class="App">
        <div class="app-navbar">
          <ul class="navbar-navx">
            <li class="navx-item left-item">
                  <a class="navx-link" @click="routing = 'home'" href="#">
                      Home
                  </a>
              </li>
              <li class="middle-item">
                  <Principal @goReservation="routing = 'reservation'"/>
              </li>
              <li class="navx-item-button right-item">
                  <ConnectButton />
              </li>
              <li class="navx-item right-item">
                  <a class="navx-link" @click="routing('/')" href="#">
                      FAQ
                  </a>
              </li>
              <li class="navx-item right-item">
                  <a class="navx-link" @click="routing = 'bookingList'" href="#">
                      My Booking
                  </a>
              </li>
              <li class="navx-item right-item">
                  <a class="navx-link" @click="routing = 'booking'" href="#">
                      Booking
                  </a>
              </li>
              <li class="navx-item right-item">
                  <a class="navx-link" @click="routing = 'swap'" href="#">
                      Swap
                  </a>
              </li>
          </ul>
        </div>
        <ConnectDialog />
        <div class="app-header">
        </div>
        <div class="app-view">
          <HomePage @tripReady="getTrip" v-if="routing == 'home'"/>
          <TripPage :trip="trip_date" v-if="routing == 'trip'"/>
          <BookingPage v-if="routing == 'booking'" @ratingReady="routing = 'rating'"/>
          <SwapPage v-if="routing == 'swap'" />
          <MyBooking v-if="routing == 'bookingList'" />
          <Rating v-if="routing == 'rating'"/>
          <Reservation v-if="routing == 'reservation'" />
        </div>
        <div class="app-footer">
        </div>
      </div>
    </Connect2ICProvider>
  </template>
  
  <style>
  body {
    margin: 0;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen",
    "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue",
    sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    color: #424242;
  }
  
  
  ul {
    padding-left: 0rem;
    list-style-type: none;
    margin-top: 0;
  }
  
  /* NavBar css */
  .app-navbar {
    height: 60px;
    width: 100%;
    position: sticky;
    top: 0;
  
    z-index: 1000;
  }
  
  .app-view {
    z-index: 1;
  }
  
  .navbar-navx {
    height: 100%;
    width: 100%;
    background-color: white;
  
  }
  
  .navx-item {
    display: inline-block;
    height: 100%;
    padding: 1rem 1rem 1rem 1rem;
  }
  
  .left-item{
    float: left;
  }
  
  .middle-item{
    display: inline-block;
    margin-left: 35%;
    padding-top: 0.5rem;
  }
  .right-item{
    float: right;
  }
  
  .navx-item-button {
    display: inline-block;
    padding: 0.5rem 0.5rem 0.5rem 0.5rem;
  }
  
  .navx-item .navx-link {
    font-size: 1rem;
    font-weight: 600;
    line-height: 1.5;
    color: #525c68;
    text-decoration: none;
  }
  
  </style>
  