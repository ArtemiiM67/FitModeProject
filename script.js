// Global State
const state = {
    user: {
        gender: '',
        age: 0,
        height: 0,
        weight: 0,
        frequency: 0,
        goal: ''
    },
    macros: {
        calories: 0,
        protein: 0,
        fat: 0,
        carbs: 0
    },
    consumed: {
        calories: 0,
        protein: 0,
        fat: 0,
        carbs: 0
    },
    onboardingComplete: false,
    tracking: {
        chatStarted: false,
        messages: []
    }
};

// Init
window.addEventListener('DOMContentLoaded', () => {
    // Load saved data
    loadFromStorage();

    // Check if onboarding is complete
    if (state.onboardingComplete) {
        setTimeout(() => {
            showView('home');
            updateDashboard();
        }, 2000);
    } else {
        setTimeout(() => {
            showView('welcome');
        }, 2000);
    }

    document.getElementById('skip-card-btn').addEventListener('click', () => {
        showView('onboarding');
    });

    document.getElementById('user-details-form').addEventListener('submit', (e) => {
        e.preventDefault();
        if (validateForm()) {
            saveUserData();
            showView('goal');
        }
    });

    document.querySelectorAll('.goal-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            state.user.goal = btn.dataset.goal;
            calculateMacros();
            updateDashboard();
            showView('home');
        });
    });

    document.getElementById('back-to-home').addEventListener('click', () => {
        showView('home');
    });

    document.getElementById('nav-track').addEventListener('click', () => {
        showView('home');
    });

    const navTrackTracking = document.getElementById('nav-track-tracking');
    if (navTrackTracking) {
        navTrackTracking.addEventListener('click', () => {
            showView('home');
        });
    }

    document.getElementById('nav-settings').addEventListener('click', () => {
        showView('settings');
    });

    document.getElementById('back-to-home-settings').addEventListener('click', () => {
        showView('home');
    });

    // Settings handlers
    document.getElementById('dark-mode-toggle').addEventListener('change', (e) => {
        document.body.classList.toggle('light-mode', !e.target.checked);
        localStorage.setItem('darkMode', e.target.checked);
    });

    document.getElementById('reset-app-btn').addEventListener('click', () => {
        if (confirm('Are you sure you want to reset the app? All data will be lost.')) {
            resetApp();
        }
    });

    // Load dark mode preference
    const darkMode = localStorage.getItem('darkMode');
    if (darkMode === 'false') {
        document.body.classList.add('light-mode');
        document.getElementById('dark-mode-toggle').checked = false;
    }

    // Additional nav buttons on tracking page
    const navSettingsTracking = document.getElementById('nav-settings-tracking');
    if (navSettingsTracking) {
        navSettingsTracking.addEventListener('click', () => showView('settings'));
    }

    // Additional nav buttons on settings page
    const navTrackSettings = document.getElementById('nav-track-settings');
    if (navTrackSettings) {
        navTrackSettings.addEventListener('click', () => showView('tracking'));
    }

    setupTracking();

    // Track Meal Button - Updated Flow
    const trackMealBtn = document.getElementById('track-meal-btn');
    if (trackMealBtn) {
        trackMealBtn.addEventListener('click', () => {
            // Reset scale view state
            const statusText = document.getElementById('scale-status-text');
            const connectBtn = document.getElementById('connect-scale-btn');
            const pulseRing = document.querySelector('.pulse-ring');

            if (statusText) statusText.textContent = "Please turn on your FitCard Scale";
            if (connectBtn) {
                connectBtn.style.display = 'block';
                connectBtn.textContent = 'Connect';
                connectBtn.disabled = false;
            }
            if (pulseRing) pulseRing.classList.remove('animating');

            showView('scale-connect'); // Navigate to scale connect view first
        });
    }

    // Connect Scale Button
    const connectScaleBtn = document.getElementById('connect-scale-btn');
    if (connectScaleBtn) {
        connectScaleBtn.addEventListener('click', () => {
            const statusText = document.getElementById('scale-status-text');
            const pulseRing = document.querySelector('.pulse-ring');

            // Start Animation
            connectScaleBtn.textContent = 'Connecting...';
            connectScaleBtn.disabled = true;
            pulseRing.classList.add('animating');
            statusText.textContent = "Searching for FitCard Scale...";

            // Simulate Connection Delay
            setTimeout(() => {
                statusText.textContent = "Connected!";
                connectScaleBtn.style.display = 'none';

                setTimeout(() => {
                    showView('tracking');
                    // Ensure chat is ready
                    if (!state.tracking.chatStarted) {
                        state.tracking.chatStarted = true;
                        const inputArea = document.getElementById('food-input-area');
                        if (inputArea) inputArea.classList.remove('hidden');
                        addMessage('ai', "Scale connected! Place your food on the scale and click 'Track Weight'.");
                        saveToStorage();
                    }
                }, 1000);
            }, 2500);
        });
    }

    // Camera Button
    const cameraBtn = document.getElementById('camera-btn');
    if (cameraBtn) {
        cameraBtn.addEventListener('click', () => {
            alert('Camera feature coming soon! (Mock)');
        });
    }
});

