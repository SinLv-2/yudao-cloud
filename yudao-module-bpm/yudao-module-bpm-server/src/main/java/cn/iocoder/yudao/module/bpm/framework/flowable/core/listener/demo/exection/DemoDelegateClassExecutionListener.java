package cn.iocoder.yudao.module.bpm.framework.flowable.core.listener.demo.exection;

import lombok.extern.slf4j.Slf4j;
import org.flowable.engine.delegate.DelegateExecution;
import org.flowable.engine.delegate.JavaDelegate;
import org.flowable.engine.impl.el.FixedValue;

/**
 * 类型为 class 的 ExecutionListener 监听器示例(JavaDelegate 版本)
 *
 * ExecutionListener需要使用ExecutionListener的实现类
 * 也可以复用 JavaDelegate 的实现类，只要使用 delegateExpression 或 class 方式。
 *
 * 如果监听器中有配置注入字段，需要定义对应的属性
 * 1）如果注入字段类型为字符串，则直接取字符串的值
 * 2）如果注入字段为表达式，则会运行时从流程变量里取值 或者 去 Spring 容器中查找对应的 Bean
 */
@Slf4j
public class DemoDelegateClassExecutionListener implements JavaDelegate {

//    private FixedValue age;

    @Override
    public void execute(DelegateExecution execution) {
//        log.info((String) age.getValue(null));
        log.info("[execute][execution({}) 被调用！变量有：{}]", execution.getId(),
                execution.getCurrentFlowableListener().getFieldExtensions());
    }

}