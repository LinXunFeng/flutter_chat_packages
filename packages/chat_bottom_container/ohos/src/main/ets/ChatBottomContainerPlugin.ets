import { window } from '@kit.ArkUI';
import {
  AbilityAware,
  AbilityPluginBinding,
  FlutterPlugin,
  FlutterPluginBinding,
  Log,
  MethodChannel,
  WindowFocusChangedListener,
} from '@ohos/flutter_ohos';

const TAG = 'ChatBottomContainerPlugin';

export default class ChatBottomContainerPlugin implements FlutterPlugin, AbilityAware,
  WindowFocusChangedListener {
  private channel: MethodChannel | null = null;
  private abilityBinding: AbilityPluginBinding | null = null;
  private mainWindow: window.Window | null = null;
  private attachment = 0;
  private connecting = false;

  private keyboardHeightChanged = (height: number): void => {
    this.sendKeyboardHeight(height);
  };

  getUniqueClassName(): string {
    return TAG;
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), 'chat_bottom_container/ohos');
  }

  onAttachedToAbility(binding: AbilityPluginBinding): void {
    this.detachWindow();
    this.abilityBinding = binding;
    binding.addOnWindowFocusChangedListener(this);
    this.connectWindow();
  }

  onWindowFocusChanged(hasFocus: boolean): void {
    if (hasFocus) {
      // 初次绑定时窗口可能还没创建，窗口获得焦点后再次尝试。
      this.connectWindow();
    }
  }

  private async connectWindow(): Promise<void> {
    const binding = this.abilityBinding;
    if (binding === null || this.mainWindow !== null || this.connecting) return;
    const attachment = this.attachment;
    this.connecting = true;
    try {
      const mainWindow = await window.getLastWindow(binding.getAbility().context);
      // 等待窗口期间可能已经退出页面或切换到另一个 Ability。
      if (attachment !== this.attachment || this.abilityBinding !== binding) return;
      mainWindow.on('keyboardHeightChange', this.keyboardHeightChanged);
      this.mainWindow = mainWindow;
    } catch (error) {
      Log.w(TAG, '暂未绑定键盘高度监听，窗口获得焦点后重试');
    } finally {
      if (attachment === this.attachment) this.connecting = false;
    }
  }

  private sendKeyboardHeight(height: number): void {
    if (this.channel === null || this.mainWindow === null) return;
    try {
      // 系统事件使用物理像素；Dart 面板使用当前窗口的逻辑像素。
      const logicalHeight = this.mainWindow.getUIContext().px2vp(Math.max(0, height));
      this.channel.invokeMethod('keyboardHeight', logicalHeight);
    } catch (error) {
      Log.w(TAG, '窗口已失效，跳过本次键盘高度通知');
    }
  }

  private detachWindow(): void {
    this.attachment++;
    this.connecting = false;
    this.abilityBinding?.removeOnWindowFocusChangedListener(this);
    this.abilityBinding = null;
    if (this.mainWindow !== null) {
      try {
        this.mainWindow.off('keyboardHeightChange', this.keyboardHeightChanged);
      } catch (error) {
        Log.w(TAG, '窗口已销毁，结束键盘监听');
      }
      this.mainWindow = null;
    }
  }

  onDetachedFromAbility(): void {
    this.detachWindow();
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    this.detachWindow();
    this.channel = null;
  }
}
