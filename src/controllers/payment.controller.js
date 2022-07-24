const httpStatus = require('http-status');
const catchAsync = require('../utils/catchAsync');
const { paymentService } = require('../services');

const mpesaExpress = catchAsync(async (req, res) => {
  const response = await paymentService.mpesaExpress(req.body.phone);
  res.status(httpStatus.OK).send(response);
});

const transactionCallback = catchAsync(async (req, res) => {
  const response = await paymentService.callback(req.body);
  res.status(httpStatus.OK).send(response);
});

const mpesaQuery = catchAsync(async (req, res) => {
  const { CheckoutRequestID } = req.body;
  const response = await paymentService.query(CheckoutRequestID);
  if (response.ResultCode === 0) {
    return res.status(httpStatus.OK).send(response);
  }
  res.status(httpStatus.NO_CONTENT).send();
});

module.exports = {
  mpesaExpress,
  transactionCallback,
  mpesaQuery,
};
