const mongoose = require('mongoose');
const { toJSON } = require('./plugins');
const { statusTypes } = require('../config/tokens');

const ordersSchema = mongoose.Schema(
  {
    paymentId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Payment',
    },
    stationId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Station',
      required: true,
    },
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    storeId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Store',
      required: true,
    },
    amount: {
      type: String,
      required: true,
    },
    status: {
      type: String,
      enum: Object.values(statusTypes),
      required: true,
      default: 'Initial',
    },
    expectedPickUp: {
      required: true,
      type: Date,
    },
    alias: {
      type: String,
      required: true,
    },
    clothes: {
      required: true,
      type: Array,
    },
    droppedOff: {
      type: Date,
    },
  },
  {
    timestamps: true,
  }
);

// add plugin that converts mongoose to json
ordersSchema.plugin(toJSON);
ordersSchema.index({ paymentId: 1, storeId: 1, stationId: 1, userId: 1, expectedPickUp: 1 }, { name: 'order_search' });

/**
 * @typedef Orders
 */
const Orders = mongoose.model('Orders', ordersSchema);

module.exports = Orders;
