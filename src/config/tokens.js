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
  INITIAL: 'Initial',
  RECEIVED: 'Received',
  PENDING: 'Pending',
  COMPLETED: 'Completed',
  PICKED: 'Picked',
};

module.exports = {
  tokenTypes,
  genderOpt,
  statusTypes,
  userStatus,
};
