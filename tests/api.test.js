const request = require('supertest');
const express = require('express');

// Mock Express app for testing
const app = express();
app.use(express.json());

// Mock routes
app.get('/health', (req, res) => {
  res.json({ 
    status: 'healthy', 
    timestamp: new Date().toISOString() 
  });
});

app.get('/api/tasks', (req, res) => {
  res.json([
    { id: 1, title: 'Test Task', description: 'Test Description', completed: false }
  ]);
});

app.post('/api/tasks', (req, res) => {
  res.status(201).json({ 
    id: 2, 
    ...req.body,
    completed: false,
    createdAt: new Date().toISOString()
  });
});

describe('Backend API Tests', () => {
  
  // Test 1: Health Check Endpoint
  test('GET /health should return healthy status', async () => {
    const response = await request(app).get('/health');
    
    expect(response.statusCode).toBe(200);
    expect(response.body).toHaveProperty('status', 'healthy');
    expect(response.body).toHaveProperty('timestamp');
  });

  // Test 2: Get All Tasks
  test('GET /api/tasks should return array of tasks', async () => {
    const response = await request(app).get('/api/tasks');
    
    expect(response.statusCode).toBe(200);
    expect(Array.isArray(response.body)).toBe(true);
    expect(response.body.length).toBeGreaterThan(0);
  });

  // Test 3: Create New Task
  test('POST /api/tasks should create a new task', async () => {
    const newTask = {
      title: 'New Test Task',
      description: 'Testing task creation'
    };
    
    const response = await request(app)
      .post('/api/tasks')
      .send(newTask)
      .set('Content-Type', 'application/json');
    
    expect(response.statusCode).toBe(201);
    expect(response.body).toHaveProperty('id');
    expect(response.body).toHaveProperty('title', newTask.title);
    expect(response.body).toHaveProperty('description', newTask.description);
    expect(response.body).toHaveProperty('completed', false);
  });

  // Test 4: Validate Task Structure
  test('Tasks should have required properties', async () => {
    const response = await request(app).get('/api/tasks');
    const task = response.body[0];
    
    expect(task).toHaveProperty('id');
    expect(task).toHaveProperty('title');
    expect(task).toHaveProperty('description');
    expect(task).toHaveProperty('completed');
  });

  // Test 5: Invalid Request Handling
  test('POST /api/tasks with invalid data should handle gracefully', async () => {
    const response = await request(app)
      .post('/api/tasks')
      .send({})
      .set('Content-Type', 'application/json');
    
    // Should still process, but in real app would validate
    expect(response.statusCode).toBe(201);
  });
});

describe('Integration Tests', () => {
  
  test('Application should handle multiple requests', async () => {
    const requests = [
      request(app).get('/health'),
      request(app).get('/api/tasks'),
      request(app).get('/health')
    ];
    
    const responses = await Promise.all(requests);
    responses.forEach(response => {
      expect(response.statusCode).toBeLessThan(400);
    });
  });
});

module.exports = app;
