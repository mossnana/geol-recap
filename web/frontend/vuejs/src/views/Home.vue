<template>
  <div class="home">
    <img alt="Vue logo" src="../assets/logo.png" />
    <LoginBox msg="Welcome to Your Vue.js App" />
  </div>
</template>

<script>
import LoginBox from "@/components/LoginBox.vue";

export default {
  name: "Home",
  components: {
    LoginBox
  }
};
</script>
