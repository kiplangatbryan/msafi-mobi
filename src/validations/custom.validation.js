const objectId = (value, helpers) => {
  if (!value.match(/^[0-9a-fA-F]{24}$/)) {
    return helpers.message('"{{#label}}" must be a valid mongo id');
  }
  return value;
};

const password = (value, helpers) => {
  if (value.length < 8) {
    return helpers.message('password must be at least 8 characters');
  }
  if (!value.match(/\d/) || !value.match(/[a-zA-Z]/)) {
    return helpers.message('password must contain at least 1 letter and 1 number');
  }
  return value;
};

const arrayCheck = (value, helpers) => {
  const arr = JSON.parse(value);
  if (!Array.isArray(arr)) {
    return helpers.message('{{#label}} must be an array');
  }
  return arr;
};

const checkObject = (value, helpers) => {
  const obj = JSON.parse(value);
  if (!(obj && typeof obj === 'object' && obj.constructor === Object)) {
    return helpers.message('{{#label}} must be an object');
  }
  return obj;
};
const phoneNumber = (value, helpers) => {
  const pattern = /^254[0-9]+/;
  if (!pattern.test(value)) {
    return helpers.message('{{#label}} is invalid must be 254 * pattern');
  }
  return value;
};

module.exports = {
  objectId,
  password,
  arrayCheck,
  checkObject,
  phoneNumber,
};
