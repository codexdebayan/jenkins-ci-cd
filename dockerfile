FROM python:3.8-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the source code into the container
COPY src/ src/
COPY tests/ tests/

# Command to run the unit tests
CMD ["python", "-m", "unittest", "discover", "tests"]

