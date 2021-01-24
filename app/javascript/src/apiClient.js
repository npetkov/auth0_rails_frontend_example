import * as Fetch from './fetchJson'

let origin
let jwtToken

export const getJson = async function (path) {
  return Fetch.getJson(requestUrl(path), 'cors', 'omit', authorizationHeader())
}

export const postJson = async function (path, body) {
  return Fetch.postJson(requestUrl(path), 'cors', 'omit', body, authorizationHeader())
}

export const getNotes = async function () {
  return getJson('/notes')
}

export const setOrigin = function (url) {
  origin = url
}

export const setJwtToken = function (token) {
  jwtToken = token
}

const requestUrl = function (path) {
  return new URL(path, origin).toString()
}

const authorizationHeader = function () {
  return {
    'Authorization': `Bearer ${jwtToken}`
  }
}
