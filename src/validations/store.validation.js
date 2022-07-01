const Joi = require('joi');
const { objectId } = require('./custom.validation');

const createStore = {
  body: Joi.object().keys({
    name: Joi.string().required(),
    description: Joi.string().required().min(15),
    userId: Joi.string().required().custom(objectId),
    address: Joi.string().required(),
    pricing: Joi.array().required(),
    storeImg: Joi.string().required(),
    locations: Joi.array().required(),
  }),
};

const fetchStores = {
  params: Joi.object().keys({
    userId: Joi.string().custom(objectId),
  }),
};

module.exports = {
  createStore,
  fetchStores,
};
