let isMenuOpen = false;

// Fonction pour ouvrir le menu
function openArenaMenu() {
    const menu = document.getElementById('arenaMenu');
    menu.classList.remove('hidden');
    isMenuOpen = true;
    
    // Animation d'entrée pour chaque carte
    const cards = document.querySelectorAll('.arena-card');
    cards.forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(30px)';
        setTimeout(() => {
            card.style.transition = 'all 0.5s ease';
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, index * 100);
    });
}

// Fonction pour fermer le menu
function closeArenaMenu() {
    const menu = document.getElementById('arenaMenu');
    menu.classList.add('hidden');
    isMenuOpen = false;
}

// Gestion des clics sur les cartes d'arène
document.querySelectorAll('.arena-card').forEach(card => {
    card.addEventListener('click', function() {
        const arenaId = this.getAttribute('data-arena');
        
        // Animation de sélection
        this.style.transform = 'scale(0.95)';
        setTimeout(() => {
            this.style.transform = 'scale(1)';
        }, 150);
        
        // Envoyer la sélection à FiveM
        fetch(`https://${GetParentResourceName()}/selectArena`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                arena: parseInt(arenaId)
            })
        });
        
        closeArenaMenu();
    });
});

// Gestion des touches
document.addEventListener('keydown', function(event) {
    if (!isMenuOpen) return;
    
    // ESC pour fermer
    if (event.key === 'Escape') {
        fetch(`https://${GetParentResourceName()}/closeMenu`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({})
        });
        closeArenaMenu();
    }
    
    // Touches numériques pour sélection rapide
    const numKey = parseInt(event.key);
    if (numKey >= 1 && numKey <= 4) {
        const card = document.querySelector(`[data-arena="${numKey}"]`);
        if (card) {
            card.click();
        }
    }
});

// Écouter les messages de FiveM
window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.type === 'openArenaMenu') {
        openArenaMenu();
    } else if (data.type === 'closeArenaMenu') {
        closeArenaMenu();
    }
});

// Fermer le menu si on clique en dehors
document.getElementById('arenaMenu').addEventListener('click', function(event) {
    if (event.target === this) {
        fetch(`https://${GetParentResourceName()}/closeMenu`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({})
        });
        closeArenaMenu();
    }
});