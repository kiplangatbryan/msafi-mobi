const express = require('express');
const validate = require('../../middlewares/validate');
const launderValidation = require('../../validations/store.validation');
const launderController = require('../../controllers/launder.controller');
const stationController = require('../../controllers/stations.controller');

const auth = require('../../middlewares/auth');
const { fileHandler } = require('../../middlewares/files');

const router = express.Router();

router
  .route('/createStore')
  .post(auth(), fileHandler('store'), validate(launderValidation.createStore), launderController.createStore);
router.route('/fetchStore').get(auth(), launderController.fetchStore);
router.route('/fetchStores').get(launderController.fetchAllStores);
router.route('/fetchStations/:storeId').get(auth(), validate(launderValidation.fetchStore), stationController.fetchStations);
// router.route('/test').post(validate(launderValidation.createStore), fileHandler('store'), launderController.createStore);

router.route('/stk-push/callback').post(launderController.fetchAllStores);

module.exports = router;
