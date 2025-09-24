<template>
  <div class="app-container">
    <div class="main-card">
      <!-- Loading Overlay -->
      <div v-if="isLoading" class="loader-overlay">
        <div class="loader-spinner"></div>
      </div>

      <LoginPage v-if="currentPage === 'signin'" @signin="handleSignin" @switch-page="currentPage = $event" :login-error="loginError" />
      <SignupPage v-if="currentPage === 'signup'" @signup="handleSignup" @switch-page="currentPage = $event" />
      
      <EditProfilePage 
        v-if="currentPage === 'editProfile'" 
        :user="loggedInUser"
        @update-profile="handleUpdateProfile"
        @delete-account="handleDeleteAccount"
        @cancel="currentPage = 'homepage'"
      />

      <!-- User Homepage -->
      <div v-if="currentPage === 'homepage'" class="page-transition homepage-layout">
        <div class="homepage-header">
          <div class="profile-name-container">
            <h2 class="user-name">
              {{ loggedInUser.first_name }} {{ loggedInUser.last_name }}
            </h2>
            <span class="profile-name">{{ loggedInUser.profile_name }}</span>
          </div>
          <div class="button-group">
            <button @click="handleEditProfile" class="edit-button">
              Edit Profile
            </button>
            <button @click="handleLogout" class="logout-button">
              Log Out
            </button>
          </div>
        </div>
        
        <div class="main-content-area">
          <!-- Left Column -->
          <div class="left-column">
            <div class="profile-image-container">
              <img src="https://placehold.co/96x96/6ee7b7/111827?text=U" alt="Profile Picture" class="profile-image">
            </div>
            
            <div class="date-display">{{ currentDateDisplay }}</div>
            
            <div class="timer-section">
              <p v-if="isCheckedIn" class="timer-label">Time tracked today:</p>
              <p v-else class="timer-label">Total time tracked today:</p>
              <div class="timer-display">{{ formattedTime }}</div>
            </div>

            <button @click="toggleCheckIn" :class="isCheckedIn ? 'checkout-button' : 'checkin-button'">
              {{ checkInButtonText }}
            </button>
          </div>
          
          <!-- Right Column -->
          <div class="right-column">
            <div class="sessions-list-container">
                <p class="sessions-title">Today's Sessions:</p>
                <div v-if="workSessions.length > 0" class="sessions-table">
                  <div class="table-header">
                    <span>Start Time</span>
                    <span>End Time</span>
                    <span>Duration</span>
                  </div>
                    <div v-for="(session, index) in workSessions" :key="index" class="session-entry">
                        <span>{{ session.checkInTime }}</span>
                        <span>{{ session.checkOutTime }}</span>
                        <span>{{ session.duration }}</span>
                    </div>
                </div>
                <span v-else class="no-sessions">No sessions recorded today.</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import LoginPage from './loginPage.vue';
import SignupPage from './signupPage.vue';
import EditProfilePage from './editProfilePage.vue';

export default {
  name: 'userManagementApp',
  components: {
    LoginPage,
    SignupPage,
    EditProfilePage
  },
  data() {
    return {
      currentPage: 'signin',
      users: [
        {
          first_name: 'Test',
          last_name: 'User',
          profile_name: 'Tester',
          email: 'user@example.com',
          password: 'password123'
        }
      ],
      loggedInUser: null,
      loginError: '',
      isLoading: false,
      
      // Timer state
      isCheckedIn: false,
      checkInTime: null,
      checkOutTime: null,
      workSessions: [],
      elapsedTime: 0,
      intervalId: null,
      lastDate: null,
    };
  },
  computed: {
    checkInButtonText() {
      return this.isCheckedIn ? 'Check Out' : 'Check In';
    },
    currentDateDisplay() {
        return new Date().toLocaleDateString('en-US', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });
    },
    formattedTime() {
      const totalSeconds = this.elapsedTime;
      const hours = Math.floor(totalSeconds / 3600);
      const minutes = Math.floor((totalSeconds % 3600) / 60);
      const seconds = totalSeconds % 60;

      const pad = (num) => String(num).padStart(2, '0');
      return `${pad(hours)}:${pad(minutes)}:${pad(seconds)}`;
    },
  },
  methods: {
    handleSignup(newUser) {
      this.users.push(newUser);
      this.currentPage = 'signin';
    },
    handleSignin(signinForm) {
      const user = this.users.find(u => u.email === signinForm.email && u.password === signinForm.password);
      if (user) {
        this.isLoading = true;
        this.loginError = '';
        setTimeout(() => {
          this.loggedInUser = user;
          this.currentPage = 'homepage';
          this.resetDailyTimer();
          this.isLoading = false;
        }, 2000);
      } else {
        this.loginError = 'Invalid email or password.';
      }
    },
    handleLogout() {
      this.loggedInUser = null;
      this.currentPage = 'signin';
      this.isCheckedIn = false;
      this.checkInTime = null;
      this.checkOutTime = null;
      this.elapsedTime = 0;
      clearInterval(this.intervalId);
    },
    toggleCheckIn() {
      if (!this.isCheckedIn) {
        // Check for new day and reset if needed
        const today = new Date().toLocaleDateString();
        if (this.lastDate !== today) {
            this.resetDailyTimer();
        }
        this.lastDate = today;

        // Checking in
        this.checkInTime = Date.now();
        this.isCheckedIn = true;
        this.intervalId = setInterval(() => {
          this.elapsedTime++;
        }, 1000);
      } else {
        // Checking out
        this.checkOutTime = Date.now();
        const durationMs = this.checkOutTime - this.checkInTime;
        const minutes = Math.floor(durationMs / 60000);
        const seconds = Math.floor((durationMs % 60000) / 1000);

        this.workSessions.push({
            checkInTime: new Date(this.checkInTime).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
            checkOutTime: new Date(this.checkOutTime).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
            duration: `${minutes}m ${seconds}s`
        });
        this.isCheckedIn = false;
        clearInterval(this.intervalId);
      }
    },
    resetDailyTimer() {
        this.elapsedTime = 0;
        this.workSessions = [];
        this.lastDate = new Date().toLocaleDateString();
    },
    handleEditProfile() {
        if (this.loggedInUser) {
            this.currentPage = 'editProfile';
        }
    },
    handleUpdateProfile(updatedUser) {
        const userIndex = this.users.findIndex(u => u.email === this.loggedInUser.email);
        if (userIndex !== -1) {
            this.users[userIndex] = { ...this.users[userIndex], ...updatedUser };
            this.loggedInUser = { ...this.loggedInUser, ...updatedUser };
            this.currentPage = 'homepage';
        }
    },
    handleDeleteAccount() {
        const userIndex = this.users.findIndex(u => u.email === this.loggedInUser.email);
        if (userIndex !== -1) {
            this.users.splice(userIndex, 1);
            this.handleLogout(); // Log out and reset state
        }
    }
  },
  mounted() {
      // Check if the date has changed since the last visit
      const today = new Date().toLocaleDateString();
      if (this.lastDate && this.lastDate !== today) {
          this.resetDailyTimer();
      }
  }
};
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap');

