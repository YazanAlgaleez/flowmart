# TODO: Implement TikTok-Style Home Screen

## Steps to Complete

- [x] Create lib/models/product.dart: Define Product model class with fields like id, name, price, discount, imageUrl, videoUrl, etc.
- [x] Create dummy product data: Add sample product list in home_page.dart or a separate data file.
- [x] Add video_player dependency: Update pubspec.yaml to include video_player package for video previews.
- [x] Create lib/widgets/product_card.dart: Build ProductCard widget with Stack layout, background image/video, overlay text, and right-side action buttons (like, add to cart, comment).
- [x] Create custom top bar widget: Develop a new widget for the home screen top bar with shop logo, search icon, and filter options.
- [x] Modify lib/pages/home_page.dart: Implement PageView.builder for vertical scrolling, manage state for likes/cart, handle gestures (double-tap to like, drag to add to cart).
- [x] Add action handlers: Implement logic for like toggles, add to cart, and comment/review (opens dialog or navigates to page).
- [x] Update lib/main.dart: Change home to HomePage if not already set.
- [ ] Test vertical scrolling and animations: Ensure smooth transitions and responsiveness.
- [ ] Implement gestures and state management: Verify double-tap, drag gestures, and state persistence.
- [ ] Add comment/review functionality: Complete the comment feature with UI.
- [ ] Ensure responsive design: Use ScreenUtil for proper scaling across devices.
