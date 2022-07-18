// eslint-disable-next-line import/extensions
const api = require('../../node_modules/clicksend/api.js');
const { clicksend } = require('../config/config');
const logger = require('../config/logger');

const mainApi = new api.SMSApi(clicksend.user, clicksend.apiKey);
/**
 * Send confirmation message
 * @param {Object} clicksendCollection
 * @returns {Promise}
 */
const sendSms = async (smsCollection) => {
  const response = await mainApi.smsSendPost(smsCollection);
  if (response.body.response_code === 'SUCCESS') {
    if (response.body.data.total_price > 0) {
      return 0;
    }
    return 1;
  }
};

/**
 * Create message and send message
 * @param {string} to
 * @param {string} code
 * @param {string} amount
 * @param {string} username
 * @returns {Promise}
 */

const createAndSendNotification = async (to, code, amount, username) => {
  try {
    const smsCollection = new api.SmsMessageCollection();
    const smsMessage = new api.SmsMessage();
    const message = ` Payment of ${amount} received. batch code is ${code}. Thank you ${username}`;

    smsMessage.from = '+254718287786';
    smsMessage.to = to;
    smsMessage.body = message;

    smsCollection.messages = [smsMessage];

    await sendSms(smsCollection);
  } catch (err) {
    logger.error('There was a problem sending sms notification');
  }
};

module.exports = {
  sendSms,
  createAndSendNotification,
};
