const mongoose = require('mongoose');
const { toJSON } = require('./plugins');

const storeSchema = mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    description: {
      type: String,
      required: true,
    },
    pricing: {
      type: Array,
      required: true,
    },
    address: {
      type: String,
      required: true,
    },
    storeImg: {
      type: String,
      required: true,
    },
  },
  {
    timestamps: true,
  }
);

// add plugin that converts mongoose to json
storeSchema.plugin(toJSON);

/**
 * @typedef Store
 */
const Store = mongoose.model('Store', storeSchema);

module.exports = Store;