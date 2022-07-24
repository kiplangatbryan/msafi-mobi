// eslint-disable-next-line import/extensions
const httpStatus = require('http-status');

const ApiError = require('../utils/ApiError');
const Notify = require('../models/notification.model');

/**
 * create a notification
 * @param {string} notificationObject
 * @param {string} senderId
 * @param {string} receiverId
 * @returns {Promise}
 */

const create = async ({ title, body }, senderId, receiverId) => {
  try {
    await Notify.create({ title, body, senderId, receiverId });
  } catch (err) {
    throw new ApiError(httpStatus.NOT_FOUND, err.message);
  }
};
/**
 * Fetch all notifications
 * @returns {Promise}
 */
const fetch = async (receiverId) => {
  return Notify.find({ receiverId });
};

module.exports = {
  create,
  fetch,
};
