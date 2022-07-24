const mongoose = require('mongoose');
const { toJSON } = require('./plugins');

const notifySchema = mongoose.Schema(
  {
    title: {
      type: String,
      required: true,
    },
    read: {
      type: Boolean,
      required: true,
      default: false,
    },
    senderId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Store',
      required: true,
    },
    receiverId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    body: {
      type: String,
      required: true,
    },
  },
  {
    timestamps: true,
  }
);

// add plugin that converts mongoose to json
notifySchema.plugin(toJSON);

/**
 * @typedef Notify
 */
const Notify = mongoose.model('notify', notifySchema);

module.exports = Notify;
