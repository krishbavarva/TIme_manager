<template>
  <div id="app">
    <!-- The userManagementApp component will handle all the application's pages and logic -->
    <userManagementApp />
  </div>
</template>

<script>
import userManagementApp from './components/userManagementApp.vue';

export default {
  name: 'App',
  components: {
    userManagementApp,
  }
};
</script>

<style>
/* You can add global styles here if needed */
body {
  margin: 0;
  padding: 0;
  background-color: #111827;
  font-family: 'Inter', sans-serif;
}
</style>
