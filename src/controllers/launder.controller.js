const httpStatus = require('http-status');
const catchAsync = require('../utils/catchAsync');
const { stationService, launderService } = require('../services');

const createStore = catchAsync(async (req, res) => {
  const { locations } = req.body;
  const launderStore = await launderService.create(req.user.id, req.body, req.files);
  await stationService.create(req.user.id, launderStore.id, locations);
  res.status(httpStatus.CREATED).send();
});

const fetchStore = catchAsync(async (req, res) => {
  const stores = await launderService.fetchStore(req.userId);
  res.status(httpStatus.OK).send(stores);
});

const fetchAllStores = catchAsync(async (req, res) => {
  const stores = await launderService.fetchAllStores();
  res.status(httpStatus.OK).send(stores);
});

module.exports = {
  createStore,
  fetchStore,
  fetchAllStores,
};
