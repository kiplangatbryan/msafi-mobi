const express = require('express');
const validate = require('../../middlewares/validate');
const launderValidation = require('../../validations/store.validation');
const launderController = require('../../controllers/launder.controller');
const stationController = require('../../controllers/stations.controller');
const paymentController = require('../../controllers/payment.controller');
const notificationController = require('../../controllers/notify.controller');
const paymentValidation = require('../../validations/payment.validation');

const auth = require('../../middlewares/auth');
const { fileHandler } = require('../../middlewares/files');

const router = express.Router();

//

router.route('/createStore').post(
  auth('fetchOrders'),
  fileHandler('store'),
  validate(launderValidation.createStore),

  launderController.createStore
);
router.route('/fetchStore').get(auth('manageStore'), launderController.fetchStore);
router.route('/fetchStores').get(launderController.fetchAllStores);
router.route('/fetchStations/:storeId').get(auth(), validate(launderValidation.fetchStore), stationController.fetchStations);
// router.route('/test').post(validate(launderValidation.createStore), fileHandler('store'), launderController.createStore);

// order routes
router.route('/createOrder').post(auth(), validate(launderValidation.createOrder), launderController.createOrder);
router
  .route('/fetchOrders/:storeId')
  .get(auth('fetchOrders'), validate(launderValidation.fetchOrders), launderController.fetchOrders);
router.route('/fetch-user-orders').get(auth(), launderController.getUserOrders);
router.route('/fetch-notifications').get(auth(), notificationController.fetch);
router.route('/changeState').post(auth('manageStore'), launderController.changeState);
router.route('/search').get(launderController.search);
router.route('/stk-push/simulate').post(validate(paymentValidation.simulateStk), auth(), paymentController.mpesaExpress);
router.route('/stk-push/query').post(validate(paymentValidation.mpesaQuery), auth(), paymentController.mpesaQuery);
router.route('/stk-push/callback').post(paymentController.transactionCallback);

module.exports = router;
