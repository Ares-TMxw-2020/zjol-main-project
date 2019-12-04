package cn.com.zjol;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.os.Bundle;
import android.os.Process;
import android.os.SystemClock;
import android.support.multidex.MultiDexApplication;
import android.support.text.emoji.EmojiCompat;
import android.support.text.emoji.bundled.BundledEmojiCompatConfig;
import android.support.v4.content.res.ResourcesCompat;
import android.text.TextUtils;
import android.util.Log;

import com.aliya.uimode.UiModeManager;
import com.core.glide.GlideMode;
import com.meituan.android.walle.WalleChannelReader;
import com.tencent.bugly.crashreport.CrashReport;
import com.umeng.commonsdk.UMConfigure;
import com.umeng.socialize.PlatformConfig;
import com.umeng.socialize.UMShareAPI;
import com.umeng.socialize.UMShareConfig;
import com.zjol.video.UGC;
import com.zjrb.core.utils.AppUtils;
import com.zjrb.core.utils.UIUtils;
import com.zjrb.daily.db.DatabaseLoader;
import com.zjrb.daily.db.ReadRecordHelper;
import com.zjrb.passport.ZbConfig;
import com.zjrb.passport.ZbPassport;
import com.zjrb.passport.constant.ZbConstants;

import cn.com.zjol.biz.core.Mobsec;
import cn.com.zjol.biz.core.UserBiz;
import cn.com.zjol.biz.core.db.SettingManager;
import cn.com.zjol.biz.core.db.ThemeMode;
import cn.com.zjol.biz.core.network.DailyNetworkManager;
import cn.com.zjol.me.util.Contacts;
import cn.com.zjol.push.Push;
import cn.com.zjol.push.insight.Insight;
import cn.com.zjol.quick_login.OneClickLogin;
import cn.daily.news.analytics.AnalyticsManager;
import cn.daily.news.update.UpdateManager;
import zjol.com.cn.launcher.SplashActivity;
import zjol.com.cn.location.OnLineLocationManager;

public class ZjolApplication extends MultiDexApplication {

    private Application mApp;
    private boolean debuggable;
    private String mChannel;

    // 正式版
    String ugcLicenceUrl = "http://license.vod2.myqcloud.com/license/v1/5dc9e2376e5650783cb2197bd26661f7/TXUgcSDK.licence";
    String ugcKey = "98be69985348b84dd20ea564aaa9fb32";

    @Override
    public void onCreate() {
        super.onCreate();
        mApp = this;
        UIUtils.init(this);
        boolean isMainProcess = TextUtils.equals(getPackageName(), AppUtils.getProcessName(Process.myPid()));
        if (isMainProcess) {
            new Thread(new Runnable() {

                @Override
                public void run() {
                    UiModeManager.init(mApp, null);

                    // 字体提前加载并缓存
                    ResourcesCompat.getFont(mApp, R.font.fzbiaoysk_zbjt);
                    ResourcesCompat.getFont(mApp, R.font.fzzcysk_zbjt);

                    DatabaseLoader.init(mApp);
                    ReadRecordHelper.initReadIds();
                    GlideMode.setProvincialTraffic(SettingManager.getInstance().isProvincialTraffic());
                    Push.init(mApp);
                    Insight.init(mApp);
                    Contacts.init(mApp);
                    OneClickLogin.init(mApp, "ad356081117148588b7c2376333de0a5");
                    //放在所有初始化的最后面，防止其他第三方SDK重写UncaughtExceptionHandler被覆盖
                    initCrashHandler(debuggable);

                    getTheme().applyStyle(R.style.FangZhengFontTheme, false);

                    // 网易易盾初始化
                    Mobsec.init(getApplicationContext(), "YD00980345767024");
                }
            }).start();
            debuggable = UIUtils.isDebuggable();
            DailyNetworkManager.init(this);
            mChannel = WalleChannelReader.getChannel(this);
            if (TextUtils.isEmpty(mChannel)) {
                mChannel = "bianfeng";
            }
            AppUtils.setChannel(mChannel);
            UpdateManager.init(this);
            OnLineLocationManager.getInstance().locationUseGpsThenIp(null);
            UGC.init(this, ugcLicenceUrl, ugcKey); // 腾讯小视频初始化
            initUmeng(this, mChannel);
            initPassport(debuggable);
            initAnalytic(debuggable);
            BundledEmojiCompatConfig compatConfig = new BundledEmojiCompatConfig(this);
            EmojiCompat.init(compatConfig);
        } else {
            UiModeManager.init(mApp, null);
        }
        registerActivityLifecycleCallbacks(mLifecycleCallbacks);
    }

