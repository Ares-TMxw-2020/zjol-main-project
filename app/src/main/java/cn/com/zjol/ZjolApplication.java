package cn.com.zjol;

import android.support.multidex.MultiDexApplication;
import android.text.TextUtils;

import com.aliya.uimode.UiModeManager;
import com.meituan.android.walle.WalleChannelReader;
import com.tencent.bugly.crashreport.CrashReport;
import com.zjrb.core.utils.AppUtils;
import com.zjrb.core.utils.UIUtils;
import com.zjrb.daily.db.DatabaseLoader;
import com.zjrb.daily.db.dao.ReadNewsDaoHelper;

import cn.com.zjol.biz.core.network.DailyNetworkManager;
import cn.com.zjol.push.Push;

public class ZjolApplication extends MultiDexApplication {


    @Override
    public void onCreate() {
        super.onCreate();
        UIUtils.init(this);
        UiModeManager.init(this, null);
        DailyNetworkManager.init(this);
        DatabaseLoader.init(this);
        Push.init(this);
        ReadNewsDaoHelper.initReadIds();

        // TODO: 2019/7/31
        AppUtils.setChannel("bianfeng");
        initGeTui();
        initBugly();
    }

    /**
     * 初始化个推配置
     */
    private void initGeTui() {
    }

    /**
     * 初始化Bugly配置
     */
    private void initBugly() {
        // 设置上报进程为主进程
        String processName = AppUtils.getProcessName(android.os.Process.myPid());
        CrashReport.UserStrategy strategy = new CrashReport.UserStrategy(this);
        strategy.setUploadProcess(processName == null || processName.equals(getPackageName()));
        CrashReport.initCrashReport(this, UIUtils.getString(R.string.BUGLY_APPID),
                UIUtils.isDebuggable(), strategy);
        // 设置当前APP渠道
        String ch = WalleChannelReader.getChannel(this);
        String channel = TextUtils.isEmpty(ch) ? UIUtils.getString(R.string.text_test_channel) : ch;
        CrashReport.setAppChannel(this, channel);
        // 设置唯一设备值
        CrashReport.setUserId(AppUtils.getUniquePsuedoID());
    }
}
