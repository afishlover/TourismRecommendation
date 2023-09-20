module.exports = {
    devServer: {
        proxy: {
          "/bapi": {
            ws: true,
            changeOrigin: true,
            target: "http://127.0.0.1:8080"
          }
        }
      }
}