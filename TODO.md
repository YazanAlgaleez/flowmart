# TODO: Make All Files More Reusable

## Overview
Refactor the codebase to improve reusability by extracting hardcoded values, making styles configurable, and separating data logic from UI components.

## Tasks
- [x] Refactor `lib/core/styling/app_styles.dart`: Convert static TextStyles to functions with parameters for color, size, weight, etc.
- [x] Refactor `lib/widgets/product_card.dart`: Extract inline styles to `app_styles.dart`, make the widget accept custom styles and actions via parameters.
- [x] Refactor `lib/pages/home_page.dart`: Move hardcoded products list to a provider (e.g., `ProductProvider`), make the page accept a list of products or use a service.
- [ ] Check and refactor other pages/widgets (e.g., `login_page.dart`, `register_page.dart`, `search_page.dart`) for hardcoded styles or logic, extract to reusable components.
- [ ] Update `lib/core/widgets/` files to use configurable styles from `app_styles.dart`.
- [ ] Ensure `main.dart` and routing are flexible for different themes/data.

## Followup Steps
- Run the app to test changes.
- Verify that components can be reused in different contexts without hardcoding.
