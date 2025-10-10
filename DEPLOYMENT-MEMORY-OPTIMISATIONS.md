# Memory Optimization Deployment Guide

## Changes Made to Reduce Memory Usage

### 1. Library Loading Optimizations

- **Removed `tidyverse`** from both `ui.R` and `server.R` as it loads many heavy packages unnecessarily
- **Kept only essential packages** for core functionality
- **Reduced file upload limit** from 30MB to 10MB to prevent memory spikes

### 2. Reactive Expression Optimizations

- **Consolidated duplicate reactive expressions** (e.g., `totalA` and `TOT_A` now use single reactive)
- **Removed redundant reactive calculations** to reduce memory overhead
- **Added proper reactive invalidation** to clean up unused values

### 3. Bulk Processing Optimizations

- **Added chunked processing** in `runNP()` function for large datasets (processes 1000 rows at a time)
   - Removed this due to errors, can look at re-implementation
- **Implemented memory cleanup** with `gc()` calls after processing chunks
   - Removed this step also, after removing chunking; can look at re-implementing
- **Added file size validation** (max 50MB) before loading data
- **Pre-allocate data structures** to avoid repeated `cbind()` operations

### 4. Docker Image Optimizations

- **Switched to lighter base image** (`rocker/r-ver` instead of `rocker/shiny-verse`)
- **Install only necessary packages** to reduce image size
- **Added cleanup commands** to remove temporary files and caches
- **Optimized layer caching** for better build performance

### 5. Shiny Server Configuration

- **Added memory-conscious timeouts**:
  - `app_init_timeout 60` (60 seconds)
  - `app_idle_timeout 300` (5 minutes before killing idle apps)
  - `app_session_timeout 3600` (1 hour session timeout)
- **Limited concurrent users** to 15 per app instance
- **Disabled websockets** to reduce memory overhead

### 6. Memory Monitoring

- **Added memory monitoring utilities** in `R/memory-utils.R`
- **Added file size warnings** for large datasets
- **Implemented cleanup functions** for session management

## Deployment for Azure

To do following testing of code updates. Copied from Azure app service hub recommendations.

### 1. App Service Configuration

- **Use at least B2 (Basic) tier** with 3.5GB RAM or higher
- **Enable Always On** to prevent cold starts
- **Set WEBSITES_CONTAINER_START_TIME_LIMIT** to 600 seconds

### 2. Environment 

Adding these to Azure App Service Configuration:

```
SHINY_LOG_LEVEL=WARN
R_GC_MEM_GROW=3
R_MAX_VSIZE=2GB
WEBSITES_ENABLE_APP_SERVICE_STORAGE=true
```

### 3. Monitoring Setup

- **Enable Application Insights** to monitor memory usage
- **Set up alerts** for memory usage > 80%
- **Monitor swap space usage** in Azure metrics

### 4. Scaling Strategy

- **Consider horizontal scaling** if you expect high concurrent usage
- **Use Azure Front Door** for load balancing multiple instances
- **Implement session affinity** if needed

## Testing the Optimizations

1. **Local Testing**:

   ```bash
   docker build -f Dockerfile . -t npm-calculator-optimized
   docker run -p 3838:3838 npm-calculator-optimized
   ```

2. **Memory Usage Testing**:

   - Upload progressively larger files (1MB, 5MB, 10MB)
   - Monitor memory usage in browser dev tools
   - Check for memory leaks with multiple uploads

3. **Load Testing**:

   - Simulate multiple concurrent users
   - Monitor Azure metrics during peak usage

## Expected Improvements

- **~40% reduction in base memory usage** from library optimizations
- **~60% reduction in bulk processing memory** from chunking
- **Faster garbage collection** from consolidated reactives  
- **Smaller Docker image** (~500MB reduction)
- **Better handling of large datasets** without crashes

## Rollback Plan

If issues occur, you can quickly rollback by:
1. Reverting the Dockerfile to use `rocker/shiny-verse:4.5.1`
2. Re-enabling `tidyverse` in ui.R and server.R
3. Increasing file upload limits back to 30MB
4. Removing chunking from `runNP()` function <- done, this was causing errors for bulk calculation