    /**
     * 浙报通行证初始化
     */
    private void initPassport(boolean isDebug) {
        String passport = SettingManager.getInstance().getPassport();
        String[] params = passport.split("#");
        passport = params[0];
        String clientId = params[1];
        ZbPassport.init(this,
                new ZbConfig.Builder().setEnvType(isDebug ? ZbConstants.Env.CUSTOM : ZbConstants.Env.OFFICIAL)
                        .setDebug(isDebug)
                        .setHost(passport)
                        .setAppVersion("1.0")
                        .setClientId(isDebug ? Integer.parseInt(clientId) : 44)
                        .setAppUuid("uuid"));
    }

    /**
     * 初始化埋点相关信息
     */
    private void initAnalytic(boolean isDebug) {
        String appKey = isDebug ? "jzcif5f3_07rbh5dzvuuk9" : "jzcid4st_04o7ebuj3yhqv";
        long mpID = isDebug ? 102 : 100;
        String statisticsURL = isDebug ? "https://ta.8531.cn/c" : "https://ta.8531.cn/c";

        AnalyticsManager.TAConfig taConfig = new AnalyticsManager.TAConfig(appKey, mpID, statisticsURL);
        taConfig.setEnable(true);
        if (UserBiz.get() != null && UserBiz.get().isLoginUser()) {
            taConfig.setAccountId(UserBiz.get().getAccountID());
        }

        String saStatisticsURL = isDebug ? "http://sa.tmuyun.com/sa?project=zjxwtest" : "http://sa.tmuyun.com/sa?project=zjxwprod";
        AnalyticsManager.SAConfig saConfig = new AnalyticsManager.SAConfig(saStatisticsURL);
        saConfig.setEnable(false);
        if (UserBiz.get() != null && UserBiz.get().isLoginUser()) {
            saConfig.setAccountId(UserBiz.get().getAccountID());
        }
        saConfig.setLogEnable(false);
        saConfig.setAutoTrack(false);

        String logService = "dot.wts.xinwen.cn";
        AnalyticsManager.SHWConfig shwConfig = new AnalyticsManager.SHWConfig("", "", logService);
        shwConfig.setImmediateReport(false);
        shwConfig.setLogEnable(false);
        shwConfig.setEnable(false);
        if (UserBiz.get() != null && UserBiz.get().isLoginUser()) {
            shwConfig.setAccountId(UserBiz.get().getAccountID());
        }

        AnalyticsManager.initAnalytics(this, AppUtils.getChannelName(), taConfig, saConfig, shwConfig);
    }


    /**
     * 友盟第三方登录
     */
    private void initUmeng(Context context, String channel) {
        UMConfigure.init(context, "5d5664b53fc19587cb000f83", channel, UMConfigure.DEVICE_TYPE_PHONE, "");
        UMShareAPI.get(context).setShareConfig(new UMShareConfig().isNeedAuthOnGetUserInfo(true));
        PlatformConfig.setWeixin("wx6979efeb905e22f3", "b483df3317162dab6fb0b17aac581026");
        PlatformConfig.setSinaWeibo("1688425623", "7be1dd6d1365a8bc307c253366e3ab5a", "https://www.zjol.com.cn");
        PlatformConfig.setQQZone("101781365", "c84c1077680a30601670e741265e1442");
        PlatformConfig.setDing("dingoa65puwgwj5n2tpzlf");
    }

    /**
     * 初始化Bugly配置
     */
    private void initCrashHandler(boolean isDebug) {
        CrashHandler.getInstance().init(this);
        // 设置上报进程为主进程
        String processName = AppUtils.getProcessName(android.os.Process.myPid());
        CrashReport.UserStrategy strategy = new CrashReport.UserStrategy(this);
        strategy.setUploadProcess(processName == null || processName.equals(getPackageName()));
        CrashReport.initCrashReport(this, UIUtils.getString(R.string.BUGLY_APPID), isDebug, strategy);
        // 设置当前APP渠道
        CrashReport.setAppChannel(this, mChannel);
        // 设置唯一设备值
        CrashReport.setUserId(AppUtils.getUniquePsuedoID());
    }

    private ActivityLifecycleCallbacks mLifecycleCallbacks = new ActivityLifecycleCallbacks() {

        @Override
        public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
            if (!(activity instanceof SplashActivity)) {
                // 全局修改TextView字体，第二个参数:false 表示不强制覆盖原主题设置过的字体
                activity.getTheme().applyStyle(R.style.FangZhengFontTheme, false);
            }
        }

        @Override
        public void onActivityStarted(Activity activity) {
            OneClickLogin.fitChinaMobileTypeface(activity, R.font.fzbiaoysk_zbjt);
        }

        @Override
        public void onActivityResumed(Activity activity) {
        }

        @Override
        public void onActivityPaused(Activity activity) {
        }

        @Override
        public void onActivityStopped(Activity activity) {
        }

        @Override
        public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
        }

        @Override
        public void onActivityDestroyed(Activity activity) {
        }
    };
}
