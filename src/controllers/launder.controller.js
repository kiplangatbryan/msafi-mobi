const httpStatus = require('http-status');
const catchAsync = require('../utils/catchAsync');
const { stationService, launderService } = require('../services');

const createStore = catchAsync(async (req, res) => {
  const { locations } = req.body;
  const launderStore = await launderService.create(req.user.id, req.body);
  await stationService.create(req.user.id, launderStore.id, locations);
  res.status(httpStatus.CREATED).send();
});

const fetchStores = catchAsync(async (req, res) => {
  const stores = await launderService.fetchStores(req.user.id);
  res.status(httpStatus.OK).send(stores);
});

module.exports = {
  createStore,
  fetchStores,
};
