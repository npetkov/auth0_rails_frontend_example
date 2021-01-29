import * as OriginClient from './originClient'
import * as ApiClient from './apiClient'

document.onreadystatechange = function () {
  if (document.readyState === 'interactive') {
    initApplication()
  }
}

const setErrorMessage = function (message) {
  const errorContainer = document.querySelector('div#error')
  errorContainer.innerHTML = message
}

const setInspectLinkTarget = function (token) {
  const inspectLink = document.querySelector('a#inspect_token')
  inspectLink.setAttribute('href', `https://jwt.io/?value=${token}`)
}

const setRequestButtonClickHandler = function () {
  const requestButton = document.querySelector('button#api_request')
  requestButton.addEventListener('click', async () => {
    const [status, data] = await ApiClient.getNotes()

    if (status === 'error') {
      const [_, statusText] = data
      setErrorMessage(statusText)
    }
  })
}

const initApplication = async function () {
  let [status, data] = await OriginClient.apiParams()

  if (status === 'ok') {
    const {api_params} = data
    ApiClient.setOrigin(api_params.apiOrigin)
    ApiClient.setJwtToken(api_params.apiToken)
    setInspectLinkTarget(api_params.apiToken)
    setRequestButtonClickHandler()
  }
}
