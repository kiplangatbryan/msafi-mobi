const Joi = require('joi');
const { objectId, arrayCheck, checkObject } = require('./custom.validation');

const createStore = {
  body: Joi.object().keys({
    name: Joi.string().required(),
    description: Joi.string().required().min(15),
    // userId: Joi.string().required().custom(objectId),
    address: Joi.string().required(),
    pricing: Joi.custom(arrayCheck).required(),
    locations: Joi.custom(arrayCheck).required(),
    payment: Joi.custom(checkObject).required(),
  }),
};

const fetchStore = {
  params: Joi.object().keys({
    storeId: Joi.string().custom(objectId),
  }),
};

module.exports = {
  createStore,
  fetchStore,
};
