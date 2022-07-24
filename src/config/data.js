const orderPlaced = (name, orderId) => {
  return {
    title: 'Order Recieved ✔',
    body: `Dear ${name} we have successfully recieved your order ${orderId}. We will initiate processing your request.`,
  };
};

const orderCompleted = (name, orderId) => {
  return {
    title: 'Order Completed ✔',
    body: `Dear ${name} your bucket id ${orderId} has been succcesfully processed and will be ready for pickup as soon as possible.`,
  };
};

module.exports = {
  orderPlaced,
  orderCompleted,
};
