const express = require('express');
const validate = require('../../middlewares/validate');
const launderValidation = require('../../validations/store.validation');
const launderController = require('../../controllers/launder.controller');
const stationController = require('../../controllers/stations.controller');
const paymentController = require('../../controllers/payment.controller');

const auth = require('../../middlewares/auth');
const { fileHandler } = require('../../middlewares/files');

const router = express.Router();

router
  .route('/createStore')
  .post(auth('manageStore'), fileHandler('store'), validate(launderValidation.createStore), launderController.createStore);
router.route('/fetchStore').get(auth('manageStore'), launderController.fetchStore);
router.route('/fetchStores').get(launderController.fetchAllStores);
router.route('/fetchStations/:storeId').get(auth(), validate(launderValidation.fetchStore), stationController.fetchStations);
// router.route('/test').post(validate(launderValidation.createStore), fileHandler('store'), launderController.createStore);

// order routes
router.route('/createOrder').post(auth(), validate(launderValidation.createOrder), launderController.createOrder);
router
  .route('/fetchOrders/:storeId')
  .get(auth('fetchOrders'), validate(launderValidation.fetchOrders), launderController.fetchOrders);

router.route('/changeState').post(auth('manageStore'), launderController.changeState);
router.route('/search').get(launderController.search);
router.route('/stk-push/simulate').post(paymentController.mpesaExpress);
router.route('/stk-push/callback').post(paymentController.transactionCallback);

module.exports = router;
