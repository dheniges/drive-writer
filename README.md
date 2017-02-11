# drive-writer
A not-entirely-functional writing app with gdocs storage

## Overview
This was a side project to play with oauth solutions and the google docs API. It is incomplete.

The idea was to build a wrapper around Google Drive to support creative writing endeavors. The actual writing would occur in Google Docs, but you
could organize and create/launch docs from the app.

For example, you could add a "Characters" section and keep all character background in a file. Sections are completely flexible.

## Features
Sign-in with your Google account
Create a root folder in your Google docs account, which is used to store projects

## Code notes
- The APIClient model should probably be a lib, but it provides a simple wrapper around the Google API.
- The user model reads through the Google Drive folder and parses any existing projects and their corresponding sections and files. This data is cached per session.
