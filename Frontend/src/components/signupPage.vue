<template>
  <div class="page-transition">
    <h2 class="title">Sign Up</h2>
    <form @submit.prevent="handleSignup">
      <div class="input-group">
        <label class="input-label" for="first_name">First Name</label>
        <input class="input-field" type="text" id="first_name" v-model="signupForm.first_name" required>
      </div>
      <div class="input-group">
        <label class="input-label" for="last_name">Last Name</label>
        <input class="input-field" type="text" id="last_name" v-model="signupForm.last_name" required>
      </div>
      <div class="input-group">
        <label class="input-label" for="profile_name">Profile Name</label>
        <input class="input-field" type="text" id="profile_name" v-model="signupForm.profile_name" required>
      </div>
      <div class="input-group">
        <label class="input-label" for="email">Email</label>
        <input class="input-field" type="email" id="email" v-model="signupForm.email" required>
      </div>
      <div class="input-group">
        <label class="input-label" for="password">Password</label>
        <input class="input-field" type="password" id="password" v-model="signupForm.password" required>
      </div>
      <div class="input-group">
        <label class="input-label" for="confirm_password">Confirm Password</label>
        <input class="input-field" type="password" id="confirm_password" v-model="signupForm.confirm_password" required>
        <p v-if="passwordMismatch" class="error-message">Passwords do not match.</p>
      </div>
      <button type="submit" class="submit-button">
        Sign Up
      </button>
      <p class="link-text">Already have an account? <a href="#" @click.prevent="$emit('switch-page', 'signin')" class="link-anchor">Sign In</a></p>
    </form>
  </div>
</template>

<script>
export default {
  name: 'SignupPage',
  data() {
    return {
      signupForm: {
        first_name: '',
        last_name: '',
        profile_name: '',
        email: '',
        password: '',
        confirm_password: ''
      }
    };
  },
  computed: {
    passwordMismatch() {
      return this.signupForm.password !== this.signupForm.confirm_password;
    },
  },
  methods: {
    handleSignup() {
      if (this.passwordMismatch) {
        return;
      }
      this.$emit('signup', this.signupForm);
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
