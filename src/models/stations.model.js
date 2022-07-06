/* eslint-disable prettier/prettier */
const mongoose = require('mongoose');
const { toJSON } = require('./plugins');

const stationSchema = mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },
    long: {
      type: String,
      required: true,
    },
    storeId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Store',
      required: true,
    },
    lat: {
      type: String,
      required: true,
    },
    stationImg: {
      type: String,
    },
  },
  {
    timestamps: true,
  }
);

// add plugin that converts mongoose to json
stationSchema.plugin(toJSON);

/**
 * @typedef Station
 */
const Station = mongoose.model('Station', stationSchema);

module.exports = Station;
