import * as Fetch from './fetchJson'

export const getJson = async function (path) {
  return Fetch.getJson(path, 'same-origin', 'include')
}

export const postJson = async function (path, body) {
  return Fetch.postJson(path, 'same-origin', 'include', body, csrfHeader())
}

export const apiParams = async function () {
  return postJson('/api_params')
}

export const apiToken = async function () {
  return postJson('/api_token')
}

const getCookie = function (name) {
  const cookieString = document.cookie + "; ''=''"
  const map = new Map(
    cookieString
      .split(';')
      .map(entry => entry.split('=')
      .map(entry => entry.trim()))
  )
  return map.get(name)
}

const csrfHeader = function () {
  return {
    'X-CSRF-TOKEN': getCookie('CSRF-TOKEN')
  }
}
