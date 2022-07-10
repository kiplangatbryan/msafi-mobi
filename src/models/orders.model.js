const mongoose = require('mongoose');
const { toJSON } = require('./plugins');
const { statusTypes } = require('../config/tokens');

const ordersSchema = mongoose.Schema(
  {
    paymentId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Payment',
    },
    paid: {
      required: true,
      type: Boolean,
      default: false,
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
    status: {
      type: String,
      enum: Object.values(statusTypes),
      required: true,
      default: 'initial',
    },
    expectedPickUp: {
      required: true,
      type: Date,
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

/**
 * @typedef Orders
 */
const Orders = mongoose.model('Orders', ordersSchema);

module.exports = Orders;
