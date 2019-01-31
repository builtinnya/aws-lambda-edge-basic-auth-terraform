FROM node:8.10

###
# Set up the working directory
#
ENV CODES_DIR /codes
RUN mkdir -p "${CODES_DIR}"
WORKDIR "${CODES_DIR}"

###
# Install dependencies
#
COPY package.json .
COPY yarn.lock .
RUN yarn

###
# Install codes
#
COPY . .

###
# What we need is.. bash!
#
CMD [ "bash" ]
