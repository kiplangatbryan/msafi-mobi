/* eslint-disable radix */
const axios = require('axios');
const httpStatus = require('http-status');
const moment = require('moment');
const Meta = require('../models/meta.model');
const Payments = require('../models/payments.model');
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
        CallBackURL: config.mpesaPay.uri_callback,
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

const callback = async (response) => {
  const body = response.Body;
  if (body.stkCallback.ResultCode === 0) {
    // eslint-disable-next-line no-console
    // save my payment
    const { CallbackMetadata } = body.stkCallback;
    const res = await Payments.create({
      ...body.stkCallback,
      Amount: CallbackMetadata.Item[0].Value,
      MpesaReceiptNumber: CallbackMetadata.Item[1].Value,
      PhoneNumber: CallbackMetadata.Item[2].Value,
      TransactionDate: CallbackMetadata.Item[3].Value,
    });

    await Meta.create({
      confirmed: true,
      paymentId: res.id,
      info: body.stkCallback,
    });
  } else {
    await Meta.create({
      confirmed: false,
      info: body.stkCallback,
    });
  }

  const message = {
    ResponseCode: '00000000',
    ResponseDesc: 'success',
  };

  return message;
};

const query = async (CheckoutRequestID) => {
  const result = await Meta.find({ 'info.CheckoutRequestID': CheckoutRequestID });

  let response = null;
  if (result.length > 0) {
    const paySlip = result[0];
    if (paySlip.confirmed && paySlip.paymentId) {
      response = {
        ResultCode: 0,
        ...paySlip,
      };
    } else {
      response = {
        ResultCode: 1,
        ...paySlip,
      };
    }
    await Meta.findByIdAndDelete(paySlip._id);

    return response;
  }
  return {};
};

module.exports = {
  mpesaExpress,
  callback,
  query,
};
