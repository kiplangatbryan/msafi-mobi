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

module.exports = {
  mpesaExpress,
  transactionCallback,
};
