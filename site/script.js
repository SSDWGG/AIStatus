const translations = {
    zh: {
        title: "AiStatus - macOS 菜单栏 AI 状态灯",
        description: "AiStatus 是一款 macOS 菜单栏工具，用状态灯显示本机 Codex/GPT 和 Claude Code 是否正在处理任务，并提供防休眠开关。",
        headerAria: "主导航",
        brandAria: "AiStatus 首页",
        navAria: "页面导航",
        navFeatures: "功能",
        navPrivacy: "隐私",
        navInstall: "安装",
        navDownload: "下载 DMG",
        languageLabel: "Switch to English",
        languageButton: "EN",
        heroEyebrow: "macOS menu bar utility",
        heroTitle: "直视AI任务状态",
        heroLede: "AiStatus 用一颗状态灯显示本机 Codex/GPT 与 Claude Code 是否正在工作，并提供一个可手动开启的防休眠开关。",
        downloadActionsAria: "下载操作",
        heroDownload: "下载 macOS 版",
        heroChecksum: "查看 SHA-256",
        releaseAria: "版本信息",
        releaseVersion: "版本",
        releaseFormat: "格式",
        releaseSize: "大小",
        releaseSizeValue: "约 1.2 MB",
        productAria: "AiStatus 产品预览",
        iconAlt: "AiStatus 图标",
        panelKicker: "当前状态",
        panelState: "蓝灯，GPT + Claude 正在使用",
        activeSessionOne: "活跃会话 1",
        sleepPrevention: "防休眠",
        enabled: "已开启",
        latestEvent: "最近事件",
        sampleRunningTitle: "整理项目状态和会话标题",
        sampleEndedTitle: "修复防休眠显示器断言",
        running: "运行中",
        ended: "已结束",
        featuresEyebrow: "What it watches",
        featuresTitle: "只做一件事：直视本机 AI 任务状态",
        featureOneTitle: "菜单栏状态灯",
        featureOneText: "蓝灯代表 GPT 或 Claude 正在处理任务，绿灯代表两者都空闲。无需切回终端就能扫一眼确认。",
        featureOneDetail: "状态灯直接贴在菜单栏里，适合在多个窗口之间切换时保留一个持续可见的任务信号。",
        featureTwoTitle: "会话标题列表",
        featureTwoText: "读取 Codex 和 Claude Code 的本机会话事件，展示活跃和闲置会话标题，方便快速定位最近任务。",
        featureTwoDetail: "列表把 GPT 与 Claude 的状态放在同一处，减少分别打开终端、日志和编辑器确认进度的来回切换。",
        featureThreeTitle: "防休眠开关",
        featureThreeText: "需要长时间等待模型输出时，可手动开启保持活跃，阻止系统和显示器因空闲进入睡眠。",
        featureThreeDetail: "防休眠使用 macOS 电源断言，只有用户手动开启时才生效，适合长时间任务和外接显示器场景。",
        featureFourTitle: "结束通知",
        featureFourText: "当活跃会话变为空闲时，桌面通知会提示哪个会话刚结束，减少反复查看窗口的打断。",
        featureFourDetail: "通知只在状态从运行切到空闲时出现，让你能继续做别的事，同时知道哪个 AI 任务刚刚结束。",
        privacyEyebrow: "Local first",
        privacyTitle: "本地解析，不上传会话正文。",
        privacyText: "AiStatus 只读取运行状态和用于展示的会话标题。它不复制完整会话正文，也不需要远程账号。当前版本面向本机使用场景，所有状态判断都在你的 Mac 上完成。",
        privacyItemCodex: "读取 <code>~/.codex/sessions</code> 的任务事件",
        privacyItemClaude: "读取 <code>~/.claude/projects</code> 的 Claude Code 事件",
        privacyItemSleep: "防休眠功能必须由用户手动开启",
        installEyebrow: "Install",
        installTitle: "下载 DMG，拖入 Applications。",
        installStepOneTitle: "下载",
        installStepOneText: "获取当前版本的 DMG 安装包。",
        installStepOneLink: "下载 AiStatus-0.1.0.dmg",
        installStepTwoTitle: "安装",
        installStepTwoText: "打开 DMG，把 AiStatus 拖到 Applications。",
        installStepThreeTitle: "运行",
        installStepThreeText: "从 Applications 启动，菜单栏出现状态灯后即可使用。",
        securityEyebrow: "Gatekeeper",
        securityTitle: "如果提示“Apple 无法验证”，这样打开。",
        securityIntro: "当前 DMG 使用非 Apple 认证证书签名，首次打开时 macOS 可能拦截。确认你从本站下载后，可以在系统设置中手动允许。",
        securityStepOne: "看到“Apple 无法验证是否包含可能危害...”提示时，先点“完成”或关闭提示。",
        securityStepTwo: "打开“系统设置” → “隐私与安全性”。",
        securityStepThree: "滚动到“安全性”，找到 AiStatus 被阻止的提示，点击“仍要打开”。",
        securityStepFour: "输入密码或使用 Touch ID，再点击“打开”。之后即可正常启动。",
        securityVisualPrivacy: "隐私与安全性",
        securityVisualTitle: "安全性",
        securityVisualText: "“AiStatus” 已被阻止使用，因为 Apple 无法验证是否包含恶意软件。",
        securityVisualButton: "仍要打开",
        securityVisualWarning: "Apple 无法验证“AiStatus”是否包含可能危害 Mac 的恶意软件。",
        currentRelease: "Current release",
        downloadPanelText: "DMG SHA-256 校验文件随包提供，适合放到下载页一起发布。",
        downloadDmg: "下载 DMG",
        copySha: "复制 SHA-256",
        copied: "已复制",
        footerDownload: "下载"
    },
    en: {
        title: "AiStatus - macOS menu bar status for AI tasks",
        description: "AiStatus is a macOS menu bar utility that shows whether local Codex/GPT and Claude Code tasks are active, with optional sleep prevention.",
        headerAria: "Main navigation",
        brandAria: "AiStatus home",
        navAria: "Page navigation",
        navFeatures: "Features",
        navPrivacy: "Privacy",
        navInstall: "Install",
        navDownload: "Download DMG",
        languageLabel: "切换到中文",
        languageButton: "中",
        heroEyebrow: "macOS menu bar utility",
        heroTitle: "See AI task status",
        heroLede: "AiStatus uses a menu bar light to show whether local Codex/GPT and Claude Code are still working, plus a manual sleep-prevention switch.",
        downloadActionsAria: "Download actions",
        heroDownload: "Download for macOS",
        heroChecksum: "View SHA-256",
        releaseAria: "Release information",
        releaseVersion: "Version",
        releaseFormat: "Format",
        releaseSize: "Size",
        releaseSizeValue: "About 1.2 MB",
        productAria: "AiStatus product preview",
        iconAlt: "AiStatus icon",
        panelKicker: "Current status",
        panelState: "Blue light, GPT + Claude active",
        activeSessionOne: "1 active session",
        sleepPrevention: "Keep awake",
        enabled: "Enabled",
        latestEvent: "Latest event",
        sampleRunningTitle: "Reviewing project state and session titles",
        sampleEndedTitle: "Fixed display sleep prevention assertion",
        running: "Running",
        ended: "Ended",
        featuresEyebrow: "What it watches",
        featuresTitle: "One job: see local AI task status",
        featureOneTitle: "Menu bar status light",
        featureOneText: "Blue means GPT or Claude is working. Green means both are idle. Check status without switching back to a terminal.",
        featureOneDetail: "The light stays in the menu bar, keeping one persistent task signal visible while you move between windows.",
        featureTwoTitle: "Session title lists",
        featureTwoText: "Reads local Codex and Claude Code session events, then shows active and idle session titles for quick orientation.",
        featureTwoDetail: "GPT and Claude states live in one place, reducing the need to bounce between terminals, logs, and editor windows.",
        featureThreeTitle: "Sleep prevention",
        featureThreeText: "When a model run may take a while, manually keep the Mac active and prevent idle system or display sleep.",
        featureThreeDetail: "Sleep prevention uses macOS power assertions and only runs when you enable it, including long jobs and external display setups.",
        featureFourTitle: "Completion notifications",
        featureFourText: "When an active session becomes idle, a desktop notification tells you which session just finished.",
        featureFourDetail: "Notifications appear only when a session changes from running to idle, so you can keep working elsewhere and still catch completion.",
        privacyEyebrow: "Local first",
        privacyTitle: "Local parsing. No transcript upload.",
        privacyText: "AiStatus only reads runtime state and session titles for display. It does not copy full transcripts and does not require a remote account. Status checks happen on your Mac.",
        privacyItemCodex: "Reads task events from <code>~/.codex/sessions</code>",
        privacyItemClaude: "Reads Claude Code events from <code>~/.claude/projects</code>",
        privacyItemSleep: "Sleep prevention is only enabled manually by the user",
        installEyebrow: "Install",
        installTitle: "Download the DMG. Drag to Applications.",
        installStepOneTitle: "Download",
        installStepOneText: "Get the current DMG release.",
        installStepOneLink: "Download AiStatus-0.1.0.dmg",
        installStepTwoTitle: "Install",
        installStepTwoText: "Open the DMG and drag AiStatus into Applications.",
        installStepThreeTitle: "Run",
        installStepThreeText: "Launch from Applications. Use the menu bar light once it appears.",
        securityEyebrow: "Gatekeeper",
        securityTitle: "If macOS says Apple cannot verify the app, open it this way.",
        securityIntro: "This DMG is signed without an Apple-certified Developer ID certificate. macOS may block the first launch. If you downloaded it from this page, allow it manually in System Settings.",
        securityStepOne: "When the warning says Apple cannot verify whether the app may harm your Mac, click Done or close the dialog.",
        securityStepTwo: "Open System Settings -> Privacy & Security.",
        securityStepThree: "Scroll to Security, find the AiStatus blocked message, then click Open Anyway.",
        securityStepFour: "Authenticate with your password or Touch ID, then click Open. Future launches should work normally.",
        securityVisualPrivacy: "Privacy & Security",
        securityVisualTitle: "Security",
        securityVisualText: "\"AiStatus\" was blocked because Apple cannot check it for malicious software.",
        securityVisualButton: "Open Anyway",
        securityVisualWarning: "Apple cannot verify whether \"AiStatus\" contains malware that may harm your Mac.",
        currentRelease: "Current release",
        downloadPanelText: "The SHA-256 checksum ships with the DMG and can be published beside the download.",
        downloadDmg: "Download DMG",
        copySha: "Copy SHA-256",
        copied: "Copied",
        footerDownload: "Download"
    }
};

