# Contributing to Machine Learning Docker Image

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## How to Contribute

### Reporting Issues

- Check if the issue already exists
- Provide clear reproduction steps
- Include your environment details (Docker version, OS, etc.)

### Submitting Changes

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Make your changes
4. Test your changes thoroughly
5. Commit with clear messages
6. Push to your fork
7. Submit a Pull Request

## Development Guidelines

### Dockerfile Changes

- Follow Docker best practices
- Minimize layer size
- Use specific package versions when stability is critical
- Document why packages are included
- Clean up temporary files in the same RUN command

### Environment File Changes

- Group related packages together
- Add comments explaining the purpose of packages
- Test that packages install correctly
- Check for version conflicts

### Testing

Before submitting:

1. Build the Docker image locally:
   ```bash
   docker build -f default.Dockerfile -t test-image .
   ```

2. Run the image and verify functionality:
   ```bash
   docker run -it test-image /bin/bash
   ```

3. Test key libraries are importable in Python

## Style Guidelines

- Use consistent formatting
- Add comments for complex operations
- Keep lines under 120 characters when possible
- Use meaningful variable names

## Questions?

Feel free to open an issue for questions or discussions.
