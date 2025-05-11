# Hotwire To-Do App - Stacks

A simple to-do list built with Ruby on Rails, Hotwire (Turbo + Stimulus), and Tailwind CSS.

## Features

- Add, edit, toggle, and delete tasks
- Real-time updates with Turbo Streams
- Flash messages that auto-dismiss
- Clean UI with Tailwind CSS

## Setup

```bash
bundle install
rails db:create db:migrate
rails tailwindcss:build
bin/dev
