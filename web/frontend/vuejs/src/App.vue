<style scroped>
  #app {
    background-color: #21D4FD;
    background-image: linear-gradient(19deg, #21D4FD 0%, #B721FF 100%);
  }
  .app-bar {
    margin: 40px 5em 40px 5em;
  }
</style>

<template>
  <v-app>
    <div class="d-flex align-center app-bar">
        <v-img
          alt="Geol Recap Logo"
          class="shrink mr-2"
          contain
          src="./assets/logo.png"
          transition="scale-transition"
          width="100"
        />
        <div class="display-1 white--text">Geol Recap</div>
      </div>
  </v-app>
</template>

<script lang="ts">
import Vue from "vue";
import LoginBox from "./components/LoginBox.vue";

export default Vue.extend({
  name: "App",

  components: {},

  data: () => ({
    style: {
      padding: {
        top: '40px',
        left: '250px',
        right: '250px',
        bottom: '250px'
      }
    }
  })
});
</script>
