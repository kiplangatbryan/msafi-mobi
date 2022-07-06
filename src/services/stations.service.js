const httpStatus = require('http-status');
const ApiError = require('../utils/ApiError');
const { Stations, User } = require('../models');

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
 * @param {ObjectId} userId
 * @param {ObjectId} launderId
 * @param {Array} body
 * @returns {Promise}
 */

const create = async (userId, storeId, locations) => {
  const user = await getUserById(userId);
  if (!user) {
    throw new ApiError(httpStatus.UNAUTHORIZED, 'User not found');
  }
  const data = locations.map((pickUp) => {
    return { ...pickUp, storeId };
  });
  // eslint-disable-next-line no-console
  console.log(data);
  return Stations.create(data);
};

module.exports = {
  create,
};
