const httpStatus = require('http-status');
const ApiError = require('../utils/ApiError');
const { Stores, User, Orders } = require('../models');
const { tokenTypes } = require('../config/tokens');

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

const create = async (userId, { name, description, address, pricing, phone }, files) => {
  const user = await getUserById(userId);
  if (!user) {
    throw new ApiError(httpStatus.UNAUTHORIZED, 'User not found');
  }
  const storeImg = files.avatar.map((element) => element.destination + element.filename);
  const data = { name, description, address, pricing, phone, storeImg, userId };
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
  return Stores.find().populate('userId').exec();
};

/**
 * adds a new store to the Store collection
 * @param {object} body
 * @param {object} userId
 * @returns {Promise}
 */

const createOrder = async ({ stationId, storeId, clothes, expectedPickUp, amount, paymentId }, alias, userId) => {
  const user = await getUserById(userId);
  if (!user) {
    throw new ApiError(httpStatus.UNAUTHORIZED, 'User not found');
  }
  return Orders.create({ stationId, storeId, clothes, amount, alias, paymentId, expectedPickUp, userId });
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

const search = async (storeId) => {
  // const pipeline = [
  //   {
  //     $match: { _id: { $eq: storeId } },
  //   },
  // ];
  const response = await Orders.find({ storeId }).populate('userId').populate('stationId');

  return response;
};

const changeState = async (userId, storeId, orderId) => {
  const orders = await fetchOrders(storeId, userId);
  const result = orders.find((value) => {
    return value.id === orderId;
  });
  if (result === undefined) {
    throw new ApiError(httpStatus.INTERNAL_SERVER_ERROR, 'Order not found');
  }
  const statesArr = Object.values(tokenTypes);
  const pos = statesArr.findIndex((value) => {
    return value === result.status;
  });
  result.status = pos < statesArr.length ? statesArr[pos + 1] : statesArr.lenth - 1;
  let order = await Orders.findById(orderId);
  order = { ...result };
  return order.save();
};
const fetchUserOrders = async (userId) => {
  const user = await getUserById(userId);
  if (!user) {
    throw new ApiError(httpStatus.UNAUTHORIZED, 'User not found');
  }
  return Orders.find({ userId }).populate('storeId').populate('userId').populate('stationId').exec();
};
module.exports = {
  create,
  fetchStore,
  fetchAllStores,
  createOrder,
  fetchOrders,
  search,
  changeState,
  fetchUserOrders,
};