function showView(viewName) {
    const views = {
        loading: document.getElementById('loading-view'),
        welcome: document.getElementById('welcome-view'),
        onboarding: document.getElementById('onboarding-view'),
        goal: document.getElementById('goal-view'),
        home: document.getElementById('home-view'),
        tracking: document.getElementById('tracking-view'),
        settings: document.getElementById('settings-view'),
        'scale-connect': document.getElementById('scale-connect-view')
    };

    Object.values(views).forEach(view => {
        if (!view) return;
        view.classList.remove('active');
        setTimeout(() => {
            if (!view.classList.contains('active')) view.classList.add('hidden');
        }, 300);
    });

    const target = views[viewName];
    if (target) {
        target.classList.remove('hidden');
        setTimeout(() => {
            target.classList.add('active');
        }, 10);
    }
}

// ... (validateForm, saveUserData, calculateMacros, updateDashboard remain unchanged) ...

function setupTracking() {
    const chatContainer = document.getElementById('chat-container');
    const inputArea = document.getElementById('food-input-area');
    const input = document.getElementById('food-input');
    const sendBtn = document.getElementById('send-food-btn');
    const trackWeightBtn = document.getElementById('track-weight-btn');

    // Restore chat state if exists
    restoreTrackingState();

    if (trackWeightBtn) {
        trackWeightBtn.addEventListener('click', () => {
            // Simulate receiving weight from scale
            const mockWeight = Math.floor(Math.random() * 200) + 100; // Random weight 100-300g
            addMessage('ai', `Scale: <b>${mockWeight}g</b>`);
            input.focus();
        });
    }

    sendBtn.addEventListener('click', handleFoodSubmit);
    input.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') handleFoodSubmit();
    });

    function handleFoodSubmit() {
        const text = input.value.trim();
        if (!text) return;

        addMessage('user', text);
        input.value = '';

        setTimeout(() => {
            const mockFood = {
                name: text, // Use user input as name
                calories: 350,
                protein: 30,
                carbs: 40,
                fat: 8
            };

            addMessage('ai', `I've analyzed your meal: <b>${mockFood.name}</b><br>
                Calories: ${mockFood.calories}<br>
                Protein: ${mockFood.protein}g<br>
                Carbs: ${mockFood.carbs}g<br>
                Fat: ${mockFood.fat}g<br><br>
                Do you want to log this?`);

            const actions = document.createElement('div');
            actions.className = 'message ai actions';
            actions.innerHTML = `
                <button class="btn btn-sm btn-accent" id="log-yes">Log it</button>
                <button class="btn btn-sm btn-secondary" id="log-no">Don't</button>
            `;
            chatContainer.appendChild(actions);
            chatContainer.scrollTop = chatContainer.scrollHeight;

            document.getElementById('log-yes').addEventListener('click', () => {
                logFood(mockFood);
                actions.remove();
                addMessage('ai', "Logged! Your daily targets have been updated.");
                setTimeout(() => {
                    showView('home');
                }, 1500);
            });

            document.getElementById('log-no').addEventListener('click', () => {
                actions.remove();
                addMessage('ai', "Okay, cancelled.");
            });

        }, 1000);
    }

    function addMessage(sender, html) {
        const msg = document.createElement('div');
        msg.className = `message ${sender}`;
        msg.innerHTML = html;
        chatContainer.appendChild(msg);
        chatContainer.scrollTop = chatContainer.scrollHeight;

        // Save message to state
        state.tracking.messages.push({ sender, html });
        saveToStorage();
    }

    function logFood(food) {
        state.consumed.calories += food.calories;
        state.consumed.protein += food.protein;
        state.consumed.carbs += food.carbs;
        state.consumed.fat += food.fat;
        updateDashboard();
        saveToStorage();
    }
}

function restoreTrackingState() {
    const chatContainer = document.getElementById('chat-container');
    const startBtn = document.getElementById('start-scale-btn');
    const inputArea = document.getElementById('food-input-area');

    if (state.tracking.chatStarted) {
        // Hide start button
        if (startBtn && startBtn.parentElement) {
            startBtn.parentElement.style.display = 'none';
        }

        // Show input area
        inputArea.classList.remove('hidden');

        // Restore messages
        state.tracking.messages.forEach(msg => {
            const msgEl = document.createElement('div');
            msgEl.className = `message ${msg.sender}`;
            msgEl.innerHTML = msg.html;
            chatContainer.appendChild(msgEl);
        });

        chatContainer.scrollTop = chatContainer.scrollHeight;
    }
}

function saveToStorage() {
    localStorage.setItem('fitmode-state', JSON.stringify(state));
}

function loadFromStorage() {
    const saved = localStorage.getItem('fitmode-state');
    if (saved) {
        const loaded = JSON.parse(saved);
        Object.assign(state, loaded);
    }
}

function resetApp() {
    localStorage.clear();
    location.reload();
}
