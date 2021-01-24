export const getJson = async function (url, mode, credentials, headers = {}) {
  const response = await request(url, {
    method: 'GET',
    mode,
    credentials,
    headers: {
      'Accept': 'application/json, text/plain, */*',
      ...headers
    }
  });

  return processResponse(response)
}

export const postJson = async function (url, mode, credentials, body, headers = {}) {
  const response = await request(url, {
    method: 'POST',
    mode,
    credentials,
    headers: {
      'Accept': 'application/json, text/plain, */*',
      'Content-Type': 'application/json',
      ...headers
    },
    body: JSON.stringify(body)
  })

  return processResponse(response)
}

const request = async function (url, config = {}) {
  try {
    const response = await window.fetch(url, config)
    return ['ok', response]
  } catch (error) {
    console.info(error)
    return ['error', undefined]
  }
}

const parseJsonResponse = async function (response) {
  try {
    const json = await response.json()
    return ['ok', json]
  } catch (error) {
    console.info(error)
    return ['error', response]
  }
}

const processResponse = async function (response) {
  const [responseStatus, responseValue] = response

  if (responseStatus === 'ok') {
    const [parseStatus, value] = await parseJsonResponse(responseValue)

    if (parseStatus === 'ok') {
      return ['ok', value]
    }
  }

  return responseError(responseValue)
}

const responseError = function (response) {
  if (response) {
    switch (response.status) {
      case 401:
        return ['error', [401, authErrorReason(response)]]
      default:
        return ['error', [response.status, response.statusText]]
    }
  }

  return ['error', [undefined, 'network']]
}

const authErrorReason = function (response) {
  const authHeader = response.headers.get('WWW-Authenticate')
  const reason = /^.*error_description="(.*?)".*$/.exec(authHeader)
  return reason ? reason[1] : response.statusText
}
