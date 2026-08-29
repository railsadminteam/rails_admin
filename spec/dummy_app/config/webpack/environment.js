const { environment } = require("@rails/webpacker");
const path = require("path");

const babelConfig = path.resolve(__dirname, "../../babel.config.js");
const hotwiredPackages = /node_modules\/@hotwired\/turbo(?:-rails)?\//;
const babelLoader = environment.loaders.get("babel");
const babelUse = babelLoader.use[0];
const babelExclude = babelLoader.exclude;
const nodeModulesLoader = environment.loaders.get("nodeModules");
const nodeModulesUse = nodeModulesLoader.use[0];
const nodeModulesExclude = nodeModulesLoader.exclude;

babelUse.options.configFile = babelConfig;
babelLoader.include.push(hotwiredPackages);
babelLoader.exclude = (modulePath) => {
  if (hotwiredPackages.test(modulePath)) {
    return false;
  }
  return babelExclude.test(modulePath);
};

nodeModulesUse.options.configFile = babelConfig;
nodeModulesUse.options.babelrc = false;
nodeModulesLoader.exclude = (modulePath) => {
  if (hotwiredPackages.test(modulePath)) {
    return true;
  }
  return nodeModulesExclude.test(modulePath);
};

module.exports = environment;