const supportedLanguages = Object.keys(translations);
const savedLanguage = localStorage.getItem("aistatus-language");
const requestedLanguage = new URLSearchParams(window.location.search).get("lang");
const initialLanguage = supportedLanguages.includes(requestedLanguage)
    ? requestedLanguage
    : supportedLanguages.includes(savedLanguage) ? savedLanguage : "zh";

function applyLanguage(language) {
    const dictionary = translations[language] || translations.zh;
    const nextLanguage = language === "zh" ? "en" : "zh";
    const metaDescription = document.querySelector('meta[name="description"]');
    const toggle = document.querySelector("[data-lang-toggle]");
    const toggleLabel = document.querySelector("[data-lang-current]");

    document.documentElement.lang = language === "zh" ? "zh-CN" : "en";
    document.title = dictionary.title;

    if (metaDescription) {
        metaDescription.setAttribute("content", dictionary.description);
    }

    document.querySelectorAll("[data-i18n]").forEach((element) => {
        const key = element.getAttribute("data-i18n");
        if (key && dictionary[key]) {
            element.textContent = dictionary[key];
        }
    });

    document.querySelectorAll("[data-i18n-html]").forEach((element) => {
        const key = element.getAttribute("data-i18n-html");
        if (key && dictionary[key]) {
            element.innerHTML = dictionary[key];
        }
    });

    document.querySelectorAll("[data-i18n-attr]").forEach((element) => {
        const attributePairs = element.getAttribute("data-i18n-attr").split(",");
        for (const pair of attributePairs) {
            const [attribute, key] = pair.split(":").map((value) => value.trim());
            if (attribute && key && dictionary[key]) {
                element.setAttribute(attribute, dictionary[key]);
            }
        }
    });

    if (toggle) {
        toggle.setAttribute("aria-label", dictionary.languageLabel);
        toggle.setAttribute("aria-pressed", String(language === "en"));
        toggle.dataset.nextLanguage = nextLanguage;
    }

    if (toggleLabel) {
        toggleLabel.textContent = dictionary.languageButton;
    }

    localStorage.setItem("aistatus-language", language);
}

