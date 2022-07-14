const httpStatus = require('http-status');
const catchAsync = require('../utils/catchAsync');
const { stationService, launderService } = require('../services');

const createStore = catchAsync(async (req, res) => {
  const { locations } = req.body;
  const launderStore = await launderService.create(req.user.id, req.body, req.files);
  await stationService.create(req.user.id, launderStore.id, locations);
  const response = 'sucess';
  res.status(httpStatus.CREATED).send(response);
});

const fetchStore = catchAsync(async (req, res) => {
  const stores = await launderService.fetchStore(req.userId);
  res.status(httpStatus.OK).send(stores);
});

const fetchAllStores = catchAsync(async (req, res) => {
  const stores = await launderService.fetchAllStores();
  res.status(httpStatus.OK).send(stores);
});

const createOrder = catchAsync(async (req, res) => {
  const { body } = req;
  const order = await launderService.createOrder(body, req.user.id);
  res.status(httpStatus.CREATED).send(order);
});

const fetchOrders = catchAsync(async (req, res) => {
  const { storeId } = req.params;
  const orders = await launderService.fetchOrders(storeId, req.user.id);
  res.status(httpStatus.OK).send(orders);
});

const search = catchAsync(async (req, res) => {
  const { storeId, q } = req.query;
  const results = await launderService.search(storeId, q);
  res.status(httpStatus.OK).send(results);
});

const changeState = catchAsync(async (req, res) => {
  const { storeId, orderId } = req.body;
  await launderService.changeState(req.user.id, storeId, orderId);
  res.status(httpStatus.OK).send();
});

module.exports = {
  createStore,
  fetchStore,
  fetchAllStores,
  createOrder,
  fetchOrders,
  search,
  changeState,
};
