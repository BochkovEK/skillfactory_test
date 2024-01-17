// module "array_app_js_test.js"
exports.multiplyByTwo = function (array) {
  return array.map((number) => number * 2);
}

exports.removeDuplicates = function (array) {
  return [...new Set(array)]
}