document.querySelector("[data-lang-toggle]")?.addEventListener("click", (event) => {
    const nextLanguage = event.currentTarget.dataset.nextLanguage || "en";
    applyLanguage(nextLanguage);
});

applyLanguage(initialLanguage);

const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)");
const hasPrecisePointer = window.matchMedia("(pointer: fine)").matches;

function initCursorFollower() {
    const cursor = document.querySelector("[data-cursor]");

    if (!cursor || reduceMotion.matches || !hasPrecisePointer) {
        return;
    }

    document.documentElement.classList.add("cursor-enabled");

    const state = {
        x: window.innerWidth / 2,
        y: window.innerHeight / 2,
        vx: 0,
        vy: 0,
        targetX: window.innerWidth / 2,
        targetY: window.innerHeight / 2
    };

    window.addEventListener("pointermove", (event) => {
        state.targetX = event.clientX;
        state.targetY = event.clientY;
        document.documentElement.classList.add("cursor-ready");

        if (event.target.closest("a, button, [data-spring-card]")) {
            document.documentElement.classList.add("cursor-active");
        } else {
            document.documentElement.classList.remove("cursor-active");
        }
    }, { passive: true });

    const tick = () => {
        state.vx += (state.targetX - state.x) * 0.18;
        state.vy += (state.targetY - state.y) * 0.18;
        state.vx *= 0.68;
        state.vy *= 0.68;
        state.x += state.vx;
        state.y += state.vy;
        cursor.style.transform = `translate3d(${state.x}px, ${state.y}px, 0)`;
        window.requestAnimationFrame(tick);
    };

    tick();
}

