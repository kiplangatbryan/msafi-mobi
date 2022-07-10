const httpStatus = require('http-status');
const ApiError = require('../utils/ApiError');
const { Stores, User, Orders } = require('../models');

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

const create = async (userId, { name, description, address, pricing }, files) => {
  const user = await getUserById(userId);
  if (!user) {
    throw new ApiError(httpStatus.UNAUTHORIZED, 'User not found');
  }
  const storeImg = files.avatar.map((element) => element.destination + element.filename);
  const data = { name, description, address, pricing, storeImg, userId };
  return Stores.create(data);
};

/**
 * returns all the stores created by this user
 * @param {object} userId
 * @returns {Promise}
 */

const fetchStore = async (userId) => {
  const user = await getUserById(userId);
  if (!user) {
    throw new ApiError(httpStatus.UNAUTHORIZED, 'User not found');
  }
  return Stores.find({ userId });
};

/**
 * finds all the stores in the database and returns the array
 * @returns {Promise}
 */

const fetchAllStores = async () => {
  return Stores.find();
};

/**
 * adds a new store to the Store collection
 * @param {object} body
 * @param {object} userId
 * @returns {Promise}
 */

const createOrder = async ({ stationId, storeId, clothes, expectedPickUp }, userId) => {
  const user = await getUserById(userId);
  if (!user) {
    throw new ApiError(httpStatus.UNAUTHORIZED, 'User not found');
  }
  return Orders.create({ stationId, storeId, clothes, expectedPickUp, userId });
};

/**
 * finds all the orders linked to a specific store
 * @param {object} storeId
 * @param {object} userId
 * @returns {Promise}
 */

const fetchOrders = async (storeId, userId) => {
  const user = await getUserById(userId);
  if (!user) {
    throw new ApiError(httpStatus.UNAUTHORIZED, 'User not found');
  }
  return Orders.find({ storeId }).populate('userId').populate('stationId').exec();
};

const search = async (storeId, query) => {
  const response = await Orders.find({ storeId }).populate('userId').populate('stationId').exec();
  const result = response.filter((item) => {
    return item.id === query;
  });
  return result;
};

module.exports = {
  create,
  fetchStore,
  fetchAllStores,
  createOrder,
  fetchOrders,
  search,
};
