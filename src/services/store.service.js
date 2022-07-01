const httpStatus = require('http-status');
const ApiError = require('../utils/ApiError');
const { Stores, User } = require('../models');

/**
 * Get user by id
 * @param {ObjectId} id
 * @returns {Promise<User>}
 */
const getUserById = async (id) => {
  return User.findById(id);
};

/**
 * req body
 * @param {object} userId
 * @param {object} body
 * @returns {Promise}
 */

const create = async (userId, { name, description, address, pricing, storeImg }) => {
  const user = await getUserById(userId);
  if (!user) {
    throw new ApiError(httpStatus.UNAUTHORIZED, 'User not found');
  }
  const data = { name, description, address, pricing, storeImg, userId };
  return Stores.create(data);
};

const fetchStores = async (userId) => {
  const user = await getUserById(userId);
  if (!user) {
    throw new ApiError(httpStatus.UNAUTHORIZED, 'User not found');
  }
  return Stores.find({ userId });
};

module.exports = {
  create,
  fetchStores,
};
