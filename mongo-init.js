// MongoDB initialization script
db = db.getSiblingDB('taskmanager');

// Create collections
db.createCollection('tasks');

// Create indexes for better performance
db.tasks.createIndex({ "createdAt": -1 });
db.tasks.createIndex({ "completed": 1 });

// Insert sample data for testing
db.tasks.insertMany([
    {
        title: "Setup DevOps Pipeline",
        description: "Configure CI/CD pipeline with Docker and Kubernetes",
        completed: true,
        createdAt: new Date()
    },
    {
        title: "Deploy to Azure AKS",
        description: "Deploy the application to Azure Kubernetes Service",
        completed: false,
        createdAt: new Date()
    },
    {
        title: "Configure Ansible",
        description: "Setup Ansible playbooks for configuration management",
        completed: false,
        createdAt: new Date()
    }
]);

print('✅ Database initialized successfully with sample data');
