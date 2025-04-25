import type { StrapiApp } from '@strapi/strapi/admin';  // Importing types for type checking

const config = {
  // Replace the Strapi logo in auth (login) views
  auth: {
    // Removed logo section
  },
  // Replace the favicon
  head: {
    // Removed favicon section
  },
  // Replace the Strapi logo in the main navigation
  menu: {
    // Removed menu logo section
  },
  // Extend the translations
  translations: {
    en: {
      "app.components.LeftMenu.navbrand.title": "Struggle to success",

      "app.components.LeftMenu.navbrand.workplace": "admin",

      "Auth.form.welcome.title": "Welcome to Admin Panel",

      "Auth.form.welcome.subtitle": "Login to your account",

      "Settings.profile.form.section.experience.interfaceLanguageHelp":
        "Preference changes will apply only to you.",
    },
  },
  // Disable video tutorials
  tutorials: false,
  // Disable notifications about new Strapi releases
  notifications: { releases: false },
};

const bootstrap = (app: StrapiApp) => {
  console.log(app);  // Logging the app instance for debugging
};

export default {
  config,
  bootstrap,
};
