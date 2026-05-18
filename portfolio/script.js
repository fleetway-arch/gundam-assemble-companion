document.addEventListener("DOMContentLoaded", () => {
  document.body.classList.add("is-loaded");

  const revealElements = document.querySelectorAll("[data-reveal]");
  if (revealElements.length > 0) {
    revealElements.forEach((element) => element.classList.add("reveal"));

    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add("is-visible");
            observer.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.12 },
    );

    revealElements.forEach((element) => observer.observe(element));
  }

  const projectCards = Array.from(document.querySelectorAll(".project-card"));
  const detailName = document.getElementById("detail-name");
  const detailDescription = document.getElementById("detail-description");
  const detailDifficulties = document.getElementById("detail-difficulties");
  const detailLink = document.getElementById("detail-link");

  const projectDetails = {
    1: {
      intro:
        "A concert discovery app that explores artist and location data with filtering, structured responses, and a clean information layout.",
      highlights: [
        "Structured API data into a browsable experience",
        "Kept the layout readable while exposing useful filtering context",
        "Balanced technical depth with a clean visual presentation",
      ],
    },
    2: {
      intro:
        "A concurrent chat tool built in Go with live messaging, multiple client handling, and a focus on reliable networking behavior.",
      highlights: [
        "Handled concurrent clients without losing clarity in the code",
        "Focused on predictable socket behavior and message flow",
        "Kept the interface minimal so the networking behavior stayed central",
      ],
    },
    3: {
      intro:
        "A playful word game inspired by Wordle, built around Yu-Gi-Oh! cards with fast feedback and a game loop that keeps the experience moving.",
      highlights: [
        "Built a game loop with fast feedback and clear state changes",
        "Kept the interaction playful without making the logic fragile",
        "Used a clean data flow for card-driven gameplay decisions",
      ],
    },
    4: {
      intro:
        "The site redesign you are viewing now: a multi-page portfolio with a clearer hierarchy, usable navigation, and responsive content sections.",
      highlights: [
        "Replaced brittle page structure with a shared system",
        "Made the portfolio useful on both desktop and mobile",
        "Removed dead placeholders and simplified the navigation flow",
      ],
    },
  };

  const setActiveProject = (button) => {
    if (
      !button ||
      !detailName ||
      !detailDescription ||
      !detailDifficulties ||
      !detailLink
    ) {
      return;
    }

    const name = button.dataset.name || "Project";
    const description = button.dataset.description || "";
    const link = button.dataset.link || "";
    const projectInfo = projectDetails[button.dataset.project] || {};
    const highlights = projectInfo.highlights || [];

    projectCards.forEach((card) => {
      card.classList.toggle("is-active", card === button);
      card.setAttribute("aria-pressed", String(card === button));
    });

    detailName.textContent = name;
    detailDescription.textContent = description;
    detailDifficulties.innerHTML = `<strong>What this project highlights</strong><ul>${highlights
      .map((item) => `<li>${item}</li>`)
      .join("")}</ul>`;

    if (link) {
      detailLink.href = link;
      detailLink.hidden = false;
      detailLink.target = "_blank";
      detailLink.rel = "noreferrer";
    } else {
      detailLink.hidden = true;
      detailLink.removeAttribute("href");
      detailLink.removeAttribute("target");
      detailLink.removeAttribute("rel");
    }
  };

  if (projectCards.length > 0) {
    projectCards.forEach((card) => {
      card.addEventListener("click", () => setActiveProject(card));
      card.addEventListener("focus", () => setActiveProject(card));
      card.addEventListener("keydown", (event) => {
        if (event.key === "Enter" || event.key === " ") {
          event.preventDefault();
          setActiveProject(card);
        }
      });
    });

    setActiveProject(projectCards[0]);
  }
});
