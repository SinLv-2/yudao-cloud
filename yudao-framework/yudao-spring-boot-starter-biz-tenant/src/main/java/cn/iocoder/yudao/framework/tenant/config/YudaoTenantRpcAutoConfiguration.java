package cn.iocoder.yudao.framework.tenant.config;

import cn.iocoder.yudao.framework.tenant.core.rpc.TenantRequestInterceptor;
import cn.iocoder.yudao.framework.common.biz.system.tenant.TenantCommonApi;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.context.annotation.Bean;

@AutoConfiguration
@ConditionalOnProperty(prefix = "yudao.tenant", value = "enable", matchIfMissing = true) // 允许使用 yudao.tenant.enable=false 禁用多租户
// 主要是引入相关的 API 服务
// 启用 Feign，并且只扫描并启用指定的 Feign 客户端接口 —— 这里是 TenantCommonApi
@EnableFeignClients(clients = TenantCommonApi.class)
public class YudaoTenantRpcAutoConfiguration {

    @Bean
    public TenantRequestInterceptor tenantRequestInterceptor() {
        return new TenantRequestInterceptor();
    }

}
