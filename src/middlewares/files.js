/* eslint-disable security/detect-non-literal-fs-filename */
const crypto = require('crypto');
const multer = require('multer');
const fs = require('fs');

function ensureExists(path, mask, cb) {
  if (typeof mask === 'function') {
    // Allow the `mask` parameter to be optional
    // eslint-disable-next-line no-param-reassign
    cb = mask;
    // eslint-disable-next-line no-param-reassign
    mask = 0o744;
  }
  fs.mkdir(path, mask, function (err) {
    if (err) {
      if (err.code === 'EEXIST') cb(null);
      // Ignore the error if the folder already exists
      else cb(err); // Something else went wrong
    } else cb(null); // Successfully created folder
  });
}

const storage = (folder) => {
  ensureExists('../../uploads/profileImgs');
  ensureExists('../../uploads/stores');

  return multer.diskStorage({
    destination(req, file, cb) {
      // eslint-disable-next-line no-console
      const fileType = file.mimetype.split('/')[0];
      if (fileType === 'image') {
        cb(null, `uploads/${folder}/`);
      }
    },
    filename: (req, file, cb) => {
      cb(null, `${crypto.randomBytes(12).toString('hex') + Date.now()}.${file.mimetype.split('/')[1]}`);
    },
  });
};

const handler = (folder) => {
  return multer({
    storage: storage(folder),
    limits: {
      fileSize: 1024 * 1024 * 10,
    },
    fileFilter: null,
  });
};

const profile = [{ name: 'avatar', maxCount: 1 }];

const config = [{ name: 'avatar', maxCount: 5 }];

const fileHandler = (type) => (type === 'store' ? handler('stores').fields(config) : handler('profileImgs').fields(profile));

module.exports = {
  fileHandler,
};
