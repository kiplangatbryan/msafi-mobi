/* eslint-disable radix */
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
  const phraseText = `${config.mpesaPay.consumerKeyUri}:${config.mpesaPay.consumerSecret}`;
  const phraseKey = Buffer.from(phraseText).toString('base64');

  try {
    const res = await axios.get(config.mpesaPay.accessTokenUri, {
      headers: {
        Authorization: `Basic ${phraseKey}`,
      },
    });

    return res.data.access_token;
  } catch (err) {
    throw new ApiError(httpStatus.INTERNAL_SERVER_ERROR, err.code);
  }
};

/**
 * Initiate Mpesa Stk push Request
 * @returns {Promise<Response>}
 */

const mpesaExpress = async (MSSID) => {
  const timestamp = moment().format('YYYYMMDDHHmmss');
  // console.log(process.env.shortcode);
  // eslint-disable-next-line new-cap
  const blobText = Buffer.from(config.mpesaPay.shortcode + config.mpesaPay.passkey + timestamp);
  const Password = blobText.toString('base64');

  const authToken = await getAccessToken();

  try {
    const res = await axios.post(
      config.mpesaPay.simulateMpesaUri,
      {
        BusinessShortCode: config.mpesaPay.shortcode,
        Password,
        Timestamp: timestamp,
        TransactionType: 'CustomerPayBillOnline',
        Amount: 1,
        PartyA: parseInt(MSSID, 10),
        PhoneNumber: parseInt(MSSID, 10),
        PartyB: config.mpesaPay.shortcode,
        // callBackURL: 'https://9360-41-89-160-19.eu.ngrok.io/v1/store/stk-push/callback',
        CallBackURL: 'https://wasafi.onrender.com/v1/store/stk-push/callback',
        AccountReference: 'CompanyX',
        TransactionDesc: 'Payment for Laundry Service',
      },
      {
        headers: {
          Authorization: `Bearer ${authToken}`,
        },
      }
    );
    return res.data;
  } catch (err) {
    throw new ApiError(httpStatus.INTERNAL_SERVER_ERROR, err.code);
  }
};

/**
 * Webhook that recieves Transaction status from Mpesa
 * @returns {Promise<Response>}
 */

const callback = (response) => {
  // eslint-disable-next-line no-console
  console.log(response);
  const message = {
    ResponseCode: '00000000',
    ResponseDesc: 'success',
  };

  return message;
};

module.exports = {
  mpesaExpress,
  callback,
};
