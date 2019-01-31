'use strict'

exports.handler = (event, context, callback) => {
  const request = event.Records[0].cf.request
  const headers = request.headers

  const authUser = '${user}'
  const authPass = '${password}'

  const encodedCredentials = new Buffer(`${authUser}:${authPass}`).toString('base64')
  const authString = `Basic ${encodedCredentials}`

  if (
    typeof headers.authorization == 'undefined' ||
    headers.authorization[0].value != authString
  ) {
    const response = {
      status: '401',
      statusDescription: 'Unauthorized',
      body: 'Unauthorized',
      headers: {
        'www-authenticate': [
          {
            key: 'WWW-Authenticate',
            value: 'Basic',
          }
        ]
      },
    }

    callback(null, response)
    return
  }

  // Continue request processing if authentication passed
  callback(null, request)
}
