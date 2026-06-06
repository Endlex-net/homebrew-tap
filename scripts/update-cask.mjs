#!/usr/bin/env node

import { createHash } from 'node:crypto'
import { mkdirSync, readFileSync, writeFileSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

const __dirname = dirname(fileURLToPath(import.meta.url))
const ROOT = resolve(__dirname, '..')

const args = process.argv.slice(2)
let repo = 'Endlex-net/Texere'
let cask = 'texere'
let arch = 'aarch64'
let tag = null

for (let i = 0; i < args.length; i += 1) {
  const arg = args[i]
  if (arg === '--repo') repo = args[++i]
  else if (arg === '--cask') cask = args[++i]
  else if (arg === '--arch') arch = args[++i]
  else if (arg === '--tag') tag = args[++i]
  else {
    console.error(`Unknown argument: ${arg}`)
    process.exit(1)
  }
}

async function fetchJson(url) {
  const response = await fetch(url, {
    headers: {
      Accept: 'application/vnd.github+json',
      'User-Agent': 'homebrew-tap-update-cask-script'
    }
  })

  if (!response.ok) {
    throw new Error(`GitHub API request failed (${response.status}): ${url}`)
  }

  return response.json()
}

async function fetchBuffer(url) {
  const response = await fetch(url, {
    headers: {
      Accept: 'application/octet-stream',
      'User-Agent': 'homebrew-tap-update-cask-script'
    }
  })

  if (!response.ok) {
    throw new Error(`Download failed (${response.status}): ${url}`)
  }

  const arrayBuffer = await response.arrayBuffer()
  return Buffer.from(arrayBuffer)
}

function sha256(buffer) {
  return createHash('sha256').update(buffer).digest('hex')
}

function parseChecksums(content) {
  const map = new Map()
  for (const line of content.split('\n')) {
    const trimmed = line.trim()
    if (!trimmed) continue
    const match = trimmed.match(/^([a-f0-9]{64})\s+(.+)$/i)
    if (!match) continue
    map.set(match[2].trim(), match[1])
  }
  return map
}

function pickRelease(releases) {
  const published = releases.find((release) => !release.draft)
  if (!published) {
    throw new Error('No published release found')
  }
  return published
}

function getAssetUrl(asset) {
  return asset.browser_download_url
}

function pickDmgAsset(assets, version, arch) {
  const stableName = `Texere-${version}-${arch}.dmg`
  const stable = assets.find((asset) => asset.name === stableName)
  if (stable) {
    return stable
  }

  const archPatterns = {
    aarch64: /(aarch64|arm64)/i,
    x64: /(x64|x86_64|amd64)/i,
    universal: /universal/i
  }

  const archPattern = archPatterns[arch] ?? new RegExp(arch, 'i')
  const legacy = assets.find((asset) => asset.name.endsWith('.dmg') && archPattern.test(asset.name))
  if (legacy) {
    return legacy
  }

  throw new Error(`Could not find a matching DMG asset for arch=${arch}`)
}

function normalizeVersionFromTag(tagName) {
  return tagName.startsWith('v') ? tagName.slice(1) : tagName
}

function updateCaskFile(caskPath, version, fileSha, downloadUrl) {
  const before = readFileSync(caskPath, 'utf8')
  let after = before
    .replace(/version\s+"[^"]+"/, `version "${version}"`)
    .replace(/sha256\s+"[a-f0-9]+"/i, `sha256 "${fileSha}"`)
    .replace(/url\s+"[^"]+"/, `url "${downloadUrl}"`)

  if (after === before) {
    throw new Error(`No cask fields updated in ${caskPath}`)
  }

  writeFileSync(caskPath, after)
}

async function main() {
  const releasesUrl = tag
    ? `https://api.github.com/repos/${repo}/releases/tags/${tag}`
    : `https://api.github.com/repos/${repo}/releases`

  const releaseData = tag
    ? await fetchJson(releasesUrl)
    : pickRelease(await fetchJson(releasesUrl))

  const version = normalizeVersionFromTag(releaseData.tag_name)
  const checksumName = `Texere-${version}-checksums.txt`

  const dmgAsset = pickDmgAsset(releaseData.assets, version, arch)
  const dmgName = dmgAsset.name

  const checksumAsset = releaseData.assets.find((asset) => asset.name === checksumName)

  let fileSha
  if (checksumAsset) {
    const checksums = parseChecksums((await fetchBuffer(getAssetUrl(checksumAsset))).toString('utf8'))
    fileSha = checksums.get(dmgName)
  }

  if (!fileSha) {
    console.warn(`Checksum file missing or incomplete for ${dmgName}; calculating directly from asset download`)
    fileSha = sha256(await fetchBuffer(getAssetUrl(dmgAsset)))
  }

  const caskPath = resolve(ROOT, 'Casks', `${cask}.rb`)
  updateCaskFile(caskPath, version, fileSha, getAssetUrl(dmgAsset))

  console.log(`Updated ${cask}.rb`)
  console.log(`- version: ${version}`)
  console.log(`- arch: ${arch}`)
  console.log(`- asset: ${dmgName}`)
  console.log(`- sha256: ${fileSha}`)
  console.log(`- url: ${getAssetUrl(dmgAsset)}`)
}

main().catch((error) => {
  console.error(error.message)
  process.exit(1)
})
