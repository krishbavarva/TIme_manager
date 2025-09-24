<template>
  <div class="page-transition">
    <h2 class="title">Sign In</h2>
    <form @submit.prevent="handleSignin">
      <div class="input-group">
        <label class="input-label" for="signin_email">Email</label>
        <input class="input-field" type="email" id="signin_email" v-model="signinForm.email" required>
      </div>
      <div class="input-group">
        <label class="input-label" for="signin_password">Password</label>
        <input class="input-field" type="password" id="signin_password" v-model="signinForm.password" required>
        <p v-if="loginError" class="error-message">{{ loginError }}</p>
      </div>
      <button type="submit" class="submit-button">
        Sign In
      </button>
      <p class="link-text">Don't have an account? <a href="#" @click.prevent="$emit('switch-page', 'signup')" class="link-anchor">Sign Up</a></p>
    </form>
  </div>
</template>

<script>
export default {
  name: 'LoginPage',
  props: {
    loginError: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      signinForm: {
        email: 'user@example.com',
        password: 'password123'
      }
    };
  },
  methods: {
    handleSignin() {
      this.$emit('signin', this.signinForm);
    }
  }
};
</script>

<style scoped>
.page-transition {
  transition: opacity 0.5s ease-in-out;
}
.title {
  font-size: 1.875rem;
  font-weight: bold;
  margin-bottom: 1.5rem;
  text-align: center;
  color: #2dd4bf;
}
.input-group {
  margin-bottom: 1rem;
}
.input-label {
  display: block;
  color: #d1d5db;
  font-size: 0.875rem;
  font-weight: 600;
  margin-bottom: 0.5rem;
}
.input-field {
  width: 100%;
  padding: 0.5rem 1rem;
  border-radius: 0.5rem;
  background-color: #374151;
  color: #ffffff;
  border: 1px solid #4b5563;
  transition: all 0.3s ease;
}
.input-field:focus {
  border-color: #2dd4bf;
  outline: none;
}
.error-message {
  color: #f87171;
  font-size: 0.75rem;
  margin-top: 0.5rem;
}
.submit-button {
  width: 100%;
  background-color: #10b981;
  color: #ffffff;
  font-weight: bold;
  padding: 0.75rem 1rem;
  border-radius: 0.75rem;
  transition: background-color 0.3s ease;
}
.submit-button:hover {
  background-color: #059669;
}
.link-text {
  margin-top: 1rem;
  text-align: center;
  color: #9ca3af;
}
.link-anchor {
  color: #2dd4bf;
  text-decoration: none;
}
.link-anchor:hover {
  text-decoration: underline;
}
</style>
