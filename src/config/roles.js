const allRoles = {
  user: [],
  merchant: ['getOrders', 'fetchOrders', 'manageStore'],
  admin: ['getUsers', 'manageUsers'],
};

const roles = Object.keys(allRoles);
const roleRights = new Map(Object.entries(allRoles));

module.exports = {
  roles,
  roleRights,
};
