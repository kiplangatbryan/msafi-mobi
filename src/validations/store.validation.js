const Joi = require('joi');
const { objectId, arrayCheck, checkObject } = require('./custom.validation');

const createStore = {
  body: Joi.object().keys({
    name: Joi.string().required(),
    description: Joi.string().required().min(15),
    // userId: Joi.string().required().custom(objectId),
    phone: Joi.string().required(),
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

const createOrder = {
  body: Joi.object().keys({
    stationId: Joi.string().required().custom(objectId),
    storeId: Joi.string().required().custom(objectId),
    expectedPickUp: Joi.date().required(),
    phone: Joi.number().required(),
    paymentId: Joi.string().required().custom(objectId),
    amount: Joi.number().required(),
    clothes: Joi.array().items({
      id: Joi.string().required(),
      imagePath: Joi.string().required(),
      count: Joi.number().required(),
      price: Joi.number().required(),
    }),
  }),
};

const fetchOrders = {
  params: Joi.object().keys({
    storeId: Joi.string().required().custom(objectId),
  }),
};

module.exports = {
  createStore,
  fetchStore,
  createOrder,
  fetchOrders,
};
