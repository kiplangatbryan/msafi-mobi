/* eslint-disable prettier/prettier */
const mongoose = require('mongoose');
const { toJSON } = require('./plugins');

const paymentSchema = mongoose.Schema(
    {
    CheckoutRequestID: {
        type: String,
    },
    Amount: {
        type: Number,
    },
    MerchantRequestID: {
        type: String,
    },
    MpesaReceiptNumber: {type: String},
    TransactionDate: {type: String},
    PhoneNumber: {type: String},

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
