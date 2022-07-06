const express = require('express');
const validate = require('../../middlewares/validate');
const launderValidation = require('../../validations/store.validation');
const launderController = require('../../controllers/launder.controller');
const auth = require('../../middlewares/auth');

const router = express.Router();

router.route('/createStore').post(auth(), validate(launderValidation.createStore), launderController.createStore);
router.route('/fetchStore').get(auth(), validate(launderValidation.fetchStores), launderController.fetchStore);
router.route('/fetchStores').get(launderController.fetchAllStores);
router.route('/stk-push/callback').post(launderController.fetchAllStores);

module.exports = router;
