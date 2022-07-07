const httpStatus = require('http-status');
const catchAsync = require('../utils/catchAsync');

const { stationService } = require('../services');

const fetchStations = catchAsync(async (req, res) => {
  const stations = await stationService.fetchStations(req.params.storeId);
  res.status(httpStatus.OK).send(stations);
});

module.exports = {
  fetchStations,
};
