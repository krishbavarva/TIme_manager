<template>
  <div class="page-transition edit-profile-layout">
    <h2 class="edit-title">Edit Profile</h2>
    <form @submit.prevent="handleUpdateProfile" class="edit-form">
      <div class="form-group">
        <label for="firstName">First Name</label>
        <input type="text" id="firstName" v-model="form.first_name" required>
      </div>
      <div class="form-group">
        <label for="lastName">Last Name</label>
        <input type="text" id="lastName" v-model="form.last_name" required>
      </div>
      <div class="form-group">
        <label for="profileName">Username</label>
        <input type="text" id="profileName" v-model="form.profile_name" required>
      </div>
      <div class="button-group-edit">
        <button type="button" @click="$emit('cancel')" class="cancel-button">
          Cancel
        </button>
        <button type="submit" class="update-button">
          Update Profile
        </button>
      </div>
    </form>
    <div class="delete-account-section">
      <button @click="handleDeleteAccount" class="delete-account-button">
        Delete Account
      </button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'EditProfilePage',
  props: {
    user: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      form: {
        first_name: this.user.first_name,
        last_name: this.user.last_name,
        profile_name: this.user.profile_name
      }
    };
  },
  methods: {
    prompt(message, callback) {
        const result = window.prompt(message);
        callback(result);
    },
    handleUpdateProfile() {
      this.$emit('update-profile', this.form);
    },
    handleDeleteAccount() {
        this.prompt('To confirm deletion, type DELETE in the box below.', (input) => {
            if (input === 'DELETE') {
                this.$emit('delete-account');
            }
        });
    }
  }
};
</script>

<style scoped>
.page-transition {
  transition: opacity 0.5s ease-in-out;
}

.edit-profile-layout {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.edit-title {
  font-size: 2rem;
  font-weight: 800;
  color: #2dd4bf;
  margin-bottom: 2rem;
}

.edit-form {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 1rem;
  margin-bottom: 2rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  width: 100%;
}

.form-group label {
  font-size: 0.875rem;
  font-weight: 600;
  color: #d1d5db;
}

.form-group input {
  background-color: #374151;
  border: 1px solid #4b5563;
  color: #ffffff;
  padding: 0.75rem;
  border-radius: 0.5rem;
  font-size: 1rem;
  width: 100%;
}

.button-group-edit {
  display: flex;
  justify-content: space-between;
  gap: 1rem;
  margin-top: 1rem;
}

.cancel-button {
  background-color: #6b7280;
  color: #ffffff;
  font-weight: bold;
  padding: 0.75rem 1.5rem;
  border-radius: 0.75rem;
  transition: background-color 0.3s ease;
  flex: 1;
}

.cancel-button:hover {
  background-color: #4b5563;
}

.update-button {
  background-color: #10b981;
  color: #ffffff;
  font-weight: bold;
  padding: 0.75rem 1.5rem;
  border-radius: 0.75rem;
  transition: background-color 0.3s ease;
  flex: 1;
}

.update-button:hover {
  background-color: #059669;
}

.delete-account-section {
    width: 100%;
    text-align: center;
    border-top: 1px solid #4b5563;
    padding-top: 1.5rem;
}

.delete-account-button {
  background-color: #ef4444;
  color: #ffffff;
  font-weight: bold;
  padding: 0.75rem 1.5rem;
  border-radius: 0.75rem;
  transition: background-color 0.3s ease;
}

.delete-account-button:hover {
  background-color: #dc2626;
}
</style>
