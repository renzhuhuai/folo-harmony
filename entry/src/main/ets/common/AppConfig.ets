import { common } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN: number = 0x0000;
const TAG: string = 'FoloConfig';
const STORE_NAME: string = 'folo_settings';
const KEY_URL: string = 'web_url';

/** The web app Folo ships; the home screen settings page can point elsewhere when needed. */
export const DEFAULT_URL: string = 'https://app.folo.is/';

export class AppConfig {
  static async getUrl(context: common.Context): Promise<string> {
    try {
      const store: preferences.Preferences = await preferences.getPreferences(context, STORE_NAME);
      const value: preferences.ValueType = await store.get(KEY_URL, DEFAULT_URL);
      if (typeof value === 'string' && value.length > 0) {
        return value;
      }
    } catch (error) {
      hilog.error(DOMAIN, TAG, 'read url failed: %{public}s', JSON.stringify(error));
    }
    return DEFAULT_URL;
  }

  static async setUrl(context: common.Context, url: string): Promise<void> {
    try {
      const store: preferences.Preferences = await preferences.getPreferences(context, STORE_NAME);
      await store.put(KEY_URL, url);
      await store.flush();
    } catch (error) {
      hilog.error(DOMAIN, TAG, 'save url failed: %{public}s', JSON.stringify(error));
    }
  }
}
