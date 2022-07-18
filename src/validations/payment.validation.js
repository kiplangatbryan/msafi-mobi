const Joi = require('joi');
const { phoneNumber } = require('./custom.validation');

const simulateStk = {
  body: Joi.object().keys({
    phone: Joi.string().required().custom(phoneNumber),
    amount: Joi.number().required(),
  }),
};

const mpesaQuery = {
  body: Joi.object().keys({
    CheckoutRequestID: Joi.string().required(),
  }),
};

module.exports = {
  simulateStk,
  mpesaQuery,
};
