# Client Search Application

A simple command-line application that allows users to search for duplicate emails and search for clients by name.

## Project Features

- Search for duplicate emails
    - Identifies and displays all clients with duplicate email addresses
- Search by client name
    - Search for clients by full or partial name
    - Case-insensitive matching

## Table of Contents

- [Project Features](##project-features)
- [Core Technologies](##core-technologies)
- [Project Installation and Setup](##project-installation-and-setup)
  - [Prerequisites](###prerequisites)
  - [Installation](###installation)
- [Usage](##usage)
- [Project Structure](##project-structure)
- [Testing](##testing)
- [Author](##author)

## Core Technologies

- **Language**: Ruby `3.4.4`
- **Bundler**: `2.4.1`

## Project Installation and Setup

### Prerequisites
- Ensure you have the following installed:
  - Ruby `3.4.4`
  - Bundler `2.4.1`

### Installation

1. **Clone the Repository**:
   ```
   git clone git@github.com:Prepsa/clients-search.git
   cd clients-search
   ```

2. **Install Dependencies**:
   ```
   bundle install
   ```

3. **Prepare data**:
Place the client data in the `db/data/clients.json` file.
Example format:
```json
[
    {
        "id": 1,
        "full_name": "John Doe",
        "email": "john.doe@gmail.com"
    },
    {
        "id": 2,
        "full_name": "Jane Smith",
        "email": "jane.smith@yahoo.com"
    }
]
```

## Usage
Run the application from command line:
```bash
ruby bin/runner.rb
```

## Project Structure
```
  clients-search/
  ├── bin/
  │   └── runner.rb       # Application entry point
  ├── db/
  │   └── data/
  │       └── clients.json # Sample client data
  ├── lib/
  │   └── search/
  │       ├── client.rb      # Client model
  │       ├── client_loader.rb # Data loading and parsing
  │       ├── utils.rb      # Search and display utilities
  │       └── search.rb     # Main application logic
  └── spec/              # Test files
      ├── lib/
      │   └── search/
      └── spec_helper.rb # Test configuration
```
## Testing
To run the test suite:
```bash
bundle exec rspec
```
## Author
Prepsa Kayastha
