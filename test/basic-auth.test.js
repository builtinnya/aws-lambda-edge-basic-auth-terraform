const expect = require('chai').expect
const sinon = require('sinon')
const { handler } = require('../src/basic-auth')

describe('Basic Auth', function() {
  describe('handler', function () {
    it('should return 401 and WWW-Authenticate: Basic header without Authorization header', function() {
      const event = {
        Records: [
          {
            cf: {
              request: {
                headers: {
                },
              },
            },
          },
        ],
      }

      const callback = sinon.fake()

      handler(event, null, callback)

      expect(callback.calledOnce).to.be.true

      const [ err, response ] = callback.args[0]

      expect(err).to.be.null
      expect(response).to.have.property('status', '401')
      expect(response).to.have.property('headers')

      const { headers } = response

      expect(headers).to.have.property('www-authenticate')

      expect(headers['www-authenticate']).to.deep.equal([
        {
          key: 'WWW-Authenticate',
          value: 'Basic',
        },
      ])
    })

    it('should return 401 and WWW-Authenticate: Basic header if authentication failed', function() {
      const event = {
        Records: [
          {
            cf: {
              request: {
                headers: {
                  authorization: [
                    {
                      // new Buffer('impossible:impossible').toString('base64')
                      value: 'Basic aW1wb3NzaWJsZTppbXBvc3NpYmxl',
                    },
                  ],
                },
              },
            },
          },
        ],
      }

      const callback = sinon.fake()

      handler(event, null, callback)

      expect(callback.calledOnce).to.be.true

      const [ err, response ] = callback.args[0]

      expect(err).to.be.null
      expect(response).to.have.property('status', '401')
      expect(response).to.have.property('headers')

      const { headers } = response

      expect(headers).to.have.property('www-authenticate')

      expect(headers['www-authenticate']).to.deep.equal([
        {
          key: 'WWW-Authenticate',
          value: 'Basic',
        },
      ])
    })

    it('should return request if authentication succeeded', function() {
      const event = {
        Records: [
          {
            cf: {
              request: {
                headers: {
                  authorization: [
                    {
                      // new Buffer('${user}:${password}').toString('base64')
                      value: 'Basic JHt1c2VyfToke3Bhc3N3b3JkfQ==',
                    },
                  ],
                },
              },
            },
          },
        ],
      }

      const callback = sinon.fake()

      handler(event, null, callback)

      expect(callback.calledOnce).to.be.true

      const [ err, response ] = callback.args[0]

      expect(err).to.be.null
      expect(response).to.deep.equal(event.Records[0].cf.request)
    })
  })
})
