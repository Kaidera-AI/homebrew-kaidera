#!/usr/bin/env node
'use strict'

const { execFileSync } = require('child_process')
const crypto = require('crypto')
const fs = require('fs')
const os = require('os')
const path = require('path')

const VERSION = require('../package.json').version
const HOME = process.env.KAIDERA_OS_HOME || path.join(os.homedir(), 'kaidera-os')
const CLI = path.join(HOME, 'local-cortex', 'console', 'scripts', 'kaidera-os')
const VERSION_FILE = path.join(HOME, 'local-cortex', 'console', 'app', 'version.py')
const BASE = `https://github.com/Kaidera-AI/homebrew-kaidera/releases/download/v${VERSION}`
const TARBALL = `kaidera-os-v${VERSION}.tar.gz`

function installedVersion() {
  try {
    const match = fs.readFileSync(VERSION_FILE, 'utf8').match(/__version__\s*=\s*"([^"]+)"/)
    return match ? match[1] : null
  } catch {
    return null
  }
}

function sha256(file) {
  return crypto.createHash('sha256').update(fs.readFileSync(file)).digest('hex')
}

function ensureInstalled() {
  if (fs.existsSync(CLI) && installedVersion() === VERSION) return

  process.stderr.write(`Kaidera OS ${VERSION}: downloading verified runtime\n`)
  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'kaidera-os-'))
  const archive = path.join(tmp, TARBALL)
  const checksum = `${archive}.sha256`
  try {
    execFileSync('curl', ['-fsSL', `${BASE}/${TARBALL}`, '-o', archive], { stdio: 'inherit' })
    execFileSync('curl', ['-fsSL', `${BASE}/${TARBALL}.sha256`, '-o', checksum], { stdio: 'inherit' })
    const expected = fs.readFileSync(checksum, 'utf8').trim().split(/\s+/)[0]
    const actual = sha256(archive)
    if (!expected || expected !== actual) throw new Error('release checksum verification failed')

    fs.mkdirSync(HOME, { recursive: true })
    execFileSync('tar', ['-xzf', archive, '-C', HOME, '--strip-components=1'], { stdio: 'inherit' })
  } finally {
    fs.rmSync(tmp, { recursive: true, force: true })
  }
}

try {
  ensureInstalled()
  const args = process.argv.slice(2)
  execFileSync(CLI, args.length ? args : ['version'], { stdio: 'inherit' })
} catch (err) {
  process.stderr.write(`kaidera-os: ${err.message}\n`)
  process.exit(typeof err.status === 'number' ? err.status : 1)
}
