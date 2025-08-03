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
- [Assumptions and Design Decisions](##assumptions-and-design-decisions)
- [Known Limitations](##known-limitations)
- [Future Improvements](##future-improvements)
- [Next Priorities](##next-priorities)
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

## Assumptions and Design Decisions
1. **Data Source**:
   - The application assumes that the client data is stored in a JSON file.
   - The JSON file should be placed in the `db/data/clients.json` directory.
   - Expects specific fields in the JSON file: `id`, `full_name`, and `email`.
2. **Search Functionality**:
   - The name search is case-insensitive.
   - The search is partial, meaning it will match any part of the name.
3. **Error Handling**:
   - Basic input validation is implemented.
   - Handling of missing or invalid data is implemented.

## Known Limitations
1. The entire dataset is loaded into memory
2. The application does not handle large datasets efficiently.
3. The search functionality if limited to name and email.
4. There is no pagination for large result sets.
5. The application does not allow for data modifications.
6. Limited error handling.

## Future Improvements
1. **Dynamic field search**: Allow users to search any client field (not just name), e.g., id, other fields.
2. **Configurable file source**: Allow users to specify the file source for the client data.
3. **REST API Interface**: Allow users to access the application via a REST API with Rails API implementation.
4. **Scalability and Performance**:
   - For large datasets, store data in a database (e.g. PostgreSQL).
   - Implement pagination for large result sets in both CLI and API.
5. **Code Quality Improvements**:
   - Code Quality Improvements
   - Add RuboCop and Reek for linting and code smell detection.
   - Add detailed logging and error handling.
6. **Advanced Features**:
   - Improvement in search functionality to support fuzzy search.
   - Improvement in search functionality to check for invalid input and data(including special characters).
   - Export results to CSV or JSON for reports or integrations.
7. **Deployment**: Dockerize the app for easy deployment and environment consistency.

## Next Priorities
1. **Dynamic field search**: Allow users to search any client field (not just name), e.g., id, other fields.
2. **Enchanced search functionality**

## Author
Prepsa Kayastha
