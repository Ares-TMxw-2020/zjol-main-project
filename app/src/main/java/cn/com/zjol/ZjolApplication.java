package cn.com.zjol;

import android.app.ActivityManager;
import android.content.Context;
import android.support.multidex.MultiDexApplication;
import android.text.TextUtils;

import com.aliya.uimode.UiModeManager;
import com.core.glide.GlideMode;
import com.meituan.android.walle.WalleChannelReader;
import com.tencent.bugly.crashreport.CrashReport;
import com.umeng.commonsdk.UMConfigure;
import com.umeng.socialize.PlatformConfig;
import com.umeng.socialize.UMShareAPI;
import com.umeng.socialize.UMShareConfig;
import com.zjrb.core.utils.AppUtils;
import com.zjrb.core.utils.UIUtils;
import com.zjrb.daily.db.DatabaseLoader;
import com.zjrb.daily.db.ReadRecordHelper;
import com.zjrb.passport.ZbConfig;
import com.zjrb.passport.ZbPassport;
import com.zjrb.passport.constant.ZbConstants;

import java.util.List;

import cn.com.zjol.biz.core.UserBiz;
import cn.com.zjol.biz.core.db.CompatV4DB;
import cn.com.zjol.biz.core.db.SettingManager;
import cn.com.zjol.biz.core.db.ThemeMode;
import cn.com.zjol.biz.core.network.DailyNetworkManager;
import cn.com.zjol.push.Push;
import cn.daily.news.analytics.AnalyticsManager;
import cn.daily.news.update.UpdateManager;
import zjol.com.cn.news.location.OnLineLocationManager;

public class ZjolApplication extends MultiDexApplication {

    private boolean isMainProcess = false;

    @Override
    public void onCreate() {
        super.onCreate();
        UIUtils.init(this);
        DailyNetworkManager.init(this);
        String channel = WalleChannelReader.getChannel(UIUtils.getApp());
        AppUtils.setChannel(TextUtils.isEmpty(channel) ? "bianfeng" : channel);
        UpdateManager.init(this);
        isMainProcess = TextUtils.equals(getPackageName(), getCurProcessName());
        if (isMainProcess) {
            OnLineLocationManager.getInstance().locationWithIpAndGps();
            initUmengLogin(UIUtils.getApp(), channel);
            initPassport(UIUtils.isDebuggable());
            initAnalytic();
            new Thread(new Runnable() {

                @Override
                public void run() {
                    CompatV4DB.dataCleanUp(UIUtils.getApp());
                    ThemeMode.init(ZjolApplication.this);
                    UiModeManager.init(UIUtils.getApp(), null);
                    DatabaseLoader.init(UIUtils.getApp());
                    ReadRecordHelper.initReadIds();
                    GlideMode.setProvincialTraffic(SettingManager.getInstance().isProvincialTraffic());
                    Push.init(UIUtils.getApp());
                }
            }).start();
        }
        //放在所有初始化的最后面，防止其他第三方SDK重写UncaughtExceptionHandler被覆盖
        initCrashHandler();
    }

    /**
     * 获取进程名称
     *
     * @return
     */
    private String getCurProcessName() {
        final int pid = android.os.Process.myPid();
        ActivityManager manager = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
        List<ActivityManager.RunningAppProcessInfo> processInfos = manager.getRunningAppProcesses();
        if (processInfos != null) {
            for (ActivityManager.RunningAppProcessInfo processInfo : processInfos) {
                if (processInfo.pid == pid) return processInfo.processName;
            }
        }
        return null;
    }

    /**
     * 初始化个推配置
     */
    private void initGeTui() {
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
                        .setClientId(isDebug ? Integer.parseInt(clientId) : 9)
                        .setAppUuid("uuid"));
    }

    /**
     * 初始化埋点相关信息
     */
    private void initAnalytic() {

        boolean isDebug = UIUtils.isDebuggable();

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
        saConfig.setLogEnable(isDebug);
        saConfig.setAutoTrack(true);

        String logService = "dot.wts.xinwen.cn";
        AnalyticsManager.SHWConfig shwConfig = new AnalyticsManager.SHWConfig("", "", logService);
        shwConfig.setImmediateReport(true);
        shwConfig.setLogEnable(true);
        shwConfig.setEnable(true);
        if (UserBiz.get() != null && UserBiz.get().isLoginUser()) {
            shwConfig.setAccountId(UserBiz.get().getAccountID());
        }

        AnalyticsManager.initAnalytics(this, AppUtils.getChannelName(), taConfig, saConfig, shwConfig);
    }


    /**
     * 友盟第三方登录
     */
    private void initUmengLogin(Context context, String channel) {
        UMConfigure.init(context, "5d5664b53fc19587cb000f83", channel, UMConfigure.DEVICE_TYPE_PHONE, "");
        UMShareConfig config = new UMShareConfig();
        config.isNeedAuthOnGetUserInfo(true);
        UMShareAPI.get(context).setShareConfig(config);
        PlatformConfig.setWeixin("wx6979efeb905e22f3", "b483df3317162dab6fb0b17aac581026");
        PlatformConfig.setSinaWeibo("3028984400", "cbb5c547f3f1b53fd36a4f2c818df769", "http://www.zjol.com.cn");
        PlatformConfig.setQQZone("1109683115", "1tXO7AiuhY17wReo");
        PlatformConfig.setDing("dingkcmyq1dhfhjdgl0b");
    }

    /**
     * 初始化Bugly配置
     */
    private void initCrashHandler() {
        CrashHandler.getInstance().init(this);
        // 设置上报进程为主进程
        String processName = AppUtils.getProcessName(android.os.Process.myPid());
        CrashReport.UserStrategy strategy = new CrashReport.UserStrategy(this);
        strategy.setUploadProcess(processName == null || processName.equals(getPackageName()));
        CrashReport.initCrashReport(this, UIUtils.getString(R.string.BUGLY_APPID), UIUtils.isDebuggable(), strategy);
        // 设置当前APP渠道
        String ch = WalleChannelReader.getChannel(this);
        String channel = TextUtils.isEmpty(ch) ? UIUtils.getString(R.string.text_test_channel) : ch;
        CrashReport.setAppChannel(this, channel);
        // 设置唯一设备值
        CrashReport.setUserId(AppUtils.getUniquePsuedoID());
    }
}
