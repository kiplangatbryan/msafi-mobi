const crypto = require('crypto');
const multer = require('multer');

const storage = (folder) => {
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

const config = [{ name: 'avatar', maxCount: 3 }];

const fileHandler = (type) => (type === 'store' ? handler('stores').fields(config) : handler('profileImgs').fields(profile));

module.exports = {
  fileHandler,
};