.app-container {
  background-color: #111827;
  color: #ffffff;
  min-height: 100vh;
  display: flex;
  justify-content: center;
  padding: 1rem;
  font-family: 'Inter', sans-serif;
}

.main-card {
  background-color: rgba(31, 41, 55, 0.7);
  border-radius: 1rem;
  padding: 2rem;
  width: 100%;
  backdrop-filter: blur(8px);
  border: 1px solid #374151;
  position: relative;
  max-width: 1200px;
}

.page-transition {
  transition: opacity 0.5s ease-in-out;
}

.homepage-layout {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.homepage-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
  margin-bottom: 2rem;
}

.profile-name-container {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.user-name {
  font-size: 1.5rem;
  font-weight: 800;
  color: #2dd4bf;
  margin: 0;
}

.profile-name {
  font-size: 1rem;
  font-weight: 600;
  color: #d1d5db;
}

.button-group {
    display: flex;
    gap: 0.5rem;
}

.edit-button,
.logout-button {
  background-color: #ef4444;
  color: #ffffff;
  font-weight: bold;
  padding: 0.5rem 1rem;
  border-radius: 0.75rem;
  transition: background-color 0.3s ease;
}

.edit-button {
  background-color: #3b82f6;
}
.edit-button:hover {
  background-color: #2563eb;
}

.logout-button:hover {
  background-color: #dc2626;
}

.main-content-area {
  display: flex;
  justify-content: space-between;
  gap: 2rem;
  flex-wrap: wrap;
}

.left-column,
.right-column {
  flex: 1;
  min-width: 250px;
}

.left-column {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.profile-image-container {
  position: relative;
  width: 6rem;
  height: 6rem;
  margin-bottom: 1rem;
}

.profile-image {
  border-radius: 9999px;
  width: 100%;
  height: 100%;
  object-fit: cover;
  border: 4px solid #2dd4bf;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
}

.date-display {
    font-size: 1.125rem;
    color: #9ca3af;
    margin-bottom: 1rem;
    font-weight: 600;
}

.timer-section {
  width: 100%;
  text-align: left;
}

.timer-label {
  color: #9ca3af;
  font-size: 0.875rem;
}

.timer-display {
  font-size: 3rem;
  font-weight: 800;
  color: #ffffff;
  margin-top: 0.5rem;
  margin-bottom: 1.5rem;
}

.sessions-list-container {
  width: 100%;
}

.sessions-title {
    font-size: 1rem;
    font-weight: 600;
    color: #d1d5db;
    margin-bottom: 0.5rem;
    text-align: left;
}

.sessions-table {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  width: 100%;
}

.table-header {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  font-size: 0.875rem;
  color: #9ca3af;
  font-weight: 600;
  padding: 0 1rem;
}

.session-entry {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  width: 100%;
  padding: 0.5rem 1rem;
  border-radius: 0.5rem;
  background-color: #374151;
  border: 1px solid #4b5563;
  font-size: 0.875rem;
}

.no-sessions {
    color: #9ca3af;
    font-size: 0.875rem;
    text-align: left;
}

.checkin-button {
  width: 100%;
  background-color: #10b981;
  color: #ffffff;
  font-weight: bold;
  padding: 1rem;
  border-radius: 0.75rem;
  transition: background-color 0.3s ease;
}

.checkin-button:hover {
  background-color: #059669;
}

.checkout-button {
  width: 100%;
  background-color: #ef4444;
  color: #ffffff;
  font-weight: bold;
  padding: 1rem;
  border-radius: 0.75rem;
  transition: background-color 0.3s ease;
}

.checkout-button:hover {
  background-color: #dc2626;
}

.loader-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(17, 24, 39, 0.9);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 10;
}

.loader-spinner {
  width: 48px;
  height: 48px;
  border: 5px solid #fff;
  border-bottom-color: #2dd4bf;
  border-radius: 50%;
  display: inline-block;
  box-sizing: border-box;
  animation: rotation 1s linear infinite;
}

@keyframes rotation {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}
</style>
