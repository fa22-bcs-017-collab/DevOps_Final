class TaskManager {
    constructor() {
        this.apiUrl = '/api/tasks';
        this.tasksList = document.getElementById('tasksList');
        this.taskForm = document.getElementById('taskForm');
        this.init();
    }

    init() {
        this.taskForm.addEventListener('submit', (e) => this.handleSubmit(e));
        this.loadTasks();
    }

    async loadTasks() {
        try {
            this.showLoading();
            const response = await fetch(this.apiUrl);
            if (!response.ok) throw new Error('Failed to fetch tasks');
            
            const tasks = await response.json();
            this.renderTasks(tasks);
        } catch (error) {
            this.showError('Failed to load tasks: ' + error.message);
        }
    }

    async handleSubmit(e) {
        e.preventDefault();
        
        const title = document.getElementById('taskTitle').value.trim();
        const description = document.getElementById('taskDescription').value.trim();
        
        if (!title || !description) {
            this.showError('Please fill in all fields');
            return;
        }

        try {
            const response = await fetch(this.apiUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ title, description })
            });

            if (!response.ok) throw new Error('Failed to create task');
            
            // Clear form
            this.taskForm.reset();
            
            // Reload tasks
            this.loadTasks();
        } catch (error) {
            this.showError('Failed to create task: ' + error.message);
        }
    }

    async toggleComplete(taskId, completed) {
        try {
            const response = await fetch(`${this.apiUrl}/${taskId}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ completed: !completed })
            });

            if (!response.ok) throw new Error('Failed to update task');
            
            this.loadTasks();
        } catch (error) {
            this.showError('Failed to update task: ' + error.message);
        }
    }

    async deleteTask(taskId) {
        if (!confirm('Are you sure you want to delete this task?')) return;
        
        try {
            const response = await fetch(`${this.apiUrl}/${taskId}`, {
                method: 'DELETE'
            });

            if (!response.ok) throw new Error('Failed to delete task');
            
            this.loadTasks();
        } catch (error) {
            this.showError('Failed to delete task: ' + error.message);
        }
    }

    renderTasks(tasks) {
        if (tasks.length === 0) {
            this.tasksList.innerHTML = `
                <div class="loading">
                    <p>No tasks yet. Add your first task above! 🎯</p>
                </div>
            `;
            return;
        }

        this.tasksList.innerHTML = tasks.map(task => `
            <div class="task-item ${task.completed ? 'completed' : ''}">
                <div class="task-title">${this.escapeHtml(task.title)}</div>
                <div class="task-description">${this.escapeHtml(task.description)}</div>
                <div class="task-actions">
                    <button class="complete-btn" onclick="taskManager.toggleComplete('${task._id}', ${task.completed})">
                        ${task.completed ? '↩️ Undo' : '✅ Complete'}
                    </button>
                    <button class="delete-btn" onclick="taskManager.deleteTask('${task._id}')">
                        🗑️ Delete
                    </button>
                </div>
            </div>
        `).join('');
    }

    showLoading() {
        this.tasksList.innerHTML = `
            <div class="loading">
                <p>Loading tasks... ⏳</p>
            </div>
        `;
    }

    showError(message) {
        const errorDiv = document.createElement('div');
        errorDiv.className = 'error';
        errorDiv.textContent = message;
        
        // Remove existing errors
        document.querySelectorAll('.error').forEach(el => el.remove());
        
        // Add new error
        this.tasksList.parentNode.insertBefore(errorDiv, this.tasksList);
        
        // Auto-remove after 5 seconds
        setTimeout(() => errorDiv.remove(), 5000);
    }

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
}

// Initialize the app
const taskManager = new TaskManager();

// Add some demo functionality
document.addEventListener('DOMContentLoaded', () => {
    console.log('🚀 Cloud Pipeline Task Manager loaded!');
    console.log('📊 App Status: Running in browser');
    console.log('🔗 API Endpoint:', '/api/tasks');
});