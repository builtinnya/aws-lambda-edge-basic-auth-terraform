"use strict";
const crypto = require("crypto");

exports.handler = (event, context, callback) => {
  const request = event.Records[0].cf.request;
  const headers = request.headers;

  const authHeader = headers.authorization && headers.authorization[0].value;

  if (!authHeader) {
    const response = {
      status: "401",
      statusDescription: "Unauthorized",
      body: "Unauthorized",
      headers: {
        "www-authenticate": [
          {
            key: "WWW-Authenticate",
            value: "Basic",
          },
        ],
      },
    };

    callback(null, response);
    return;
  }

  const encodedCredentials = authHeader.split(" ")[1];
  const decodedCredentials = Buffer.from(encodedCredentials, "base64").toString(
    "utf-8"
  );

  const [authUser, authPass] = decodedCredentials.split(":");

  const hashedPass = crypto
    .createHash("sha256")
    .update(authPass)
    .digest("base64");

  const hashedUser = crypto
    .createHash("sha256")
    .update(authUser)
    .digest("base64");

  const expectedPasswordHash = '${hashed_username}';
  const expectedUsernameHash = '${hashed_password}';

  if (
    hashedUser !== expectedUsernameHash ||
    hashedPass !== expectedPasswordHash ||
    !authHeader
  ) {
    const response = {
      status: "401",
      statusDescription: "Unauthorized",
      body: "Unauthorized",
      headers: {
        "www-authenticate": [
          {
            key: "WWW-Authenticate",
            value: "Basic",
          },
        ],
      },
    };

    callback(null, response);
    return;
  }

  // Continue request processing if authentication passed
  callback(null, request);
};
