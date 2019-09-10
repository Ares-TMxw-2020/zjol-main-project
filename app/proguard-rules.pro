# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in /Users/lixinke/Library/Android/sdk/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the proguardFiles
# directive in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Add any project specific keep options here:

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile


#-------------------------------------------基本不用动区域--------------------------------------------
#---------------------------------基本指令区----------------------------------
-optimizationpasses 5
-dontskipnonpubliclibraryclassmembers
-printmapping proguardMapping.txt
-optimizations !code/simplification/cast,!field/*,!class/merging/*
-keepattributes *Annotation*,InnerClasses
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable
#----------------------------------------------------------------------------

#---------------------------------默认保留区---------------------------------
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.app.backup.BackupAgentHelper
-keep public class * extends android.preference.Preference
-keep public class * extends android.view.View
-keep public class com.android.vending.licensing.ILicensingService
-keep class android.support.** {*;}

-keep public class * extends android.view.View{
    *** get*();
    void set*(***);
    public <init>(android.content.Context);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
}
-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
}
-keep class * implements java.io.Serializable { *; }
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}
-keep class **.R$* {
 *;
}
-keepclassmembers class * {
    void *(**On*Event);
}

# The support library contains references to newer platform versions.
# Don't warn about those in case this app is linking against an older
# platform version.  We know about them, and they are safe.
-dontwarn android.support.**

# Understand the @Keep support annotation.
-keep class android.support.annotation.Keep

-keep @android.support.annotation.Keep class * {*;}

-keepclasseswithmembers class * {
    @android.support.annotation.Keep <methods>;
}

-keepclasseswithmembers class * {
    @android.support.annotation.Keep <fields>;
}

-keepclasseswithmembers class * {
    @android.support.annotation.Keep <init>(...);
}

#----------------------------------------------------------------------------

#---------------------------------webview------------------------------------
-keepclassmembers class fqcn.of.javascript.interface.for.Webview {
   public *;
}
-keepclassmembers class * extends android.webkit.WebViewClient {
    public void *(android.webkit.WebView, java.lang.String, android.graphics.Bitmap);
    public boolean *(android.webkit.WebView, java.lang.String);
    public void *(android.webkit.WebView, jav.lang.String);
    public void openFileChooser(...);
}



#-------------------------------------------定制化区域----------------------------------------------
#---------------------------------1.实体类---------------------------------

### network model
-keep class * implements cn.com.zjol.biz.core.network.IgnoreProGuard {*;}
-keepclassmembers class * implements cn.com.zjol.biz.core.network.IgnoreProGuard {*;}
-keepnames class * implements  cn.com.zjol.biz.core.network.IgnoreProGuard{ *; }
-keepclassmembernames class * implements cn.com.zjol.biz.core.network.IgnoreProGuard { *; }

### core-library
-keep class com.zjrb.core.domain.base.** { *; }
-keepnames class com.zjrb.core.domain.base.** { *; }
-keep public class * extends cn.com.zjol.biz.core.model.BaseData{*;}
-keep class com.zjrb.core.common.biz.**{*;}
-keep class com.zjrb.core.ui.widget.**{*;}

-keep class com.zjrb.core.common.location.DailyLocation$IpResponse$DataBean { *; }
-keepclassmembers class com.zjrb.core.common.location.DailyLocation$IpResponse$DataBean { *; }
-keepnames class com.zjrb.core.common.location.DailyLocation$IpResponse$DataBean { *; }
-keepclassmembernames class com.zjrb.core.common.location.DailyLocation$IpResponse$DataBean { *; }

-keep class com.zjrb.core.common.location.DailyLocation$IpResponse { *; }
-keepclassmembers class com.zjrb.core.common.location.DailyLocation$IpResponse { *; }
-keepnames class com.zjrb.core.common.location.DailyLocation$IpResponse { *; }
-keepclassmembernames class com.zjrb.core.common.location.DailyLocation$IpResponse { *; }

-keep class com.zjrb.core.domain.UrlCheckBean { *; }
-keepclassmembers class com.zjrb.core.domain.UrlCheckBean { *; }
-keepnames class com.zjrb.core.domain.UrlCheckBean { *; }

### 定位
-keep class com.daily.news.location.** { *; }
-keepnames class com.daily.news.location.** { *; }

### update
-keep class cn.com.zjol.biz.core.update.UpdateResponse { *; }
-keepclassmembers class cn.com.zjol.biz.core.update.UpdateResponse { *; }
-keepnames class cn.com.zjol.biz.core.update.UpdateResponse { *; }
-keepclassmembernames class cn.com.zjol.biz.core.update.UpdateResponse { *; }

-keep class cn.daily.news.update.model.VersionBean { *; }
-keepclassmembers class cn.daily.news.update.model.VersionBean { *; }
-keepnames class cn.daily.news.update.model.VersionBean { *; }
-keepclassmembernames class cn.daily.news.update.model.VersionBean { *; }


### 数据库
-keep class com.zjrb.daily.db.bean.** { *; }
-keepnames class com.zjrb.daily.db.bean.** { *; }
### 数据库
-keep class com.zjrb.daily.db.bean.** { *; }
-keepnames class com.zjrb.daily.db.bean.** { *; }
### 新闻
-keep public class zjol.com.cn.news.home.bean.**{*;}
-keep class com.zjrb.daily.news.bean.** { *; }
-keepnames class com.zjrb.daily.news.bean.** { *; }
### 本地
-keep class com.zjrb.daily.local.bean.** { *; }
-keepnames class com.zjrb.daily.local.bean.** { *; }
### 发现
-keep class com.zjrb.daily.find.bean.** { *; }
-keepnames class com.zjrb.daily.find.bean.** { *; }
### 视频
-keep public class zjol.com.cn.player.bean.**{*;}
-keep class com.zjrb.daily.video.bean.** { *; }
-keepnames class com.zjrb.daily.video.bean.** { *; }
### 推送
-keep class com.zjrb.daily.push.bean.** { *; }
-keepnames class com.zjrb.daily.push.bean.** { *; }
### 详情
-keep class com.zjrb.zjxw.detail.request.bean.**{*;}
### 启动
-keep public class zjol.com.cn.launcher.bean.**{*;}

###JSSDK
-keep class bean.**{*;}
-keepnames class bean.** { *; }
-keep class port.**{*;}
-keepnames class port.** { *; }
-keep class com.google.gson.** { *; }
-keepnames class com.google.gson.** { *; }


### 首页
-keep class com.daily.news.launcher.title.TitleResponse$* { *; }
-keepclassmembers class com.daily.news.launcher.title.TitleResponse$* { *; }
-keepnames class com.daily.news.launcher.title.TitleResponse$* { *; }
-keepclassmembernames class com.daily.news.launcher.title.TitleResponse$* { *; }
-keep class com.daily.news.launcher.ad.AdResponse$* { *; }
-keepclassmembers class com.daily.news.launcher.ad.AdResponse$* { *; }
-keepnames class com.daily.news.launcher.ad.AdResponse$* { *; }
-keepclassmembernames class com.daily.news.launcher.ad.AdResponse$* { *; }
-keep class com.daily.news.launcher.ad.AdResponse { *; }
-keepclassmembers class com.daily.news.launcher.ad.AdResponse { *; }
-keepnames class com.daily.news.launcher.ad.AdResponse { *; }
-keepclassmembernames class com.daily.news.launcher.ad.AdResponse { *; }

-keep class com.daily.news.continuous.landing.ContinuousResponse$* { *; }
-keepclassmembers class com.daily.news.continuous.landing.ContinuousResponse$* { *; }
-keepnames class com.daily.news.continuous.landing.ContinuousResponse$* { *; }
-keepclassmembernames class com.daily.news.continuous.landing.ContinuousResponse$* { *; }
-keep class com.daily.news.continuous.landing.ContinuousResponse { *; }
-keepclassmembers class com.daily.news.continuous.landing.ContinuousResponse { *; }
-keepnames class com.daily.news.continuous.landing.ContinuousResponse { *; }
-keepclassmembernames class com.daily.news.continuous.landing.ContinuousResponse { *; }

### 用户中心
-keep class cn.daily.news.user.history.HistoryResponse$* { *; }
-keepclassmembers class cn.daily.news.user.history.HistoryResponse$* { *; }
-keepnames class cn.daily.news.user.history.HistoryResponse$* { *; }
-keepclassmembernames class cn.daily.news.user.history.HistoryResponse$* { *; }
-keep class cn.daily.news.user.dynamic.bean.** { *; }
-keepnames class cn.daily.news.user.dynamic.bean.** { *; }
-keep class cn.daily.news.user.feedback.UploadImageResponse$* { *; }
-keepclassmembers class cn.daily.news.user.feedback.UploadImageResponse$* { *; }
-keepnames class cn.daily.news.user.feedback.UploadImageResponse$* { *; }
-keepclassmembernames class cn.daily.news.user.feedback.UploadImageResponse$* { *; }
-keep class cn.daily.news.user.score.ScoreResponse$* { *; }
-keepclassmembers class cn.daily.news.user.score.ScoreResponse$* { *; }
-keepnames class cn.daily.news.user.score.ScoreResponse$* { *; }
-keepclassmembernames class cn.daily.news.user.score.ScoreResponse$* { *; }
-keep class cn.daily.news.user.score.DayScoreResponse* { *; }
-keepclassmembers class cn.daily.news.user.score.DayScoreResponse* { *; }
-keepnames class cn.daily.news.user.score.DayScoreResponse* { *; }
-keepclassmembernames class cn.daily.news.user.score.DayScoreResponse* { *; }

-keep class cn.daily.news.user.api.bean.** { *; }
-keepnames class cn.daily.news.user.api.bean.** { *; }

-keep class cn.daily.news.user.recommend.RecommendResponse$* { *; }
-keepclassmembers class cn.daily.news.user.recommend.RecommendResponse$* { *; }
-keepnames class cn.daily.news.user.recommend.RecommendResponse$* { *; }
-keepclassmembernames class cn.daily.news.user.recommend.RecommendResponse$* { *; }
-keep class cn.daily.news.user.base.UserCenterResponse$* { *; }
-keepclassmembers class cn.daily.news.user.base.UserCenterResponse$* { *; }
-keepnames class cn.daily.news.user.base.UserCenterResponse$* { *; }
-keepclassmembernames class cn.daily.news.user.base.UserCenterResponse$* { *; }

-keep class cn.daily.news.user.base.LogoutResponse$* { *; }
-keepclassmembers class cn.daily.news.user.base.LogoutResponse$* { *; }
-keepnames class cn.daily.news.user.base.LogoutResponse$* { *; }
-keepclassmembernames class cn.daily.news.user.base.LogoutResponse$* { *; }

-keep class cn.daily.news.user.about.AboutResponse$* { *; }
-keepclassmembers class cn.daily.news.user.about.AboutResponse$* { *; }
-keepnames class cn.daily.news.user.about.AboutResponse$* { *; }
-keepclassmembernames class cn.daily.news.user.about.AboutResponse$* { *; }

-keep class cn.daily.news.service.model.** { *; }
-keepnames class cn.daily.news.service.model.** { *; }

-keep class cn.daily.news.update.UpdateResponse$* { *; }
-keepclassmembers class cn.daily.news.update.UpdateResponse$* { *; }
-keepnames class cn.daily.news.update.UpdateResponse$* { *; }
-keepclassmembernames class cn.daily.news.update.UpdateResponse$* { *; }

-keep class com.daily.news.subscription.home.SubscriptionResponse$* { *; }
-keepclassmembers class com.daily.news.subscription.home.SubscriptionResponse$* { *; }
-keepnames class com.daily.news.subscription.home.SubscriptionResponse$* { *; }
-keepclassmembernames class com.daily.news.subscription.home.SubscriptionResponse$* { *; }

-keep class cn.daily.news.user.modify.ModifyIconActivity$* { *; }
-keepclassmembers class cn.daily.news.user.modify.ModifyIconActivity$* { *; }
-keepnames class cn.daily.news.user.modify.ModifyIconActivity$* { *; }
-keepclassmembernames class cn.daily.news.user.modify.ModifyIconActivity$* { *; }

-keep class cn.daily.news.user.PushPreferenceActivity$* { *; }
-keepclassmembers class cn.daily.news.user.PushPreferenceActivity$* { *; }
-keepnames class cn.daily.news.user.PushPreferenceActivity$* { *; }
-keepclassmembernames class cn.daily.news.user.PushPreferenceActivity$* { *; }


-keep class cn.daily.news.user.modify.ModifyPhoneNumResponse$* { *; }
-keepclassmembers class cn.daily.news.user.modify.ModifyPhoneNumResponse$* { *; }
-keepnames class cn.daily.news.user.modify.ModifyPhoneNumResponse$* { *; }
-keepclassmembernames class cn.daily.news.user.modify.ModifyPhoneNumResponse$* { *; }

#VR
-keep class daily.zjrb.com.daily_vr.bean

# 广告
-keep class com.zjrb.daily.ad.model.**{*;}
-keep class com.alimama.** { *; }
-keepnames class com.alimama.** { *; }
-keep class com.taobao.** { *; }
-keepnames class com.taobao.** { *; }

# 起航号
-keep class cn.daily.android.sail.list.model.** { *; }
-keepnames class cn.daily.android.sail.list.model.** { *; }
############


#-------------------------------------------------------------------------

#---------------------------------2.第三方包-------------------------------
### 友盟
-keep class com.umeng.commonsdk.** {*;}
### butterknife
-keep class butterknife.** { *; }
-dontwarn butterknife.internal.**
-keep class **$$ViewBinder { *; }

-keepclasseswithmembernames class * {
    @butterknife.* <fields>;
}

-keepclasseswithmembernames class * {
    @butterknife.* <methods>;
}

### 魔窗
-keep class com.tencent.mm.sdk.** {*;}
-keep class cn.magicwindow.** {*;}
-dontwarn cn.magicwindow.**

# fastJson
-keepattributes Signature
-dontwarn com.alibaba.fastjson.**
-keep class com.alibaba.fastjson.**{*; }
-keepattributes *Annotation*


### greendao
#greendao3.2.0,此是针对3.2.0，如果是之前的，可能需要更换下包名
-keep class org.greenrobot.greendao.**{*;}
-keepclassmembers class * extends org.greenrobot.greendao.AbstractDao {
public static java.lang.String TABLENAME;
}
-keep class **$Properties
### greenDAO 3
-keepclassmembers class * extends org.greenrobot.greendao.AbstractDao {
public static java.lang.String TABLENAME;
}
-keep class **$Properties

# If you do not use SQLCipher:
-dontwarn org.greenrobot.greendao.database.**
# If you do not use RxJava:
-dontwarn rx.**

### 友盟
-dontpreverify
-dontshrink
-dontoptimize
-dontwarn com.google.android.maps.**
-dontwarn android.webkit.WebView
-dontwarn com.umeng.**
-dontwarn com.tencent.weibo.sdk.**
-dontwarn com.facebook.**
-keep public class javax.**
-keep public class android.webkit.**
-dontwarn android.support.v4.**
-keep enum com.facebook.**
-keepattributes Exceptions,InnerClasses,Signature
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable

-keep public interface com.facebook.**
-keep public interface com.tencent.**
-keep public interface com.umeng.socialize.**
-keep public interface com.umeng.socialize.sensor.**
-keep public interface com.umeng.scrshot.**

-keep public class com.umeng.socialize.* {*;}


-keep class com.facebook.**
-keep class com.facebook.** { *; }
-keep class com.umeng.scrshot.**
-keep public class com.tencent.** {*;}
-keep class com.umeng.socialize.sensor.**
-keep class com.umeng.socialize.handler.**
-keep class com.umeng.socialize.handler.*
-keep class com.umeng.weixin.handler.**
-keep class com.umeng.weixin.handler.*
-keep class com.umeng.qq.handler.**
-keep class com.umeng.qq.handler.*
-keep class UMMoreHandler{*;}
-keep class com.tencent.mm.sdk.modelmsg.WXMediaMessage {*;}
-keep class com.tencent.mm.sdk.modelmsg.** implements com.tencent.mm.sdk.modelmsg.WXMediaMessage$IMediaObject {*;}
-keep class im.yixin.sdk.api.YXMessage {*;}
-keep class im.yixin.sdk.api.** implements im.yixin.sdk.api.YXMessage$YXMessageData{*;}
-keep class com.tencent.mm.sdk.** {
   *;
}
-keep class com.tencent.mm.opensdk.** {
   *;
}
-keep class com.tencent.wxop.** {
   *;
}
-keep class com.tencent.mm.sdk.** {
   *;
}
-dontwarn twitter4j.**
-keep class twitter4j.** { *; }

-keep class com.tencent.** {*;}
-dontwarn com.tencent.**
-keep class com.kakao.** {*;}
-dontwarn com.kakao.**
-keep public class com.umeng.com.umeng.soexample.R$*{
    public static final int *;
}
-keep public class com.linkedin.android.mobilesdk.R$*{
    public static final int *;
}
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

-keep class com.tencent.open.TDialog$*
-keep class com.tencent.open.TDialog$* {*;}
-keep class com.tencent.open.PKDialog
-keep class com.tencent.open.PKDialog {*;}
-keep class com.tencent.open.PKDialog$*
-keep class com.tencent.open.PKDialog$* {*;}
-keep class com.umeng.socialize.impl.ImageImpl {*;}
-keep class com.sina.** {*;}
-dontwarn com.sina.**
-keep class  com.alipay.share.sdk.** {
   *;
}

### 钉钉分享
-keep class  com.android.dingtalk.share.ddsharemodule.** {
   *;
}
-keep class  com.umeng.socialize.** {
   *;
}

### 保持 Parcelable 不被混淆
-keep class * implements android.os.Parcelable {*;}
-keepnames class * implements  android.os.Parcelable{ *; }
-keepclassmembers class * implements android.os.Parcelable {*;}
-keepclassmembernames class * implements android.os.Parcelable { *; }

-keep class com.linkedin.** { *; }
-keep class com.android.dingtalk.share.ddsharemodule.** { *; }
-keepattributes Signature

### 友盟统计
-keepclassmembers class * {
  public <init> (org.json.JSONObject);
}
-keep public class com.zhejiangdaily.R$*{
  public static final int *;
}
-keepclassmembers enum * {
  public static **[] values(); public static ** valueOf(java.lang.String);
}

### RXJava Android
-dontwarn sun.misc.**
-keepclassmembers class rx.internal.util.unsafe.*ArrayQueue*Field* {
   long producerIndex;
   long consumerIndex;
}
-keepclassmembers class rx.internal.util.unsafe.BaseLinkedQueueProducerNodeRef {
    rx.internal.util.atomic.LinkedQueueNode producerNode;
}
-keepclassmembers class rx.internal.util.unsafe.BaseLinkedQueueConsumerNodeRef {
    rx.internal.util.atomic.LinkedQueueNode consumerNode;
}

### Gson

-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.stream.** { *; }

###zxing
-keep class com.google.zxing.** {*;}
-dontwarn com.google.zxing.**

# Application classes that will be serialized/deserialized over Gson 下面替换成自己的实体类
-keep class com.example.bean.** { *; }
### OkHttp3
-dontwarn com.squareup.okhttp3.**
-keep class com.squareup.okhttp3.** { *;}
-dontwarn okio.**
-keep interface com.squareup.okhttp3.* { *; }
-dontwarn javax.annotation.Nullable
-dontwarn javax.annotation.ParametersAreNonnullByDefault
### Glide
-keep public class * implements com.bumptech.glide.module.GlideModule
-keep public class * extends com.bumptech.glide.AppGlideModule
-keep public enum com.bumptech.glide.load.resource.bitmap.ImageHeaderParser$** {
  **[] $VALUES;
  public *;
}

-dontwarn com.bumptech.glide.load.engine.bitmap_recycle.LruBitmapPool
-dontwarn com.bumptech.glide.load.resource.bitmap.Downsampler
-dontwarn com.bumptech.glide.load.resource.bitmap.HardwareConfigState

### bugly
-dontwarn com.tencent.bugly.**
-keep public class com.tencent.bugly.**{*;}
 -keep class android.support.**{*;}

### 网脉
-keep class com.trs.** { *; }
-keepnames class com.trs.** { *; }

### 个像
-dontwarn com.getui.**
-keep class com.getui.**{*;}

# 个推辅助通道 华为、魅族、小米
-keep class com.huawei.hms.** { *; }
-dontwarn com.huawei.hms.**
-keep class com.meizu.** { *; }
-dontwarn com.meizu.**
-keep class com.xiaomi.** { *; }
-dontwarn com.xiaomi.push.**
-keep class org.apache.thrift.** { *; }

## 网易洞见
-dontwarn com.netease.**
-keep public class com.netease.**{*;}

## VR
-dontwarn com.google.vrtoolkit.**
-keep public class com.google.vrtoolkit.**{*;}
-keep public class com.utovr.**{*;}

## jsoup
-dontwarn org.jsoup.**
-keep class org.jsoup.**{*;}

## 新闻
-dontwarn java.lang.invoke.*

## 神策SDK
-dontwarn com.sensorsdata.analytics.android.**
-keep class com.sensorsdata.analytics.android.** {
*;
}
-keep class **.R$* {
    <fields>;
}
-keepnames class * implements android.view.View$OnClickListener
-keep public class * extends android.content.ContentProvider
-keepnames class * extends android.view.View

-keep class * extends android.app.Fragment {
 public void setUserVisibleHint(boolean);
 public void onHiddenChanged(boolean);
 public void onResume();
 public void onPause();
}
-keep class android.support.v4.app.Fragment {
 public void setUserVisibleHint(boolean);
 public void onHiddenChanged(boolean);
 public void onResume();
 public void onPause();
}
-keep class * extends android.support.v4.app.Fragment {
 public void setUserVisibleHint(boolean);
 public void onHiddenChanged(boolean);
 public void onResume();
 public void onPause();
}

## 网易云易盾
-keep class com.netease.mobsec.**{*;}

#-------------------------------------------------------------------------

#---------------------------------3.与js互相调用的类------------------------
-keepclasseswithmembers class cn.daily.news.user.shop.ShopActivity$ShopJavaScriptObject {
      <methods>;
}

