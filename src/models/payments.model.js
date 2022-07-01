/* eslint-disable prettier/prettier */
const mongoose = require('mongoose');
const { toJSON } = require('./plugins');

const paymentSchema = mongoose.Schema(
    {
    amount: {
        type: String,
        required: true,
    },
    confirmed: {
        type: Boolean,
        default: false,
        required: true,
    },
    transactionId: {
        type: String,
        require: true
    },
    phone: {
        type: String,
        required: true,
    },
    },
  {
    timestamps: true,
  }
);

// add plugin that converts mongoose to json
paymentSchema.plugin(toJSON);

/**
 * @typedef Payment
 */
const Payment = mongoose.model('Payment', paymentSchema);

module.exports = Payment;
