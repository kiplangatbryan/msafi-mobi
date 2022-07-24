const dotenv = require('dotenv');
const path = require('path');
const Joi = require('joi');

dotenv.config({ path: path.join(__dirname, '../../.env') });

const envVarsSchema = Joi.object()
  .keys({
    NODE_ENV: Joi.string().valid('production', 'development', 'test').required(),
    PORT: Joi.number().default(3000),
    MONGODB_URL: Joi.string().required().description('Mongo DB url'),
    JWT_SECRET: Joi.string().required().description('JWT secret key'),
    JWT_ACCESS_EXPIRATION_MINUTES: Joi.number().default(30).description('minutes after which access tokens expire'),
    JWT_REFRESH_EXPIRATION_DAYS: Joi.number().default(30).description('days after which refresh tokens expire'),
    JWT_RESET_PASSWORD_EXPIRATION_MINUTES: Joi.number()
      .default(10)
      .description('minutes after which reset password token expires'),
    JWT_VERIFY_EMAIL_EXPIRATION_MINUTES: Joi.number()
      .default(10)
      .description('minutes after which verify email token expires'),
    SMTP_HOST: Joi.string().description('server that will send the emails'),
    SMTP_PORT: Joi.number().description('port to connect to the email server'),
    SMTP_USERNAME: Joi.string().description('username for email server'),
    SMTP_PASSWORD: Joi.string().description('password for email server'),
    EMAIL_FROM: Joi.string().description('the from field in the emails sent by the app'),
    TOKEN_URL: Joi.string().description('safaricom access token url'),
    CONSUMER_KEY: Joi.string().description('safaricom consumer key'),
    CONSUMER_SECRET: Joi.string().description('safaricom consumer secret'),
    ONLINE_PROCESS_URL: Joi.string().description('safaricom sandbox url to initiate payment'),
    passkey: Joi.string().description('safaricom sandbox passkety'),
    shortcode: Joi.string().description('safaricom sandbox shortcode'),
    CLICKSEND_MAIL: Joi.string().description('clicksend user mail'),
    CLICKSEND_KEY: Joi.string().description('clicksend api key'),
    CALLBACK_SAF_URL: Joi.string().description('endpoint that will recieve payment confirmation'),
  })
  .unknown();

const { value: envVars, error } = envVarsSchema.prefs({ errors: { label: 'key' } }).validate(process.env);

if (error) {
  throw new Error(`Config validation error: ${error.message}`);
}

module.exports = {
  env: envVars.NODE_ENV,
  port: envVars.PORT,
  mongoose: {
    url: envVars.MONGODB_URL + (envVars.NODE_ENV === 'test' ? '-test' : ''),
    options: {
      useCreateIndex: true,
      useNewUrlParser: true,
      useUnifiedTopology: true,
    },
  },
  jwt: {
    secret: envVars.JWT_SECRET,
    accessExpirationMinutes: envVars.JWT_ACCESS_EXPIRATION_MINUTES,
    refreshExpirationDays: envVars.JWT_REFRESH_EXPIRATION_DAYS,
    resetPasswordExpirationMinutes: envVars.JWT_RESET_PASSWORD_EXPIRATION_MINUTES,
    verifyEmailExpirationMinutes: envVars.JWT_VERIFY_EMAIL_EXPIRATION_MINUTES,
  },
  email: {
    smtp: {
      host: envVars.SMTP_HOST,
      port: envVars.SMTP_PORT,
      auth: {
        user: envVars.SMTP_USERNAME,
        pass: envVars.SMTP_PASSWORD,
      },
    },
    from: envVars.EMAIL_FROM,
  },
  mpesaPay: {
    accessTokenUri: envVars.TOKEN_URL,
    consumerKeyUri: envVars.CONSUMER_KEY,
    consumerSecret: envVars.CONSUMER_SECRET,
    simulateMpesaUri: envVars.ONLINE_PROCESS_URL,
    passkey: envVars.passkey,
    uri_callback: envVars.CALLBACK_SAF_URL,
    shortcode: envVars.shortcode,
  },
  clicksend: {
    apiKey: envVars.CLICKSEND_KEY,
    user: envVars.CLICKSEND_MAIL,
  },
};