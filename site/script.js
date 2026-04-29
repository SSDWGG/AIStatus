const revealTargets = document.querySelectorAll(".section, .feature-card, .install-step, .download-panel");

if ("IntersectionObserver" in window) {
    const observer = new IntersectionObserver(
        (entries) => {
            for (const entry of entries) {
                if (entry.isIntersecting) {
                    entry.target.classList.add("is-visible");
                    observer.unobserve(entry.target);
                }
            }
        },
        { threshold: 0.14 }
    );

    revealTargets.forEach((target, index) => {
        target.classList.add("reveal");
        target.style.transitionDelay = `${Math.min(index * 45, 220)}ms`;
        observer.observe(target);
    });
} else {
    revealTargets.forEach((target) => target.classList.add("is-visible"));
}

document.querySelectorAll("[data-copy-source]").forEach((button) => {
    button.addEventListener("click", async () => {
        const sourceID = button.getAttribute("data-copy-source");
        const source = sourceID ? document.getElementById(sourceID) : null;

        if (!source) {
            return;
        }

        const originalText = button.textContent;
        try {
            await navigator.clipboard.writeText(source.textContent.trim());
            button.textContent = "已复制";
            button.classList.add("is-copied");
            window.setTimeout(() => {
                button.textContent = originalText;
                button.classList.remove("is-copied");
            }, 1800);
        } catch {
            source.focus();
        }
    });
});
