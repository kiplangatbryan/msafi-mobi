const tokenTypes = {
  ACCESS: 'access',
  REFRESH: 'refresh',
  RESET_PASSWORD: 'resetPassword',
  VERIFY_EMAIL: 'verifyEmail',
};

const userStatus = {
  DISABLED: 'suspended',
  REGULER: 'regular',
  MERCHANT: 'merchant',
};

const genderOpt = {
  MALE: 'male',
  FEMALE: 'female',
};

const statusTypes = {
  PENDING: 'pending',
  PROCESSING: 'processing',
  COMPLETED: 'completed',
};

module.exports = {
  tokenTypes,
  genderOpt,
  statusTypes,
  userStatus,
};
