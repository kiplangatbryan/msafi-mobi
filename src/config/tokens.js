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
  DROPPED: 'dropped',
  INITIAL: 'initial',
  COMPLETED: 'completed',
  PICKED: 'picked',
};

module.exports = {
  tokenTypes,
  genderOpt,
  statusTypes,
  userStatus,
};
