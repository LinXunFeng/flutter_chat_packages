# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## 2025-06-26

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`chat_bottom_container` - `v0.3.2`](#chat_bottom_container---v032)

---

#### `chat_bottom_container` - `v0.3.2`

 - **FIX**(chat_bottom_container): remove listeners from inputFocusNode when ChatBottomPanelContainer is disposed.


## 2025-03-23

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`chat_bottom_container` - `v0.3.1`](#chat_bottom_container---v031)

---

#### `chat_bottom_container` - `v0.3.1`

 - **FEAT**(chat_bottom_container): allow switching focusNode.


## 2024-12-04

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`chat_bottom_container` - `v0.3.0`](#chat_bottom_container---v030)
 - [`chat_bottom_container` - `0.2.1`](#chat_bottom_container---021)
 - [`chat_bottom_container` - `0.2.0`](#chat_bottom_container---020)
 - [`chat_bottom_container` - `0.1.0`](#chat_bottom_container---010)

---

#### `chat_bottom_container` - `v0.3.0`

 - **FEAT**(chat_bottom_container): add safeAreaBottom to ChatBottomPanelContainerController.


#### `chat_bottom_container` - `0.2.1`

* Avoid conflicts with flutter engine's view event listener on Android.

#### `chat_bottom_container` - `0.2.0`

* Support switching to other panel, the input box gets the focus and displays the cursor.
* Record keyboard height to optimize user experience next time.

#### `chat_bottom_container` - `0.1.0`

* Adjust keyboard height listener manager logic.
* Add `safeAreaBottom` and `changeKeyboardPanelHeight`.
* Adjust the logic about obtaining the bottom height of the safe area.
* Adjust the constraints of the SDK (sdk: ">=3.0.0 <4.0.0").
* Fix version of `FSAChatBottomContainer.xcframework`.
