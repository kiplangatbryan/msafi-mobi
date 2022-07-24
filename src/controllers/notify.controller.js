const httpStatus = require('http-status');
const catchAsync = require('../utils/catchAsync');
const { notifyService } = require('../services');

const fetch = catchAsync(async (req, res) => {
  const notifications = await notifyService.fetch(req.user.id);
  return res.status(httpStatus.OK).send(notifications);
});

module.exports = {
  fetch,
};
