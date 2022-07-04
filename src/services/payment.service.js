const axios = require('axios');
const httpStatus = require('http-status');
const moment = require('moment');
const ApiError = require('../utils/ApiError');
const config = require('../config/config');

/**
 * Fetch access token
 * @returns {Promise}
 */

const getAccessToken = async () => {
  const phraseText = `${config.mpesaPay.accessTokenUri}:${config.mpesaPay.consumerKeyUri}`;
  const phraseKey = Buffer.from(phraseText).toString('base64');

  try {
    const res = await axios.get(config.mpesaPay.accessTokenUri, {
      headers: {
        Authorization: `Basic ${phraseKey}`,
      },
    });

    return res.data.access_token;
  } catch (err) {
    throw ApiError(httpStatus.SERVICE_UNAVAILABLE, err.response.data);
  }
};

/**
 * Initiate Mpesa Stk push Request
 * @returns {Promise<Response>}
 */

const mpesaExpress = async (account, targetTill, businessName) => {
  const timestamp = moment().format('YYYYMMDDHHmmss');
  // console.log(process.env.shortcode);
  // eslint-disable-next-line new-cap
  const blobText = Buffer.from(config.mpesaPay.passkey + config.mpesaPay.passkey + timestamp);
  const Password = blobText.toString('base64');

  const authToken = await getAccessToken();

  try {
    const res = await axios.post(
      process.env.ONLINE_PROCESS_URL,
      {
        BusinessShortCode: process.env.shortcode,
        Password,
        Timestamp: timestamp,
        TransactionType: 'CustomerPayBillOnline',
        Amount: 1,
        PartyA: account,
        PhoneNumber: account,
        PartyB: targetTill,
        // PartyB: 174379,
        CallBackURL: 'https://wasafi.onrender.com/v1/store/stk-push/callback',
        AccountReference: businessName,
        TransactionDesc: 'service payment',
      },
      {
        headers: {
          Authorization: `Bearer ${authToken}`,
        },
      }
    );
    return res.data;
  } catch (err) {
    throw ApiError(httpStatus.SERVICE_UNAVAILABLE, err.response.data);
  }
};

/**
 * Webhook that recieves Transaction status from Mpesa
 * @returns {Promise<Response>}
 */

const callback = (req, res) => {
  // console.log('-----------Received M-Pesa webhook-----------');

  // console.log(req.body);
  // console.log('-----------------------');

  const message = {
    ResponseCode: '00000000',
    ResponseDesc: 'success',
  };

  res.status(200).json(message);
};

module.exports = {
  mpesaExpress,
  getAccessToken,
  callback,
};
