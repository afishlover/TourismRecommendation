<template>
    <div class="body">
        <ul class="navbar-navx-t">
            <li class="navx-t-item" :class="route_item == 'Route' ? 'route-selected-item' : ''">
                <a class="navx-t-link" href="#" @click="route_item = 'Route'">
                    <span class="link-name">Route</span>
                    <div class="sidebar-icon">
                        <span class="material-icons" v-if="route_item == 'Route'">keyboard_arrow_down</span>
                    </div>
                </a>
            </li>
            <li class="navx-t-item" :class="route_item == 'Day by day' ? 'route-selected-item' : ''">
                <a class="navx-t-link" href="#" @click="route_item = 'Day by day'">
                    <span class="link-name">Day by day</span>
                    <div class="sidebar-icon">
                        <span class="material-icons" v-if="route_item == 'Day by day'">keyboard_arrow_down</span>
                    </div>
                </a>
            </li>
            <li class="navx-t-item" :class="route_item == 'Where to stay' ? 'route-selected-item' : ''">
                <a class="navx-t-link" href="#" @click="route_item = 'Where to stay'">
                    <span class="link-name">Where to stay</span>
                    <div class="sidebar-icon">
                        <span class="material-icons" v-if="route_item == 'Where to stay'">keyboard_arrow_down</span>
                    </div>
                </a>
            </li>
            <li class="navx-t-item" :class="route_item == 'Checklist' ? 'route-selected-item' : ''">
                <a class="navx-t-link" href="#" @click="route_item = 'Checklist'">
                    <span class="link-name">Checklist</span>
                    <div class="sidebar-icon">
                        <span class="material-icons" v-if="route_item == 'Checklist'">keyboard_arrow_down</span>
                    </div>
                </a>
            </li>
        </ul>
        <div class="trip-section">
            <div class="t-right-section t-section">
                <div v-for="date in getDates(props.trip.listDays)" :key="date">
                <!-- <div v-for="date in getDates(props.listDays)" :key="date"> -->
                    <div class="tr-mon tr-item">{{ date.mon }}</div>
                    <div v-for="(day, idx) in date.days" :key="day">
                        <a :href="'#t-date-' + date.dates[idx]" class="tr-day tr-item">{{ day }}</a>
                    </div>
                </div>
            </div>
            <div class="t-middle-section t-section">
                <!-- <div v-for="(pois, idx) in props.trip.listDays" :key="idx + 'lday'"> -->
                <div v-for="(pois, idx) in props.trip.listDays" :key="idx + 'lday'">
                    <div class="t-day-item" :id="'t-date-' + pois.date">
                        {{ pois.date }}
                    </div>
                    <div v-for="poi in pois.listPOIs" :key="poi.number + 'lpoi'">
                        <div class="t-hope-item">
                            <div class="top-line"></div>
                            <span class="material-icons">local_taxi</span>
                            <div class="bottom-line"></div>
                        </div>
                        <div class="t-place-item">
                            <div class="tp-time">
                                <div class="tp-time-item">{{ convertHour(poi.startTime) }}</div>
                                <div class="tp-time-item">{{ convertHour(poi.endTime) }}</div>
                            </div>
                            <div class="tp-image">
                                <!-- <img src="https://s2982.pcdn.co/wp-content/uploads/2020/06/feel-good-road-trip-books-150x150.jpg.optimal.jpg" /> -->
                                <img width="180" height="150"
                                    src="https://st2.depositphotos.com/2931363/5383/i/600/depositphotos_53837931-stock-photo-people-enjoying-road-trip.jpg" />
                            </div>
                            <div class="tp-infor">
                                <div class="tp-i-destination">{{ poi.poi.name }}</div>
                                <div class="tp-i-rate"> Rating:{{ poi.poi.totalRating }}</div>
                                <div class="tp-i-price"> Price: {{ poi.poi.price }}</div>
                                <div class="tp-i-description">{{ poi.poi.description }}</div>
                            </div>
                        </div>
                    </div>
                    <div class="separate-line"></div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { useCanister, useWallet } from "@connect2ic/vue"
import { ref } from "vue";

const [defi] = useCanister("defi")
const [wallet] = useWallet()

const props = defineProps({
    trip: {
        type: Object,
        required: true
    }
})

console.log(props.trip)
var route_item = ref("Day by day")

const convertMon = (day) => {
    switch (day) {
        case "01":
            return "Jan"
            break;
        case "02":
            return "Feb"
            break;
        case "03":
            return "Mar"
            break;
        case "04":
            return "Apr"
            break;
        case "05":
            return "May"
            break;
        case "06":
            return "Jun"
            break;
        case "07":
            return "Jul"
            break;
        case "08":
            return "Aug"
            break;
        case "09":
            return "Sep"
            break;
        case "10":
            return "Oct"
            break;
        case "11":
            return "Nov"
            break;
        case "12":
            return "Dec"
            break;
        default:
            return ""
    }
}

