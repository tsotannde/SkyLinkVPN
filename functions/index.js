const { setGlobalOptions } = require("firebase-functions");
const { onCall } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const fetch = require("node-fetch");

// Limit concurrent instances for cost control
setGlobalOptions({ maxInstances: 10 });

// Test endpoint for sanity check
exports.helloWorld = onCall(async () => {
  logger.info("✅ helloWorld function triggered");
  return { message: "🔥 Hello from Firebase Cloud Functions!" };
});

// Dynamic function to request IP from a specific server
exports.requestIPAddress = onCall(async (data) => {
    logger.info("📡 requestIPAddress function triggered with data:", data);

    try {
      const input = data.data || data; // ✅ Fix for nested iOS payloads

      const {
        serverName,
        serverIP,
        tunnelName,
        tunnelIP,
        uniqueInstallID,
        uid,
        publicKey,
        serverPort = 5000,
      } = input;

      if (!serverIP) {
        throw new Error("Missing required parameter: serverIP");
      }

      const serverUrl = `http://${serverIP}:${serverPort}/assign-ip`;
      logger.info(`🌐 Forwarding request to: ${serverUrl}`);

      const response = await fetch(serverUrl, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          serverName,
          serverIP,
          tunnelName,
          tunnelIP,
          uniqueInstallID,
          uid,
          publicKey,
        }),
      });

      if (!response.ok) {
        const text = await response.text();
        throw new Error(`Server responded with status ${response.status}: ${text}`);
      }

      const json = await response.json();
      const assignedIP = json.ip;

      if (!assignedIP) {
        throw new Error("Server response missing 'ip' field");
      }

      logger.info("✅ Received IP from server:", assignedIP);
      return { ip: assignedIP };
    } catch (error) {
      logger.error("❌ Error in requestIPAddress:", error);
      throw new Error(`Failed to assign IP: ${error.message}`);
    }
});
