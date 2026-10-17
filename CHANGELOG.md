## 1.0.0

- Added first-class skeleton support for Form Controls & Selection Inputs:
  - `Checkbox` & `CheckboxListTile`: Rounded square box placeholder with leading/trailing text lines, secondary widget, and `controlAffinity` support.
  - `Switch` & `SwitchListTile`: Pill-shaped toggle indicator with thumb circle and `controlAffinity` support.
  - `Radio` & `RadioListTile`: Circular radio button placeholder with inner dot indicator and `controlAffinity` support.
  - `Slider` & `RangeSlider`: Horizontal track line with circular thumb indicator(s) and active track segments.
  - `DropdownButton` & `DropdownMenu`: Outlined container with placeholder text, optional leading icon, and trailing chevron.
- Added full RTL directionality awareness for all form controls and list tiles.
- Updated `WidgetBlueprintParser` with blueprint parsing for form and selection widgets.
- Updated size heuristics in `size_resolver` for all form widgets in `Column`, `Row`, `Wrap`, and `Stack`.
- Added comprehensive unit and widget tests covering form controls and selection inputs.

## 0.0.4

- Added support for essential layout wrappers and spacing widgets:
  - `SafeArea`
  - `Opacity` and `AnimatedOpacity`
  - `Offstage`
  - `Spacer` (with custom flex factor support in `Row` and `Column`)
  - `ConstrainedBox`
  - `FractionallySizedBox`
  - `LimitedBox`
  - `ClipRect`
- Updated `WidgetBlueprintParser` to parse children inside layout and clipping wrappers.
- Added comprehensive unit and widget tests for all newly supported widgets.


## 0.0.3

- Added support for Flutter's `Visibility` widget across shimmer painting, size estimation, and layout handling.
- Supported `visible`, `replacement`, and `maintainSize` modes for `Visibility`.
- Added unit and widget tests for `Visibility`.


## 0.0.2

- Fixed pub.dev static analysis lint issues.
- Improved internal part-file organization.
- Removed unnecessary imports.
- Updated package documentation.


## 0.0.1

- Initial release of Auto Shimmer Widget.
- Added automatic shimmer skeleton generation from existing Flutter widgets.
- Added support for common widgets such as Container, Row, Column, Stack, ListTile, Card, Wrap, Chip, TextField, and buttons.
- Added ListView, ListView.builder, GridView, and GridView.builder skeleton support.
- Added multiple shimmer animation types including slide, wave, pulse, breathe, glow, bounce, and none.
- Added shimmer speed, color, direction, border radius, item count, and grid count customization.
- Added dark mode support with system, light, and dark theme modes.
- Added RTL support for Arabic and other right-to-left layouts.
- Added example app, screenshots, GIF demo, and documentation.