const mongoose = require('mongoose');
const { toJSON } = require('./plugins');

const metaSchema = mongoose.Schema(
  {
    confirmed: {
      type: Boolean,
    },
    paymentId: {
      type: mongoose.Schema.Types.ObjectId,
    },
    info: {
      type: Object,
    },
  },
  {
    timestamps: true,
  }
);

// add plugin that converts mongoose to json
metaSchema.plugin(toJSON);

/**
 * @typedef Orders
 */
const Meta = mongoose.model('meta', metaSchema);

module.exports = Meta;