const getDates = (data) => {
    var dates = []
    var c_t = { mon: "", days: [], dates: [] }
    for (const i in data) {
        var t = data[i].date
        var temp = t.split("-")
        if (c_t.mon == "") {
            c_t.mon = convertMon(temp[1])
            c_t.days.push(temp[2])
            c_t.dates.push(t)
        } else {
            if (c_t.mon == convertMon(temp[1])) {
                c_t.days.push(temp[2])
                c_t.dates.push(t)
            } else {
                dates.push(JSON.parse(JSON.stringify(c_t)))
                c_t.mon = convertMon(temp[1])
                c_t.days = [temp[2]]
                c_t.dates = [t]
            }
        }
    }
    dates.push(JSON.parse(JSON.stringify(c_t)))
    return dates;
}

const convertHour = (data) => {
    let x = data
    let hour = Math.floor(x / 3600)
    let second = Math.ceil((x % 3600) / 60)
    let secondString = ''
    let hourString = ''
    if (hour < 10) {
        hourString = '0' + hour.toString()
    } else {
        hourString = hour.toString()
    }
    if (second === 0) {
        secondString = '00'
    } else if (second <= 10) {
        secondString = '0' + second.toString()
    } else {
        secondString = second.toString()
    }
    let hourConvert = hourString + ":" + secondString
    return hourConvert
}

</script>

<style>
html {
    scroll-behavior: smooth;
}

.body {
    height: 100%;
    width: 100%;
    margin-top: 60px;
}

ul {
    padding-left: 0rem;
    list-style-type: none;
    margin-top: 0;
}

.navbar-navx-t {
    position: fixed;
    top: 60px;
    width: 100%;
    text-align: center;
    box-shadow: rgba(0, 0, 0, 0.1) 0px 4px 12px;
    ;
    background-color: white;
}

.navx-t-item {
    display: inline-block;
    height: 43px;
    margin: auto;
    padding-left: 0.8rem;
    margin-top: 0.2rem;
}

.navx-t-item:hover {
    background-color: #e5e6e7;
}

.navx-t-item .navx-t-link {
    height: 100%;
    width: 100%;
    color: rgb(91, 91, 91);
    display: flex;
    align-items: center;
    text-decoration: none;
    white-space: nowrap;
    text-overflow: clip;
    overflow: hidden;
}

.navx-t-item .navx-t-link .sidebar-icon {
    margin-left: 0.05rem;
    margin-right: 0.2rem;
    margin-top: 0.6rem;
    text-align: center;
    width: 1.6rem;
}

.route-selected-item {
    border-bottom: 2px solid black;
}

.route-selected-item .navx-t-link {
    color: black;
}

/* trip section */
.trip-section {
    margin-top: 60px;
    width: 100%;
}

.t-right-section {
    width: 80px;
    left: calc(50% - 430px);
    overflow-y: auto;
    position: fixed;
}

.t-right-section .tr-item {
    color: #0E0E0F;
    font-weight: 500;
    text-align: center;
    padding: 12px 0;
    display: block;
    text-decoration: none;
}

.t-right-section .tr-day {
    cursor: pointer;
}

.t-right-section .tr-day:hover {
    text-decoration: underline solid rgb(139, 74, 237) 2px;
    background-color: #3fd373;
}

.t-middle-section {
    padding-top: 30px;
    width: 700px;
    margin: auto;
}

.t-day-item {
    height: 36px;
    line-height: 36px;
    text-align: center;
    display: inline-block;
    padding: 0 25px;
    background: #f0F1F1;
    border-radius: 20px;
    font-weight: 700;
    background-color: #f0f1f1;
}

.t-place-item {
    width: 600px;
    height: 180px;
    box-shadow: 0 2px 9px rgba(0, 0, 0, .15);
    border-radius: 16px;
    display: flex;
}

.tp-time {
    padding: 15px;
    font-family: Arial, Helvetica, sans-serif;
}

.tp-time-item {
    padding-top: 20px;
}

.tp-i-destination {
    font-size: 20px;
    font-weight: bold;
    text-align: center;
    padding: 15px;
}

.tp-i-rate {
    padding-left: 15px;
}

.tp-i-price {
    padding-left: 15px;
}

.tp-image {
    padding-top: 15px;
}

.t-hope-item {
    padding-left: 34px;
}

.bottom-line {
    bottom: 0;
    width: 0;
    height: 30px;
    border-right: 2px solid #f0F1F1 !important;
    margin-inline-start: 11px;
}

.top-line {
    top: 0;
    width: 0;
    height: 30px;
    border-right: 2px solid #f0F1F1 !important;
    margin-inline-start: 11px;
}

.separate-line {
    top: 0;
    width: 0;
    height: 30px;
    border-right: 2px solid #f0F1F1 !important;
    margin-inline-start: 45px;
}
</style>
