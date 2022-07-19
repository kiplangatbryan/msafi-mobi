/* eslint-disable security/detect-non-literal-fs-filename */
const crypto = require('crypto');
const multer = require('multer');
const fs = require('fs');
const path = require('path');
const logger = require('../config/logger');

function createDirectories(pathname) {
  // Remove leading directory markers, and remove ending /file-name.extension
  fs.mkdir(path.join(__dirname, '..', '..', pathname.split('/')[0], pathname.split('/')[1]), { recursive: true }, (e) => {
    if (e) {
      logger.error(e);
    } else {
      logger.info('Success');
    }
  });
}
const storage = (folder) => {
  createDirectories('uploads/profileImgs');
  createDirectories('uploads/stores');

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