function initSpringCards() {
    if (reduceMotion.matches || !hasPrecisePointer) {
        return;
    }

    document.querySelectorAll("[data-spring-card]").forEach((card) => {
        const state = {
            x: 0,
            y: 0,
            rx: 0,
            ry: 0,
            scale: 1,
            vx: 0,
            vy: 0,
            vrx: 0,
            vry: 0,
            vs: 0,
            tx: 0,
            ty: 0,
            trx: 0,
            try: 0,
            ts: 1
        };

        const animate = () => {
            state.vx += (state.tx - state.x) * 0.15;
            state.vy += (state.ty - state.y) * 0.15;
            state.vrx += (state.trx - state.rx) * 0.14;
            state.vry += (state.try - state.ry) * 0.14;
            state.vs += (state.ts - state.scale) * 0.18;

            state.vx *= 0.66;
            state.vy *= 0.66;
            state.vrx *= 0.66;
            state.vry *= 0.66;
            state.vs *= 0.62;

            state.x += state.vx;
            state.y += state.vy;
            state.rx += state.vrx;
            state.ry += state.vry;
            state.scale += state.vs;

            card.style.setProperty("--spring-x", `${state.x.toFixed(2)}px`);
            card.style.setProperty("--spring-y", `${state.y.toFixed(2)}px`);
            card.style.setProperty("--spring-rx", `${state.rx.toFixed(2)}deg`);
            card.style.setProperty("--spring-ry", `${state.ry.toFixed(2)}deg`);
            card.style.setProperty("--spring-scale", state.scale.toFixed(4));

            window.requestAnimationFrame(animate);
        };

        card.addEventListener("pointermove", (event) => {
            const rect = card.getBoundingClientRect();
            const px = (event.clientX - rect.left) / rect.width - 0.5;
            const py = (event.clientY - rect.top) / rect.height - 0.5;
            state.tx = px * 7;
            state.ty = py * 7;
            state.trx = py * -4.2;
            state.try = px * 4.2;
            state.ts = 1.012;
        }, { passive: true });

        card.addEventListener("pointerleave", () => {
            state.tx = 0;
            state.ty = 0;
            state.trx = 0;
            state.try = 0;
            state.ts = 1;
        });

        card.addEventListener("pointerdown", () => {
            state.ts = 0.982;
        });

        card.addEventListener("pointerup", () => {
            state.ts = 1.018;
            window.setTimeout(() => {
                state.ts = 1;
            }, 120);
        });

        animate();
    });
}

function initExpandableCards() {
    document.querySelectorAll("[data-expand-card]").forEach((card) => {
        const toggle = card.querySelector(".feature-card-toggle");

        if (!toggle) {
            return;
        }

        toggle.addEventListener("click", () => {
            const isExpanded = card.classList.toggle("is-expanded");
            toggle.setAttribute("aria-expanded", String(isExpanded));
        });
    });
}

initCursorFollower();
initSpringCards();
initExpandableCards();

const revealTargets = document.querySelectorAll(".section, .feature-card, .install-step, .download-panel, .security-help");

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
        const language = localStorage.getItem("aistatus-language") || "zh";
        const dictionary = translations[language] || translations.zh;
        const sourceID = button.getAttribute("data-copy-source");
        const source = sourceID ? document.getElementById(sourceID) : null;

        if (!source) {
            return;
        }

        const originalText = button.textContent;
        try {
            await navigator.clipboard.writeText(source.textContent.trim());
            button.textContent = dictionary.copied;
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
