package cn.iocoder.yudao.module.bpm.framework.flowable.core.listener.demo.exection;

import lombok.extern.slf4j.Slf4j;
import org.flowable.bpmn.model.FieldExtension;
import org.flowable.common.engine.api.delegate.Expression;
import org.flowable.common.engine.impl.el.ExpressionManager;
import org.flowable.common.engine.impl.el.JuelExpression;
import org.flowable.engine.ProcessEngine;
import org.flowable.engine.ProcessEngines;
import org.flowable.engine.delegate.DelegateExecution;
import org.flowable.engine.delegate.JavaDelegate;
import org.flowable.engine.impl.cfg.ProcessEngineConfigurationImpl;
import org.flowable.engine.impl.el.FixedValue;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * start 事件的执行监听器
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

    private FixedValue age; // 直接注入
    private Expression sex; // 表达式注入，从流程变量中获取
    private Expression taskId; // 表达式注入，从 Spring 容器中获取

    @Override
    public void execute(DelegateExecution execution) {
        // 获取监听器中的注入字段
        List<FieldExtension> fieldExtensions = execution.getCurrentFlowableListener().getFieldExtensions();
        for (FieldExtension fieldExtension : fieldExtensions) {
            String fieldName = fieldExtension.getFieldName();
            Object fieldValue = null;
            if (fieldExtension.getStringValue() != null) {
                // 字符串值
                fieldValue = fieldExtension.getStringValue();
            } else if (fieldExtension.getExpression() != null) {
                // 表达式值
                ProcessEngine processEngine = ProcessEngines.getDefaultProcessEngine();
                ProcessEngineConfigurationImpl config =
                        (ProcessEngineConfigurationImpl) processEngine.getProcessEngineConfiguration();
                ExpressionManager expressionManager = config.getExpressionManager();
                // ⭐ 使用 ExpressionManager 创建 Expression 对象
                JuelExpression expression = (JuelExpression) expressionManager.createExpression(fieldExtension.getExpression());
                fieldValue = expression.getValue(execution);
            }
            log.info("[execute][注入字段：{}={}]", fieldName, fieldValue);
        }
    }

}