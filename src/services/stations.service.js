const httpStatus = require('http-status');

const ApiError = require('../utils/ApiError');
const { Stations, User, Stores } = require('../models');
/**
 * Get user by id
 * @param {ObjectId} id
 * @returns {Promise<User>}
 */
const getUserById = async (id) => {
  return User.findById(id);
};

/**
 * Get store by id
 * @param {ObjectId} id
 * @returns {Promise<User>}
 */
const getStoreById = async (id) => {
  return Stores.findById(id);
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
  return Stations.create(data);
};

const fetchStations = async (storeId) => {
  const spot = await getStoreById(storeId);
  if (!spot) {
    throw new ApiError(httpStatus.NO_CONTENT, 'Pick Up Station Association not Found!');
  }
  return Stations.find({ storeId });
};

module.exports = {
  create,
  fetchStations,
};
