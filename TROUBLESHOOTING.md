# Troubleshooting Guide

Common issues and their solutions.

## Build Issues

### Package Installation Fails

**Problem**: Package fails to install during Docker build

**Solution**:
- Check if the package name or version has changed
- Try updating conda/pip before installing
- Check system dependencies are installed

### Out of Disk Space

**Problem**: Docker build fails with "no space left on device"

**Solution**:
```bash
# Clean up Docker images and containers
docker system prune -a

# Remove unused volumes
docker volume prune
```

## Runtime Issues

### Jupyter Lab Won't Start

**Problem**: Container starts but Jupyter is not accessible

**Solution**:
- Check port mapping: `docker ps`
- Check container logs: `docker logs <container-id>`
- Ensure firewall allows the port

### Import Errors

**Problem**: Python package import fails

**Solution**:
- Verify package is in environment file
- Rebuild image if recently added
- Check package compatibility with Python version

### Permission Denied Errors

**Problem**: Cannot write to mounted volume

**Solution**:
```bash
# On Linux/Mac, ensure proper permissions
chmod -R 755 ./work

# Or run with correct user
docker run -u $(id -u):$(id -g) ...
```

## Performance Issues

### Slow Performance

**Solutions**:
- Allocate more memory to Docker
- Use volume mounts efficiently
- Consider using GPU image for compute-intensive tasks

### Container Uses Too Much Memory

**Solution**:
```bash
# Limit memory usage
docker run -m 4g ...
```

## Network Issues

### Cannot Access External Resources

**Problem**: Package installation or data download fails

**Solution**:
- Check internet connectivity
- Configure proxy if behind corporate firewall
- Use `--network=host` if needed

## AWS Integration Issues

### AWS Credentials Not Working

**Solution**:
- Mount credentials file: `-v ~/.aws:/home/jovyan/.aws:ro`
- Set environment variables correctly
- Ensure IAM permissions are correct

## Getting Help

If issues persist:
1. Check [GitHub Issues](https://github.com/eyadsibai/machine-learning-docker-image/issues)
2. Search for similar problems
3. Create a new issue with:
   - Docker version
   - OS information
   - Complete error message
   - Steps to reproduce
